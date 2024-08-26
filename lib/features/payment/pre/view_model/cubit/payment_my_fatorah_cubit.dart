import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ghanim_law_app/core/AppLocalizations/app_localizations.dart';
import 'package:ghanim_law_app/core/enum/enum.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';

import '../../../data/model/invoice_model.dart';

part 'payment_my_fatorah_state.dart';

class PaymentMyFatorahCubit extends HydratedCubit<PaymentMyFatorahState> {
  PaymentMyFatorahCubit() : super(const PaymentMyFatorahState());

  static int? paymentMethodId;
  static String? serviceName;
  static String? email;
  Future<void> init(PaymentMyFatorahModel paymentMyFatorahModel) async {
    if (email == paymentMyFatorahModel.email &&
        state.executePaymentResponse != null &&
        paymentMyFatorahModel.serviceName == serviceName) {
    } else {
      emit(state.copyWith(paymentSendState: PaymentState.init));
      serviceName = paymentMyFatorahModel.serviceName;
      email = paymentMyFatorahModel.email;
      if (Config.testAPIKey.isEmpty) {
        emit(state.copyWith(
            response:
                "Missing API Token Key.. You can get it from here: https://myfatoorah.readme.io/docs/test-token"));
        return;
      }

      await MFSDK.init(Config.testAPIKey, MFCountry.EGYPT, MFEnvironment.TEST);

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await initiatePayment(num.parse(paymentMyFatorahModel.price));
      });
    }
  }

  void setUpActionBar(BuildContext context) {
    MFSDK.setUpActionBar(
        toolBarTitleColor: "#Ffffff",
        toolBarTitle: "Checkout".tr(context),
        isShowToolBar: true);
  }

  String convertToHexWithoutAlpha(int colorValue) {
    String hexString =
        colorValue.toRadixString(16).padLeft(8, '0').toUpperCase();

    return hexString.substring(2); // Returns the RGB part of the hex string
  }

  Future<void> initiatePayment(num price) async {
    emit(state.copyWith(paymentSendState: PaymentState.methodsPaymentLoading));
    var request = MFInitiatePaymentRequest(
        invoiceAmount: price, currencyIso: MFCurrencyISO.QATAR_QAR);

    await MFSDK.initiatePayment(request, MFLanguage.ARABIC).then((value) {
      emit(state.copyWith(
          paymentMethods: value.paymentMethods!,
          paymentSendState: PaymentState.methodsPaymentSuccess));
      log('Initiate Payment Response: ${jsonEncode(value.toJson())}');
    }).catchError((error) {
      log('Initiate Payment Error: ${error.toString()}');
      emit(state.copyWith(
          erorrMessage: error.message,
          paymentSendState: PaymentState.paymentErorr));
    });
  }

  void log(String message) {
    debugPrint(message);
  }

  Future<void> sendPayment(PaymentMyFatorahModel paymentMyFatorahModel) async {
    emit(state.copyWith(paymentSendState: PaymentState.requestPaymentLoading));
    if (kDebugMode) {
      print(double.parse(paymentMyFatorahModel.price));
    }
    var request = MFSendPaymentRequest(
        displayCurrencyIso: MFCurrencyISO.QATAR_QAR,
        invoiceValue: int.parse(paymentMyFatorahModel.price),
        customerName: paymentMyFatorahModel.name,
        customerEmail: paymentMyFatorahModel.email,
        invoiceItems: [
          MFInvoiceItem(
            quantity: 1,
            unitPrice: double.parse(paymentMyFatorahModel.price),
            itemName: paymentMyFatorahModel.serviceName,
          )
        ],
        notificationOption: MFNotificationOption.EMAIL);
    await MFSDK.sendPayment(request, MFLanguage.ARABIC).then((value) {
      log("Send Payment Response: ${jsonEncode(value.toJson())}");
      emit(
          state.copyWith(paymentSendState: PaymentState.requestPaymentSuccess));
      getPaymentStatus(value.invoiceId.toString());
    }).catchError((error) {
      log('Send Payment Error: ${error.toString()}');
      emit(state.copyWith(
          paymentSendState: PaymentState.paymentErorr,
          erorrMessage: error.message));
    });
  }

  Future<void> executeRegularPayment(
      PaymentMyFatorahModel paymentMyFatorahModel, BuildContext context) async {
    setUpActionBar(context);
    var request = MFExecutePaymentRequest(
      displayCurrencyIso: MFCurrencyISO.QATAR_QAR,
      customerEmail: paymentMyFatorahModel.email,
      customerName: paymentMyFatorahModel.name,
      paymentMethodId: paymentMethodId,
      invoiceValue: double.parse(paymentMyFatorahModel.price),
      invoiceItems: [
        MFInvoiceItem(
          quantity: 1,
          unitPrice: double.parse(paymentMyFatorahModel.price),
          itemName: paymentMyFatorahModel.serviceName,
        )
      ],
    );

    await MFSDK
        .executePayment(request, MFLanguage.ARABIC, (invoiceId) {})
        .then((value) {
      emit(state.copyWith(
          paymentSendState: PaymentState.executePaymentSuccess,
          executePaymentResponse: value));
      log("Execute Payment Response: ${jsonEncode(value.toJson())}");
    }).catchError((error) {
      emit(state.copyWith(
          paymentSendState: PaymentState.paymentErorr,
          erorrMessage: error.message));
      log('Execute Payment Error: ${error.message}');
    });
  }

  void setMethodId(int id) {
    paymentMethodId = id;
  }

  Future<void> getPaymentStatus(String key) async {
    emit(state.copyWith(paymentSendState: PaymentState.statusPaymentLoading));
    MFGetPaymentStatusRequest request =
        MFGetPaymentStatusRequest(key: key, keyType: MFKeyType.INVOICEID);

    await MFSDK.getPaymentStatus(request, MFLanguage.ARABIC).then((value) {
      print("ResPoser results:${value.toJson()} ");
      emit(state.copyWith(
          paymentSendState: PaymentState.statusPaymentSuccess,
          paymentStatusResponse: value));
    }).catchError((error) {
      emit(state.copyWith(
          paymentSendState: PaymentState.paymentErorr,
          erorrMessage: error.toString()));
    });
  }

  @override
  PaymentMyFatorahState? fromJson(Map<String, dynamic> json) {
    try {
      return PaymentMyFatorahState.fromMap(json);
    } catch (e) {
      return null;
    }
  }

  Future<void> resetStates() {
    serviceName = null;
    emit(state.copyWith(
        paymentSendState: PaymentState.init,
        paymentStatusResponse: null,
        paymentMethods: [],
        paymentStatusState: RequestState.loading,
        executePaymentResponse: null));
    return super.clear();
  }

  @override
  Map<String, dynamic>? toJson(PaymentMyFatorahState state) {
    try {
      return state.toMap();
    } catch (e) {
      return null;
    }
  }
}

class Config {
  static const String testAPIKey =
      "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL";
}
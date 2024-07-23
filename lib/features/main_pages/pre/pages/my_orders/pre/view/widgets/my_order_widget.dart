import 'package:flutter/material.dart';
import 'package:ghanim_law_app/core/AppLocalizations/app_localizations.dart';
import 'package:ghanim_law_app/core/constants/app_colors.dart';
import 'package:ghanim_law_app/core/constants/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../../core/constants/app_router.dart';
import '../../../../home/pre/view/widgets/service_icon_build_item_widget.dart';

class Orders {
  final String myService;
  final String orderState;

  Orders({
    required this.myService,
    required this.orderState,
  });
}

class OrdersWidget extends StatelessWidget {
  final Orders orders;

  const OrdersWidget({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // GoRouter.of(context).push(AppRouter.kOrderForm);
      },
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[200]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
             orders.myService.tr(context),
            ),
            Text(orders.orderState),
          ],
        ),
      ),
    );
  }
}

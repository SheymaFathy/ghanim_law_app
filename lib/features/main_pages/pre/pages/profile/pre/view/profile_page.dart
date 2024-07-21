import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghanim_law_app/core/AppLocalizations/app_localizations.dart';
import 'package:ghanim_law_app/core/constants/app_router.dart';
import 'package:ghanim_law_app/core/enum/enum.dart';
import 'package:ghanim_law_app/core/profile.dart';
import 'package:ghanim_law_app/core/shared_preferences/cache_helper.dart';
import 'package:ghanim_law_app/core/widget/app_bar.dart';
import 'package:ghanim_law_app/features/main_pages/pre/pages/profile/pre/view/widgets/profile_view_body_widget.dart';
import 'package:ghanim_law_app/features/main_pages/pre/pages/profile/pre/view_model/cubit/profile_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../core/get_it/service_locator.dart';
import '../../../../../../../core/required_login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    checkUserMethod();
    return BlocProvider.value(
      value: getIt<ProfileCubit>(),
      child: Scaffold(
          appBar: myAppBar(context, "profile".tr(context),
              actionWidget: UserData.uId != null
                  ? IconButton(
                      onPressed: () {
                        CacheHelper.clearData(key: "uId").then((onValue) {
                          GoRouter.of(context).go(AppRouter.kLogin);
                          UserData.init();
                        });
                      },
                      icon: const Icon(Icons.logout))
                  : null),
          body: checkUserMethod()
              ? BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    switch (state.profileRequestState) {
                      case RequestState.loading:
                        return const Center(child: CircularProgressIndicator());
                      case RequestState.sucess:
                        return ProfileViewBodyWidget(state: state);
                      case RequestState.erorr:
                        return Center(child: Text(state.profileErorrMessage));
                    }
                  },
                )
              : const RequiredLoginScreen()),
    );
  }
}

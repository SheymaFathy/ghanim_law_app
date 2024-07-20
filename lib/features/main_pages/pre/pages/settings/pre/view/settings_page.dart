import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghanim_law_app/core/AppLocalizations/app_localizations.dart';
import 'package:ghanim_law_app/core/constants/app_router.dart';

import 'package:go_router/go_router.dart';
import '../../../../../../../core/profile.dart';
import '../../../../../../../core/widget/app_bar.dart';

import '../view_model/cubit/setting_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(
      buildWhen: (previous, current) {
        if (previous.locale.languageCode != current.locale.languageCode) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        print(state.locale.languageCode == "en");
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              myAppBar(context, "settings".tr(context)),
              ListTile(
                leading: const Icon(Icons.feedback_outlined),
                title: Text("feedback".tr(context)),
                trailing: UserData.lang == "ar"
                    ? const Icon(Icons.arrow_back_ios, size: 16)
                    : const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  GoRouter.of(context).push(AppRouter.kFeedback);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text("about".tr(context)),
                trailing: UserData.lang == "ar"
                    ? const Icon(Icons.arrow_back_ios, size: 16)
                    : const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  GoRouter.of(context).push(AppRouter.kFeedback);
                },
              ),
              ExpansionTile(
                expandedAlignment: Alignment.topCenter,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                leading: const Icon(Icons.language),
                title: Text("language".tr(context)),
                children: [
                  ListTile(
                    title: Text("eng".tr(context)),
                    onTap: () {
                      context.read<SettingCubit>().changeLanguage("en");
                    },
                    selected: state.locale.languageCode == "en",
                  ),
                  ListTile(
                    title: Text("arb".tr(context)),
                    onTap: () {
                      context.read<SettingCubit>().changeLanguage("ar");
                    },
                    selected: state.locale.languageCode == "ar",
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.feedback_outlined),
                title: const Text("Send Feedback"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  GoRouter.of(context).push(AppRouter.kFeedback);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("about"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  GoRouter.of(context).push(AppRouter.kFeedback);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

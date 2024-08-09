import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/AppLocalizations/app_localizations.dart';
import '../../../../../../../../core/theme/theme.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit(this.languageCacheHelper) : super(const SettingState());
  final LanguageCacheHelper languageCacheHelper;
  Future<void> getSavedLanguage() async {
    final String cacheLanguageCode =
        await languageCacheHelper.getCacheLanguageCode();
    emit(SettingState(locale: Locale(cacheLanguageCode)));
  }

  Future<void> changeLanguage(String languageCode) async {
    await languageCacheHelper.setCacheLanguageCode(languageCode);
    emit(SettingState(locale: Locale(languageCode)));
  }

  toggleAppTheme(bool value) {
    emit(SettingState(locale: state.locale));
    ThemeService.changeDarkMode();
    emit(SettingState(locale: state.locale));
  }
}

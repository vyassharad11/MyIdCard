
import 'package:flutter/material.dart';

class LocalizationNotifier extends ChangeNotifier{
  LocalizationNotifier(this._appLocale);
  Locale _appLocale = const Locale('en');

  Locale get appLocal => _appLocale;

  setAppLocal (Locale language ) async {
    _appLocale = language;
    notifyListeners();
  }

}
import 'package:flutter/cupertino.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

    changeLocale(Locale locale) {
    _locale = locale;
  }

  clearLocale() {
    _locale = null;
    notifyListeners();
  }
}

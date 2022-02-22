import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainProvider with ChangeNotifier {
  late SharedPreferences _prefs;
  MainProvider(prefs) {
    _prefs = prefs;
  }

  get prefs => _prefs;
}

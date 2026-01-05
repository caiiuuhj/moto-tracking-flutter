import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends ChangeNotifier {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;
  bool _bootstrapped = false;

  bool get isReady => _bootstrapped;

  bool get isLoggedIn {
    final idIsu = _prefs?.getString('id-isu');
    return idIsu != null && idIsu.isNotEmpty;
  }

  Future<void> bootstrap() async {
    _prefs ??= await SharedPreferences.getInstance();
    _bootstrapped = true;
    notifyListeners();
  }

  String? getString(String key) => _prefs?.getString(key);

  Future<void> setString(String key, String value) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(key, value);
    notifyListeners();
  }

  Future<void> remove(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove(key);
    notifyListeners();
  }

  Future<void> logout() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove('id-isu');
    await _prefs!.remove('nome');
    notifyListeners();
  }
}

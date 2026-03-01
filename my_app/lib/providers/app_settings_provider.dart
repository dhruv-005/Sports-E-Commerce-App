import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  static const _phoneKey = 'settings_phone';
  static const _addressKey = 'settings_address';
  static const _pushNotificationsKey = 'settings_push_notifications';
  static const _orderUpdatesKey = 'settings_order_updates';
  static const _offersKey = 'settings_personalized_offers';
  static const _biometricLockKey = 'settings_biometric_lock';
  static const _currencyKey = 'settings_currency';
  static const _languageKey = 'settings_language';
  static const _preferredSportKey = 'settings_preferred_sport';

  bool _isLoading = true;
  String _phone = '';
  String _address = '';
  bool _pushNotifications = true;
  bool _orderUpdates = true;
  bool _personalizedOffers = false;
  bool _biometricLock = false;
  String _currency = 'INR';
  String _language = 'English';
  String _preferredSport = 'Football';

  bool get isLoading => _isLoading;
  String get phone => _phone;
  String get address => _address;
  bool get pushNotifications => _pushNotifications;
  bool get orderUpdates => _orderUpdates;
  bool get personalizedOffers => _personalizedOffers;
  bool get biometricLock => _biometricLock;
  String get currency => _currency;
  String get language => _language;
  String get preferredSport => _preferredSport;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _phone = prefs.getString(_phoneKey) ?? '';
    _address = prefs.getString(_addressKey) ?? '';
    _pushNotifications = prefs.getBool(_pushNotificationsKey) ?? true;
    _orderUpdates = prefs.getBool(_orderUpdatesKey) ?? true;
    _personalizedOffers = prefs.getBool(_offersKey) ?? false;
    _biometricLock = prefs.getBool(_biometricLockKey) ?? false;
    _currency = prefs.getString(_currencyKey) ?? 'INR';
    _language = prefs.getString(_languageKey) ?? 'English';
    _preferredSport = prefs.getString(_preferredSportKey) ?? 'Football';
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateContactInfo({
    required String phone,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    _phone = phone.trim();
    _address = address.trim();
    await prefs.setString(_phoneKey, _phone);
    await prefs.setString(_addressKey, _address);
    notifyListeners();
  }

  Future<void> setPushNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _pushNotifications = value;
    await prefs.setBool(_pushNotificationsKey, value);
    notifyListeners();
  }

  Future<void> setOrderUpdates(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _orderUpdates = value;
    await prefs.setBool(_orderUpdatesKey, value);
    notifyListeners();
  }

  Future<void> setPersonalizedOffers(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _personalizedOffers = value;
    await prefs.setBool(_offersKey, value);
    notifyListeners();
  }

  Future<void> setBiometricLock(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _biometricLock = value;
    await prefs.setBool(_biometricLockKey, value);
    notifyListeners();
  }

  Future<void> setCurrency(String value) async {
    final prefs = await SharedPreferences.getInstance();
    _currency = value;
    await prefs.setString(_currencyKey, value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    _language = value;
    await prefs.setString(_languageKey, value);
    notifyListeners();
  }

  Future<void> setPreferredSport(String value) async {
    final prefs = await SharedPreferences.getInstance();
    _preferredSport = value;
    await prefs.setString(_preferredSportKey, value);
    notifyListeners();
  }

  Future<void> resetPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    _phone = '';
    _address = '';
    _pushNotifications = true;
    _orderUpdates = true;
    _personalizedOffers = false;
    _biometricLock = false;
    _currency = 'INR';
    _language = 'English';
    _preferredSport = 'Football';

    await prefs.remove(_phoneKey);
    await prefs.remove(_addressKey);
    await prefs.remove(_pushNotificationsKey);
    await prefs.remove(_orderUpdatesKey);
    await prefs.remove(_offersKey);
    await prefs.remove(_biometricLockKey);
    await prefs.remove(_currencyKey);
    await prefs.remove(_languageKey);
    await prefs.remove(_preferredSportKey);

    notifyListeners();
  }
}

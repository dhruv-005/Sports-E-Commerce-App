import 'package:shared_preferences/shared_preferences.dart';

enum AuthLoginResult {
  success,
  notRegistered,
  missingCredentials,
  invalidCredentials,
}

class AuthService {
  static const String _registeredKey = 'auth_registered';
  static const String _loggedInKey = 'auth_logged_in';
  static const String _nameKey = 'auth_name';
  static const String _emailKey = 'auth_email';
  static const String _passwordKey = 'auth_password';

  static Future<bool> isRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_registeredKey) ?? false;
  }

  static Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_registeredKey, true);
    await prefs.setBool(_loggedInKey, false);
    await prefs.setString(_nameKey, name.trim());
    await prefs.setString(_emailKey, email.trim().toLowerCase());
    await prefs.setString(_passwordKey, password.trim());
  }

  static Future<bool> validateLogin({
    required String email,
    required String password,
  }) async {
    final result = await login(
      email: email,
      password: password,
    );
    return result == AuthLoginResult.success;
  }

  static Future<AuthLoginResult> login({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final isRegistered = prefs.getBool(_registeredKey) ?? false;
    if (!isRegistered) {
      return AuthLoginResult.notRegistered;
    }

    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password.trim();
    if (normalizedEmail.isEmpty || normalizedPassword.isEmpty) {
      return AuthLoginResult.missingCredentials;
    }

    final storedEmail = prefs.getString(_emailKey);
    final storedPassword = prefs.getString(_passwordKey);

    if (storedEmail == null || storedPassword == null) {
      return AuthLoginResult.notRegistered;
    }

    if (storedEmail == normalizedEmail && storedPassword == normalizedPassword) {
      return AuthLoginResult.success;
    }

    return AuthLoginResult.invalidCredentials;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, value);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
  }

  static Future<String?> registeredEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<String?> registeredName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  static Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name.trim());
    await prefs.setString(_emailKey, email.trim().toLowerCase());
  }

  static Future<void> updatePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_passwordKey, password.trim());
  }

  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_registeredKey);
    await prefs.remove(_loggedInKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_passwordKey);
  }
}

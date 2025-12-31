import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _tokenKey = 'token';
  static const _userIdKey = 'id_users';
  static const _tourIdKey = 'id_tour';
  static const _usernameKey = 'name_users';
  static const _useroleKey = 'role_users';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_useroleKey, role);
  }
  static Future<void> saveUserId(int idUser) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, idUser);
  }

  static Future<void> saveUserneme(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, name);
  }  
  
  static Future<void> saveTourId(int idtour) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tourIdKey, idtour);
  }
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

    static Future<int?> getTourId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_tourIdKey);
  }
    static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }
    static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_useroleKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> clearToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_tokenKey);
}

}

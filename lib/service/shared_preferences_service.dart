import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late final SharedPreferences _instance;

  static const String _kAuthToken = "authToken";

  static Future<SharedPreferences> init() async =>
      _instance = await SharedPreferences.getInstance();

  static String get token => _instance.getString(_kAuthToken) ?? "";

  static set token(String newToken) => _instance.setString(_kAuthToken, token);
}

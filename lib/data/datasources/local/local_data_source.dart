import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}

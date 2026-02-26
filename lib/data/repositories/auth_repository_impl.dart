import '../../domain/repositories/auth_repository.dart';
import 'package:prepal_app/data/datasources/auth/auth_remote_datasource.dart';
import 'package:prepal_app/data/datasources/local/local_data_source.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource = LocalDataSource();

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> login(String email, String password) async {
    final result = await remoteDataSource.login(email, password);
    final token = result['token'];
    if (token != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    }

    // Example: Authenticated POST request
    final storedToken = await localDataSource.getToken();
    final headers = {
      'Authorization': 'Bearer $storedToken',
      'Content-Type': 'application/json',
    };
    final postResponse = await http.post(
      Uri.parse('https://your-api-url.com/api/v1/user/update'),
      headers: headers,
      body: jsonEncode({
        'field': 'value', // Replace with your actual data
      }),
    );
    if (postResponse.statusCode == 200) {
      // Success: parse response
      final responseData = postResponse.body; // or jsonDecode(postResponse.body)
      // ...use responseData as needed
    } else {
      // Handle error
      throw Exception('Failed to post data');
    }

    return token;
  }
}
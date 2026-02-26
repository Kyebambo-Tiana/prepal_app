
import 'package:flutter/material.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  AuthProvider(this.loginUseCase);

  bool isLoading = false;

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      await loginUseCase(email, password);
    } catch (e) {
      print(e);
    }

    isLoading = false;
    notifyListeners();
  }
}
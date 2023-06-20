import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tukang_online/models/user_model.dart';
import 'package:tukang_online/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;

  UserModel get user => _user!;

  set user(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<bool?> registerCustomer(
      {String? nama, String? email, String? password}) async {
    try {
      UserModel user = await AuthServiceCustomer().register(
        nama: nama,
        email: email,
        password: password,
      );
      _user = user;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool?> registerTukang(
      {String? nama, String? email, String? password}) async {
    try {
      UserModel user = await AuthServiceTukang().register(
        nama: nama,
        email: email,
        password: password,
      );
      _user = user;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool?> login({String? email, String? password}) async {
    try {
      UserModel user = await AuthLogin().login(
        email: email,
        password: password,
      );
      _user = user;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

class AuthProviderr extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  Future<bool> login({required String email, required String password}) async {
    try {
      final authService = AuthLoginn();
      final token = await authService.login(email: email, password: password);

      if (token != null) {
        _token = token;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        notifyListeners();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      _token = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      notifyListeners();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    _token = token;
    notifyListeners();
  }
}

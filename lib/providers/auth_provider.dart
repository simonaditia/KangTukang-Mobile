import 'package:flutter/cupertino.dart';
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
}

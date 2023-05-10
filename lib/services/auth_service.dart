// untuk melakukan request ke dalam backend
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:tukang_online/models/user_model.dart';

class AuthServiceCustomer {
  String baseUrl = 'http://172.10.51.23:8000/auth';

  get response => null;
  Future<UserModel> register({
    String? nama,
    String? email,
    String? password,
  }) async {
    if (nama == null || email == null || password == null) {
      throw Exception('Nama, email, dan password harus diisi');
    }

    var url = '$baseUrl/register-customer';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'nama': nama,
      'email': email,
      'password': password,
    });

    // try {
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    print(response.toString());
    print(response.statusCode.toString());
    print(response.body);

    if (response.statusCode == 201) {
      var data = jsonDecode(response.body)['user'];
      UserModel user = UserModel.fromJson(data);
      // user.token = 'Bearer ' + data['access_token'];
      return user;
    } else {
      throw Exception('Gagal Register');
      // }
      // } catch (e) {
      //   print("-----------blok catch-----------");
      //   print(e.toString);
      //   print(response.toString());
      //   print(response.statusCode.toString());
      //   print("-----------blok catch-----------");
      //   throw Exception("Gagal Register | Blok Catch");
      // }
    }
  }
}

class AuthServiceTukang {
  String baseUrl = 'http://172.10.51.23:8000/auth';

  get response => null;
  Future<UserModel> register({
    String? nama,
    String? email,
    String? password,
  }) async {
    if (nama == null || email == null || password == null) {
      throw Exception('Nama, email, dan password harus diisi');
    }

    var url = '$baseUrl/register-tukang';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'nama': nama,
      'email': email,
      'password': password,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    print(response.toString());
    print(response.statusCode.toString());
    print(response.body);

    if (response.statusCode == 201) {
      var data = jsonDecode(response.body)['user'];
      UserModel user = UserModel.fromJson(data);
      return user;
    } else {
      throw Exception('Gagal Register');
    }
  }
}


// saya mendapatkan hasil log seperti: nosuchmethoderror: the method '[]' was called on null, receiver: null, tried calling: []("user")
// hasil log lagi yaitu: type 'Null' is not a subtype of type 'Map<String, dynamic>'
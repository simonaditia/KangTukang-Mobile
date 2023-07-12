// untuk melakukan request ke dalam backend
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:tukang_online/models/user_model.dart';

class AuthServiceCustomerEmail {
  String baseUrl = 'http://192.168.1.100:8000/auth/v2';

  get response => null;
  Future<UserModel> register({
    String? nama,
    String? email,
    String? password,
    double? latitude,
    double? longitude,
  }) async {
    if (latitude == null || longitude == null) {
      print("Latidue dan Longitude tidak ditemukan");
    }
    if (nama == null || email == null || password == null) {
      throw Exception('Nama, email, dan password harus diisi');
    }

    var url = '$baseUrl/register-customer';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'nama': nama,
      'email': email,
      'password': password,
      'latitude': latitude,
      'longitude': longitude,
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
    }
  }
}

class AuthServiceCustomerNoTelp {
  String baseUrl = 'http://192.168.1.100:8000/auth/v2';

  get response => null;
  Future<UserModel> register({
    String? nama,
    String? notelp,
    String? password,
    double? latitude,
    double? longitude,
  }) async {
    if (latitude == null || longitude == null) {
      print("Latidue dan Longitude tidak ditemukan");
    }
    if (nama == null || notelp == null || password == null) {
      throw Exception('Nama, notelp, dan password harus diisi');
    }

    var url = '$baseUrl/register-customer';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'nama': nama,
      'no_telp': notelp,
      'password': password,
      'latitude': latitude,
      'longitude': longitude,
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
    }
  }
}

class AuthServiceTukangEmail {
  String baseUrl = 'http://192.168.1.100:8000/auth/v2';

  get response => null;
  Future<UserModel> register({
    String? nama,
    String? email,
    String? password,
    double? latitude,
    double? longitude,
  }) async {
    if (latitude == null || longitude == null) {
      print("Latidue dan Longitude tidak ditemukan");
    }
    if (nama == null || email == null || password == null) {
      throw Exception('Nama, email, dan password harus diisi');
    }

    var url = '$baseUrl/register-tukang';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'nama': nama,
      'email': email,
      'password': password,
      'latitude': latitude,
      'longitude': longitude,
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

class AuthServiceTukangNoTelp {
  String baseUrl = 'http://192.168.1.100:8000/auth/v2';

  get response => null;
  Future<UserModel> register({
    String? nama,
    String? notelp,
    String? password,
    double? latitude,
    double? longitude,
  }) async {
    if (latitude == null || longitude == null) {
      print("Latidue dan Longitude tidak ditemukan");
    }
    if (nama == null || notelp == null || password == null) {
      throw Exception('Nama, notelp, dan password harus diisi');
    }

    var url = '$baseUrl/register-tukang';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'nama': nama,
      'no_telp': notelp,
      'password': password,
      'latitude': latitude,
      'longitude': longitude,
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

class AuthLogin {
  // String baseUrl = 'http://192.168.1.100:8000/auth';
  String baseUrl = 'http://localhost:8000/auth';

  get response => null;
  Future<UserModel> login({
    String? email,
    String? password,
  }) async {
    if (email == null || password == null) {
      throw Exception('Nama, email, dan password harus diisi');
    }

    var url = '$baseUrl/login';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
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

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['user'];
      UserModel user = UserModel.fromJson(data);
      // user.token = 'Bearer ' + data['access_token'];
      print(data);
      print(user);
      print("HALOHALO");
      return user;
    } else {
      throw Exception('Gagal Login');
    }
  }
}

class AuthLoginn {
  static const baseUrl = 'http://192.168.1.100:8000/auth';

  Future<String?> login(
      {required String email, required String password}) async {
    final url = Uri.parse('$baseUrl/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['jwt'];
    } else {
      throw Exception('Failed to login');
    }
  }
}

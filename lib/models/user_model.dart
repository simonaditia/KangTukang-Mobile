class UserModel {
  int? id;
  String? nama;
  String? email;
  String? password;
  // String? token;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.password,
    // required this.token,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    email = json['email'];
    password = json['password'];
    // token = json['token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'password': password,
      // 'token': token,
    };
  }
}

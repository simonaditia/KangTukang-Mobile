import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tukang_online/providers/auth_provider.dart';
import 'package:tukang_online/screens/LoginScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isVisible = false;
  TextEditingController namaController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  bool isLoading = false;
  bool isLoadingTukang = false;
  double latitude = 0.0;
  double longitude = 0.0;

  // @override
  // void initState() {
  //   super.initState();
  //   // getToken();
  //   // getCurrentLocation();
  // }

  Color namaColor = Color.fromARGB(255, 92, 92, 92);
  Color emailOrNoTelpColor = Color.fromARGB(255, 92, 92, 92);
  Color passwordColor = Color.fromARGB(255, 92, 92, 92);

  TextEditingController _emailOrNoTelpController =
      TextEditingController(text: '');
  bool _isEmail = false;
  bool _isPhoneNumber = false;

  // @override
  // void dispose() {
  // _emailOrNoTelpController.dispose();
  // for (final focusNode in _focusNodes.values) {
  //   focusNode.dispose();
  // }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    void checkInputT(String value) {
      setState(() {
        // Check if input is an email
        _isEmail = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
            .hasMatch(value);

        // Check if input is a phone number
        _isPhoneNumber = RegExp(r'^[0-9]{10,12}$').hasMatch(value);
      });
    }

    // void getCurrentLocation() async {
    void getCurrentLocation(
        Function(double latitude, double longitude) locationCallback) async {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are disabled, handle this case as needed
        return;
      }

      // Check for location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Location permission not granted, handle this case as needed
          return;
        }
      }

      // Get the current position (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Access the latitude and longitude from the position object
      double latitude = position.latitude;
      double longitude = position.longitude;
      // setState(() {
      //   latitude = position.latitude;
      //   longitude = position.longitude;
      // });
      // Invoke the callback function with the latitude and longitude values
      locationCallback(latitude, longitude);

      // Use these coordinates as needed, for example, display on a map
      print("Latitude");
      print(latitude);
      print("Longitude");
      print(longitude);
    }

    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleSignupCustomerEmail() async {
      setState(() {
        isLoading = true;
      });
      if (_formKey.currentState!.validate()) {
        String nama = namaController.text;
        String email = _emailOrNoTelpController.text;
        String password = passwordController.text;
        if (nama.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
          dynamic result = null;
          // Kirim permintaan ke API untuk memeriksa email
          dynamic checkResult =
              await authProvider.checkEmailAvailability(email);

          if (checkResult['status'] == 'success' &&
              checkResult['available'] == true) {
            // Email tersedia, lanjutkan proses registrasi
            getCurrentLocation((latitude, longitude) async {
              setState(() {
                isLoading = true;
              });
              dynamic result = await authProvider.registerCustomerEmail(
                nama: nama,
                email: email,
                password: password,
                latitude: latitude,
                longitude: longitude,
              );
              print("Register CUSTOMER");
              print(latitude);
              print(longitude);
              if (result != null && checkResult['status'] == 'success') {
                Fluttertoast.showToast(
                  msg: 'Register Berhasil!\n Silahkan Lakukan Login',
                  gravity: ToastGravity.CENTER,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );
                Navigator.pushNamed(context, '/login');
              } else {
                print("di else");
                String errorMessage = result != null
                    ? checkResult['error']
                    : 'Gagal Register Customer!\n Silahkan Register Kembali';
                Fluttertoast.showToast(
                  msg: errorMessage,
                  gravity: ToastGravity.CENTER,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
                setState(() {
                  isLoading = false;
                });
              }
            });
          } else {
            // Email sudah ada, tampilkan peringatan
            Fluttertoast.showToast(
              msg: 'Email sudah digunakan. Gunakan Email lain.',
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.yellow,
              textColor: Colors.black,
            );

            setState(() {
              isLoading = false;
            });
          }
        }
      }
      setState(() {
        isLoading = false;
      });
    }

    handleSignupCustomerNoTelp() async {
      setState(() {
        isLoading = true;
      });
      if (_formKey.currentState!.validate()) {
        String nama = namaController.text;
        String notelp = _emailOrNoTelpController.text;
        String password = passwordController.text;
        if (nama.isNotEmpty && notelp.isNotEmpty && password.isNotEmpty) {
          dynamic result = null;
          // Kirim permintaan ke API untuk memeriksa notelp
          dynamic checkResult =
              await authProvider.checkNoTelpAvailability(notelp);

          if (checkResult['status'] == 'success' &&
              checkResult['available'] == true) {
            // Email tersedia, lanjutkan proses registrasi
            getCurrentLocation((latitude, longitude) async {
              setState(() {
                isLoading = true;
              });
              dynamic result = await authProvider.registerCustomerNoTelp(
                nama: nama,
                notelp: notelp,
                password: password,
                latitude: latitude,
                longitude: longitude,
              );
              print("Register CUSTOMER");
              print(latitude);
              print(longitude);
              if (result != null && checkResult['status'] == 'success') {
                Fluttertoast.showToast(
                  msg: 'Register Berhasil!\n Silahkan Lakukan Login',
                  gravity: ToastGravity.CENTER,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );
                Navigator.pushNamed(context, '/login');
              } else {
                print("di else");
                String errorMessage = result != null
                    ? checkResult['error']
                    : 'Gagal Register Customer!\n Silahkan Register Kembali';
                Fluttertoast.showToast(
                  msg: errorMessage,
                  gravity: ToastGravity.CENTER,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
                setState(() {
                  isLoading = false;
                });
              }
            });
          } else {
            // No Telepon sudah ada, tampilkan peringatan
            Fluttertoast.showToast(
              msg: 'No Telepon sudah digunakan. Gunakan No Telepon lain.',
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.yellow,
              textColor: Colors.black,
            );

            setState(() {
              isLoading = false;
            });
          }
        }
      }
      setState(() {
        isLoading = false;
      });
    }

    /*
    gk bisa, karna user tidak punya jwt
    void saveDataCategories() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('jwt') ?? '';
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      int idUser = decodedToken['id'] as int;
      String apiUrl =
          'http://192.168.1.100:8000/api/v1/users/$idUser/categories/1';
      print(apiUrl);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // body: json.encode({'categories': selectedCategories}),
      );

      if (response.statusCode == 200) {
        print('Data kategori berhasil disimpan');
      } else {
        print('Error: ${response.statusCode}');
      }
    }*/

    handleSignupTukangEmail() async {
      print("EMAIL DETEK");
      setState(() {
        isLoadingTukang = true;
      });
      if (_formKey.currentState!.validate()) {
        String nama = namaController.text;
        String email = _emailOrNoTelpController.text;
        String password = passwordController.text;
        if (nama.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
          dynamic result = null;
          dynamic checkResult =
              await authProvider.checkEmailAvailability(email);
          // saveDataCategories(); gk bisa, karna user tidak punya jwt

          if (checkResult['status'] == 'success' &&
              checkResult['available'] == true) {
            getCurrentLocation((latitude, longitude) async {
              setState(() {
                isLoadingTukang = true;
              });
              dynamic result = await authProvider.registerTukangEmail(
                nama: nama,
                email: email,
                password: password,
                latitude: latitude,
                longitude: longitude,
              );
              if (result != null && checkResult['status'] == 'success') {
                Fluttertoast.showToast(
                  msg: 'Register Berhasil!\nSilahkan Lakukan Login',
                  gravity: ToastGravity.CENTER,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );
                Navigator.pushNamed(context, '/login');
              } else {
                String errorMessage = result != null
                    ? checkResult['error']
                    : 'Gagal Register Tukang!\n Silahkan Register Kembali';
                print("di else");
                Fluttertoast.showToast(
                  msg: errorMessage,
                  gravity: ToastGravity.CENTER,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
                setState(() {
                  isLoadingTukang = false;
                });
              }
            });
          } else {
            // Email sudah ada, tampilkan peringatan
            Fluttertoast.showToast(
              msg: 'Email sudah digunakan. Gunakan email lain.',
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.yellow,
              textColor: Colors.black,
            );

            setState(() {
              isLoadingTukang = false;
            });
          }
        }
      }
      setState(() {
        isLoadingTukang = false;
      });
    }

    handleSignupTukangNoTelp() async {
      print("NO TELP DETEK");
      setState(() {
        isLoadingTukang = true;
      });
      if (_formKey.currentState!.validate()) {
        String nama = namaController.text;
        String notelp = _emailOrNoTelpController.text;
        String password = passwordController.text;
        if (nama.isNotEmpty && notelp.isNotEmpty && password.isNotEmpty) {
          dynamic result = null;
          dynamic checkResult =
              await authProvider.checkNoTelpAvailability(notelp);
          // saveDataCategories(); gk bisa, karna user tidak punya jwt

          if (checkResult['status'] == 'success' &&
              checkResult['available'] == true) {
            getCurrentLocation((latitude, longitude) async {
              setState(() {
                isLoadingTukang = true;
              });
              dynamic result = await authProvider.registerTukangNoTelp(
                nama: nama,
                notelp: notelp,
                password: password,
                latitude: latitude,
                longitude: longitude,
              );
              if (result != null && checkResult['status'] == 'success') {
                Fluttertoast.showToast(
                  msg: 'Register Berhasil!\nSilahkan Lakukan Login',
                  gravity: ToastGravity.CENTER,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );
                Navigator.pushNamed(context, '/login');
              } else {
                String errorMessage = result != null
                    ? checkResult['error']
                    : 'Gagal Register Tukang!\n Silahkan Register Kembali';
                print("di else");
                Fluttertoast.showToast(
                  msg: errorMessage,
                  gravity: ToastGravity.CENTER,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
                setState(() {
                  isLoadingTukang = false;
                });
              }
            });
          } else {
            // no_telp sudah ada, tampilkan peringatan
            Fluttertoast.showToast(
              msg: 'No Telepon sudah digunakan. Gunakan No Telepon lain.',
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.yellow,
              textColor: Colors.black,
            );

            setState(() {
              isLoadingTukang = false;
            });
          }
        }
      }
      setState(() {
        isLoadingTukang = false;
      });
    }

    cekEmailOrNoTelpCustomer() async {
      if (namaController.text.isEmpty ||
          _emailOrNoTelpController.text.isEmpty ||
          passwordController.text.isEmpty) {
        Fluttertoast.showToast(
          msg: 'Mohon isi Email/No Telepon dan Password',
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
        );
      } else if (_isEmail) {
        await handleSignupCustomerEmail();
      } else if (_isPhoneNumber) {
        handleSignupCustomerNoTelp();
      } else {
        Fluttertoast.showToast(
          msg: 'Mohon hanya inputkan format email atau no telepon.',
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
        );
      }
    }

    cekEmailOrNoTelpTukang() async {
      if (_isEmail) {
        await handleSignupTukangEmail();
      } else if (_isPhoneNumber) {
        handleSignupTukangNoTelp();
      } else {
        Fluttertoast.showToast(
          msg: 'Mohon hanya inputkan format email atau no telepon.',
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
        );
      }
    }

    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: ListView(children: [
      SafeArea(
          child: SingleChildScrollView(
              child: Column(children: [
        Container(
          margin: const EdgeInsets.only(top: 50.0),
          height: deviceHeight * 0.20,
          child: FittedBox(
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'),
              radius: 120,
            ),
          ),
        ),
        Container(
          height: deviceHeight * 0.75,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: LayoutBuilder(builder: (ctx, constraints) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Selamat Datang',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.05,
                  ),
                  Center(
                    child: Text(
                      "Silahkan daftarkan akun anda untuk\n mulai menikmati layanan tukang online",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Container(
                  //   height: constraints.maxHeight * 0.10,
                  //   decoration: BoxDecoration(
                  //     color: Color(0xffB4B4B4).withOpacity(0.4),
                  //     borderRadius: BorderRadius.circular(16),
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 15),
                  //     child: Center(
                  //       child: TextFormField(
                  //         controller: _emailOrNoTelpController,
                  //         onChanged: checkInputT,
                  //         decoration: InputDecoration(
                  //           labelText: 'Email / Phone Number',
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 16.0),
                  // Text(
                  //   _isEmail
                  //       ? 'Valid email format'
                  //       : (_isPhoneNumber ? 'Valid phone number format' : ''),
                  // ),
                  // SizedBox(
                  //   height: constraints.maxHeight * 0.08,
                  // ),
                  SizedBox(
                    height: constraints.maxHeight * 0.08,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.10,
                    decoration: BoxDecoration(
                      color: Color(0xffB4B4B4).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Center(
                        child: TextFormField(
                          controller: namaController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Nama Lengkap",
                            labelText: "Nama Lengkap",
                            labelStyle: TextStyle(
                              color: namaColor,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              namaColor = Color(0xffFF5403);
                              emailOrNoTelpColor =
                                  Color.fromARGB(255, 92, 92, 92);
                              passwordColor = Color.fromARGB(255, 92, 92, 92);
                            });
                          },
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return "Nama harus diisi";
                          //   }
                          //   return null;
                          // },
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.02,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.10,
                    decoration: BoxDecoration(
                      color: Color(0xffB4B4B4).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Center(
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          // controller: emailController,
                          controller: _emailOrNoTelpController,
                          onChanged: checkInputT,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email / No Telepon",
                            labelText: "Email / No Telepon",
                            labelStyle: TextStyle(
                              color: emailOrNoTelpColor,
                            ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //     color: Color(0xffFF5403),
                            //   ),
                            // ),
                          ),
                          onTap: () {
                            setState(() {
                              namaColor = Color.fromARGB(255, 92, 92, 92);
                              emailOrNoTelpColor = Color(0xffFF5403);
                              passwordColor = Color.fromARGB(255, 92, 92, 92);
                            });
                          },
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return "Email harus diisi";
                          //   }
                          //   // if (!EmailValidator.validate(value)) {
                          //   //   return 'Masukkan email yang valid';
                          //   // }
                          //   return null;
                          // },
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.02,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.10,
                    decoration: BoxDecoration(
                      color: Color(0xffB4B4B4).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Center(
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: _isVisible ? false : true,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isVisible = !_isVisible;
                                });
                              },
                              icon: Icon(
                                _isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                            border: InputBorder.none,
                            hintText: "Password",
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: passwordColor,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              namaColor = Color.fromARGB(255, 92, 92, 92);
                              emailOrNoTelpColor =
                                  Color.fromARGB(255, 92, 92, 92);
                              passwordColor = Color(0xffFF5403);
                            });
                          },
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return "Password harus diisi";
                          //   }
                          //   return null;
                          // },
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ),
                  ),
                  isLoading
                      ? Container(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.10,
                          margin: EdgeInsets.only(
                            top: constraints.maxHeight * 0.04,
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'Loading',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xffFF5403),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.10,
                          margin: EdgeInsets.only(
                            top: constraints.maxHeight * 0.04,
                          ),
                          child: ElevatedButton(
                            // onPressed: handleSignupCustomer,
                            onPressed: cekEmailOrNoTelpCustomer,
                            child: Text(
                              'Register Sebagai Customer',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xffFF5403),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                  isLoadingTukang
                      ? Container(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.10,
                          margin: EdgeInsets.only(
                            top: constraints.maxHeight * 0.04,
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  'Loading',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xffFF5403),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.10,
                          margin: EdgeInsets.only(
                            top: constraints.maxHeight * 0.01,
                          ),
                          child: ElevatedButton(
                            onPressed: cekEmailOrNoTelpTukang,
                            child: Text(
                              'Register Sebagai Tukang',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xffFF5403),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: constraints.maxHeight * 0.01,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Sudah punya akun?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      children: [
                        TextSpan(
                          text: " Login",
                          style: TextStyle(
                            color: Color(0xffFF5403),
                            fontSize: 18,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginScreen();
                                  },
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        )
      ])))
    ]));
  }
}

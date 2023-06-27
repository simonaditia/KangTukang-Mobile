import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tukang_online/providers/auth_provider.dart';
import 'package:tukang_online/screens/LoginScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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

  @override
  Widget build(BuildContext context) {
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

    handleSignupCustomer() async {
      setState(() {
        isLoading = true;
      });
      if (_formKey.currentState!.validate()) {
        String nama = namaController.text;
        String email = emailController.text;
        String password = passwordController.text;
        if (nama.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
          dynamic result = null;
          getCurrentLocation((latitude, longitude) async {
            dynamic result = await authProvider.registerCustomer(
              nama: nama,
              email: email,
              password: password,
              latitude: latitude,
              longitude: longitude,
            );
            print("Register CUSTOMER");
            print(latitude);
            print(longitude);
            if (result != null) {
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
              Fluttertoast.showToast(
                msg: 'Gagal Register Customer!\n Silahkan Register Kembali',
                gravity: ToastGravity.CENTER,
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }
            setState(() {
              isLoading = false;
            });
          });
        }
      }
    }

    handleSignupTukang() async {
      setState(() {
        isLoadingTukang = true;
      });
      if (_formKey.currentState!.validate()) {
        String nama = namaController.text;
        String email = emailController.text;
        String password = passwordController.text;
        if (nama.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
          dynamic result = null;
          getCurrentLocation((latitude, longitude) async {
            dynamic result = await authProvider.registerTukang(
              nama: nama,
              email: email,
              password: password,
              latitude: latitude,
              longitude: longitude,
            );
            if (result != null) {
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
              Fluttertoast.showToast(
                msg: 'Gagal Register Tukang!\n Silahkan Register Kembali',
                gravity: ToastGravity.CENTER,
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }
            setState(() {
              isLoadingTukang = false;
            });
          });
        }
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
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Nama harus diisi";
                            }
                            return null;
                          },
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
                          controller: emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email harus diisi";
                            }
                            return null;
                          },
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
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password harus diisi";
                            }
                            return null;
                          },
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
                            onPressed: handleSignupCustomer,
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
                            onPressed: handleSignupTukang,
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

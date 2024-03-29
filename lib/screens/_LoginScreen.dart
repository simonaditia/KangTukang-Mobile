import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tukang_online/providers/auth_provider.dart';
import 'package:tukang_online/screens/RegisterScreen.dart';
import 'package:tukang_online/screens/customer/CustomerDashboardScreen.dart';
import 'package:tukang_online/screens/tukang/TukangDashboardScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isVisible = false;
  // //  final _formKey = GlobalKey<FormState>();
  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  bool isLoading = false;

  // final _formKey = GlobalKey<FormState>();

  // String _email = "";
  // String _password = "";
  // String _error = "";

  // bool _isLoading = false;

  // Future<void> _login() async {
  //   setState(() {
  //     _isLoading = true;
  //     _error = "";
  //   });

  //   final url = Uri.parse("localhost:8000/auth/login");
  //   final response =
  //       await http.post(url, body: {"email": _email, "password": _password});

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);

  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString("token", data["token"]);

  //     Navigator.pushNamedAndRemoveUntil(
  //         context, "/customer_dashboard", (route) => false);
  //   } else {
  //     setState(() {
  //       _error = "Invalid email or password";
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleLogin() async {
      setState(() {
        isLoading = true;
      });
      //   String email = emailController.text ?? "";
      //   String password = passwordController.text ?? "";
      // if (email.isNotEmpty && password.isNotEmpty) {
      //   if (await authProvider.login(
      //   email: email,
      //   password: password,
      // )) {
      //   Navigator.pushNamed(context, "/dashboard-customer");
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Gagal Login", textAlign: TextAlign.center,), backgroundColor: Color(0xFFEFEFEF),)
      //   )
      // }
      // }
      if (_formKey.currentState!.validate()) {
        String email = emailController.text ?? "";
        String password = passwordController.text ?? "";
        if (email.isNotEmpty && password.isNotEmpty) {
          final result = await authProvider.login(
            email: email,
            password: password,
          );

          if (result != null) {
            Navigator.pushNamed(context, '/dashboard-customer');
          } else {
            print("di else");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Gagal Login!",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          setState(() {
            isLoading = false;
          });
        }
      }
    }

// @override
    /*void initState() {
      super.initState();
      Provider.of<AuthProviderr>(context, listen: false).checkLoginStatus();
    }

    Future<void> handleLogin(BuildContext context) async {
      setState(() {
        isLoading = true;
      });

      final email = emailController.text.trim();
      final password = passwordController.text;

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success =
          await authProvider.login(email: email, password: password);

      if (success != null) {
        Navigator.pushNamed(context, '/dashboard-customer');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to login'),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    }*/

    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                height: deviceHeight * 0.65,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: LayoutBuilder(builder: (ctx, constraints) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.05,
                        ),
                        Center(
                          child: Text(
                            'Silakan masukkan Email dan Kata sandi \nAnda untuk masuk ke aplikasi',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.08,
                        ),
                        Container(
                          height: constraints.maxHeight * 0.12,
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
                                  hintText: "test@gmail.com",
                                ),
                                textInputAction: TextInputAction.next,
                                // onChanged: (value) =>
                                //     setState(() => _email = value.trim()),
                                // validator: (value) =>
                                //     value!.isEmpty ? "Email is required" : null,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        Container(
                          height: constraints.maxHeight * 0.12,
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
                                textInputAction: TextInputAction.done,
                                // onChanged: (value) =>
                                //     setState(() => _password = value.trim()),
                                // validator: (value) => value!.isEmpty
                                //     ? "Password is required"
                                //     : null,
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(height: 16),
                        // if (_isLoading) CircularProgressIndicator(),
                        // if (_error.isNotEmpty)
                        //   Text(_error, style: TextStyle(color: Colors.red)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Lupa Password?",
                                style: TextStyle(
                                  color: Color(0xffFF5403),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.12,
                          margin: EdgeInsets.only(
                            top: constraints.maxHeight * 0.05,
                          ),
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () => handleLogin(),
                            // onPressed: () {
                            //   // if (_formKey.currentState!.validate()) {
                            //   //   _login();
                            //   // }
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) {
                            //         return CustomerDashboardScreen();
                            //       },
                            //     ),
                            //   );
                            // },
                            child: isLoading
                                ? CircularProgressIndicator()
                                : Text(
                                    'Login',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
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
                          height: constraints.maxHeight * 0.02,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Belum punya akun!",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            children: [
                              TextSpan(
                                  text: " Register",
                                  style: TextStyle(
                                    color: Color(0xffFF5403),
                                    fontSize: 18,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen()),
                                      );
                                    }),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.02,
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.info, color: Color(0xffFF5403)),
                          label: Text("Tukang Dashboard"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return TukangDashboardScreen();
                                },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            minimumSize: Size(180, 40),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

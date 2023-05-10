import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tukang_online/providers/auth_provider.dart';
import 'package:tukang_online/screens/LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isVisible = false;
  TextEditingController namaController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

//   halo tolong bantu saya, saya mempunyai kode ini dan terjadi error A nullable expression can't be used as a condition.
// Try checking that the value isn't 'null' before using it as a condition.
    handleSignupCustomer() async {
      if (_formKey.currentState!.validate()) {
        String nama = namaController.text ?? "";
        String email = emailController.text ?? "";
        String password = passwordController.text ?? "";
        if (nama.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
          final result = await authProvider.registerCustomer(
            nama: nama,
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
                  "Gagal Register Customer!",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        }
      }
    }

    handleSignupTukang() async {
      String nama = namaController.text ?? "";
      String email = emailController.text ?? "";
      String password = passwordController.text ?? "";
      if (nama.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        if (await authProvider.registerTukang(
              nama: nama,
              email: email,
              password: password,
            ) ==
            true) {
          Navigator.pushNamed(context, '/dashboard-tukang');
        }
      }
    }

    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(children: [
        SafeArea(
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
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.05,
                          ),
                          Center(
                            child: Text(
                              "Silahkan daftarkan akun anda untuk\n mulai meikmati layanan tukang online",
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
                                  },
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     TextButton(
                          //       onPressed: () {},
                          //       child: Text(
                          //         "Lupa Password?",
                          //         style: TextStyle(
                          //           color: Color(0xffFF5403),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Container(
                            width: double.infinity,
                            height: constraints.maxHeight * 0.10,
                            margin: EdgeInsets.only(
                              top: constraints.maxHeight * 0.04,
                            ),
                            child: ElevatedButton(
                              onPressed: handleSignupCustomer,
                              // onPressed: () {
                              //   Navigator.pop(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) {
                              //         return LoginScreen();
                              //       },
                              //     ),
                              //   );
                              // },
                              child: Text(
                                'Register Sebagai Customer',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xffFF5403),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: constraints.maxHeight * 0.02,
                          // ),
                          Container(
                            width: double.infinity,
                            height: constraints.maxHeight * 0.10,
                            margin: EdgeInsets.only(
                              top: constraints.maxHeight * 0.01,
                            ),
                            child: ElevatedButton(
                              onPressed: handleSignupTukang,
                              // onPressed: () {
                              //   Navigator.pop(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) {
                              //         return LoginScreen();
                              //       },
                              //     ),
                              //   );
                              // },
                              child: Text(
                                'Register Sebagai Tukang',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
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
                                      }),
                              ],
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
      ]),
    );
  }
}

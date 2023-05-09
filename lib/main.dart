import 'package:flutter/material.dart';
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/core.engine.dart';
// import 'package:here_sdk/core.errors.dart';
import 'package:tukang_online/screens/LoginScreen.dart';
import 'package:tukang_online/screens/RegisterScreen.dart';
import 'package:tukang_online/screens/customer/CustomerDashboardScreen.dart';

void main() {
  // SdkContext.init(IsolateOrigin.main);
  // _initializeHERESDK();
  runApp(const MyApp());
}

/*void _initializeHERESDK() async {
  // Needs to be called before accessing SDKOptions to load necessary libraries.
  SdkContext.init(IsolateOrigin.main);

  // Set your credentials for the HERE SDK.
  String accessKeyId = "2MWr5nhadSBUvYYJEZVgpA";
  String accessKeySecret =
      "pi14N0N5P-otav3SjsN7x571t5w4G6rw7UYmwz_yrAlgd9LitaCiknkhg7bUYZBJe1ZHj7GOcOrPwkdq1aLeqA";
  SDKOptions sdkOptions =
      SDKOptions.withAccessKeySecret(accessKeyId, accessKeySecret);

  try {
    await SDKNativeEngine.makeSharedInstance(sdkOptions);
  } on InstantiationException {
    throw Exception("Failed to initialize the HERE SDK.");
  }
}*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 123',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => LoginScreen(),
      //   '/register': (context) => RegisterScreen(),
      //   '/customer_dashboard': (context) => CustomerDashboardScreen(),
      // },
    );
  }
}

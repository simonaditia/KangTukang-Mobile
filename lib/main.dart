import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tukang_online/providers/auth_provider.dart';
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/core.engine.dart';
// import 'package:here_sdk/core.errors.dart';
import 'package:tukang_online/screens/LoginScreen.dart';
import 'package:tukang_online/screens/RegisterScreen.dart';
import 'package:tukang_online/screens/customer/CustomerDashboardScreen.dart';
import 'package:tukang_online/screens/customer/CustomerPesanScreen.dart';
import 'package:tukang_online/screens/customer/CustomerPesananScreen.dart';
import 'package:tukang_online/screens/customer/CustomerProfileScreen.dart';
import 'package:tukang_online/screens/customer/CustomerSearchScreen.dart';
import 'package:tukang_online/screens/customer/CustomerTentangAppScreen.dart';
import 'package:tukang_online/screens/tukang/TukangDashboardScreen.dart';
import 'package:tukang_online/screens/tukang/TukangPesananScreen.dart';
import 'package:tukang_online/screens/tukang/TukangProfileScreen.dart';
import 'package:tukang_online/screens/tukang/TukangTentangAppScreen.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter 123',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/dashboard-tukang': (context) => TukangDashboardScreen(),
          '/dashboard-customer': (context) => CustomerDashboardScreen(),
          '/status-pesanan-customer': (context) => CustomerPesananScreen(),
          '/status-pesanan-tukang': (context) => TukangPesananScreen(),
          '/cari-tukang': (context) => CustomerSearchScreen(),
          '/customer-pesan': (context) => CustomerPesanScreen(),
          '/edit-profile-customer': (context) => CustomerProfileScreen(),
          '/edit-profile-tukang': (context) => TukangProfileScreen(),
          '/tentang-app-customer': (context) => CustomerTentangAppScreen(),
          '/tentang-app-tukang': (context) => TukangTentangAppScreen(),
        },
        /*home: LoginScreen(),*/
        // initialRoute: '/',
        // routes: {
        //   '/': (context) => LoginScreen(),
        //   '/register': (context) => RegisterScreen(),
        //   '/customer_dashboard': (context) => CustomerDashboardScreen(),
        // },
      ),
    );
  }
}

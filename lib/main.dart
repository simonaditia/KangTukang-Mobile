import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  // Inisialisasi Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Mengonfigurasi Firebase Storage
  // FirebaseStorage storage = FirebaseStorage.instance;
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? role = "";
  @override
  void initState() {
    super.initState();
    // _getTokenAndFetchNama();
    // _fetchNama();
    // loadUserRole();
    getUserRole(context);
  }

  Future<String> getUserRole(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt') ?? '';

    if (jwt != null && jwt.isNotEmpty) {
      String role = decodeUserRoleFromJwt(jwt);
      return role;
    } else {
      Navigator.pushReplacementNamed(context, '/login');
      return ''; // Jika tidak ada token JWT, Anda dapat mengembalikan nilai yang sesuai di sini
    }
  }

  String decodeUserRoleFromJwt(String jwt) {
    var decodedToken = JwtDecoder.decode(jwt);
    return decodedToken['role'];
  }

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
          '/': (context) => FutureBuilder<String>(
                future: getUserRole(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Menampilkan indikator loading saat menunggu role pengguna
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Menampilkan pesan error jika terjadi kesalahan dalam mengambil role pengguna
                    return Text('Error retrieving user role');
                  } else {
                    if (snapshot.data == '') {
                      // Jika tidak ada data yang tersedia (misalnya token JWT kosong), arahkan ke halaman login
                      return LoginScreen();
                    } else if (snapshot.data == 'customer') {
                      return CustomerDashboardScreen();
                    } else if (snapshot.data == 'tukang') {
                      return TukangDashboardScreen();
                    } else {
                      // Jika role tidak valid, arahkan ke halaman login
                      return LoginScreen();
                    }
                  }
                },
              ),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/dashboard-tukang': (context) => TukangDashboardScreen(),
          '/dashboard-customer': (context) => CustomerDashboardScreen(),
          '/status-pesanan-customer': (context) => CustomerPesananScreen(),
          '/status-pesanan-tukang': (context) => TukangPesananScreen(),
          '/cari-tukang': (context) =>
              CustomerSearchScreen(tukangId: '', keyword: ''),
          '/customer-pesan': (context) => CustomerPesanScreen(
                tukangId: '',
              ),
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

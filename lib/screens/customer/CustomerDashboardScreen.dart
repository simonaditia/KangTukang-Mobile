import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tukang_online/screens/LoginScreen.dart';
import 'package:tukang_online/screens/customer/CustomerPesananScreen.dart';
import 'package:tukang_online/screens/customer/CustomerProfileScreen.dart';
import 'package:tukang_online/screens/customer/CustomerSearchScreen.dart';
import 'package:tukang_online/screens/customer/CustomerTentangAppScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  // Uri gmailUrl = Uri.parse(
  //     'mailto:simonaditia22@gmail.com?subject=KangTukang&body=Halo, ...');
  /*void _sendEmail() async {
    final Uri emailLaunchUri = Uri(
  scheme: 'mailto',
  path: 'youremail@example.com',
  query: 'subject=Email Subject&body=Email body',
);
if (await canLaunchUrl(emailLaunchUri.toString())) {
  await launchUrl(emailLaunchUri.toString());
} else {
  throw 'Could not launch ${emailLaunchUri.toString()}';
}
  }*/

  // String? authToken; // Simpan token di dalam variabel ini
  String? _nama = ""; // Simpan nama pengguna di dalam variabel ini
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    checkJWTToken();
    // _getTokenAndFetchNama();
    // _fetchNama();
    loadUserNama();
  }

  Future<void> checkJWTToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString('jwt') ?? '';

    if (jwtToken == null || jwtToken == '' || jwtToken.isEmpty) {
      // Token JWT is not available, display the toast warning
      // Tampilkan peringatan toast
      Fluttertoast.showToast(
          msg: 'Anda harus login dulu\nSilahkan Login ya',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color(0xffFF5403));
      // Redirect the user to the login page
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> loadUserNama() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idUser = decodedToken['id'] as int;
    final response = await http.get(
      Uri.parse('http://192.168.1.100:8000/api/v1/users/$idUser'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Menangani respons yang berhasil
      var responseData = response.body;
      print(responseData);
      var decodedData = json.decode(responseData);
      setState(() {
        userData = decodedData['data'];
        print(userData);
      });
    } else {
      // Menangani respons yang gagal
      throw Exception('Gagal mengambil data dari API');
    }
  }

  // Future<void> _getTokenAndFetchNama() async {
  //   String? token = await _getToken();
  //   if (token != null) {
  //     _fetchNama(token);
  //   }
  // }

  /*Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  Future<String?> getData() async {
    String? token = await _getToken();
    print("TOKEN");
    print(token);
    print("TOKEN");
    if (token != null) {
      // _fetchNama(token);
      var url = Uri.parse('http://192.168.1.100:8000/api/v1/users');

      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var data = response.body;
        print(data);
        return data;
      } else {
        print('Error: ${response.statusCode}');
      }
    }
    return null;
  }
*/
  /*String _getNamaFromToken(String token) {
    List<String> parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Token tidak valid');
    }

    String payload = parts[1];
    String decodedPayload = _decodeBase64Url(payload);

    Map<String, dynamic> payloadData = jsonDecode(decodedPayload);
    List<dynamic> users = payloadData['data'];

    if (users.isNotEmpty) {
      String nama = users[0]['nama'] ?? '';
      return nama;
    } else {
      throw Exception('Data pengguna tidak tersedia dalam respons');
    }
  }*/

  /*String? _getNamaFromToken(String token) {
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

    // Pastikan token valid dan memiliki payload dengan data nama
    if (decodedToken.containsKey('nama')) {
      return decodedToken['nama'];
    }

    return null;
  }*/

  /*String _decodeBase64Url(String input) {
    String normalizedInput = input;
    while (normalizedInput.length % 4 != 0) {
      normalizedInput += '=';
    }
    String decoded = utf8.decode(base64Url.decode(normalizedInput));
    return decoded;
  }*/
  /*Future<void> _fetchNama() async {
    // if (authToken != null) {
      // String? fetchedNama = _getNamaFromToken(authToken!);

      if (fetchedNama != null) {
        setState(() {
          _nama = fetchedNama;
        });
      }
    }
  }*/

  void logout() async {
    // Menghapus token JWT dan role dari shared_preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt', '');
    // await prefs.remove('jwt');
    // await prefs.remove('role');

    // Pindah ke halaman login setelah logout
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login', // Ganti dengan nama route untuk halaman login
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
          child: Image(
            image: AssetImage("assets/images/logo.png"),
          ),
        ),
        // leadingWidth: 50,
        title: Text(
          "Kang Tukang",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          /*IconButton(
                  icon: Icon(Icons.edit_note),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CustomerPesananScreen();
                        },
                      ),
                    );
                  },
                  color: Colors.black,
                ),*/
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              icon: Icon(Icons.more_vert, color: Color(0xffFF5403)),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_note,
                          color: Color(0xffFF5403),
                        ),
                        Text(" Status Pesanan"),
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(
                          Icons.manage_accounts,
                          color: Color(0xffFF5403),
                        ),
                        Text(" Edit Profile"),
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Color(0xffFF5403),
                        ),
                        Text(" Log Out"),
                      ],
                    ),
                    onTap: logout,
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CustomerPesananScreen();
                      },
                    ),
                  );
                } else if (value == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CustomerProfileScreen();
                      },
                    ),
                  );
                }
                /*else if (value == 2) {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen();
                            },
                          ),
                        );
                      }*/
                // else if (value == 2) {
                //   print("Logout menu is selected.");
                // }
              }),
        ],
        flexibleSpace: Container(
          color: Colors.white,
        ),
        elevation: 0,
        // automaticallyImplyLeading: false,
      ),
      body: userData != null
          ? ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              // mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  child: SizedBox(
                    width: 700,
                    height: 320,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          // color: Colors.yellow,
                          child: SizedBox(
                            width: 700,
                            height: 150,
                            child: Container(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hi,  ${userData!['nama']}!",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Pilih jasa tukang yang sesuai dengan kebutuhan",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            color: Color(0xffFF5403),
                            // boxShadow: [
                            //   BoxShadow(color: Colors.yellowAccent, spreadRadius: 3),
                            // ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton.icon(
                              icon:
                                  Icon(Icons.search, color: Color(0xffFF5403)),
                              label: Text("Cari Tukang Terdekat"),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CustomerSearchScreen(
                                        tukangId: '',
                                      );
                                    },
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                minimumSize: Size(320, 55),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.asset(
                                          "assets/images/dashboard-img1b.jpg",
                                          fit: BoxFit.fill),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                  ),
                                  Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.asset(
                                          "assets/images/dashboard-img2.jpg",
                                          fit: BoxFit.fill),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                  ),
                                  Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.asset(
                                          "assets/images/dashboard-img3c.jpg",
                                          fit: BoxFit.fill),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    // padding: EdgeInsets.all(10),
                    padding: EdgeInsets.only(
                        left: 17, top: 10, right: 10, bottom: 10),
                    // color: Colors.blue,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 5),
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text("Kategori")),
                        Card(
                          child: SizedBox(
                            width: 370,
                            height: 280,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 17.0, bottom: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                // Arahkan ke halaman Search dengan parameter "renovasi"
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomerSearchScreen(
                                                            tukangId: '',
                                                            keyword:
                                                                "renovasi"),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          'assets/images/renovasi.jpg'),
                                                      radius: 50,
                                                    ),
                                                    Text("Renovasi"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                // Arahkan ke halaman Search dengan parameter "renovasi"
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomerSearchScreen(
                                                            tukangId: '',
                                                            keyword: "cat"),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          'assets/images/catb.jpg'),
                                                      radius: 50,
                                                    ),
                                                    Text("Cat"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                // Arahkan ke halaman Search dengan parameter "renovasi"
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomerSearchScreen(
                                                            tukangId: '',
                                                            keyword: "plafon"),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          'assets/images/plafon.jpg'),
                                                      radius: 50,
                                                    ),
                                                    Text("Plafon"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              // Arahkan ke halaman Search dengan parameter "renovasi"
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CustomerSearchScreen(
                                                          tukangId: '',
                                                          keyword: "kebocoran"),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        'assets/images/kebocoran.jpg'),
                                                    radius: 50,
                                                  ),
                                                  Text("Kebocoran"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              // Arahkan ke halaman Search dengan parameter "renovasi"
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CustomerSearchScreen(
                                                          tukangId: '',
                                                          keyword: "keramik"),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        'assets/images/keramik.jpg'),
                                                    radius: 50,
                                                  ),
                                                  Text("Keramik"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              // Arahkan ke halaman Search dengan parameter "renovasi"
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CustomerSearchScreen(
                                                          tukangId: '',
                                                          keyword: "dinding"),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        'assets/images/dinding.jpeg'),
                                                    radius: 50,
                                                  ),
                                                  Text("Dinding"),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                    padding: EdgeInsets.only(
                        left: 10, top: 10, right: 10, bottom: 20),
                    // color: Colors.green,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 10),
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text("Lainnya")),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Card(
                            //   child: SizedBox(
                            //     width: 177,
                            //     height: 47,
                            //     child: Container(
                            //       margin: EdgeInsets.only(left: 10),
                            //       child: Row(
                            //         children: [
                            //           Icon(Icons.favorite, color: Colors.green),
                            //           Text("Tentang APP"),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            ElevatedButton.icon(
                              icon: Icon(Icons.info, color: Color(0xffFF5403)),
                              label: Text("Tentang APP"),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CustomerTentangAppScreen();
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
                            ElevatedButton.icon(
                              icon: Icon(Icons.contact_mail,
                                  color: Color(0xffFF5403)),
                              label: Text("Hubungi Kami"),
                              onPressed: () async {
                                debugPrint("keklik, tapi gk masuk ke if");
                                String email = 'simonaditia22@gmail.com';
                                String subject = 'KangTukang - Bertanya';
                                String body = 'Halo ....';

                                String emailUrl =
                                    "mailto:$email?subject=$subject&body=$body";

                                if (await canLaunch(emailUrl)) {
                                  await launch(emailUrl);
                                  debugPrint("INi harusnya bisa");
                                } else {
                                  debugPrint("INI ERROR harusnya");
                                  throw "Error occured sending an email";
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                minimumSize: Size(180, 40),
                              ),
                            ),

                            // Card(
                            //   child: SizedBox(
                            //     width: 177,
                            //     height: 47,
                            //     child: Row(
                            //       children: [
                            //         Icon(Icons.favorite, color: Colors.green),
                            //         Text("Hubungi Kami"),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    )),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFF5403)),
              ),
            ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tukang_online/screens/LoginScreen.dart';
import 'package:tukang_online/screens/customer/CustomerPesanScreen.dart';
import 'package:tukang_online/screens/customer/CustomerPesananScreen.dart';
import 'package:tukang_online/screens/tukang/TukangPesananScreen.dart';
import 'package:tukang_online/screens/tukang/TukangProfileScreen.dart';
import 'package:tukang_online/screens/tukang/TukangTentangAppScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TukangDashboardScreen extends StatefulWidget {
  const TukangDashboardScreen({super.key});

  @override
  State<TukangDashboardScreen> createState() => _TukangDashboardScreenState();
}

class _TukangDashboardScreenState extends State<TukangDashboardScreen> {
  String? _nama = ""; // Simpan nama pengguna di dalam variabel ini
  Map<String, dynamic>? userData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // loadUserNama();
  }

  @override
  void initState() {
    super.initState();
    checkJWTToken();
    // _getTokenAndFetchNama();
    // _fetchNama();
    loadUserNama();
    fetchDataStatusMenunggu();
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

      if (userData!['Categories'] == null || userData!['Categories'].isEmpty) {
        Fluttertoast.showToast(
            msg: 'Silahkan Pilih Kategori Pekerjaan\nDimenu Edit Profile',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Color(0xffFF5403));
      }
    } else {
      // Menangani respons yang gagal
      throw Exception('Gagal mengambil data dari API');
    }
  }

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

  List<dynamic> dataSDikerjakan = []; // Variabel untuk menyimpan data dari API
  List<dynamic> dataSSelesai = []; // Variabel untuk menyimpan data dari API
  List<dynamic> dataSMenunggu = []; // Variabel untuk menyimpan data dari API
  // var random = Random();

  Future<void> fetchDataStatusMenunggu() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idTukang = decodedToken['id'] as int;
    final String apiUrlSMenunggu =
        'http://192.168.1.100:8000/api/v1/orders/statusOrderTukangMenunggu?id_tukang=$idTukang';

    print("TOKEN DI Pesanan screen");
    print(token);
    final responseSMenunggu = await http.get(
      Uri.parse(apiUrlSMenunggu),
      headers: {
        'Authorization':
            'Bearer $token', // Ganti <your_jwt_token> dengan token JWT yang valid
      },
    );

    if (responseSMenunggu.statusCode == 200) {
      final jsonData = jsonDecode(responseSMenunggu.body);
      final List<dynamic> responseSMenungguData =
          jsonData['data']; // Mengakses array 'data'

      setState(() {
        dataSMenunggu = responseSMenungguData;
      });
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  void _refreshData() {
    // Tambahkan fungsi ini untuk mengambil data baru
    // dari server menggunakan API atau sumber data lainnya
    setState(() {
      // Contoh penggunaan data sementara
      dataSMenunggu = List<dynamic>.empty(growable: true);
    });
  }

  Future<void> _rejectOrder(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idTukang = decodedToken['id'] as int;

    final String response =
        'http://192.168.1.100:8000/api/v1/orders/rejectOrderByTukang/$orderId';

    final responsePost = await http.put(
      Uri.parse(response),
      headers: {
        'Authorization':
            'Bearer $token', // Ganti <your_jwt_token> dengan token JWT yang valid
      },
    );

    // final response = await http.post(
    //   'http://localhost:8000/api/v1/orders/rejectOrderByTukang/$orderId',
    // );
    if (responsePost.statusCode == 200) {
      fetchDataStatusMenunggu();
      setState(() {
        dataSMenunggu.removeWhere((item) => item['ID'] == orderId);
      });
    }
  }

  Future<void> _acceptOrder(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idTukang = decodedToken['id'] as int;

    final String response =
        'http://192.168.1.100:8000/api/v1/orders/accOrderByTukang/$orderId';

    final responsePost = await http.put(
      Uri.parse(response),
      headers: {
        'Authorization':
            'Bearer $token', // Ganti <your_jwt_token> dengan token JWT yang valid
      },
    );

    if (responsePost.statusCode == 200) {
      fetchDataStatusMenunggu();
      setState(() {
        dataSMenunggu.removeWhere((item) => item['ID'] == orderId);
      });
    }
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
                          return TukangPesananScreen();
                        },
                      ),
                    );
                  } else if (value == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return TukangProfileScreen();
                        },
                      ),
                    );
                  } else if (value == 2) {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  }
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
            ? Column(
                children: [
                  Container(
                    child: SizedBox(
                      width: 700,
                      height: 150,
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Halo, ${userData!['nama']}!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                "Semoga harimu menyenangkan dan sukses dalam menerima pesanan dari pelanggan.",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      color: Color(0xffFF5403),
                    ),
                  ),
                  Container(
                      // margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text("Daftar Pesanan")),
                          SingleChildScrollView(
                            child: Container(
                                margin: EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width: 370,
                                  height: 425,
                                  child: RefreshIndicator(onRefresh: () async {
                                    fetchDataStatusMenunggu();
                                  }, child: FutureBuilder(
                                      // future:
                                      //     fetchDataStatusMenunggu(), // Mengganti fetchData() dengan fungsi atau metode yang digunakan untuk mengambil data tukangData dan item
                                      builder: (context, snapshot) {
                                    if (dataSMenunggu == [] ||
                                        dataSMenunggu == null) {
                                      return Center(
                                        child:
                                            CircularProgressIndicator(), // Menampilkan loading spinner
                                      );
                                    } else {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                              "Terjadi kesalahan dalam memuat data"), // Menampilkan pesan kesalahan jika terjadi error
                                        );
                                      } else {
                                        if (dataSMenunggu.isEmpty) {
                                          return Center(
                                            child: Text(
                                                "Tidak ada daftar pesanan"), // Menampilkan pesan jika data kosong
                                          );
                                        } else {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              // physics: NeverScrollableScrollPhysics(),
                                              itemCount: dataSMenunggu.length,
                                              itemBuilder: (context, index) {
                                                final item =
                                                    dataSMenunggu[index];
                                                DateTime selectedDateTimeAwal =
                                                    DateTime.parse(item[
                                                        'jadwal_perbaikan_awal']);

                                                DateTime selectedDateTimeAkhir =
                                                    DateTime.parse(item[
                                                        'jadwal_perbaikan_akhir']);
                                                int differenceInDays =
                                                    selectedDateTimeAkhir
                                                            .difference(
                                                                selectedDateTimeAwal)
                                                            .inDays +
                                                        1;
                                                return Card(
                                                  child: SizedBox(
                                                    width: 370,
                                                    height: 190,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  bottom: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Spacer(flex: 1),
                                                              Column(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .house_siding,
                                                                    color: Color(
                                                                        0xffFF5403),
                                                                    size: 30.0,
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                              ),
                                                              // Spacer(flex: 1),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    item[
                                                                        'nama_customer'],
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                10),
                                                                    child: Text(
                                                                      item[
                                                                          'detail_perbaikan'],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Spacer(flex: 1),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10),
                                                          child: Text(
                                                            "Lama Pengerjaan: $differenceInDays hari",
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10),
                                                          child: Center(
                                                            child: Text(
                                                                "Total Biaya: Rp.${item['total_biaya']}"),
                                                          ),
                                                        ),
                                                        Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  ElevatedButton
                                                                      .icon(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: Color(
                                                                            0xffFF5403)),
                                                                    label: Text(
                                                                        "Tolak"),
                                                                    onPressed:
                                                                        () {
                                                                      _rejectOrder(
                                                                          item[
                                                                              'ID']);
                                                                      // Navigator.push(
                                                                      //   context,
                                                                      //   MaterialPageRoute(
                                                                      //     builder: (context) {
                                                                      //       return CustomerTentangAppScreen();
                                                                      //     },
                                                                      //   ),
                                                                      // );
                                                                    },
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      foregroundColor:
                                                                          Colors
                                                                              .black,
                                                                      minimumSize:
                                                                          Size(
                                                                              130,
                                                                              40),
                                                                    ),
                                                                  ),
                                                                  ElevatedButton
                                                                      .icon(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .done,
                                                                        color: Color(
                                                                            0xffFF5403)),
                                                                    label: Text(
                                                                        "Terima"),
                                                                    onPressed:
                                                                        () {
                                                                      _acceptOrder(
                                                                          item[
                                                                              'ID']);
                                                                      // Navigator.push(
                                                                      //   context,
                                                                      //   MaterialPageRoute(
                                                                      //     builder: (context) {
                                                                      //       return CustomerTentangAppScreen();
                                                                      //     },
                                                                      //   ),
                                                                      // );
                                                                    },
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      foregroundColor:
                                                                          Colors
                                                                              .black,
                                                                      minimumSize:
                                                                          Size(
                                                                              130,
                                                                              40),
                                                                    ),
                                                                  ),
                                                                ]))
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        }
                                      }
                                    }
                                  })),
                                )),
                          ),
                        ],
                      )),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 10, right: 10, bottom: 20),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.only(left: 10),
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text("Lainnya")),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  icon: Icon(Icons.info,
                                      color: Color(0xffFF5403)),
                                  label: Text("Tentang APP"),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return TukangTentangAppScreen();
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
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFF5403)),
                ),
              ),
      ),
    );
  }
}

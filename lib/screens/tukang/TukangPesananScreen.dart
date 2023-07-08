import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tukang_online/screens/tukang/TukangDashboardScreen.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class TukangPesananScreen extends StatefulWidget {
  const TukangPesananScreen({super.key});

  @override
  State<TukangPesananScreen> createState() => _TukangPesananScreenState();
}

class _TukangPesananScreenState extends State<TukangPesananScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<dynamic> dataSMenunggu = []; // Variabel untuk menyimpan data dari API
  List<dynamic> dataSDikerjakan = []; // Variabel untuk menyimpan data dari API
  List<dynamic> dataSSelesai = []; // Variabel untuk menyimpan data dari API
  var random = Random();
  Map<String, dynamic>? tukangData;

  Future<void> fetchDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idUser = decodedToken['id'] as int;
    String apiUrl = 'http://192.168.1.100:8000/api/v1/users/$idUser';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization':
            'Bearer $token', // Ganti <your_jwt_token> dengan token JWT yang valid
      },
    );

    if (response.statusCode == 200) {
      // Berhasil mendapatkan data
      var responseData = response.body;
      // print(responseData);
      var decodedData = json.decode(responseData);

      setState(() {
        tukangData = decodedData['data'];
        // print(tukangData!['latitude'].runtimeType);
        // print(tukangData!['longitude'].runtimeType);
      });
    } else {
      // Gagal mendapatkan data
      print('Error: ${response.statusCode}');
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<void> fetchDataStatusMenunggu() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idTukang = decodedToken['id'] as int;
    final String apiUrlSMenunggu =
        'http://192.168.1.100:8000/api/v1/orders/statusOrderTukangMenunggu?id_tukang=$idTukang';

    // print("TOKEN DI Pesanan screen");
    // print(token);
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
      // await Future.delayed(Duration(seconds: 2));
      if (responseSMenungguData != null) {
        setState(() {
          dataSMenunggu = responseSMenungguData;
        });
      } else {
        setState(() {
          dataSMenunggu = [];
        });
      }
      /*setState(() {
        dataSMenunggu = responseSMenungguData;
        // print(dataSMenunggu!['latitude_customer'].runtimeType);
        // print(dataSMenunggu!['longitude_customer'].runtimeType);
      });*/
    } else {
      print('Error: ${responseSMenunggu.statusCode}');
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<void> fetchDataStatusDikerjakan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idTukang = decodedToken['id'] as int;
    final String apiUrlSDikerjakan =
        'http://192.168.1.100:8000/api/v1/orders/statusOrderTukangBerlangsung?id_tukang=$idTukang';

    print("TOKEN DI Pesanan screen");
    print(token);
    final responseSDikerjakan = await http.get(
      Uri.parse(apiUrlSDikerjakan),
      headers: {
        'Authorization':
            'Bearer $token', // Ganti <your_jwt_token> dengan token JWT yang valid
      },
    );

    if (responseSDikerjakan.statusCode == 200) {
      final jsonData = jsonDecode(responseSDikerjakan.body);
      final List<dynamic> responseSDikerjakanData =
          jsonData['data']; // Mengakses array 'data'
      if (responseSDikerjakanData != null) {
        setState(() {
          dataSDikerjakan = responseSDikerjakanData;
        });
      } else {
        setState(() {
          dataSDikerjakan = [];
        });
      }
      // return responseSDikerjakanData;
      // setState(() {
      //   dataSDikerjakan = responseSDikerjakanData;
      // });
    } else {
      print('Error: ${responseSDikerjakan.statusCode}');
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<void> fetchDataStatusSelesai() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idTukang = decodedToken['id'] as int;
    print(idTukang);
    final String apiUrlSSelesai =
        'http://192.168.1.100:8000/api/v1/orders/statusOrderTukangSelesai?id_tukang=$idTukang';

    print("TOKEN DI Pesanan screen");
    print(token);
    final responseSSelesai = await http.get(
      Uri.parse(apiUrlSSelesai),
      headers: {
        'Authorization':
            'Bearer $token', // Ganti <your_jwt_token> dengan token JWT yang valid
      },
    );

    if (responseSSelesai.statusCode == 200) {
      final jsonData = jsonDecode(responseSSelesai.body);
      final List<dynamic> responseSSelesaiData =
          jsonData['data']; // Mengakses array 'data'
      if (responseSSelesaiData != null) {
        setState(() {
          dataSSelesai = responseSSelesaiData;
        });
      } else {
        setState(() {
          dataSSelesai = [];
        });
      }
      // setState(() {
      //   dataSSelesai = responseSSelesaiData;
      // });
    } else {
      print('Error: ${responseSSelesai.statusCode}');
      throw Exception('Failed to fetch data from API');
    }
  }

  /* Future<void> refreshDataStatusDikerjakan() async {
    // Fetch the latest data from the API
    final newData = await fetchDataStatusDikerjakan();

    setState(() {
      dataSDikerjakan = newData;
    });
  }*/

  @override
  void initState() {
    super.initState();
    fetchDataUser();
    fetchDataStatusMenunggu();
    fetchDataStatusDikerjakan();
    fetchDataStatusSelesai();
  }
  // refreshDataStatusDikerjakan();
  // _refreshData();

  void _launchGoogleMaps(double customerLat, double customerLng,
      double tukangLat, double tukangLng) async {
    String url =
        "https://www.google.com/maps/dir/$customerLat,$customerLng/$tukangLat,$tukangLng";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _refreshData() async {
    // Mengambil data baru dari server atau sumber data lainnya
    // dan memperbarui variabel state dengan data yang diperbarui
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idTukang = decodedToken['id'] as int;

    final String apiUrlSMenunggu =
        'http://192.168.1.100:8000/api/v1/orders/statusOrderTukangMenunggu?id_tukang=$idTukang';
    final String apiUrlSDikerjakan =
        'http://192.168.1.100:8000/api/v1/orders/statusOrderTukangBerlangsung?id_tukang=$idTukang';
    final String apiUrlSSelesai =
        'http://192.168.1.100:8000/api/v1/orders/statusOrderTukangSelesai?id_tukang=$idTukang';

    final responseSMenunggu = await http.get(
      Uri.parse(apiUrlSMenunggu),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final responseSDikerjakan = await http.get(
      Uri.parse(apiUrlSDikerjakan),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final responseSSelesai = await http.get(
      Uri.parse(apiUrlSSelesai),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (responseSMenunggu.statusCode == 200 &&
        responseSDikerjakan.statusCode == 200 &&
        responseSSelesai.statusCode == 200) {
      final jsonDataSMenunggu = jsonDecode(responseSMenunggu.body);
      final List<dynamic> responseSMenungguData = jsonDataSMenunggu['data'];

      final jsonDataSDikerjakan = jsonDecode(responseSDikerjakan.body);
      final List<dynamic> responseSDikerjakanData = jsonDataSDikerjakan['data'];

      final jsonDataSSelesai = jsonDecode(responseSSelesai.body);
      final List<dynamic> responseSSelesaiData = jsonDataSSelesai['data'];

      setState(() {
        dataSMenunggu = responseSMenungguData;
        dataSDikerjakan = responseSDikerjakanData;
        dataSSelesai = responseSSelesaiData;
      });
    } else {
      throw Exception('Failed to fetch data from API');
    }
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
    fetchDataStatusSelesai();
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
      fetchDataStatusDikerjakan();
    }
  }

  Future<void> _doneOrder(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idTukang = decodedToken['id'] as int;

    final String response =
        'http://192.168.1.100:8000/api/v1/orders/doneOrderByTukang/$orderId';

    final responsePost = await http.put(
      Uri.parse(response),
      headers: {
        'Authorization':
            'Bearer $token', // Ganti <your_jwt_token> dengan token JWT yang valid
      },
    );

    if (responsePost.statusCode == 200) {
      fetchDataStatusDikerjakan();
      setState(() {
        dataSDikerjakan.removeWhere((item) => item['ID'] == orderId);
      });
      fetchDataStatusSelesai();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    TabBar myTabBar = TabBar(
      indicatorColor: Color(0xffFF5403),
      labelColor: Color(0xffFF5403),
      onTap: (index) {
        if (index == 1) {
          // Indeks tab "Dikerjakan"
          fetchDataStatusMenunggu(); //memanggilan fetchDataStatusDikerjakan() saat berpindah ke tab "Dikerjakan"
        } else if (index == 2) {
          fetchDataStatusDikerjakan();
        } else {
          fetchDataStatusSelesai();
        }
      },
      tabs: <Widget>[
        Tab(
          text: "Menunggu",
        ),
        Tab(text: "Dikerjakan"),
        Tab(text: "Selesai")
      ],
    );
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return TukangDashboardScreen();
                        },
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.black)),
              flexibleSpace: Container(color: Colors.white),
              title: Text("Pesanan", style: TextStyle(color: Colors.black)),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(myTabBar.preferredSize.height),
                child: Container(color: Colors.white, child: myTabBar),
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                RefreshIndicator(
                  onRefresh: () async {
                    fetchDataStatusMenunggu();
                    fetchDataStatusDikerjakan();
                    fetchDataStatusSelesai();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: FutureBuilder(
                      // future:
                      //     fetchDataStatusMenunggu(), // Mengganti fetchData() dengan fungsi atau metode yang digunakan untuk mengambil data tukangData dan item
                      builder: (context, snapshot) {
                        if (dataSMenunggu == [] || dataSMenunggu == null) {
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
                                itemCount: dataSMenunggu.length,
                                itemBuilder: (context, index) {
                                  final item = dataSMenunggu[index];
                                  return Stack(
                                    children: [
                                      Card(
                                        child: SizedBox(
                                          width: 420,
                                          height: 305,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Spacer(flex: 1),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 15),
                                                          child: Icon(
                                                              Icons.home,
                                                              color: Color(
                                                                  0xffF24E1E))),
                                                      Container(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Status Pemesanan - ${item['detail_perbaikan']}",
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                            Text(
                                                              item[
                                                                  'nama_customer'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Spacer(flex: 1)
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
                                                  // padding: EdgeInsets.all(20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 14),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                "Nomor Invoice",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14)),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Text("Total Biaya",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14)),
                                                            SizedBox(
                                                              height: 14,
                                                            ),
                                                            Text(
                                                                "Layanan Survey",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14))
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 40),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            // Text("#20230316",
                                                            //     style: TextStyle(fontSize: 14)),
                                                            Text(
                                                                "Kang-" +
                                                                    item['ID']
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14)),
                                                            Text(
                                                                "Rp." +
                                                                    NumberFormat(
                                                                            '#,##0')
                                                                        .format(item[
                                                                            'total_biaya']),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14)),
                                                            ElevatedButton(
                                                                child: Text(
                                                                    item[
                                                                        'status'],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12)),
                                                                onPressed:
                                                                    () {},
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        Color(
                                                                            0xff24309C),
                                                                    foregroundColor:
                                                                        Colors
                                                                            .white,
                                                                    minimumSize:
                                                                        Size(50,
                                                                            26)))
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                // Container(
                                                //     padding: EdgeInsets.only(
                                                //         top: 8, left: 8),
                                                //     child: Text(
                                                //       "Waktu Perjanjian",
                                                //       style: TextStyle(
                                                //           fontSize: 12,
                                                //           fontWeight:
                                                //               FontWeight.w500),
                                                //     )),
                                                // Container(
                                                //   child: Row(
                                                //     mainAxisAlignment:
                                                //         MainAxisAlignment
                                                //             .spaceAround,
                                                //     children: [
                                                //       Container(
                                                //         child: Row(
                                                //           children: [
                                                //             IconButton(
                                                //               icon: Icon(
                                                //                   Icons.date_range),
                                                //               onPressed: () {},
                                                //               color:
                                                //                   Color(0xffF24E1E),
                                                //             ),
                                                //             Text("2023-03-16"),
                                                //           ],
                                                //         ),
                                                //       ),
                                                //       Container(
                                                //         margin: EdgeInsets.only(
                                                //             right: 17),
                                                //         child: Row(
                                                //           children: [
                                                //             IconButton(
                                                //               icon: Icon(Icons
                                                //                   .access_time),
                                                //               onPressed: () {},
                                                //               color:
                                                //                   Color(0xffF24E1E),
                                                //             ),
                                                //             Text("08:00"),
                                                //           ],
                                                //         ),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(Icons
                                                                  .date_range),
                                                              onPressed: () {},
                                                              color: Color(
                                                                  0xffF24E1E),
                                                            ),
                                                            Text(DateFormat
                                                                    .yMMMMEEEEd()
                                                                .format(DateTime
                                                                    .parse(item[
                                                                        'jadwal_perbaikan_awal']))),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 17),
                                                        child: Row(
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(Icons
                                                                  .access_time),
                                                              onPressed: () {},
                                                              color: Color(
                                                                  0xffF24E1E),
                                                            ),
                                                            Text(DateFormat.jm()
                                                                .format(DateTime
                                                                    .parse(item[
                                                                        'jadwal_perbaikan_awal']))),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(Icons
                                                                  .date_range),
                                                              onPressed: () {},
                                                              color: Color(
                                                                  0xffF24E1E),
                                                            ),
                                                            Text(DateFormat
                                                                    .yMMMMEEEEd()
                                                                .format(DateTime
                                                                    .parse(item[
                                                                        'jadwal_perbaikan_akhir']))),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 17),
                                                        child: Row(
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(Icons
                                                                  .access_time),
                                                              onPressed: () {},
                                                              color: Color(
                                                                  0xffF24E1E),
                                                            ),
                                                            Text(DateFormat.jm()
                                                                .format(DateTime
                                                                    .parse(item[
                                                                        'jadwal_perbaikan_akhir']))),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 2),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      ElevatedButton.icon(
                                                          icon: Icon(
                                                              Icons.close,
                                                              color: Colors
                                                                  .white,
                                                              size: 18),
                                                          label: Text("Tolak",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12)),
                                                          onPressed: () {
                                                            _rejectOrder(
                                                                item['ID']);
                                                            fetchDataStatusMenunggu();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xffDD1D1D),
                                                                  foregroundColor:
                                                                      Colors
                                                                          .white,
                                                                  minimumSize:
                                                                      Size(50,
                                                                          26))),
                                                      ElevatedButton.icon(
                                                          icon: Icon(Icons.done,
                                                              color: Colors
                                                                  .white,
                                                              size: 18),
                                                          label: Text("Terima",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12)),
                                                          onPressed: () {
                                                            _acceptOrder(
                                                                item['ID']);
                                                            fetchDataStatusMenunggu();
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          19,
                                                                          153,
                                                                          48),
                                                              foregroundColor:
                                                                  Colors.white,
                                                              minimumSize: Size(
                                                                  50, 26))),
                                                    ],
                                                  ),
                                                ),
                                                /*Container(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: ElevatedButton(
                                                    child: Text(
                                                        "Hubungi Sekarang",
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                    onPressed: () {
                                                      String
                                                          nomorTelpPelanggan =
                                                          item[
                                                              'no_telp_customer'];
                                                      String
                                                          nomorTelpPelangganCodeCountry =
                                                          nomorTelpPelanggan
                                                              .replaceFirst(
                                                                  '0', '+62');
                                                      print(nomorTelpPelanggan);
                                                      String urlWhatsApp =
                                                          "https://wa.me/$nomorTelpPelangganCodeCountry/?text=Halo...";

                                                      // if (kIsWeb) {
                                                      //   js.context.callMethod('open', urlWhatsApp);
                                                      // } else {
                                                      launchUrl(
                                                              Uri.parse(
                                                                  urlWhatsApp),
                                                              mode: LaunchMode
                                                                  .externalApplication)
                                                          .catchError((e) {
                                                        // Menangani jika tidak dapat membuka aplikasi WhatsApp
                                                        throw 'Tidak dapat membuka aplikasi WhatsApp.';
                                                      });
                                                      // }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Color(
                                                                    0xff007BFF),
                                                            foregroundColor:
                                                                Colors.white,
                                                            minimumSize:
                                                                Size(150, 26))),
                                              ),*/
                                                /*Container(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: ElevatedButton(
                                                    child: Text("Lihat Lokasi",
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                    onPressed: () {
                                                      _launchGoogleMaps(
                                                          customerLat,
                                                          customerLng,
                                                          tukangLat,
                                                          tukangLng);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Color(
                                                                    0xffFF5403),
                                                            foregroundColor:
                                                                Colors.white,
                                                            minimumSize:
                                                                Size(150, 26))),
                                              ),*/
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: PopupMenuButton<int>(
                                          // padding: EdgeInsets.only(left: 100),
                                          // elevation: 3.2,
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Color(0xffFF5403),
                                          ),
                                          onSelected: (value) {
                                            // Tangani aksi yang dipilih dari menu overflow di sini
                                            if (value != null) {
                                              // Logika yang sesuai dengan opsi yang dipilih
                                              print('Opsi $value dipilih');
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              [
                                            PopupMenuItem(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.build,
                                                    color: Color(0xffFF5403),
                                                  ),
                                                  Text(' Detail Perbaikan'),
                                                ],
                                              ),
                                              value: 1,
                                              onTap: () {
                                                // Aksi saat Opsi 3 ditekan
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        content: Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          children: <Widget>[
                                                            Positioned(
                                                              right: -15.0,
                                                              top: -15.0,
                                                              child:
                                                                  InkResponse(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 12,
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    size: 18,
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ),
                                                            Form(
                                                              // key: _formKey,
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    height: 60,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    decoration: BoxDecoration(
                                                                        color: Color.fromARGB(
                                                                                255,
                                                                                212,
                                                                                212,
                                                                                212)
                                                                            .withOpacity(
                                                                                0.2),
                                                                        border: Border(
                                                                            bottom:
                                                                                BorderSide(color: Colors.grey.withOpacity(0.3)))),
                                                                    child: Center(
                                                                        child: Text(
                                                                            "Detail Perbaikan",
                                                                            style: TextStyle(
                                                                                color: Color(0xffFF5403),
                                                                                fontWeight: FontWeight.w700,
                                                                                fontSize: 20,
                                                                                fontStyle: FontStyle.italic,
                                                                                fontFamily: "Helvetica"))),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            20.0),
                                                                    child: Container(
                                                                        height: 250,
                                                                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2))),
                                                                        child: Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              // flex: 4,
                                                                              child: TextFormField(
                                                                                maxLines: 18,
                                                                                initialValue: item['detail_perbaikan'],
                                                                                decoration: InputDecoration(hintText: "Name", contentPadding: EdgeInsets.only(left: 20), border: InputBorder.none, focusedBorder: InputBorder.none, errorBorder: InputBorder.none, hintStyle: TextStyle(color: Colors.black26, fontSize: 18, fontWeight: FontWeight.w500)),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        )),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              },
                                            ),
                                            PopupMenuItem(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.call,
                                                    color: Color(0xffFF5403),
                                                  ),
                                                  Text(' Hubungi Sekarang'),
                                                ],
                                              ),
                                              value: 2,
                                              onTap: () {
                                                // Aksi saat Opsi 1 ditekan
                                                String nomorTelpPelanggan =
                                                    item['no_telp_customer'];
                                                String
                                                    nomorTelpPelangganCodeCountry =
                                                    nomorTelpPelanggan
                                                        .replaceFirst(
                                                            '0', '+62');
                                                print(nomorTelpPelanggan);
                                                String urlWhatsApp =
                                                    "https://wa.me/$nomorTelpPelangganCodeCountry/?text=Halo...";

                                                launchUrl(
                                                        Uri.parse(urlWhatsApp),
                                                        mode: LaunchMode
                                                            .externalApplication)
                                                    .catchError((e) {
                                                  throw 'Tidak dapat membuka aplikasi WhatsApp.';
                                                });
                                              },
                                            ),
                                            PopupMenuItem(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Color(0xffFF5403),
                                                    ),
                                                    Text(' Lihat Lokasi'),
                                                  ],
                                                ),
                                                value: 3,
                                                onTap: () {
                                                  double customerLat =
                                                      item['latitude_customer']
                                                          .toDouble();
                                                  double customerLng =
                                                      item['longitude_customer']
                                                          .toDouble();
                                                  double tukangLat =
                                                      tukangData!['latitude']
                                                          .toDouble();
                                                  double tukangLng =
                                                      tukangData!['longitude']
                                                          .toDouble();
                                                  // Aksi saat Opsi 2 ditekan
                                                  // if (customerLat != null &&
                                                  //     customerLng != null &&
                                                  //     tukangLat != null &&
                                                  //     tukangLng != null) {
                                                  _launchGoogleMaps(
                                                      customerLat,
                                                      customerLng,
                                                      tukangLat,
                                                      tukangLng);
                                                }
                                                // },
                                                ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
                RefreshIndicator(
                  onRefresh: () async {
                    fetchDataStatusDikerjakan();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: FutureBuilder(
                        future: Future.value(null),
                        builder: (context, snapshot) {
                          if (dataSDikerjakan == [] ||
                              dataSDikerjakan == null) {
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
                              if (dataSDikerjakan.isEmpty) {
                                return Center(
                                  child: Text(
                                      "Tidak ada daftar pesanan"), // Menampilkan pesan jika data kosong
                                );
                              } else {
                                return ListView.builder(
                                    itemCount: dataSDikerjakan.length,
                                    itemBuilder: (context, index) {
                                      final item = dataSDikerjakan[index];
                                      double customerLat =
                                          item['latitude_customer'].toDouble();
                                      double customerLng =
                                          item['longitude_customer'].toDouble();
                                      double tukangLat =
                                          tukangData!['latitude'].toDouble();
                                      double tukangLng =
                                          tukangData!['longitude'].toDouble();
                                      return Stack(children: [
                                        Card(
                                          child: SizedBox(
                                            width: 420,
                                            height: 303,
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Row(
                                                      // mainAxisAlignment:
                                                      //     MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Spacer(flex: 1),
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 15),
                                                            child: Icon(
                                                                Icons.home,
                                                                color: Color(
                                                                    0xffF24E1E))),
                                                        Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Status Pemesanan - ${item['detail_perbaikan']}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              Text(
                                                                item[
                                                                    'nama_customer'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Spacer(flex: 1)
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        top: 20),
                                                    // padding: EdgeInsets.all(20),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 14),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "Nomor Invoice",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14)),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Text(
                                                                  "Total Biaya",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14)),
                                                              SizedBox(
                                                                height: 14,
                                                              ),
                                                              Text(
                                                                  "Layanan Survey",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14))
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 40),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                  "Kang-" +
                                                                      item['ID']
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14)),
                                                              Text(
                                                                  "Rp." +
                                                                      NumberFormat(
                                                                              '#,##0')
                                                                          .format(item[
                                                                              'total_biaya']),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14)),
                                                              ElevatedButton(
                                                                  child: Text(
                                                                      item[
                                                                          'status'],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12)),
                                                                  onPressed:
                                                                      () {},
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          Color(
                                                                              0xff249C9C),
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      minimumSize:
                                                                          Size(
                                                                              50,
                                                                              26)))
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  // Container(
                                                  //     padding: EdgeInsets.only(
                                                  //         top: 8, left: 8),
                                                  //     child: Text(
                                                  //       "Waktu Perjanjian",
                                                  //       style: TextStyle(
                                                  //           fontSize: 12,
                                                  //           fontWeight:
                                                  //               FontWeight.w500),
                                                  //     )),
                                                  // Container(
                                                  //   child: Row(
                                                  //     mainAxisAlignment:
                                                  //         MainAxisAlignment
                                                  //             .spaceAround,
                                                  //     children: [
                                                  //       Container(
                                                  //         child: Row(
                                                  //           children: [
                                                  //             IconButton(
                                                  //               icon: Icon(Icons
                                                  //                   .date_range),
                                                  //               onPressed: () {},
                                                  //               color: Color(
                                                  //                   0xffF24E1E),
                                                  //             ),
                                                  //             Text("2023-03-16"),
                                                  //           ],
                                                  //         ),
                                                  //       ),
                                                  //       Container(
                                                  //         margin: EdgeInsets.only(
                                                  //             right: 17),
                                                  //         child: Row(
                                                  //           children: [
                                                  //             IconButton(
                                                  //               icon: Icon(Icons
                                                  //                   .access_time),
                                                  //               onPressed: () {},
                                                  //               color: Color(
                                                  //                   0xffF24E1E),
                                                  //             ),
                                                  //             Text("08:00"),
                                                  //           ],
                                                  //         ),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .date_range),
                                                                onPressed:
                                                                    () {},
                                                                color: Color(
                                                                    0xffF24E1E),
                                                              ),
                                                              Text(DateFormat
                                                                      .yMMMMEEEEd()
                                                                  .format(DateTime
                                                                      .parse(item[
                                                                          'jadwal_perbaikan_awal']))),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 17),
                                                          child: Row(
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .access_time),
                                                                onPressed:
                                                                    () {},
                                                                color: Color(
                                                                    0xffF24E1E),
                                                              ),
                                                              Text(DateFormat
                                                                      .jm()
                                                                  .format(DateTime
                                                                      .parse(item[
                                                                          'jadwal_perbaikan_awal']))),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .date_range),
                                                                onPressed:
                                                                    () {},
                                                                color: Color(
                                                                    0xffF24E1E),
                                                              ),
                                                              Text(DateFormat
                                                                      .yMMMMEEEEd()
                                                                  .format(DateTime
                                                                      .parse(item[
                                                                          'jadwal_perbaikan_akhir']))),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 17),
                                                          child: Row(
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .access_time),
                                                                onPressed:
                                                                    () {},
                                                                color: Color(
                                                                    0xffF24E1E),
                                                              ),
                                                              Text(DateFormat
                                                                      .jm()
                                                                  .format(DateTime
                                                                      .parse(item[
                                                                          'jadwal_perbaikan_akhir']))),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  /*Container(
                                                    // padding: EdgeInsets.only(top: 1),
                                                    // margin: EdgeInsets.only(bottom: 10),
                                                    child: ElevatedButton(
                                                        child: Text(
                                                            "Lihat Lokasi",
                                                            style: TextStyle(
                                                                fontSize: 12)),
                                                        onPressed: () {
                                                          _launchGoogleMaps(
                                                              customerLat,
                                                              customerLng,
                                                              tukangLat,
                                                              tukangLng);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Color(
                                                                        0xffFF5403),
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                minimumSize:
                                                                    Size(150,
                                                                        26))),
                                                  ),*/
                                                  Container(
                                                    child: ElevatedButton.icon(
                                                      icon: Icon(Icons.task_alt,
                                                          color: Colors.white),
                                                      label: Text("Selesai"),
                                                      onPressed: () {
                                                        _doneOrder(item['ID']);
                                                        fetchDataStatusDikerjakan();
                                                        // _rejectOrder(item['ID']);
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
                                                            Color.fromARGB(255,
                                                                19, 153, 48),
                                                        foregroundColor:
                                                            Colors.white,
                                                        minimumSize:
                                                            Size(330, 35),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: PopupMenuButton<int>(
                                            // padding: EdgeInsets.only(left: 100),
                                            // elevation: 3.2,
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: Color(0xffFF5403),
                                            ),
                                            onSelected: (value) {
                                              // Tangani aksi yang dipilih dari menu overflow di sini
                                              if (value != null) {
                                                // Logika yang sesuai dengan opsi yang dipilih
                                                print('Opsi $value dipilih');
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) => [
                                              PopupMenuItem(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.build,
                                                      color: Color(0xffFF5403),
                                                    ),
                                                    Text(' Detail Perbaikan'),
                                                  ],
                                                ),
                                                value: 1,
                                                onTap: () {
                                                  // Aksi saat Opsi 3 ditekan
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          content: Stack(
                                                            clipBehavior:
                                                                Clip.none,
                                                            children: <Widget>[
                                                              Positioned(
                                                                right: -15.0,
                                                                top: -15.0,
                                                                child:
                                                                    InkResponse(
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 12,
                                                                    child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 18,
                                                                    ),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                ),
                                                              ),
                                                              Form(
                                                                // key: _formKey,
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      height:
                                                                          60,
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      decoration: BoxDecoration(
                                                                          color: Color.fromARGB(255, 212, 212, 212).withOpacity(
                                                                              0.2),
                                                                          border:
                                                                              Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))),
                                                                      child: Center(
                                                                          child: Text(
                                                                              "Detail Perbaikan",
                                                                              style: TextStyle(color: Color(0xffFF5403), fontWeight: FontWeight.w700, fontSize: 20, fontStyle: FontStyle.italic, fontFamily: "Helvetica"))),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              20.0),
                                                                      child: Container(
                                                                          height: 250,
                                                                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2))),
                                                                          child: Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Expanded(
                                                                                // flex: 4,
                                                                                child: TextFormField(
                                                                                  maxLines: 18,
                                                                                  initialValue: item['detail_perbaikan'],
                                                                                  decoration: InputDecoration(hintText: "Name", contentPadding: EdgeInsets.only(left: 20), border: InputBorder.none, focusedBorder: InputBorder.none, errorBorder: InputBorder.none, hintStyle: TextStyle(color: Colors.black26, fontSize: 18, fontWeight: FontWeight.w500)),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                              ),
                                              PopupMenuItem(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.call,
                                                      color: Color(0xffFF5403),
                                                    ),
                                                    Text(' Hubungi Sekarang'),
                                                  ],
                                                ),
                                                value: 2,
                                                onTap: () {
                                                  // Aksi saat Opsi 1 ditekan
                                                  String nomorTelpPelanggan =
                                                      item['no_telp_customer'];
                                                  String
                                                      nomorTelpPelangganCodeCountry =
                                                      nomorTelpPelanggan
                                                          .replaceFirst(
                                                              '0', '+62');
                                                  print(nomorTelpPelanggan);
                                                  String urlWhatsApp =
                                                      "https://wa.me/$nomorTelpPelangganCodeCountry/?text=Halo...";

                                                  launchUrl(
                                                          Uri.parse(
                                                              urlWhatsApp),
                                                          mode: LaunchMode
                                                              .externalApplication)
                                                      .catchError((e) {
                                                    throw 'Tidak dapat membuka aplikasi WhatsApp.';
                                                  });
                                                },
                                              ),
                                              PopupMenuItem(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Color(0xffFF5403),
                                                    ),
                                                    Text(' Lihat Lokasi'),
                                                  ],
                                                ),
                                                value: 3,
                                                onTap: () {
                                                  // Aksi saat Opsi 2 ditekan
                                                  _launchGoogleMaps(
                                                      customerLat,
                                                      customerLng,
                                                      tukangLat,
                                                      tukangLng);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]);
                                    });
                              }
                            }
                          }
                        }),
                  ),
                ),
                RefreshIndicator(
                  onRefresh: () async {
                    fetchDataStatusMenunggu();
                    fetchDataStatusDikerjakan();
                    fetchDataStatusSelesai();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: FutureBuilder(
                        // future:
                        //     fetchDataStatusMenunggu(), // Mengganti fetchData() dengan fungsi atau metode yang digunakan untuk mengambil data tukangData dan item
                        builder: (context, snapshot) {
                      if (dataSSelesai == [] || dataSSelesai == null) {
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
                          if (dataSSelesai.isEmpty) {
                            return Center(
                              child: Text(
                                  "Tidak ada daftar pesanan"), // Menampilkan pesan jika data kosong
                            );
                          } else {
                            return ListView.builder(
                                itemCount: dataSSelesai.length,
                                itemBuilder: (context, index) {
                                  final item = dataSSelesai[index];
                                  double customerLat =
                                      item['latitude_customer'].toDouble();
                                  double customerLng =
                                      item['longitude_customer'].toDouble();
                                  double tukangLat =
                                      tukangData!['latitude'].toDouble();
                                  double tukangLng =
                                      tukangData!['longitude'].toDouble();
                                  return Stack(children: [
                                    Card(
                                      child: SizedBox(
                                        width: 420,
                                        height: 245,
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Row(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Spacer(flex: 1),
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            right: 15),
                                                        child: Icon(Icons.home,
                                                            color: Color(
                                                                0xffF24E1E))),
                                                    Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Status Pemesanan - ${item['detail_perbaikan']}",
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                          Text(
                                                            item[
                                                                'nama_customer'],
                                                            textAlign: TextAlign
                                                                .justify,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 1)
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 20,
                                                    left: 13,
                                                    right: 13),
                                                // padding: EdgeInsets.all(20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 14),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text("Nomor Invoice",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          Text("Total Biaya",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                          SizedBox(
                                                            height: 14,
                                                          ),
                                                          Text("Layanan Survey",
                                                              style: TextStyle(
                                                                  fontSize: 14))
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 40),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                              "Kang-" +
                                                                  item['ID']
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                          Text(
                                                              "Rp." +
                                                                  NumberFormat(
                                                                          '#,##0')
                                                                      .format(item[
                                                                          'total_biaya']),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                          ElevatedButton(
                                                              child: Text(
                                                                  item[
                                                                      'status'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12)),
                                                              onPressed: () {},
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor: item[
                                                                              'status'] ==
                                                                          "Selesai"
                                                                      ? Color(
                                                                          0xff1A7E2A)
                                                                      : Color(
                                                                          0xffDD1D1D),
                                                                  foregroundColor:
                                                                      Colors
                                                                          .white,
                                                                  minimumSize:
                                                                      Size(50,
                                                                          26)))
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              // Container(
                                              //     padding: EdgeInsets.only(
                                              //         top: 8, left: 8),
                                              //     child: Text(
                                              //       "Waktu Perjanjian",
                                              //       style: TextStyle(
                                              //           fontSize: 12,
                                              //           fontWeight:
                                              //               FontWeight.w500),
                                              //     )),
                                              // Container(
                                              //   child: Row(
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment
                                              //             .spaceAround,
                                              //     children: [
                                              //       Container(
                                              //         child: Row(
                                              //           children: [
                                              //             IconButton(
                                              //               icon: Icon(
                                              //                   Icons.date_range),
                                              //               onPressed: () {},
                                              //               color:
                                              //                   Color(0xffF24E1E),
                                              //             ),
                                              //             Text("2023-03-16"),
                                              //           ],
                                              //         ),
                                              //       ),
                                              //       Container(
                                              //         margin: EdgeInsets.only(
                                              //             right: 17),
                                              //         child: Row(
                                              //           children: [
                                              //             IconButton(
                                              //               icon: Icon(Icons
                                              //                   .access_time),
                                              //               onPressed: () {},
                                              //               color:
                                              //                   Color(0xffF24E1E),
                                              //             ),
                                              //             Text("08:00"),
                                              //           ],
                                              //         ),
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(Icons
                                                                .date_range),
                                                            onPressed: () {},
                                                            color: Color(
                                                                0xffF24E1E),
                                                          ),
                                                          Text(DateFormat
                                                                  .yMMMMEEEEd()
                                                              .format(DateTime
                                                                  .parse(item[
                                                                      'jadwal_perbaikan_awal']))),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 17),
                                                      child: Row(
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(Icons
                                                                .access_time),
                                                            onPressed: () {},
                                                            color: Color(
                                                                0xffF24E1E),
                                                          ),
                                                          Text(DateFormat.jm()
                                                              .format(DateTime
                                                                  .parse(item[
                                                                      'jadwal_perbaikan_awal']))),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(Icons
                                                                .date_range),
                                                            onPressed: () {},
                                                            color: Color(
                                                                0xffF24E1E),
                                                          ),
                                                          Text(DateFormat
                                                                  .yMMMMEEEEd()
                                                              .format(DateTime
                                                                  .parse(item[
                                                                      'jadwal_perbaikan_akhir']))),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 17),
                                                      child: Row(
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(Icons
                                                                .access_time),
                                                            onPressed: () {},
                                                            color: Color(
                                                                0xffF24E1E),
                                                          ),
                                                          Text(DateFormat.jm()
                                                              .format(DateTime
                                                                  .parse(item[
                                                                      'jadwal_perbaikan_akhir']))),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              /*Container(
                                                padding:
                                                    EdgeInsets.only(top: 1),
                                                child: ElevatedButton(
                                                    child: Text("Lihat Lokasi",
                                                        style:
                                                            TextStyle(
                                                                fontSize: 12)),
                                                    onPressed: () {
                                                      _launchGoogleMaps(
                                                          customerLat,
                                                          customerLng,
                                                          tukangLat,
                                                          tukangLng);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    19,
                                                                    153,
                                                                    48),
                                                            foregroundColor:
                                                                Colors.white,
                                                            minimumSize:
                                                                Size(150, 26))),
                                              ),*/
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: PopupMenuButton<int>(
                                        // padding: EdgeInsets.only(left: 100),
                                        // elevation: 3.2,
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Color(0xffFF5403),
                                        ),
                                        onSelected: (value) {
                                          // Tangani aksi yang dipilih dari menu overflow di sini
                                          if (value != null) {
                                            // Logika yang sesuai dengan opsi yang dipilih
                                            print('Opsi $value dipilih');
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => [
                                          PopupMenuItem(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.build,
                                                  color: Color(0xffFF5403),
                                                ),
                                                Text(' Detail Perbaikan'),
                                              ],
                                            ),
                                            value: 1,
                                            onTap: () {
                                              // Aksi saat Opsi 3 ditekan
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      content: Stack(
                                                        clipBehavior: Clip.none,
                                                        children: <Widget>[
                                                          Positioned(
                                                            right: -15.0,
                                                            top: -15.0,
                                                            child: InkResponse(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 12,
                                                                child: Icon(
                                                                  Icons.close,
                                                                  size: 18,
                                                                ),
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                          Form(
                                                            // key: _formKey,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  height: 60,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  decoration: BoxDecoration(
                                                                      color: Color.fromARGB(
                                                                              255,
                                                                              212,
                                                                              212,
                                                                              212)
                                                                          .withOpacity(
                                                                              0.2),
                                                                      border: Border(
                                                                          bottom:
                                                                              BorderSide(color: Colors.grey.withOpacity(0.3)))),
                                                                  child: Center(
                                                                      child: Text(
                                                                          "Detail Perbaikan",
                                                                          style: TextStyle(
                                                                              color: Color(0xffFF5403),
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 20,
                                                                              fontStyle: FontStyle.italic,
                                                                              fontFamily: "Helvetica"))),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              20.0),
                                                                  child: Container(
                                                                      height: 250,
                                                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2))),
                                                                      child: Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Expanded(
                                                                            // flex: 4,
                                                                            child:
                                                                                TextFormField(
                                                                              maxLines: 18,
                                                                              initialValue: item['detail_perbaikan'],
                                                                              decoration: InputDecoration(hintText: "Name", contentPadding: EdgeInsets.only(left: 20), border: InputBorder.none, focusedBorder: InputBorder.none, errorBorder: InputBorder.none, hintStyle: TextStyle(color: Colors.black26, fontSize: 18, fontWeight: FontWeight.w500)),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            },
                                          ),
                                          PopupMenuItem(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.call,
                                                  color: Color(0xffFF5403),
                                                ),
                                                Text(' Hubungi Sekarang'),
                                              ],
                                            ),
                                            value: 2,
                                            onTap: () {
                                              // Aksi saat Opsi 1 ditekan
                                              String nomorTelpPelanggan =
                                                  item['no_telp_customer'];
                                              String
                                                  nomorTelpPelangganCodeCountry =
                                                  nomorTelpPelanggan
                                                      .replaceFirst('0', '+62');
                                              print(nomorTelpPelanggan);
                                              String urlWhatsApp =
                                                  "https://wa.me/$nomorTelpPelangganCodeCountry/?text=Halo...";

                                              launchUrl(Uri.parse(urlWhatsApp),
                                                      mode: LaunchMode
                                                          .externalApplication)
                                                  .catchError((e) {
                                                throw 'Tidak dapat membuka aplikasi WhatsApp.';
                                              });
                                            },
                                          ),
                                          PopupMenuItem(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: Color(0xffFF5403),
                                                ),
                                                Text(' Lihat Lokasi'),
                                              ],
                                            ),
                                            value: 3,
                                            onTap: () {
                                              // Aksi saat Opsi 2 ditekan
                                              _launchGoogleMaps(
                                                  customerLat,
                                                  customerLng,
                                                  tukangLat,
                                                  tukangLng);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]);
                                });
                          }
                        }
                      }
                    }),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

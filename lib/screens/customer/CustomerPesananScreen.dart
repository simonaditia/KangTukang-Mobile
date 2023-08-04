import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tukang_online/screens/customer/CustomerDashboardScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tukang_online/screens/tukang/TukangDashboardScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerPesananScreen extends StatefulWidget {
  const CustomerPesananScreen({super.key});

  @override
  State<CustomerPesananScreen> createState() => _CustomerPesananScreenState();
}

class _CustomerPesananScreenState extends State<CustomerPesananScreen> {
  List<dynamic> dataSMenunggu = []; // Variabel untuk menyimpan data dari API
  List<dynamic> dataSDikerjakan = []; // Variabel untuk menyimpan data dari API
  List<dynamic> dataSSelesai = []; // Variabel untuk menyimpan data dari API
  var random = Random();
  TextEditingController _alasanController = TextEditingController();

  Future<void> fetchDataStatusMenunggu() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idCustomer = decodedToken['id'] as int;
    final String apiUrlSMenunggu =
        'http://192.168.1.100:8000/api/v1/orders/statusOrderCustomerMenunggu?id_customer=$idCustomer';

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

  Future<void> fetchDataStatusDikerjakan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idCustomer = decodedToken['id'] as int;
    final String apiUrlSDikerjakan =
        'http://192.168.1.100:8000/api/v1/orders/statusOrderCustomerBerlangsung?id_customer=$idCustomer';

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

      setState(() {
        dataSDikerjakan = responseSDikerjakanData;
      });
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<void> fetchDataStatusSelesai() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idCustomer = decodedToken['id'] as int;
    print(idCustomer);
    final String apiUrlSSelesai =
        'http://192.168.1.100:8000/api/v1/orders/statusOrderCustomerSelesai?id_customer=$idCustomer';

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

      setState(() {
        dataSSelesai = responseSSelesaiData;
      });
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataStatusMenunggu(); // Panggil fungsi fetchDataStatusMenunggu saat widget diinisialisasi
    fetchDataStatusDikerjakan();
    fetchDataStatusSelesai();
    _alasanController = TextEditingController();
  }

  Future<void> _cancelOrder(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idTukang = decodedToken['id'] as int;

    final String response =
        'http://192.168.1.100:8000/api/v1/orders/cancelOrderByCustomer/$orderId';
    String alasan = _alasanController.text;

    final responsePost = await http.put(Uri.parse(response),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Ganti <your_jwt_token> dengan token JWT yang valid
        },
        body: json.encode({
          'status': "Dibatalkan",
          'alasan_tolak_batal': alasan,
        }));

    // final response = await http.post(
    //   'http://localhost:8000/api/v1/orders/rejectOrderByTukang/$orderId',
    // );
    if (responsePost.statusCode == 200) {
      fetchDataStatusMenunggu();
      setState(() {
        dataSMenunggu.removeWhere((item) => item['ID'] == orderId);
      });
      Fluttertoast.showToast(
        msg: 'Berhasil Batalkan Pemesanan!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xffFF5403),
        textColor: Colors.white,
      );
    }
    fetchDataStatusSelesai();
  }

  @override
  Widget build(BuildContext context) {
    TabBar myTabBar = TabBar(
      indicatorColor: Color(0xffFF5403),
      labelColor: Color(0xffFF5403),
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CustomerDashboardScreen();
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
                                    return Card(
                                      child: SizedBox(
                                        width: 400,
                                        height: 294,
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
                                                            "Status Pemesanan - ${item['kategori_tukang']}",
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                          Text(
                                                            item['nama_tukang'],
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
                                                              onPressed: () {},
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
                                              //         top: 20, left: 8),
                                              //     child: Text(
                                              //       "Waktu Perjanjian",
                                              //       style: TextStyle(
                                              //           fontSize: 12,
                                              //           fontWeight:
                                              //               FontWeight.w500),
                                              //     )),
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
                                                // padding:
                                                //     EdgeInsets.only(top: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    ElevatedButton.icon(
                                                        icon: Icon(Icons.close,
                                                            color: Colors.white,
                                                            size: 18),
                                                        label: Text("Batalkan"),
                                                        // onPressed: () {
                                                        //   _cancelOrder(
                                                        //       item['ID']);
                                                        //   fetchDataStatusMenunggu();
                                                        // },
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  content:
                                                                      Stack(
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: <
                                                                        Widget>[
                                                                      Positioned(
                                                                        right:
                                                                            -15.0,
                                                                        top:
                                                                            -15.0,
                                                                        child:
                                                                            InkResponse(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              CircleAvatar(
                                                                            radius:
                                                                                12,
                                                                            child:
                                                                                Icon(
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
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                              height: 60,
                                                                              width: MediaQuery.of(context).size.width,
                                                                              decoration: BoxDecoration(color: Color.fromARGB(255, 212, 212, 212).withOpacity(0.2), border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))),
                                                                              child: Center(child: Text("Apakah yakin tolak pemesanan?", style: TextStyle(color: Color(0xffFF5403), fontWeight: FontWeight.w700, fontSize: 20, fontStyle: FontStyle.italic, fontFamily: "Helvetica"))),
                                                                            ),
                                                                            Padding(
                                                                              // padding:
                                                                              //     EdgeInsets.all(20.0),
                                                                              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                                                                              child: Container(
                                                                                  height: 250,
                                                                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2))),
                                                                                  child: Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Expanded(
                                                                                        // flex: 4,
                                                                                        child: TextFormField(
                                                                                          controller: _alasanController,
                                                                                          maxLines: 18,
                                                                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                          onChanged: (text) {
                                                                                            setState(() {});
                                                                                          },
                                                                                          validator: (value) {
                                                                                            if (value!.isEmpty) {
                                                                                              return "Alasan harus diisi.";
                                                                                            } else if (value.length < 10) {
                                                                                              return "Alasan harus memiliki setidaknya 10 karakter";
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          // initialValue: item['detail_perbaikan'],
                                                                                          decoration: InputDecoration(
                                                                                            hintText: "Input alasan tolak pemesanan",
                                                                                            contentPadding: EdgeInsets.only(left: 20),
                                                                                            border: InputBorder.none,
                                                                                            focusedBorder: InputBorder.none,
                                                                                            errorBorder: InputBorder.none,
                                                                                            hintStyle: TextStyle(
                                                                                              color: Colors.black26,
                                                                                              fontSize: 18,
                                                                                              fontWeight: FontWeight.w500,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  )),
                                                                            ),
                                                                            Container(
                                                                              padding: EdgeInsets.only(top: 2),
                                                                              child: ElevatedButton.icon(
                                                                                onFocusChange: (text) {
                                                                                  setState(() {});
                                                                                },
                                                                                icon: Icon(Icons.close, color: Colors.white, size: 18),
                                                                                label: Text("Tolak Pemesanan", style: TextStyle(fontSize: 12)),
                                                                                onPressed: _alasanController.text.isEmpty || _alasanController.text.length < 10
                                                                                    ? null // Tidak dapat ditekan jika alasan kosong atau kurang dari 10 karakter
                                                                                    : () {
                                                                                        _cancelOrder(item['ID']);
                                                                                        fetchDataStatusMenunggu();
                                                                                        Navigator.of(context).pop();
                                                                                      },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: _alasanController.text.isEmpty || _alasanController.text.length < 10
                                                                                      ? Colors.grey // Warna abu-abu jika tidak memenuhi syarat
                                                                                      : Color(0xffDD1D1D),
                                                                                  foregroundColor: Colors.white,
                                                                                  minimumSize: Size(300, 33), // Sesuaikan ukuran tombol
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              });
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
                                                                        30))),
                                                    ElevatedButton.icon(
                                                      icon: Icon(Icons.call,
                                                          color: Colors.white,
                                                          size: 18),
                                                      label: Text(
                                                          "Hubungi Sekarang"),
                                                      onPressed: () {
                                                        String nomorTelpTukang =
                                                            item[
                                                                'no_telp_tukang'];
                                                        String
                                                            nomorTelpTukangCodeCountry =
                                                            nomorTelpTukang
                                                                .replaceFirst(
                                                                    '0', '+62');
                                                        print(nomorTelpTukang);
                                                        String urlWhatsApp =
                                                            "https://wa.me/$nomorTelpTukangCodeCountry/?text=Halo...";

                                                        launchUrl(
                                                                Uri.parse(
                                                                    urlWhatsApp),
                                                                mode: LaunchMode
                                                                    .externalApplication)
                                                            .catchError((e) {
                                                          throw 'Tidak dapat membuka aplikasi WhatsApp.';
                                                        });
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color(0xffFF5403),
                                                        foregroundColor:
                                                            Colors.white,
                                                        minimumSize:
                                                            Size(50, 30),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
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
                                        return Card(
                                          child: SizedBox(
                                            width: 400,
                                            height: 295,
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
                                                                "Status Pemesanan - ${item['kategori_tukang']}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              Text(
                                                                item[
                                                                    'nama_tukang'],
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
                                                  //         top: 20, left: 8),
                                                  //     child: Text(
                                                  //       "Waktu Perjanjian",
                                                  //       style: TextStyle(
                                                  //           fontSize: 12,
                                                  //           fontWeight:
                                                  //               FontWeight
                                                  //                   .w500),
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
                                                  //               onPressed:
                                                  //                   () {},
                                                  //               color: Color(
                                                  //                   0xffF24E1E),
                                                  //             ),
                                                  //             Text(item[
                                                  //                 'jadwal_perbaikan_awal']),
                                                  //           ],
                                                  //         ),
                                                  //       ),
                                                  //       Container(
                                                  //         margin:
                                                  //             EdgeInsets.only(
                                                  //                 right: 17),
                                                  //         child: Row(
                                                  //           children: [
                                                  //             IconButton(
                                                  //               icon: Icon(Icons
                                                  //                   .access_time),
                                                  //               onPressed:
                                                  //                   () {},
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
                                                  Container(
                                                    child: ElevatedButton.icon(
                                                      icon: Icon(Icons.call,
                                                          color: Colors.white,
                                                          size: 18),
                                                      label: Text(
                                                          "Hubungi Sekarang"),
                                                      onPressed: () {
                                                        String nomorTelpTukang =
                                                            item[
                                                                'no_telp_tukang'];
                                                        String
                                                            nomorTelpTukangCodeCountry =
                                                            nomorTelpTukang
                                                                .replaceFirst(
                                                                    '0', '+62');
                                                        print(nomorTelpTukang);
                                                        String urlWhatsApp =
                                                            "https://wa.me/$nomorTelpTukangCodeCountry/?text=Halo...";

                                                        launchUrl(
                                                                Uri.parse(
                                                                    urlWhatsApp),
                                                                mode: LaunchMode
                                                                    .externalApplication)
                                                            .catchError((e) {
                                                          throw 'Tidak dapat membuka aplikasi WhatsApp.';
                                                        });
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color(0xffFF5403),
                                                        foregroundColor:
                                                            Colors.white,
                                                        minimumSize:
                                                            Size(330, 30),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                }
                              }
                            }
                          }),
                    )),
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
                                    return Card(
                                      child: SizedBox(
                                        width: 400,
                                        height: item['status'] == "Ditolak" ||
                                                item['status'] == "Dibatalkan"
                                            ? 340
                                            : 295,
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
                                                            "Status Pemesanan - ${item['kategori_tukang']}",
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                          Text(
                                                            item['nama_tukang'],
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
                                              //         top: 20, left: 8),
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
                                              //             Text(item[
                                              //                 'jadwal_perbaikan_awal']),
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
                                                child: ElevatedButton.icon(
                                                  icon: Icon(
                                                    Icons.call,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  label:
                                                      Text("Hubungi Sekarang"),
                                                  onPressed: () {
                                                    String nomorTelpTukang =
                                                        item['no_telp_tukang'];
                                                    String
                                                        nomorTelpTukangCodeCountry =
                                                        nomorTelpTukang
                                                            .replaceFirst(
                                                                '0', '+62');
                                                    print(nomorTelpTukang);
                                                    String urlWhatsApp =
                                                        "https://wa.me/$nomorTelpTukangCodeCountry/?text=Halo...";

                                                    launchUrl(
                                                            Uri.parse(
                                                                urlWhatsApp),
                                                            mode: LaunchMode
                                                                .externalApplication)
                                                        .catchError((e) {
                                                      throw 'Tidak dapat membuka aplikasi WhatsApp.';
                                                    });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xffFF5403),
                                                    foregroundColor:
                                                        Colors.white,
                                                    minimumSize: Size(330, 30),
                                                  ),
                                                ),
                                              ),
                                              item['status'] == "Ditolak" ||
                                                      item['status'] ==
                                                          "Dibatalkan"
                                                  ? Container(
                                                      child:
                                                          ElevatedButton.icon(
                                                        icon: Icon(
                                                            Icons.task_alt,
                                                            color:
                                                                Colors.white),
                                                        label: Text(item[
                                                                    'status'] ==
                                                                "Ditolak"
                                                            ? "Lihat Alasan Tolak Pemesanan"
                                                            : "Lihat Alasan Batal Pemesanan"),
                                                        onPressed: () {
                                                          // _doneOrder(
                                                          //     item['ID']);
                                                          // fetchDataStatusDikerjakan();
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  content:
                                                                      Stack(
                                                                    clipBehavior:
                                                                        Clip.none,
                                                                    children: <
                                                                        Widget>[
                                                                      Positioned(
                                                                        right:
                                                                            -15.0,
                                                                        top:
                                                                            -15.0,
                                                                        child:
                                                                            InkResponse(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              CircleAvatar(
                                                                            radius:
                                                                                12,
                                                                            child:
                                                                                Icon(
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
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                              height: 60,
                                                                              width: MediaQuery.of(context).size.width,
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromARGB(255, 212, 212, 212).withOpacity(0.2),
                                                                                border: Border(
                                                                                  bottom: BorderSide(
                                                                                    color: Colors.grey.withOpacity(0.3),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  item['status'] == "Ditolak" ? "Alasan tolak pemesanan\noleh tukang" : "Alasan batal pemesanan\noleh customer",
                                                                                  style: TextStyle(
                                                                                    color: Color(0xffFF5403),
                                                                                    fontWeight: FontWeight.w700,
                                                                                    fontSize: 20,
                                                                                    fontStyle: FontStyle.italic,
                                                                                    fontFamily: "Helvetica",
                                                                                  ),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.all(20.0),
                                                                              child: Container(
                                                                                  height: 250,
                                                                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2))),
                                                                                  child: Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Expanded(
                                                                                        // flex: 4,
                                                                                        child: TextFormField(
                                                                                          readOnly: true,
                                                                                          maxLines: 18,
                                                                                          initialValue: item['alasan_tolak_batal'],
                                                                                          decoration: InputDecoration(
                                                                                            // hintText: "Input alasan tolak pemesanan",
                                                                                            contentPadding: EdgeInsets.only(left: 20),
                                                                                            border: InputBorder.none,
                                                                                            focusedBorder: InputBorder.none,
                                                                                            errorBorder: InputBorder.none,
                                                                                            hintStyle: TextStyle(
                                                                                              color: Colors.black26,
                                                                                              fontSize: 18,
                                                                                              fontWeight: FontWeight.w500,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
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
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Color(0xffFF5403),
                                                          foregroundColor:
                                                              Colors.white,
                                                          minimumSize:
                                                              Size(330, 35),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }
                          }
                        }
                      }),
                    ))
              ],
            )),
      ),
    );
  }
}

// Container myTab1 = 

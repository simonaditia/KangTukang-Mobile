import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tukang_online/screens/customer/CustomerMapScreen.dart';
import 'package:tukang_online/screens/customer/CustomerPesananScreen.dart';
import 'package:tukang_online/screens/customer/CustomerSearchScreen.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:tukang_online/screens/customer/food_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/gestures.dart';

class CustomerPesanScreen extends StatefulWidget {
  const CustomerPesanScreen({Key? key, required this.tukangId})
      : super(key: key);
  final String tukangId;

  @override
  State<CustomerPesanScreen> createState() => _CustomerPesanScreenState();
}

class _CustomerPesanScreenState extends State<CustomerPesanScreen> {
  String token = '';
  DateTime selectDate = DateTime.now();
  TextEditingController detailPerbaikanController =
      TextEditingController(text: '');
  String alamat = '';

  FoodModel? tukangData;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt') ?? '';

    setState(() {
      token = jwt;
    });
    fetchTukangData(token);
  }

  Future<void> fetchTukangData(String token) async {
    var url = Uri.parse(
        'http://192.168.1.100:8000/api/v1/users/findTukang/${widget.tukangId}');
    try {
      print("didialam get token customerpesanscreen fetchTukangData");
      print(token);
      print("didialam get token customerpesanscreen fetchTukangData");
      var response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print("di customer pesan screen");
        print(response.body);

        if (responseData['status'] == 'success') {
          var data = responseData['data'];

          var foodModel = FoodModel(
            data['ID'],
            data['nama'],
            data['kategori'],
            data['email'],
            data['role'],
            data['alamat'],
            double.parse(data['distance'].toString()),
            // data['latitude'],
            // data['longitude'],
          );

          setState(() {
            tukangData = foodModel;
          });
        } else {
          throw Exception('API request failed');
        }
      } else {
        throw Exception('Failed to fetch tukang data');
      }
    } catch (error) {
      throw Exception('Error fetching tukang data: $error');
    }
  }

  Future<void> postOrderData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt') ?? '';
    var idCustomer = JwtDecoder.decode(jwt)['id'].toString();
    var idTukang = tukangData!.ID;

    var url = Uri.parse(
        'http://192.168.1.100:8000/api/v1/orders/$idTukang/order?id_customer=$idCustomer');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwt'
    };
    var body = jsonEncode({
      'detail_perbaikan': detailPerbaikanController.text,
      'waktu_perbaikan': '2023-06-27 13:44:00',
      'status': 'Menunggu Konfirmasi',
      'Alamat': tukangData!.alamat
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        // Tindakan yang diambil saat menerima respons sukses
        Fluttertoast.showToast(
          msg: 'Pemesanan tukang berhasil. Mohon tunggu konfirmasi tukang.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerPesananScreen(),
          ),
        );
      } else {
        throw Exception('Failed to post order data');
      }
    } catch (error) {
      throw Exception('Error posting order data: $error');
    }
  }

  // String selectDate2 = DateFormat.yMMMMEEEEd().format(DateTime.now());
  // DateTime selectDate3 = DateTime(2)
  @override
  Widget build(BuildContext context) {
    if (tukangData == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black)),
                flexibleSpace: Container(color: Colors.white),
                elevation: 0,
                title: Text("Panggil Tukang",
                    style: TextStyle(color: Colors.black)),
                centerTitle: true),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Spacer(
                            flex: 1,
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/logo.png'),
                                // NetworkImage(
                                //     "https://images.unsplash.com/photo-1499996860823-5214fcc65f8f"),
                                radius: 50,
                              )
                            ],
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // "Nama Tukang:
                              Text(
                                'Nama: ${tukangData != null ? tukangData!.nama : 'Nama tidak tersedia'}',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                // Kategori Tukang: Renovasi
                                child: Text(
                                  'Kategori: ${tukangData != null ? tukangData!.kategori : 'Kategori tidak tersedia'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Biaya Tukang: Rp.100.000",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          Spacer(
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Perbaikan apa yang dibutuhkan?",
                              style: TextStyle(fontSize: 16),
                            ))),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        controller: detailPerbaikanController,
                        style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide:
                                BorderSide(color: Colors.white, width: 5.5),
                          ),
                          hintText: "Detail perbaikan",
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Jadwalkan",
                              style: TextStyle(fontSize: 16),
                            ))),
                    // Container(
                    //   child: Text(DateFormat.yMMMMEEEEd().format(DateTime.now())),
                    // ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      // alignment: Alignment.c,
                      child: ElevatedButton(
                        child: Text(
                            // selectDate.toString(),
                            DateFormat.yMMMMEEEEd().format(selectDate),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: selectDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2025),
                            initialEntryMode: DatePickerEntryMode.calendar,
                          ).then((value) {
                            if (value != null)
                              setState(() {
                                selectDate = value;
                              });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 218, 218, 218),
                          foregroundColor: Color.fromARGB(255, 54, 54, 54),
                          // minimumSize: Size(50, 26),
                        ),
                      ),
                    ),
                    // Container(
                    //     padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                    //     child: Align(
                    //         alignment: Alignment.centerLeft,
                    //         child: Text(
                    //           "Alamat",
                    //           style: TextStyle(fontSize: 16),
                    //         ))),
                    // Container(
                    //   padding: EdgeInsets.only(left: 20, right: 20),
                    //   child: TextField(
                    //     style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                    //     decoration: InputDecoration(
                    //       filled: true,
                    //       fillColor: Colors.white,
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(6.0),
                    //         borderSide:
                    //             BorderSide(color: Colors.white, width: 5.5),
                    //       ),
                    //       hintText: "Jl.Mangga Raya...",
                    //     ),
                    //   ),
                    // ),
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Alamat",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        maxLines: 4,
                        initialValue: tukangData!.alamat,
                        readOnly: true,
                        style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide:
                                BorderSide(color: Colors.white, width: 5.5),
                          ),
                          // hintText: "Jl.Mangga Raya...",
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 25, left: 20, right: 20),
                      height: 300, // Sesuaikan dengan kebutuhan Anda
                      child: GestureDetector(
                        onPanUpdate: (details) {},
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(-6.2344189,
                                106.9861527), // Ganti dengan latitude dan longitude yang sesuai
                            zoom: 14.0,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId('user_location'),
                              position: LatLng(-6.2344189,
                                  106.9861527), // Ganti dengan latitude dan longitude yang sesuai
                              infoWindow: InfoWindow(
                                title: 'Lokasi Anda',
                                snippet: 'Ini adalah lokasi Anda.',
                              ),
                            ),
                          },
                          gestureRecognizers:
                              <Factory<OneSequenceGestureRecognizer>>[
                            Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer()),
                          ].toSet(),
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(
                          top: 25, left: 20, right: 20, bottom: 30),
                      // width: double.infinity,
                      // alignment: Alignment.c,
                      child: ElevatedButton(
                        child: Text("Pesan Tukang",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        onPressed: () {
                          postOrderData();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return CustomerMapScreen();
                          //     },
                          //   ),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffFF5403),
                          foregroundColor: Colors.white,
                          minimumSize: Size(430, 45),
                          // minimumSize: Size(50, 26),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
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
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';

class CustomerPesanScreen extends StatefulWidget {
  const CustomerPesanScreen({Key? key, required this.tukangId})
      : super(key: key);
  final String tukangId;

  @override
  State<CustomerPesanScreen> createState() => _CustomerPesanScreenState();
}

class _CustomerPesanScreenState extends State<CustomerPesanScreen> {
  String token = '';
  // DateTime selectDate = DateTime.now();
  TextEditingController detailPerbaikanController =
      TextEditingController(text: '');
  String alamat = '';
  DateTime selectedDateTimeAwal = DateTime.now();
  DateTime selectedDateTimeAkhir = DateTime.now();

  CustomerPesan? tukangData;
  Map<String, dynamic>? userData;
  double? _userLatitude;
  double? _userLongitude;
  GoogleMapController? _mapController;
  bool _isLoading = false;
  String _currentAddress = '';
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getToken();
    loadCustomerLatitudeLongitude();
    // loadCustomerLatitudeLongitude();
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt') ?? '';

    setState(() {
      token = jwt;
    });
    fetchTukangData(token);
  }

  // Future<void> executeOrderProcess() async {
  //   try {
  //     await Future.wait([
  //       fetchTukangData(token),
  //       loadCustomerLatitudeLongitude(),
  //       postOrderData(),
  //     ]);

  //     // Kode selanjutnya yang perlu dijalankan setelah kedua fungsi selesai
  //   } catch (error) {
  //     // Tangani error yang terjadi
  //     print('Error executing order process: $error');
  //   }
  // }

  Future<void> fetchTukangData(String token) async {
    var url =
        Uri.parse('http://192.168.1.100:8000/api/v1/users/${widget.tukangId}');
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
          List<Categoryy> categories = (data['Categories'] as List<dynamic>)
              .map((category) => Categoryy(category['ID'], category['Name']))
              .toList();

          var foodModel = CustomerPesan(
            data['ID'],
            data['nama'],
            data['kategori'],
            data['email'],
            data['role'],
            data['alamat'],
            double.parse(data['distance'].toString()),
            double.parse(data['biaya'].toString()),
            categories,
            // (data['Categories'] as List<dynamic>)
            //     .map((category) => Category(category['ID'], category['Name']))
            //     .toList(),
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

  Future<void> loadCustomerLatitudeLongitude() async {
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
      // print(responseData);
      var decodedData = json.decode(responseData);
      setState(() {
        userData = decodedData['data'];
        _addressController.text = userData!['alamat'];
        // print(userData);
      });
    } else {
      // Menangani respons yang gagal
      throw Exception('Gagal mengambil data dari API');
    }
  }

  void _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _userLatitude!,
        _userLongitude!,
      );

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address =
            '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';

        setState(() {
          _currentAddress = address;
        });
      }
    } catch (e) {
      print('Could not get the address: $e');
    }
  }

  void _getUserLocation() async {
    setState(() {
      _isLoading = true;
    });

    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Could not get the location: $e');
    }

    if (position != null) {
      setState(() {
        _userLatitude = position!.latitude;
        _userLongitude = position!.longitude;
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(_userLatitude!, _userLongitude!),
          ),
        );
      });

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _userLatitude!,
          _userLongitude!,
        );
        print(_userLatitude);
        print(_userLongitude);
        if (placemarks != null && placemarks.isNotEmpty) {
          Placemark placemark = placemarks[0];
          String address =
              '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';
          print("address");

          setState(() {
            _currentAddress = address;
            _addressController.text = _currentAddress;
          });
        }
      } catch (e) {
        print('Could not get the address: $e');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> postOrderData() async {
    await fetchTukangData(token);
    await loadCustomerLatitudeLongitude();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt') ?? '';
    var idCustomer = JwtDecoder.decode(jwt)['id'].toString();
    var idTukang = tukangData!.ID;
    if (tukangData != null && userData != null) {
      var customerLatitude = userData!['latitude'];
      var customerLongitude = userData!['longitude'];
      var customerNama = userData!['nama'];
      var tukangNama = tukangData!.nama;
      var tukangKategori = tukangData!.kategori;
      var tukangBiaya = tukangData!.biaya;
      print(customerLatitude);
      print(customerLatitude.runtimeType);
      print(customerLongitude);
      print(customerLongitude.runtimeType);

      int differenceInDays =
          selectedDateTimeAkhir.difference(selectedDateTimeAwal).inDays + 1;
      double totalBiaya = differenceInDays * tukangBiaya;

      var url = Uri.parse(
          'http://192.168.1.100:8000/api/v1/orders/$idTukang/order?id_customer=$idCustomer');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt'
      };
      var body = jsonEncode({
        'detail_perbaikan': detailPerbaikanController.text,
        'jadwal_perbaikan_awal': selectedDateTimeAwal.toString(),
        'jadwal_perbaikan_akhir': selectedDateTimeAkhir.toString(),
        'status': 'Menunggu Konfirmasi',
        'alamat': tukangData!.alamat,
        'latitude_customer': customerLatitude,
        'longitude_customer': customerLongitude,
        'nama_customer': customerNama,
        'nama_tukang': tukangNama,
        'kategori_tukang': tukangKategori,
        'total_biaya': totalBiaya
      });
      // jadi kalau tukang nya sedang ada jadawl
      // tukang dengan status sedang bekerja tidak akan
      // bisa muncul dalam pencarian
      // tukang dengan status tidak sedang bekerja
      // bisa muncul dalam pencarian

      if (selectedDateTimeAkhir.isBefore(selectedDateTimeAwal)) {
        Fluttertoast.showToast(
          msg: 'Tanggal akhir harus lebih besar dari tanggal awal.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color(0xffFF5403),
        );
        return; // Menghentikan eksekusi fungsi jika kondisi terpenuhi
      }

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

      // Lakukan operasi dengan tukangNama dan userLatitude di sini
    } else {
      throw Exception('Tukang data or user data is null');
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
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
                              // Text(
                              //   'Kategori Tukang:',
                              //   style: TextStyle(fontWeight: FontWeight.bold),
                              // ),
                              // ListView.builder(
                              //   shrinkWrap: true,
                              //   itemCount: tukangData?.categories?.length ?? 0,
                              //   itemBuilder: (context, index) {
                              //     var category = tukangData!.categories[index];
                              //     return Text(category.name);
                              //   },
                              // ),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                // Kategori Tukang: Renovasi
                                child: Text(
                                  // 'Kategori: ${tukangData != null ? tukangData!.kategori : 'Kategori tidak tersedia'}',
                                  'Kategori: ${tukangData != null ? tukangData!.categories.map((category) => category.name).join(', ') : 'Kategori tidak tersedia'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Biaya Tukang: Rp.${tukangData!.biaya.toInt()}/hr",
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
                              "Jadwalkan dari kapan?",
                              style: TextStyle(fontSize: 16),
                            ))),
                    // Container(
                    //   child: Text(DateFormat.yMMMMEEEEd().format(DateTime.now())),
                    // ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text(
                          DateFormat.yMMMMEEEEd()
                              .add_jm()
                              .format(selectedDateTimeAwal),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDateTimeAwal,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2025),
                            initialEntryMode: DatePickerEntryMode.calendar,
                          );

                          if (date != null) {
                            final TimeOfDay initialTime =
                                TimeOfDay(hour: 8, minute: 0);
                            final TimeOfDay finalTime =
                                TimeOfDay(hour: 17, minute: 0);
                            TimeOfDay? selectedTime = await showTimePicker(
                              context: context,
                              initialTime:
                                  TimeOfDay.fromDateTime(selectedDateTimeAwal),
                            );

                            if (selectedTime != null) {
                              if (selectedTime.hour < initialTime.hour ||
                                  selectedTime.hour > finalTime.hour) {
                                Fluttertoast.showToast(
                                  msg:
                                      'Mohon pilih waktu antara 8 pagi dan 5 sore.',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Color(0xffFF5403),
                                );
                              } else {
                                setState(() {
                                  selectedDateTimeAwal = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    selectedTime.hour,
                                    selectedTime.minute,
                                  );
                                });
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 218, 218, 218),
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),

                    Container(
                        padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Jadwalkan sampai kapan?",
                              style: TextStyle(fontSize: 16),
                            ))),
                    // Container(
                    //   child: Text(DateFormat.yMMMMEEEEd().format(DateTime.now())),
                    // ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text(
                          DateFormat.yMMMMEEEEd()
                              .add_jm()
                              .format(selectedDateTimeAkhir),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () async {
                          final DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDateTimeAkhir,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2025),
                            initialEntryMode: DatePickerEntryMode.calendar,
                          );

                          if (selectedDate != null) {
                            final TimeOfDay initialTime =
                                TimeOfDay(hour: 8, minute: 0);
                            final TimeOfDay finalTime =
                                TimeOfDay(hour: 17, minute: 0);
                            TimeOfDay? selectedTime = await showTimePicker(
                              context: context,
                              initialTime:
                                  TimeOfDay.fromDateTime(selectedDateTimeAkhir),
                            );

                            if (selectedTime != null) {
                              DateTime selectedDateTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );

                              if (selectedDateTime
                                  .isBefore(selectedDateTimeAwal)) {
                                Fluttertoast.showToast(
                                  msg:
                                      'Tanggal akhir harus lebih besar dari tanggal awal.',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Color(0xffFF5403),
                                );
                              } else if (selectedTime.hour < initialTime.hour ||
                                  selectedTime.hour > finalTime.hour) {
                                Fluttertoast.showToast(
                                  msg:
                                      'Mohon pilih waktu antara 8 pagi dan 5 sore.',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Color(0xffFF5403),
                                );
                              } else {
                                setState(() {
                                  selectedDateTimeAkhir = selectedDateTime;
                                });
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 218, 218, 218),
                          foregroundColor: Colors.black,
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
                          "Alamat Lengkap (RT, RW, No Rumah)",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextFormField(
                        maxLines: 4,
                        controller: _addressController,
                        // initialValue: userData!['alamat'],
                        // readOnly: true,
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
                      child: Stack(
                        children: [
                          GoogleMap(
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                _userLatitude ?? userData!['latitude'],
                                _userLongitude ?? userData!['longitude'],
                              ),
                              zoom: 14.0,
                            ),
                            markers: {
                              Marker(
                                markerId: MarkerId('user_location'),
                                position: LatLng(
                                  _userLatitude ?? userData!['latitude'],
                                  _userLongitude ?? userData!['longitude'],
                                ),
                                infoWindow: InfoWindow(
                                  title: 'Lokasi Anda',
                                  snippet: 'Ini adalah lokasi Anda.',
                                ),
                              ),
                            },
                            gestureRecognizers:
                                <Factory<OneSequenceGestureRecognizer>>[
                              Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer(),
                              ),
                            ].toSet(),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FloatingActionButton(
                                onPressed: () {
                                  _getUserLocation();
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    _isLoading
                                        ? CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          )
                                        : Icon(Icons.refresh),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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

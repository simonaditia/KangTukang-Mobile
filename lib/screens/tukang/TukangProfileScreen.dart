import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tukang_online/screens/tukang/TukangDashboardScreen.dart';
import 'package:tukang_online/screens/tukang/TukangTentangAppScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';

class TukangProfileScreen extends StatefulWidget {
  const TukangProfileScreen({super.key});

  @override
  State<TukangProfileScreen> createState() => _TukangProfileScreenState();
}

class _TukangProfileScreenState extends State<TukangProfileScreen> {
  bool? _checked1 = false;
  bool? _checked2 = false;
  bool? _checked3 = false;
  bool? _checked4 = false;
  bool? _checked5 = false;
  bool? _checked6 = false;
  Map<String, dynamic>? userData;
  List<dynamic>? categories;
  List<int> userCategoryIDs = [];
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _biayaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  double? _userLatitude;
  double? _userLongitude;
  bool _isLoading = false; // Tambahkan variabel isLoading
  bool _isChecked = false;
  GoogleMapController? _mapController;
  String _currentAddress = '';
  TextEditingController _addressController = TextEditingController();

  Future<void> fetchDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idUser = decodedToken['id'] as int;
    String apiUrl = 'http://34.128.64.114:8000/api/v1/users/$idUser';

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
      print(responseData);
      var decodedData = json.decode(responseData);

      setState(() {
        userData = decodedData['data'];
        _namaController.text = userData!['nama'];
        _emailController.text = userData!['email'];
        _noTelpController.text = userData!['no_telp'];
        _kategoriController.text = userData!['kategori'];
        _biayaController.text = userData!['biaya'].toString();
        _alamatController.text = userData!['alamat'];
        categories = userData!['Categories'];
        _addressController.text = userData!['alamat'];

        for (var category in categories!) {
          int categoryID = category['ID'];
          userCategoryIDs.add(categoryID);
        }
        _checked1 = userCategoryIDs.contains(1); // ID kategori "Renovasi"
        _checked2 = userCategoryIDs.contains(2); // ID kategori "Cat"
        _checked3 = userCategoryIDs.contains(3);
        _checked4 = userCategoryIDs.contains(4); // ID kategori "Renovasi"
        _checked5 = userCategoryIDs.contains(5); // ID kategori "Cat"
        _checked6 = userCategoryIDs.contains(6);
      });
      // for (var category in categories) {
      //   int categoryID = category['ID'];
      //   String categoryName = category['Name'];
      //   print('ID Kategori: $categoryID');
      //   print('Nama Kategori: $categoryName');
      // }
    } else {
      // Gagal mendapatkan data
      print('Error: ${response.statusCode}');
    }
  }

  // void _getUserLocation() async {
  //   Position? position;
  //   try {
  //     position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //   } catch (e) {
  //     print('Could not get the location: $e');
  //   }

  //   setState(() {
  //     if (position != null) {
  //       _userLatitude = position.latitude;
  //       _userLongitude = position.longitude;
  //       _alamatController.text = '$_userLatitude, $_userLongitude';
  //     }
  //   });
  // }

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

  Future<void> saveDataCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idUser = decodedToken['id'] as int;
    String apiUrl = 'http://34.128.64.114:8000/api/v1/users/$idUser/categories';
    List<Map<String, dynamic>> selectedCategories = [];

    if (_checked1!) {
      selectedCategories.add({'id': 1, 'name': 'Renovasi'});
    }
    if (_checked2!) {
      selectedCategories.add({'id': 2, 'name': 'Cat'});
    }
    if (_checked3!) {
      selectedCategories.add({'id': 3, 'name': 'Kategori 3'});
    }
    if (_checked4!) {
      selectedCategories.add({'id': 4, 'name': 'Renovasi'});
    }
    if (_checked5!) {
      selectedCategories.add({'id': 5, 'name': 'Cat'});
    }
    if (_checked6!) {
      selectedCategories.add({'id': 6, 'name': 'Kategori 6'});
    }

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'categories': selectedCategories}),
    );

    if (response.statusCode == 200) {
      print('Data kategori berhasil disimpan');
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> saveData() async {
    setState(() {
      _isLoading =
          true; // Set isLoading menjadi true saat proses penyimpanan dimulai
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idUser = decodedToken['id'] as int;
    String apiUrl = 'http://34.128.64.114:8000/api/v1/users/$idUser';

    _getUserLocation();
    saveDataCategories();

    String nama = _namaController.text;
    String email = _emailController.text;
    String noTelp = _noTelpController.text;
    String kategori = _kategoriController.text;
    String biaya = _biayaController.text;
    // String alamat = _alamatController.text;
    double latitude = _userLatitude ?? userData!['latitude'];
    double longitude = _userLongitude ?? userData!['longitude'];

    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        // Jika diperlukan, tambahkan header Authorization dengan token JWT
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'nama': nama,
        'email': email,
        'no_telp': noTelp,
        'kategori': kategori,
        'biaya': double.parse(biaya),
        // 'alamat': alamat,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    setState(() {
      _isLoading =
          false; // Set isLoading menjadi false setelah proses penyimpanan selesai
    });
    if (response.statusCode == 200) {
      // Berhasil menyimpan data
      print('Data berhasil disimpan');
      Fluttertoast.showToast(
        msg: 'Edit Profile Berhasil!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      // Gagal menyimpan data
      print('Error: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
              icon: Icon(Icons.arrow_back, color: Colors.black),
            ),
            flexibleSpace: Container(color: Colors.white),
            elevation: 0,
            title: Text("Profile", style: TextStyle(color: Colors.black)),
            centerTitle: true),
        body: userData != null
            ? ListView(
                children: [
                  _isLoading
                      ? CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                        )
                      : Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 50, bottom: 20),
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/tukang1.jpg'),
                                  radius: 70,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 5),
                                child: TextFormField(
                                  //initialValue: userData!['nama'],
                                  controller: _namaController,
                                  style: TextStyle(
                                      color: Color.fromARGB(190, 0, 0, 0)),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 5.5),
                                    ),
                                    hintText: "Nama",
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 5, bottom: 5),
                                child: TextFormField(
                                  //initialValue: userData!['email'],
                                  controller: _emailController,
                                  style: TextStyle(
                                      color: Color.fromARGB(190, 0, 0, 0)),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 5.5),
                                    ),
                                    hintText: "Email",
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 5, bottom: 5),
                                child: TextFormField(
                                  //initialValue: userData!['no_telp'],
                                  controller: _noTelpController,
                                  style: TextStyle(
                                      color: Color.fromARGB(190, 0, 0, 0)),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 5.5),
                                    ),
                                    hintText: "No.Telp",
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 5, bottom: 5),
                                child: TextFormField(
                                  //initialValue: userData!['kategori'],
                                  controller: _kategoriController,
                                  style: TextStyle(
                                      color: Color.fromARGB(190, 0, 0, 0)),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 5.5),
                                    ),
                                    hintText: "Kategori",
                                  ),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(
                                      left: 20, top: 20, bottom: 10),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Kategori Pekerjaan",
                                        style: TextStyle(fontSize: 16),
                                      ))),
                              Container(
                                  padding: EdgeInsets.only(left: 18, right: 18),
                                  child: Card(
                                    child: SizedBox(
                                      width: 600,
                                      height: 340,
                                      child: Column(children: [
                                        CheckboxListTile(
                                          // secondary: Icon(Icons.beach_access),
                                          title: Text("Renovasi"),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          value: _checked1,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _checked1 = value;
                                            });
                                          },
                                          activeColor: Color(0xffFF5403),
                                          checkColor: Colors.white,
                                        ),
                                        CheckboxListTile(
                                          // secondary: Icon(Icons.beach_access),
                                          title: Text("Cat"),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          value: _checked2,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _checked2 = value;
                                            });
                                          },
                                          activeColor: Color(0xffFF5403),
                                          checkColor: Colors.white,
                                        ),
                                        CheckboxListTile(
                                          // secondary: Icon(Icons.beach_access),
                                          title: Text("Plafon"),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          value: _checked3,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _checked3 = value;
                                            });
                                          },
                                          activeColor: Color(0xffFF5403),
                                          checkColor: Colors.white,
                                        ),
                                        CheckboxListTile(
                                          // secondary: Icon(Icons.beach_access),
                                          title: Text("Kebocoran"),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          value: _checked4,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _checked4 = value;
                                            });
                                          },
                                          activeColor: Color(0xffFF5403),
                                          checkColor: Colors.white,
                                        ),
                                        CheckboxListTile(
                                          // secondary: Icon(Icons.beach_access),
                                          title: Text("Keramik"),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          value: _checked5,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _checked5 = value;
                                            });
                                          },
                                          activeColor: Color(0xffFF5403),
                                          checkColor: Colors.white,
                                        ),
                                        CheckboxListTile(
                                          // secondary: Icon(Icons.beach_access),
                                          title: Text("Dinding"),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          value: _checked6,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _checked6 = value;
                                            });
                                          },
                                          activeColor: Color(0xffFF5403),
                                          checkColor: Colors.white,
                                        ),
                                      ]),
                                    ),
                                  )),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 5),
                                child: TextFormField(
                                  //initialValue: "userData!['biaya']",
                                  keyboardType: TextInputType.number,
                                  controller: _biayaController,
                                  style: TextStyle(
                                      color: Color.fromARGB(190, 0, 0, 0)),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 5.5),
                                    ),
                                    hintText: "Biaya Perhari, Rp.100.000",
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
                                  style: TextStyle(
                                      color: Color.fromARGB(190, 0, 0, 0)),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 5.5),
                                    ),
                                    // hintText: "Jl.Mangga Raya...",
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 25, left: 20, right: 20),
                                height: 300, // Sesuaikan dengan kebutuhan Anda
                                child: Stack(
                                  children: [
                                    GoogleMap(
                                      onMapCreated: (controller) {
                                        _mapController = controller;
                                      },
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                          _userLatitude ??
                                              userData!['latitude'],
                                          _userLongitude ??
                                              userData!['longitude'],
                                        ),
                                        zoom: 14.0,
                                      ),
                                      markers: {
                                        Marker(
                                          markerId: MarkerId('user_location'),
                                          position: LatLng(
                                            _userLatitude ??
                                                userData!['latitude'],
                                            _userLongitude ??
                                                userData!['longitude'],
                                          ),
                                          infoWindow: InfoWindow(
                                            title: 'Lokasi Anda',
                                            snippet: 'Ini adalah lokasi Anda.',
                                          ),
                                        ),
                                      },
                                      gestureRecognizers: <
                                          Factory<
                                              OneSequenceGestureRecognizer>>[
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
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
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
                                    left: 20, right: 20, top: 10, bottom: 40),
                                // width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xffFF5403),
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(430, 45),
                                  ),
                                  onPressed: () async {
                                    await saveData(); // Wait for the data to be saved
                                  },
                                  child: const Text('Simpan',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                ),
                              ),
                            ],
                          ),
                        )
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

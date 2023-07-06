import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tukang_online/screens/customer/CustomerDashboardScreen.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tukang_online/resources/add_image.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  Map<String, dynamic>? userData;
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  // final TextEditingController _kategoriController = TextEditingController();
  // final TextEditingController _biayaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  double? _userLatitude;
  double? _userLongitude;
  bool _isLoading = false; // Tambahkan variabel isLoading
  bool _isLoadingMap = false;
  GoogleMapController? _mapController;
  String _currentAddress = '';
  TextEditingController _addressController = TextEditingController();

  Uint8List? _image;
  String? imageUrl;

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
      print(responseData);
      var decodedData = json.decode(responseData);

      setState(() {
        userData = decodedData['data'];
        _namaController.text = userData!['nama'];
        _emailController.text = userData!['email'];
        _noTelpController.text = userData!['no_telp'];
        // _kategoriController.text = userData!['kategori'];
        // _biayaController.text = userData!['biaya'];
        _alamatController.text = userData!['alamat'];
        _addressController.text = userData!['alamat'];
      });
    } else {
      // Gagal mendapatkan data
      print('Error: ${response.statusCode}');
    }
  }

  void _getUserLocation() async {
    setState(() {
      _isLoadingMap = true;
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
      _isLoadingMap = false;
    });
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      setState(() {
        userData!['image_url'] = "";
      });
      return await _file.readAsBytes();
    }
    print("No Images Selected");
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<void> savePhoto() async {
    final StoreGambar _storeGambar = StoreGambar();
    final StoreGambar _statusLoading = StoreGambar();

    await _storeGambar.saveData(file: _image!);
    // if (_image != null || _image != "") {
    // }
    setState(() {
      // if (_statusLoading.statusLoading != null) {
      //   _isLoading = _statusLoading.statusLoading!;
      // }
      imageUrl = _storeGambar.imageUrl;
      // saveData();
    });
    print("DIDALAM SAVE PHOTO");
    print(imageUrl);
  }

  Future<void> saveData() async {
    setState(() {
      // Set isLoading menjadi true saat proses penyimpanan dimulai
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('jwt') ?? '';
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int idUser = decodedToken['id'] as int;
    String apiUrl = 'http://192.168.1.100:8000/api/v1/users/$idUser';

    print("DIDALAM SAVE DATA");
    print(_image);
    print("HALOHALO");
    _getUserLocation();
    if (userData!['image_url'] == null || userData!['image_url'] == "") {
      if (_image == null || _image == "") {
        userData!['image_url'] = "";
      } else {
        await savePhoto();
      }
    }
    print(userData!['image_url']);
    print("DIDALAM SAVE DATA");

    String nama = _namaController.text;
    String email = _emailController.text;
    String noTelp = _noTelpController.text;
    // String kategori = _kategoriController.text;
    // String biaya = _biayaController.text;
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
        // 'kategori': kategori,
        // 'biaya': biaya,
        // 'alamat': alamat,
        'latitude': latitude,
        'longitude': longitude,
        'image_url': imageUrl,
      }),
    );

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
      Navigator.pushReplacementNamed(context, '/dashboard-customer');
    } else {
      // Gagal menyimpan data
      print('Error: ${response.statusCode}');
    }
    setState(() {
      _isLoading =
          false; // Set isLoading menjadi false setelah proses penyimpanan selesai
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDataUser();
    // _getUserLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
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
                      return CustomerDashboardScreen();
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
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xffFF5403),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 50, bottom: 20),
                                child: Stack(
                                  children: [
                                    userData!['image_url'] == null ||
                                            userData!['image_url'] == ""
                                        ? _image != null
                                            ? CircleAvatar(
                                                radius: 64,
                                                backgroundImage:
                                                    MemoryImage(_image!),
                                              )
                                            : CircleAvatar(
                                                radius: 64,
                                                backgroundImage: AssetImage(
                                                    'assets/images/default_profile_image.png'),
                                              )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(64.0),
                                            child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                width: 130,
                                                height: 130,
                                                placeholder: (context, url) =>
                                                    Image.asset(
                                                      'assets/images/content_placeholder.gif',
                                                      fit: BoxFit.cover,
                                                    ),
                                                imageUrl:
                                                    userData!['image_url']),
                                          ),
                                    // CircleAvatar(
                                    //   radius: 64,
                                    //   child: FadeInImage(
                                    //     placeholder: AssetImage(
                                    //         'assets/images/content_placeholder.gif'),
                                    //     image:
                                    //         NetworkImage(userData!['image_url']),
                                    //     fit: BoxFit.fitWidth,
                                    //   ),
                                    // ),
                                    Positioned(
                                      child: IconButton(
                                        onPressed: selectImage,
                                        icon: const Icon(Icons.add_a_photo),
                                      ),
                                      bottom: -10,
                                      left: 80,
                                    ),
                                  ],
                                ),
                              ),
                              // Container(
                              //   padding: EdgeInsets.only(top: 50, bottom: 20),
                              //   child: CircleAvatar(
                              //     backgroundImage: AssetImage(
                              //         'assets/images/customer_small1.jpg'),
                              //     radius: 70,
                              //   ),
                              // ),
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
                                  keyboardType: TextInputType.emailAddress,
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
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
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
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: FloatingActionButton(
                                          onPressed: () {
                                            _getUserLocation();
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              _isLoadingMap
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

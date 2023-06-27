import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tukang_online/screens/customer/CustomerPesanScreen.dart';
import 'package:tukang_online/screens/customer/food_model.dart';

class CustomerSearchScreen extends StatefulWidget {
  final String tukangId;

  // const CustomerPesanScreen({required this.tukangId});
  const CustomerSearchScreen({Key? key, required this.tukangId})
      : super(key: key);

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  String token = '';

  static List<FoodModel> main_food_list = [
    // FoodModel("Adit Pieter", "Renovasi", "1.1KM", "assets/images/logo.png"),
    // FoodModel("Adi Mansur", "Renovasi", "1.7KM", "assets/images/logo.png"),
    // FoodModel("Ali Raja", "Cat", "2.5KM", "assets/images/logo.png"),
    // FoodModel("Iman Hasan", "Cat", "3.3KM", "assets/images/logo.png"),
    // FoodModel("Daud Surya", "Plaffon", "4.2KM", "assets/images/logo.png"),
    // FoodModel("Nurul Arif", "Kebocoran", "3.9KM", "assets/images/logo.png"),
    // FoodModel("Ibrahim Abdul", "Keramik", "2.4KM", "assets/images/logo.png"),
    // FoodModel("Udin Arif", "Dinding", "2.6KM", "assets/images/logo.png"),
    // FoodModel("Samuel Bintang", "Renovasi", "4.1KM", "assets/images/logo.png"),
    // FoodModel("Adit Pieter", "Renovasi", "1.1KM",
    //     "https://images.unsplash.com/photo-1519058082700-08a0b56da9b4"),
    // FoodModel("Adi Mansur", "Renovasi", "1.7KM",
    //     "https://images.unsplash.com/photo-1499996860823-5214fcc65f8f"),
    // FoodModel("Ali Raja", "Cat", "2.5KM",
    //     "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d"),
    // FoodModel("Iman Hasan", "Cat", "3.3KM",
    //     "https://images.unsplash.com/photo-1501196354995-cbb51c65aaea"),
    // FoodModel("Daud Surya", "Plaffon", "4.2KM",
    //     "https://images.unsplash.com/photo-1496345875659-11f7dd282d1d"),
    // FoodModel("Nurul Arif", "Kebocoran", "3.9KM",
    //     "https://images.unsplash.com/photo-1669139498665-e4a201f98016"),
    // FoodModel("Ibrahim Abdul", "Keramik", "2.4KM",
    //     "https://images.unsplash.com/photo-1518799175676-a0fed7996acb"),
    // FoodModel("Udin Arif", "Dinding", "2.6KM",
    //     "https://images.unsplash.com/photo-1508179522353-11ba468c4a1c"),
    // FoodModel("Samuel Bintang", "Renovasi", "4.1KM",
    //     "https://images.unsplash.com/photo-1489980557514-251d61e3eeb6"),
  ];
  List<FoodModel> display_list = [];
  TextEditingController searchController = TextEditingController();

//   Future<List<FoodModel>> fetchData(String query) async {
//   var url = Uri.parse('http://localhost:8000/api/v1/users/findTukang?$query');

//   var response = await http.get(url);

//   if (response.statusCode == 200) {
//     var responseData = json.decode(response.body);

//     List<FoodModel> resultList = [];

//     for (var item in responseData) {
//       var foodModel = FoodModel(
//         item['name'],
//         item['category'],
//         item['distance'],
//         item['image_url'],
//       );
//       resultList.add(foodModel);
//     }

//     return resultList;
//   } else {
//     throw Exception('Failed to fetch data');
//   }
// }
  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt') ?? '';
    print("didialam get token");
    print(jwt);
    print("didialam get token");
    setState(() {
      token = jwt;
    });
  }

  Future<List<FoodModel>> fetchDataByName(String name, String token) async {
    var url = Uri.parse(
        'http://192.168.1.100:8000/api/v1/users/findTukang?nama=$name');

    try {
      var response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          var data = responseData['data'];

          if (data is List) {
            // Iterate over the response data and create FoodModel objects
            List<FoodModel> results = data
                .map(
                  (item) => FoodModel(
                    item['ID'],
                    item['nama'],
                    item['kategori'],
                    item['email'],
                    item['role'],
                    item['alamat'],
                    double.parse(item['distance'].toString()),
                    // item['latitude'],
                    // item['longitude'],
                  ),
                )
                .toList();

            return results;
          } else if (data is Map<String, dynamic>) {
            // Handle a single JSON object
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
            return [foodModel];
          } else {
            throw Exception('Invalid response data');
          }
        } else {
          throw Exception('API request failed');
        }
      } else {
        throw Exception('Failed to fetch data by name');
      }
    } catch (error) {
      throw Exception('Error fetching data by name: $error');
    }
  }

  Future<List<FoodModel>> fetchDataByCategory(
      String category, String token) async {
    var url = Uri.parse(
        'http://192.168.1.100:8000/api/v1/users/findTukang?kategori=$category');

    try {
      var response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          var data = responseData['data'];

          if (data is List) {
            // Iterate over the response data and create FoodModel objects
            List<FoodModel> results = data
                .map((item) => FoodModel(
                      item['ID'],
                      item['nama'],
                      item['kategori'],
                      item['email'],
                      item['role'],
                      item['alamat'],
                      double.parse(item['distance'].toString()),
                      // item['latitude'],
                      // item['longitude'],
                    ))
                .toList();

            return results;
          } else if (data is Map<String, dynamic>) {
            // Handle a single JSON object
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
            return [foodModel];
          } else {
            throw Exception('Invalid response data');
          }
        } else {
          throw Exception('API request failed');
        }
      } else {
        throw Exception('Failed to fetch data by category');
      }
    } catch (error) {
      throw Exception('Error fetching data by category: $error');
    }
  }

  void updateList(String value, String token) {
    setState(() {
      if (value.isEmpty) {
        display_list = [];
      } else {
        if (value.toLowerCase().contains('nama:')) {
          var nama = value.toLowerCase().replaceAll('nama:', '').trim();
          fetchDataByName(nama, token).then((data) {
            setState(() {
              display_list = data;
            });
          }).catchError((error) {
            print('Error fetching data by name: $error');
          });
        } else {
          fetchDataByCategory(value, token).then((data) {
            setState(() {
              display_list = data;
            });
          }).catchError((error) {
            print('Error fetching data by categoryname: $error');
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Cari Tukang Terdekat",
                  style: TextStyle(
                    // color: Color(0xffFF5403),
                    color: Color.fromARGB(255, 44, 44, 44),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: searchController,
                onChanged: (value) => updateList(value, token),
                style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                  ),
                  hintText: "Cat, Plafon, Renovasi, ...",
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.white,
                ),
              ),
              SizedBox(height: 20.0),
              Expanded(
                  child: display_list.isNotEmpty
                      ? ListView.builder(
                          itemCount: display_list.length,
                          itemBuilder: ((context, index) => ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        print(display_list[index].ID!);
                                        print(display_list[index].nama!);
                                        print(display_list[index].kategori!);
                                        return CustomerPesanScreen(
                                            tukangId: display_list[index]
                                                .ID
                                                .toString());
                                      },
                                    ),
                                  );
                                },
                                contentPadding: EdgeInsets.all(8.0),
                                title: Text(
                                  display_list[index].nama!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                    '${display_list[index].kategori!} ${display_list[index].ID!}',
                                    style: TextStyle(
                                      color: Colors.black26,
                                    )),
                                trailing: Text(
                                  "${display_list[index].distance}KM",
                                  style: TextStyle(color: Colors.amber),
                                ),
                                leading: Text('${display_list[index].role!}',
                                    style: TextStyle(
                                      color: Colors.black26,
                                    )),
                                // leading: Image.asset(display_list[index].image!)
                                // leading: Image.network(
                                //     display_list[index].str_meal_thumb!),
                              )),
                        )
                      : searchController.text.isNotEmpty
                          ? Center(
                              child: Text(
                              "No Result found",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ))
                          : Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 34, 33, 33),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          "Ingin melakukan pencarian Nama Tukang?\n",
                                    ),
                                    TextSpan(
                                      text: "Ketik:",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "\nnama:namatukang",
                                    ),
                                  ],
                                ),
                              ),
                            )),
            ],
          ),
        ),
      ),
    );
  }
}

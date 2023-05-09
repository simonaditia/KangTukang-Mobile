import 'package:flutter/material.dart';
import 'package:tukang_online/screens/customer/CustomerPesanScreen.dart';
import 'package:tukang_online/screens/customer/food_model.dart';

class CustomerSearchScreen extends StatefulWidget {
  const CustomerSearchScreen({super.key});

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  static List<FoodModel> main_food_list = [
    FoodModel("Adit Pieter", "Renovasi", "1.1KM",
        "https://images.unsplash.com/photo-1519058082700-08a0b56da9b4"),
    FoodModel("Adi Mansur", "Renovasi", "1.7KM",
        "https://images.unsplash.com/photo-1499996860823-5214fcc65f8f"),
    FoodModel("Ali Raja", "Cat", "2.5KM",
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d"),
    FoodModel("Iman Hasan", "Cat", "3.3KM",
        "https://images.unsplash.com/photo-1501196354995-cbb51c65aaea"),
    FoodModel("Daud Surya", "Plaffon", "4.2KM",
        "https://images.unsplash.com/photo-1496345875659-11f7dd282d1d"),
    FoodModel("Nurul Arif", "Kebocoran", "3.9KM",
        "https://images.unsplash.com/photo-1669139498665-e4a201f98016"),
    FoodModel("Ibrahim Abdul", "Keramik", "2.4KM",
        "https://images.unsplash.com/photo-1518799175676-a0fed7996acb"),
    FoodModel("Udin Arif", "Dinding", "2.6KM",
        "https://images.unsplash.com/photo-1508179522353-11ba468c4a1c"),
    FoodModel("Samuel Bintang", "Renovasi", "4.1KM",
        "https://images.unsplash.com/photo-1489980557514-251d61e3eeb6"),
  ];
  List<FoodModel> display_list = [];
  TextEditingController searchController = TextEditingController();

  void updateList(String value) {
    setState(() {
      if (value.isEmpty) {
        display_list = [];
      } else {
        display_list = main_food_list
            .where((element) =>
                element.str_meal!.toLowerCase().contains(value.toLowerCase()))
            .toList();
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
                onChanged: (value) => updateList(value),
                style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                  ),
                  hintText: "Tukang Plafon",
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
                                      return CustomerPesanScreen();
                                    },
                                  ),
                                );
                              },
                              contentPadding: EdgeInsets.all(8.0),
                              title: Text(
                                display_list[index].str_meal!,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle:
                                  Text('${display_list[index].str_category!}',
                                      style: TextStyle(
                                        color: Colors.black26,
                                      )),
                              trailing: Text(
                                "${display_list[index].str_area}",
                                style: TextStyle(color: Colors.amber),
                              ),
                              leading: Image.network(
                                  display_list[index].str_meal_thumb!),
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
                        : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

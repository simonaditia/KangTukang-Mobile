import 'package:flutter/material.dart';
import 'package:tukang_online/screens/customer/food_model.dart';

class CustomerSearchScreen extends StatefulWidget {
  const CustomerSearchScreen({super.key});

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  static List<FoodModel> main_food_list = [
    FoodModel("Spicy Arrabiata Penn", "Vegetarian", "Italian",
        "https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg"),
    FoodModel("Rendang", "Beef", "Indonesia",
        "https://www.themealdb.com/images/media/meals/bc8v651619789840.jpg"),
    FoodModel("Shawarma", "Chicken", "Egyptian",
        "https://www.themealdb.com/images/media/meals/kcv6hj1598733479.jpg"),
    FoodModel("Moussaka", "Beef", "Greek",
        "https://www.themealdb.com/images/media/meals/ctg8jd1585563097.jpg"),
    FoodModel("Flamiche", "Vegetarian", "French",
        "https://www.themealdb.com/images/media/meals/wssvvs1511785879.jpg"),
    FoodModel("Kedgeree", "Seafood", "British",
        "https://www.themealdb.com/images/media/meals/utxqpt1511639216.jpg"),
    FoodModel("Packaes", "Dessert", "American",
        "https://www.themealdb.com/images/media/meals/rwuyqx1511383174.jpg"),
    FoodModel("Fish pie", "Seafood", "British",
        "https://www.themealdb.com/images/media/meals/ysxwuq1487323065.jpg"),
    FoodModel("Kapsalon", "Lamb", "Dutch",
        "https://www.themealdb.com/images/media/meals/sxysrt1468240488.jpg"),
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
              Text(
                "Cari Tukang Terdekat",
                style: TextStyle(
                  color: Color(0xffFF5403),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
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

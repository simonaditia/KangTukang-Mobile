class FoodModel {
  int ID;
  String? nama;
  String? kategori;
  dynamic email; // Update the type to match your data
  String? role;
  String? alamat;
  // double latitude;
  // double longitude;
  double distance;

  FoodModel(
      this.ID,
      this.nama,
      this.kategori,
      this.email,
      this.role,
      this.alamat,
      //  this.latitude, this.longitude,
      this.distance);
}

// class FoodModel {
//   String? str_meal;
//   String? str_category;
//   String? str_area;
//   String? str_meal_thumb;

//   FoodModel(
//       this.str_meal, this.str_category, this.str_area, this.str_meal_thumb);
// }

/*
search bisa gk tampil dulu datanya, waktu disearch baru tampil
import 'package:flutter/material.dart';

class CustomerSearchScreen extends StatefulWidget {
  @override
  _CustomerSearchScreenState createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  List<Map<String, dynamic>> data = [
    {'name': 'John Doe', 'gender': 'Male', 'address': '123 Main St'},
    {'name': 'Jane Doe', 'gender': 'Female', 'address': '456 Main St'},
    {'name': 'Bob Smith', 'gender': 'Male', 'address': '789 Main St'},
    {'name': 'Alice Johnson', 'gender': 'Female', 'address': '101 Main St'},
  ];

  List<Map<String, dynamic>> filteredData = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      if (text.isEmpty) {
        filteredData = [];
      } else {
        filteredData = data
            .where((item) =>
                item['name'].toLowerCase().contains(text.toLowerCase()) ||
                item['gender'].toLowerCase().contains(text.toLowerCase()) ||
                item['address'].toLowerCase().contains(text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Bar Demo',
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: searchController,
            onChanged: _onSearchTextChanged,
            decoration: InputDecoration(
              hintText: 'Search...',
            ),
          ),
        ),
        body: filteredData.isNotEmpty
            ? ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(filteredData[index]['name']),
                    subtitle: Text(
                        '${filteredData[index]['gender']}, ${filteredData[index]['address']}'),
                  );
                },
              )
            : searchController.text.isNotEmpty
                ? Center(
                    child: Text('No results found.'),
                  )
                : Container(),
      ),
    );
  }
}

















/// backup dari customerdashboard screen
/// import 'package:flutter/material.dart';
import 'package:tukang_online/screens/customer/food_model.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
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

  List<FoodModel> display_list = List.from(main_food_list);

  void updateList(String value) {
    setState(() {
      display_list = main_food_list
          .where((element) =>
              element.str_meal!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
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
                IconButton(
                  icon: Icon(Icons.edit_note),
                  onPressed: () {},
                  color: Colors.black,
                ),
              ],
              flexibleSpace: Container(
                color: Colors.white,
              ),
              elevation: 0,
              // automaticallyImplyLeading: false,
            ),
            body: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              // mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  child: SizedBox(
                    width: 700,
                    height: 320,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          // color: Colors.yellow,
                          child: SizedBox(
                            width: 700,
                            height: 150,
                            child: Container(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hi, Adit!",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Pilih jasa tukang yang sesuai dengan kebutuhan",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            color: Color(0xffFF5403),
                            // boxShadow: [
                            //   BoxShadow(color: Colors.yellowAccent, spreadRadius: 3),
                            // ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 20),
                                // height: constraints.maxHeight * 0.10,
                                height: 50,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Center(
                                    child: TextField(
                                      onChanged: (value) => updateList(value),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Cari Tukang Terdekat",
                                      ),
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                color: Colors.white,
                                child: Expanded(
                                  child: ListView.builder(
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
                                          subtitle: Text(
                                              '${display_list[index].str_category!}',
                                              style: TextStyle(
                                                color: Colors.black26,
                                              )),
                                          trailing: Text(
                                            "${display_list[index].str_area}",
                                            style:
                                                TextStyle(color: Colors.amber),
                                          ),
                                          leading: Image.network(
                                              display_list[index]
                                                  .str_meal_thumb!),
                                        )),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Card(
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child:
                                          Center(child: Text('Elevated Card')),
                                    ),
                                  ),
                                  Card(
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child:
                                          Center(child: Text('Elevated Card')),
                                    ),
                                  ),
                                  Card(
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child:
                                          Center(child: Text('Elevated Card')),
                                    ),
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    // color: Colors.blue,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text("Kategori")),
                        Card(
                          child: SizedBox(
                            width: 370,
                            height: 280,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Flexible(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage: AssetImage(
                                                            'assets/images/logo.png'),
                                                        radius: 50,
                                                      ),
                                                      Text("Renovasi"),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage: AssetImage(
                                                            'assets/images/logo.png'),
                                                        radius: 50,
                                                      ),
                                                      Text("Renovasi"),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage: AssetImage(
                                                            'assets/images/logo.png'),
                                                        radius: 50,
                                                      ),
                                                      Text("Renovasi"),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Flexible(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          'assets/images/logo.png'),
                                                      radius: 50,
                                                    ),
                                                    Text("Renovasi"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          'assets/images/logo.png'),
                                                      radius: 50,
                                                    ),
                                                    Text("Renovasi"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          'assets/images/logo.png'),
                                                      radius: 50,
                                                    ),
                                                    Text("Renovasi"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                    padding: EdgeInsets.only(
                        left: 10, top: 10, right: 10, bottom: 20),
                    // color: Colors.green,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text("Lainnya")),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Card(
                            //   child: SizedBox(
                            //     width: 177,
                            //     height: 47,
                            //     child: Container(
                            //       margin: EdgeInsets.only(left: 10),
                            //       child: Row(
                            //         children: [
                            //           Icon(Icons.favorite, color: Colors.green),
                            //           Text("Tentang APP"),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            ElevatedButton.icon(
                              icon: Icon(Icons.info, color: Color(0xffFF5403)),
                              label: Text("Tentang APP"),
                              onPressed: () {},
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
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                minimumSize: Size(180, 40),
                              ),
                            ),

                            // Card(
                            //   child: SizedBox(
                            //     width: 177,
                            //     height: 47,
                            //     child: Row(
                            //       children: [
                            //         Icon(Icons.favorite, color: Colors.green),
                            //         Text("Hubungi Kami"),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    )),
              ],
            )));
  }
}

































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
                IconButton(
                  icon: Icon(Icons.edit_note),
                  onPressed: () {},
                  color: Colors.black,
                ),
              ],
              flexibleSpace: Container(
                color: Colors.white,
              ),
              elevation: 0,
              // automaticallyImplyLeading: false,
            ),
            body: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              // mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  child: SizedBox(
                    width: 700,
                    height: 320,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          // color: Colors.yellow,
                          child: SizedBox(
                            width: 700,
                            height: 150,
                            child: Container(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hi, Adit!",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Pilih jasa tukang yang sesuai dengan kebutuhan",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            color: Color(0xffFF5403),
                            // boxShadow: [
                            //   BoxShadow(color: Colors.yellowAccent, spreadRadius: 3),
                            // ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            // height: constraints.maxHeight * 0.10,
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Center(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Cari Tukang Terdekat",
                                  ),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Card(
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child:
                                          Center(child: Text('Elevated Card')),
                                    ),
                                  ),
                                  Card(
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child:
                                          Center(child: Text('Elevated Card')),
                                    ),
                                  ),
                                  Card(
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child:
                                          Center(child: Text('Elevated Card')),
                                    ),
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                ),




















Container(
                  // color: Colors.yellow,
                  child: SizedBox(
                    width: 300,
                    height: 150,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, Adit!",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Pilih jasa tukang yang sesuai dengan kebutuhan",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 40),
                            // height: constraints.maxHeight * 0.10,
                            decoration: BoxDecoration(
                              color: Color(0xffB4B4B4).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Center(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Nama Lengkap",
                                  ),
                                  textInputAction: TextInputAction.next,
                                ),
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
                        bottomRight: Radius.circular(30)),
                    color: Colors.yellow,
                    // boxShadow: [
                    //   BoxShadow(color: Colors.yellowAccent, spreadRadius: 3),
                    // ],
                  ),
                ),



































                import 'package:flutter/material.dart';
import 'package:tukang_online/screens/customer/food_model.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  List<String> _dataList = [];

  TextEditingController _searchController = TextEditingController();

  Future<List<String>> _searchData(String query) async {
    // Lakukan proses pencarian data sesuai dengan query yang diberikan
    // Misalnya, lakukan pencarian di database atau di API
    // Sebagai contoh, kita akan mencari data dari sebuah list
    await Future.delayed(Duration(seconds: 2));
    List<String> searchData = [];
    for (String item in _dataList) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        searchData.add(item);
      }
    }
    return searchData;
  }

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

  List<FoodModel> display_list = List.from(main_food_list);

  void updateList(String value) {
    setState(() {
      display_list = main_food_list
          .where((element) =>
              element.str_meal!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    // Isi _dataList dengan data yang akan dicari
    _dataList = [
      'Apple',
      'Banana',
      'Cherry',
      'Durian',
      'Eggplant',
      'Figs',
      'Grape',
      'Honeydew',
      'Jackfruit',
      'Kiwi',
      'Lemon',
      'Mango',
      'Nectarine',
      'Orange',
      'Papaya',
      'Quince',
      'Raspberry',
      'Strawberry',
      'Tomato',
      'Ugli fruit',
      'Vanilla bean',
      'Watermelon',
      'Xigua',
      'Yellow watermelon',
      'Zucchini'
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
            ),
            onChanged: (query) {
              setState(() {});
            },
          ),
        ),
        body: FutureBuilder<List<String>>(
          future: _searchData(_searchController.text),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (_searchController.text.isEmpty) {
              // tambahkan kondisi ketika search bar kosong
              return Container();
            } else if (snapshot.data?.isEmpty ?? true) {
              return Center(child: Text('No data found.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index]),
                  );
                },
              );
            }
          },
        ));
  }
}
*/

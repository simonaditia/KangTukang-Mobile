import 'package:flutter/material.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
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
                    padding: EdgeInsets.all(10),
                    color: Colors.green,
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
                              icon: Icon(Icons.ac_unit),
                              label: Text("Tentang APP"),
                              onPressed: () {},
                            ),

                            Card(
                              child: SizedBox(
                                width: 177,
                                height: 47,
                                child: Row(
                                  children: [
                                    Icon(Icons.favorite, color: Colors.green),
                                    Text("Hubungi Kami"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ],
            )));
  }
}

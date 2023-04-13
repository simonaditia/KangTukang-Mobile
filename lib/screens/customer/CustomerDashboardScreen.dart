import 'package:flutter/material.dart';
import 'package:tukang_online/screens/customer/CustomerPesananScreen.dart';
import 'package:tukang_online/screens/customer/CustomerSearchScreen.dart';

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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CustomerPesananScreen();
                        },
                      ),
                    );
                  },
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
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton.icon(
                              icon:
                                  Icon(Icons.search, color: Color(0xffFF5403)),
                              label: Text("Cari Tukang Terdekat"),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CustomerSearchScreen();
                                    },
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                minimumSize: Size(320, 55),
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

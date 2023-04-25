import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tukang_online/screens/tukang/TukangProfileScreen.dart';

class TukangDashboardScreen extends StatefulWidget {
  const TukangDashboardScreen({super.key});

  @override
  State<TukangDashboardScreen> createState() => _TukangDashboardScreenState();
}

class _TukangDashboardScreenState extends State<TukangDashboardScreen> {
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
                icon: Icon(Icons.manage_accounts),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return TukangProfileScreen();
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
            children: [
              Container(
                child: SizedBox(
                  width: 700,
                  height: 150,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Halo, Udin!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            "Semoga harimu menyenangkan dan sukses dalam menerima pesanan dari pelanggan.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
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
                    bottomRight: Radius.circular(30),
                  ),
                  color: Color(0xffFF5403),
                ),
              ),
              Container(
                  // margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text("Daftar Pesanan")),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Card(
                          child: SizedBox(
                            width: 370,
                            height: 190,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Spacer(flex: 1),
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.house_siding,
                                            color: Color(0xffFF5403),
                                            size: 30.0,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                      ),
                                      // Spacer(flex: 1),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Adit Joko",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                              "Renovasi Rumah",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(flex: 1),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Lama Pengerjaan: 2 hari",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Center(
                                    child: Text("Total Biaya: Rp.300.000"),
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton.icon(
                                            icon: Icon(Icons.close,
                                                color: Color(0xffFF5403)),
                                            label: Text("Tolak"),
                                            onPressed: () {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) {
                                              //       return CustomerTentangAppScreen();
                                              //     },
                                              //   ),
                                              // );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              minimumSize: Size(130, 40),
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            icon: Icon(Icons.done,
                                                color: Color(0xffFF5403)),
                                            label: Text("Terima"),
                                            onPressed: () {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) {
                                              //       return CustomerTentangAppScreen();
                                              //     },
                                              //   ),
                                              // );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black,
                                              minimumSize: Size(130, 40),
                                            ),
                                          ),
                                        ]))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tukang_online/screens/customer/CustomerDashboardScreen.dart';

class CustomerPesananScreen extends StatefulWidget {
  const CustomerPesananScreen({super.key});

  @override
  State<CustomerPesananScreen> createState() => _CustomerPesananScreenState();
}

class _CustomerPesananScreenState extends State<CustomerPesananScreen> {
  @override
  Widget build(BuildContext context) {
    TabBar myTabBar = TabBar(
      indicatorColor: Color(0xffFF5403),
      labelColor: Color(0xffFF5403),
      tabs: <Widget>[
        Tab(
          text: "Menunggu",
        ),
        Tab(text: "Dikerjakan"),
        Tab(text: "Selesai")
      ],
    );
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
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
                  icon: Icon(Icons.arrow_back, color: Colors.black)),
              flexibleSpace: Container(color: Colors.white),
              title: Text("Pesanan", style: TextStyle(color: Colors.black)),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(myTabBar.preferredSize.height),
                child: Container(color: Colors.white, child: myTabBar),
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Card(
                        child: SizedBox(
                          width: 320,
                          height: 294,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Spacer(flex: 1),
                                      Container(
                                          margin: EdgeInsets.only(right: 15),
                                          child: Icon(Icons.home,
                                              color: Color(0xffF24E1E))),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Status Pemesanan - Bekasi Selatan",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              "Tukang Bangunan",
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(flex: 1)
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 20),
                                  // padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 14),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Nomor Invoice",
                                                style: TextStyle(fontSize: 14)),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text("Total Biaya",
                                                style: TextStyle(fontSize: 14)),
                                            SizedBox(
                                              height: 14,
                                            ),
                                            Text("Layanan Survey",
                                                style: TextStyle(fontSize: 14))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 40),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text("#20230316",
                                                style: TextStyle(fontSize: 14)),
                                            Text("Rp.100.000",
                                                style: TextStyle(fontSize: 14)),
                                            ElevatedButton(
                                                child: Text(
                                                    "Menunggu Konfirmasi",
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xff24309C),
                                                    foregroundColor:
                                                        Colors.white,
                                                    minimumSize: Size(50, 26)))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 20, left: 8),
                                    child: Text(
                                      "Waktu Perjanjian",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    )),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.date_range),
                                              onPressed: () {},
                                              color: Color(0xffF24E1E),
                                            ),
                                            Text("2023-03-16"),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 17),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.access_time),
                                              onPressed: () {},
                                              color: Color(0xffF24E1E),
                                            ),
                                            Text("08:00"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          child: Text("Ubah Waktu",
                                              style: TextStyle(fontSize: 12)),
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xffFF5403),
                                              foregroundColor: Colors.white,
                                              minimumSize: Size(50, 26))),
                                      ElevatedButton(
                                          child: Text("Batalkan",
                                              style: TextStyle(fontSize: 12)),
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xffDD1D1D),
                                              foregroundColor: Colors.white,
                                              minimumSize: Size(50, 26)))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Card(
                        child: SizedBox(
                          width: 320,
                          height: 249,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Spacer(flex: 1),
                                      Container(
                                          margin: EdgeInsets.only(right: 15),
                                          child: Icon(Icons.home,
                                              color: Color(0xffF24E1E))),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Status Pemesanan - Bekasi Selatan",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              "Tukang Bangunan",
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(flex: 1)
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 20),
                                  // padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 14),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Nomor Invoice",
                                                style: TextStyle(fontSize: 14)),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text("Total Biaya",
                                                style: TextStyle(fontSize: 14)),
                                            SizedBox(
                                              height: 14,
                                            ),
                                            Text("Layanan Survey",
                                                style: TextStyle(fontSize: 14))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 40),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text("#20230316",
                                                style: TextStyle(fontSize: 14)),
                                            Text("Rp.100.000",
                                                style: TextStyle(fontSize: 14)),
                                            ElevatedButton(
                                                child: Text(
                                                    "Sedang Berlangsung",
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xff249C9C),
                                                    foregroundColor:
                                                        Colors.white,
                                                    minimumSize: Size(50, 26)))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 20, left: 8),
                                    child: Text(
                                      "Waktu Perjanjian",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    )),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.date_range),
                                              onPressed: () {},
                                              color: Color(0xffF24E1E),
                                            ),
                                            Text("2023-03-16"),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 17),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.access_time),
                                              onPressed: () {},
                                              color: Color(0xffF24E1E),
                                            ),
                                            Text("08:00"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Card(
                        child: SizedBox(
                          width: 320,
                          height: 249,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Spacer(flex: 1),
                                      Container(
                                          margin: EdgeInsets.only(right: 15),
                                          child: Icon(Icons.home,
                                              color: Color(0xffF24E1E))),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Status Pemesanan - Bekasi Selatan",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              "Tukang Bangunan",
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(flex: 1)
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 13, right: 13),
                                  // padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 14),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Nomor Invoice",
                                                style: TextStyle(fontSize: 14)),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text("Total Biaya",
                                                style: TextStyle(fontSize: 14)),
                                            SizedBox(
                                              height: 14,
                                            ),
                                            Text("Layanan Survey",
                                                style: TextStyle(fontSize: 14))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 40),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text("#20230316",
                                                style: TextStyle(fontSize: 14)),
                                            Text("Rp.100.000",
                                                style: TextStyle(fontSize: 14)),
                                            ElevatedButton(
                                                child: Text("Selesai",
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xff1A7E2A),
                                                    foregroundColor:
                                                        Colors.white,
                                                    minimumSize: Size(50, 26)))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 20, left: 8),
                                    child: Text(
                                      "Waktu Perjanjian",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    )),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.date_range),
                                              onPressed: () {},
                                              color: Color(0xffF24E1E),
                                            ),
                                            Text("2023-03-16"),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 17),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.access_time),
                                              onPressed: () {},
                                              color: Color(0xffF24E1E),
                                            ),
                                            Text("08:00"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

// Container myTab1 = 

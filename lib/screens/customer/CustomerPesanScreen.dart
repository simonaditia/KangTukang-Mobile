import 'package:flutter/material.dart';
import 'package:tukang_online/screens/customer/CustomerMapScreen.dart';
import 'package:tukang_online/screens/customer/CustomerSearchScreen.dart';
import 'package:intl/intl.dart';

class CustomerPesanScreen extends StatefulWidget {
  const CustomerPesanScreen({super.key});

  @override
  State<CustomerPesanScreen> createState() => _CustomerPesanScreenState();
}

class _CustomerPesanScreenState extends State<CustomerPesanScreen> {
  DateTime selectDate = DateTime.now();
  // String selectDate2 = DateFormat.yMMMMEEEEd().format(DateTime.now());
  // DateTime selectDate3 = DateTime(2)
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
                            return CustomerSearchScreen();
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black)),
                flexibleSpace: Container(color: Colors.white),
                elevation: 0,
                title: Text("Panggil Tukang",
                    style: TextStyle(color: Colors.black)),
                centerTitle: true),
            body: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Spacer(
                          flex: 1,
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/logo.png'),
                              radius: 50,
                            )
                          ],
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nama Tukang: James Pieter",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Kategori Tukang: Tukang Plafon",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Biaya Tukang: Rp.100.000",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        Spacer(
                          flex: 1,
                        )
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Perbaikan apa yang dibutuhkan?",
                            style: TextStyle(fontSize: 16),
                          ))),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 5.5),
                        ),
                        hintText: "Detail perbaikan",
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Jadwalkan",
                            style: TextStyle(fontSize: 16),
                          ))),
                  // Container(
                  //   child: Text(DateFormat.yMMMMEEEEd().format(DateTime.now())),
                  // ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.infinity,
                    // alignment: Alignment.c,
                    child: ElevatedButton(
                      child: Text(
                          // selectDate.toString(),
                          DateFormat.yMMMMEEEEd().format(selectDate),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: selectDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2025),
                          initialEntryMode: DatePickerEntryMode.calendar,
                        ).then((value) {
                          if (value != null)
                            setState(() {
                              selectDate = value;
                            });
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 218, 218, 218),
                        foregroundColor: Color.fromARGB(255, 54, 54, 54),
                        // minimumSize: Size(50, 26),
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Alamat",
                            style: TextStyle(fontSize: 16),
                          ))),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextField(
                      style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 5.5),
                        ),
                        hintText: "Jl.Mangga Raya...",
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 25, left: 20, right: 20),
                    // width: double.infinity,
                    // alignment: Alignment.c,
                    child: ElevatedButton(
                      child: Text("Pesan Tukang",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CustomerMapScreen();
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffFF5403),
                        foregroundColor: Colors.white,
                        minimumSize: Size(430, 45),
                        // minimumSize: Size(50, 26),
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}

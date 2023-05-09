import 'package:flutter/material.dart';
import 'package:tukang_online/screens/customer/CustomerDashboardScreen.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
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
            body: ListView(children: [
              Container(
                  child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50, bottom: 40),
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/customer_small1.jpg'),
                      radius: 70,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 5),
                    child: TextFormField(
                      initialValue: "Amanda Chelsea",
                      style: TextStyle(
                        color: Color.fromARGB(190, 0, 0, 0),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 5.5),
                        ),
                        hintText: "Nama",
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: TextFormField(
                      initialValue: "amanda.chelsea@gmail.com",
                      style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 5.5),
                        ),
                        hintText: "Email",
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: TextFormField(
                      initialValue: "081395849305",
                      style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 5.5),
                        ),
                        hintText: "No.Telp",
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 10),
                    child: TextFormField(
                      initialValue: "Jalan Naga Raya",
                      style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 5.5),
                        ),
                        hintText: "Alamat",
                      ),
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
                      onPressed: () {},
                      child: const Text('Simpan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ),
                ],
              )),
            ])));
  }
}

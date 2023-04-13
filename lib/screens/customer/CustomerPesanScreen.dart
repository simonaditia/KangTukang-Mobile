import 'package:flutter/material.dart';
import 'package:tukang_online/screens/customer/CustomerSearchScreen.dart';

class CustomerPesanScreen extends StatefulWidget {
  const CustomerPesanScreen({super.key});

  @override
  State<CustomerPesanScreen> createState() => _CustomerPesanScreenState();
}

class _CustomerPesanScreenState extends State<CustomerPesanScreen> {
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
                title: Text("Panggil Tukang",
                    style: TextStyle(color: Colors.black)),
                centerTitle: true),
            body: Center(child: Text("Panggil tukang sekarang"))));
  }
}

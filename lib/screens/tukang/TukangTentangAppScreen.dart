import 'package:flutter/material.dart';

import 'package:tukang_online/screens/tukang/TukangDashboardScreen.dart';

class TukangTentangAppScreen extends StatelessWidget {
  const TukangTentangAppScreen({super.key});

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
                          return TukangDashboardScreen();
                        },
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.black)),
              flexibleSpace: Container(color: Colors.white),
              elevation: 0,
              title: Text("Tentang Aplikasi",
                  style: TextStyle(color: Colors.black)),
              centerTitle: true),
          body: Container(
            margin: EdgeInsets.only(bottom: 40),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/images/logo.png'),
                          radius: 50,
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      "Developer/Pengembang",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Simon Aditia",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "simonaditia22@gmail.com",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Aplikasi ini dibuat untuk membantu Customer",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Mencari Tukang terdekat disekitar lokasinya",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Selain itu Aplikasi ini dibuat sebagai",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Tugas Akhir/Skripsi",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

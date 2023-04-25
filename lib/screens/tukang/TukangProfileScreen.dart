import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tukang_online/screens/tukang/TukangDashboardScreen.dart';

class TukangProfileScreen extends StatefulWidget {
  const TukangProfileScreen({super.key});

  @override
  State<TukangProfileScreen> createState() => _TukangProfileScreenState();
}

class _TukangProfileScreenState extends State<TukangProfileScreen> {
  bool? check3 = false;
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
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                ),
                flexibleSpace: Container(color: Colors.white),
                elevation: 0,
                title: Text("Profile", style: TextStyle(color: Colors.black)),
                centerTitle: true),
            body: Container(
                child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 50, bottom: 20),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/logo.png'),
                    radius: 50,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
                  child: TextField(
                    style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(color: Colors.white, width: 5.5),
                      ),
                      hintText: "Nama",
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: TextField(
                    style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(color: Colors.white, width: 5.5),
                      ),
                      hintText: "Email",
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: TextField(
                    style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(color: Colors.white, width: 5.5),
                      ),
                      hintText: "No.Telp",
                    ),
                  ),
                ),
                // Container(
                //     child: Row(
                //   children: [
                //     Column(
                //       children: [
                //         CheckboxListTile(
                //           //checkbox positioned at left
                //           value: check3,
                //           controlAffinity: ListTileControlAffinity.leading,
                //           onChanged: (bool? value) {
                //             setState(() {
                //               check3 = value;
                //             });
                //           },
                //           title: Text("Do you"),
                //         ),
                //         CheckboxListTile(
                //           //checkbox positioned at left
                //           value: check3,
                //           controlAffinity: ListTileControlAffinity.leading,
                //           onChanged: (bool? value) {
                //             setState(() {
                //               check3 = value;
                //             });
                //           },
                //           title: Text("Do you really want to learn Flutter?"),
                //         ),
                //         CheckboxListTile(
                //           //checkbox positioned at left
                //           value: check3,
                //           controlAffinity: ListTileControlAffinity.leading,
                //           onChanged: (bool? value) {
                //             setState(() {
                //               check3 = value;
                //             });
                //           },
                //           title: Text("Do you really want to learn Flutter?"),
                //         ),
                //       ],
                //     ),
                //     Column(
                //       children: [
                //         CheckboxListTile(
                //           //checkbox positioned at left
                //           value: check3,
                //           controlAffinity: ListTileControlAffinity.leading,
                //           onChanged: (bool? value) {
                //             setState(() {
                //               check3 = value;
                //             });
                //           },
                //           title: Text("Do you"),
                //         ),
                //         CheckboxListTile(
                //           //checkbox positioned at left
                //           value: check3,
                //           controlAffinity: ListTileControlAffinity.leading,
                //           onChanged: (bool? value) {
                //             setState(() {
                //               check3 = value;
                //             });
                //           },
                //           title: Text("Do you really want to learn Flutter?"),
                //         ),
                //         CheckboxListTile(
                //           //checkbox positioned at left
                //           value: check3,
                //           controlAffinity: ListTileControlAffinity.leading,
                //           onChanged: (bool? value) {
                //             setState(() {
                //               check3 = value;
                //             });
                //           },
                //           title: Text("Do you really want to learn Flutter?"),
                //         ),
                //       ],
                //     )
                //   ],
                // )),

                Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: TextField(
                    style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(color: Colors.white, width: 5.5),
                      ),
                      hintText: "Biaya Perhari, Rp.100.000",
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
                  child: TextField(
                    style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(color: Colors.white, width: 5.5),
                      ),
                      hintText: "Alamat",
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
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
                )
              ],
            ))));
  }
}

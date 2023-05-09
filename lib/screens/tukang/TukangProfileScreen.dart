import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tukang_online/screens/tukang/TukangDashboardScreen.dart';
import 'package:tukang_online/screens/tukang/TukangTentangAppScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class TukangProfileScreen extends StatefulWidget {
  const TukangProfileScreen({super.key});

  @override
  State<TukangProfileScreen> createState() => _TukangProfileScreenState();
}

class _TukangProfileScreenState extends State<TukangProfileScreen> {
  bool? _checked1 = false;
  bool? _checked2 = false;
  bool? _checked3 = false;
  bool? _checked4 = false;
  bool? _checked5 = false;
  bool? _checked6 = false;

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
            body: ListView(children: [
              Container(
                  child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50, bottom: 20),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/tukang1.jpg'),
                      radius: 70,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 5),
                    child: TextFormField(
                      initialValue: "Adi Mansur",
                      style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
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
                      initialValue: "adi.mansur@gmail.com",
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
                      initialValue: "081359305839",
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
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: TextFormField(
                      initialValue: "Renovasi",
                      style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 5.5),
                        ),
                        hintText: "Kategori",
                      ),
                    ),
                  ),
                  /*
                  Container(
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Kategori Pekerjaan",
                            style: TextStyle(fontSize: 16),
                          ))),
                  Container(
                      padding: EdgeInsets.only(left: 18, right: 18),
                      child: Card(
                        child: SizedBox(
                          width: 600,
                          height: 340,
                          child: Column(children: [
                            CheckboxListTile(
                              // secondary: Icon(Icons.beach_access),
                              title: Text("Renovasi"),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _checked1,
                              onChanged: (bool? value) {
                                setState(() {
                                  _checked1 = value;
                                });
                              },
                              activeColor: Color(0xffFF5403),
                              checkColor: Colors.white,
                            ),
                            CheckboxListTile(
                              // secondary: Icon(Icons.beach_access),
                              title: Text("Cat"),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _checked2,
                              onChanged: (bool? value) {
                                setState(() {
                                  _checked2 = value;
                                });
                              },
                              activeColor: Color(0xffFF5403),
                              checkColor: Colors.white,
                            ),
                            CheckboxListTile(
                              // secondary: Icon(Icons.beach_access),
                              title: Text("Plafon"),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _checked3,
                              onChanged: (bool? value) {
                                setState(() {
                                  _checked3 = value;
                                });
                              },
                              activeColor: Color(0xffFF5403),
                              checkColor: Colors.white,
                            ),
                            CheckboxListTile(
                              // secondary: Icon(Icons.beach_access),
                              title: Text("Kebocoran"),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _checked4,
                              onChanged: (bool? value) {
                                setState(() {
                                  _checked4 = value;
                                });
                              },
                              activeColor: Color(0xffFF5403),
                              checkColor: Colors.white,
                            ),
                            CheckboxListTile(
                              // secondary: Icon(Icons.beach_access),
                              title: Text("Keramik"),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _checked5,
                              onChanged: (bool? value) {
                                setState(() {
                                  _checked5 = value;
                                });
                              },
                              activeColor: Color(0xffFF5403),
                              checkColor: Colors.white,
                            ),
                            CheckboxListTile(
                              // secondary: Icon(Icons.beach_access),
                              title: Text("Dinding"),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _checked6,
                              onChanged: (bool? value) {
                                setState(() {
                                  _checked6 = value;
                                });
                              },
                              activeColor: Color(0xffFF5403),
                              checkColor: Colors.white,
                            ),
                          ]),
                        ),
                      )),
                  */
                  Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 5),
                    child: TextFormField(
                      initialValue: "100000",
                      style: TextStyle(color: Color.fromARGB(190, 0, 0, 0)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              BorderSide(color: Colors.white, width: 5.5),
                        ),
                        hintText: "Biaya Perhari, Rp.100.000",
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 10),
                    child: TextFormField(
                      initialValue: "Jalan Mangga Raya",
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

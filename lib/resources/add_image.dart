import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/cloudsearch/v1.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreGambar {
  String? _imageUrl;
  String? get imageUrl => _imageUrl;
  bool? _statusLoading;
  bool? get statusLoading => _statusLoading;
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    _statusLoading = true;
    Reference ref =
        _storage.ref().child(childName).child(DateTime.now().toString());
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    _imageUrl = downloadUrl;
    print("Didalm uploadimagetostorage");
    print(_imageUrl);
    return downloadUrl;
  }

  Future<String> saveData({required Uint8List file}) async {
    String resp = " Some Error Occurred";
    try {
      if (file.isNotEmpty) {
        String imageUrl = await uploadImageToStorage('profileImage', file);
        await _firestore.collection('userProfile').add({
          'imageLink': imageUrl,
        });
        resp = 'success';
        print(resp);
        print("Didalam Save Data");
        print(imageUrl);
      }
    } catch (err) {
      resp = err.toString();
      print("Didalam Save Data catch");
      print(resp);
    }
    print("Didalam Save Data return terakhir");
    return resp;
  }
}

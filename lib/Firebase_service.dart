import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'dart:async';
import 'dart:io';

class FirebaseApi {


  static Future uploaddaily({
      String title, body, file}) async {

    final refMessages =
    FirebaseFirestore.instance.collection('daily').doc();

    Reference storageReferenceImage = FirebaseStorage.instance
        .ref()
        .child('image/${Path.basename(file.path)}');

    UploadTask uploadtask =  storageReferenceImage.putFile(File(file.path));
    uploadtask.then((res){
     storageReferenceImage.getDownloadURL().then((imageurl) async {
       final newMessage = {
         'title': title ?? '',
         'body': body ?? '',
         'image': imageurl ?? '',
         'createdAt': FieldValue.serverTimestamp(),
       };
       refMessages.set(newMessage);
     });
   });
  }


  static Future uploadprayer({
    String title, body, file}) async {

    final refMessages =
    FirebaseFirestore.instance.collection('prayer').doc();
        final newMessage = {
          'title': title ?? '',
          'body': body ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        };
        refMessages.set(newMessage);
  }



  static Stream<QuerySnapshot> getDaily() {
    var data = FirebaseFirestore.instance
        .collection('daily').orderBy('createdAt', descending: true);
    return data.snapshots();
  }


  static Stream<QuerySnapshot> getPrayer() {
    var data = FirebaseFirestore.instance
        .collection('prayer');
    return data.snapshots();
  }
}

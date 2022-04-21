import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailydevo9/utils.dart';


class DailyDevo {
  String title;
  String id;
  final String image;
  final String body;
  final lastMessageTime;

  DailyDevo({
   this.title,
    this.id,
    this.body,
    this.image,
    this.lastMessageTime,
  });

  DailyDevo.fromMap(Map snapshot, String id)
      : id = id ?? '',
        title = snapshot['title'] ?? '',
        image = snapshot['image'] ?? '',
        lastMessageTime = snapshot['createdAt'] ?? '',
        body = snapshot['body'] ?? '';

  toJson() {
    return {
      "body": body,
      'createdAt': lastMessageTime,
      "image": image,
      'title':title,
      'id': id,
    };
  }
}

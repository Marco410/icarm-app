import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String comment;
  int? likes;

  CommentModel({
    required this.comment,
    this.likes,
  });
}

class CommentF {
  String comment;
  List<String>? likes;
  String nameSender;
  String photo;
  Timestamp? timestamp;
  String type;
  String userId;

  CommentF({
    required this.comment,
    required this.likes,
    required this.nameSender,
    required this.photo,
    this.timestamp,
    required this.type,
    required this.userId,
  });

  factory CommentF.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CommentF(
      comment: data?['comment'],
      likes: data?['likes'] is Iterable ? List.from(data?['likes']) : null,
      nameSender: data?['nameSender'],
      photo: data?['photo'],
      timestamp: data?['timestamp'],
      type: data?['type'],
      userId: data?['userId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "comment": comment,
      "likes": likes,
      "nameSender": nameSender,
      "photo": photo,
      "timestamp": timestamp,
      "type": type,
      "userId": userId,
    };
  }
}

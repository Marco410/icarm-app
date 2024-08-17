import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String comment;
  String type;
  int? likes;

  CommentModel({
    required this.comment,
    required this.type,
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
  List<Reply> replies;

  CommentF({
    required this.comment,
    required this.likes,
    required this.nameSender,
    required this.photo,
    this.timestamp,
    required this.type,
    required this.userId,
    required this.replies,
  });

  factory CommentF.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    List<Reply> repliesList = data?['replies'] is Iterable
        ? (data?['replies'] as List)
            .where((reply) => reply['active'] == true)
            .map((reply) => Reply(
                  id: reply['id'],
                  reply: reply['reply'],
                  userId: reply['userId'],
                  nameSender: reply['nameSender'],
                  photo: reply['photo'],
                  timestamp: reply['timestamp'],
                  active: reply['active'],
                ))
            .toList()
        : [];
    return CommentF(
      comment: data?['comment'],
      likes: data?['likes'] is Iterable ? List.from(data?['likes']) : null,
      replies: repliesList.reversed.toList(),
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

class Reply {
  String id;
  String reply;
  String userId;
  String nameSender;
  Timestamp? timestamp;
  String photo;
  bool active;

  Reply({
    required this.id,
    required this.reply,
    required this.userId,
    required this.nameSender,
    required this.photo,
    required this.active,
    this.timestamp,
  });

  factory Reply.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Reply(
      id: data?['id'],
      reply: data?['reply'],
      userId: data?['userId'],
      nameSender: data?['nameSender'],
      photo: data?['photo'],
      timestamp: data?['timestamp'],
      active: data?['active'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "reply": reply,
      "userId": userId,
      "nameSender": nameSender,
      "timestamp": timestamp,
      "photo": photo,
      "active": active,
    };
  }
}

const TypeComment = {
  "text": "Texto",
  "image": "Imagen",
  "bible": "Versículo",
  "alert": "Anuncio"
};

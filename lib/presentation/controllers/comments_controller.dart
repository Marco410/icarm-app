import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/CommentModel.dart';
import '../providers/auth_service.dart';
import 'package:uuid/uuid.dart';

class Comment {
  static Future<bool> addComment(CommentModel commentModel) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.settings = const Settings(persistenceEnabled: true);

      CollectionReference comments = db.collection('comments');

      await comments.add({
        'userId': (prefs.usuarioID != "") ? prefs.usuarioID : "0",
        'likes': [],
        'replies': [],
        'type': commentModel.type,
        'comment': commentModel.comment,
        'timestamp': FieldValue.serverTimestamp(),
        'isTesting': true,
        'active': true,
        'nameSender': (prefs.usuarioID != "")
            ? '${prefs.nombre} ${prefs.aPaterno}'
            : 'Invitado',
        'photo': (prefs.usuarioID != "")
            ? (prefs.foto_perfil != "" && prefs.foto_perfil != "null")
                ? prefs.foto_perfil
                : "blank"
            : 'blank'
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteComment(String commentID) async {
    try {
      CollectionReference comments =
          FirebaseFirestore.instance.collection('comments');

      DocumentReference commentRef = comments.doc(commentID);

      await commentRef.update({
        'active': false,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateComment(CommentF comment, String commentID) async {
    CollectionReference comments =
        FirebaseFirestore.instance.collection('comments');

    DocumentReference commentRef = comments.doc(commentID);

    List<String> likes = comment.likes!;

    if (comment.likes!.contains(prefs.usuarioID)) {
      likes.remove(prefs.usuarioID);
    } else {
      likes.add(prefs.usuarioID);
    }

    await commentRef.update({
      'likes': likes,
    });
    return true;
  }

  static Future<bool> addReply(
      CommentF comment, String commentID, String reply) async {
    try {
      CollectionReference comments =
          FirebaseFirestore.instance.collection('comments');
      DocumentReference commentRef = comments.doc(commentID);

      var id = Uuid().v4();

      DocumentSnapshot doc = await commentRef.get();
      if (!doc.exists) {
        return false;
      }

      Map<String, dynamic> newReply = {
        'id': id,
        'reply': reply,
        'userId': (prefs.usuarioID != "") ? prefs.usuarioID : "0",
        'timestamp': Timestamp.now(),
        'active': true,
        'nameSender': (prefs.usuarioID != "")
            ? '${prefs.nombre} ${prefs.aPaterno}'
            : 'Invitado',
        'photo': (prefs.usuarioID != "")
            ? (prefs.foto_perfil != "" && prefs.foto_perfil != "null")
                ? prefs.foto_perfil
                : "blank"
            : 'blank'
      };

      await commentRef.update({
        "replies": FieldValue.arrayUnion([newReply])
      });
      return true;
    } on FirebaseException catch (e) {
      print('Firebase Error: $e');
      return false;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      return false;
    }
  }

  static Stream<QuerySnapshot>? getComments() {
    try {
      return FirebaseFirestore.instance
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .where('isTesting', isEqualTo: true)
          .where('active', isEqualTo: true)
          .limit(10)
          .withConverter(
            fromFirestore: CommentF.fromFirestore,
            toFirestore: (CommentF co, options) => co.toFirestore(),
          )
          .snapshots();
    } catch (e) {
      print("e");
      print(e);
      return null;
    }
  }

  static Stream<CommentF> getComment(String commentID) {
    try {
      return FirebaseFirestore.instance
          .collection('comments')
          .doc(commentID)
          .withConverter<CommentF>(
            fromFirestore: (snapshot, _) =>
                CommentF.fromFirestore(snapshot, null),
            toFirestore: (comment, _) => comment.toFirestore(),
          )
          .snapshots()
          .map((snapshot) => snapshot.data()!); // Obtén el objeto CommentF
    } catch (e) {
      print("Error al obtener el comentario: $e");
      rethrow;
    }
  }

  static Future<bool> deleteReply(
      CommentF comment, String commentID, String replyId) async {
    try {
      CollectionReference comments =
          FirebaseFirestore.instance.collection('comments');
      DocumentReference commentRef = comments.doc(commentID);

      DocumentSnapshot doc = await commentRef.get();
      if (!doc.exists) {
        print("El documento no existe");
        return false;
      }
      List<Map<String, dynamic>> updatedReplies =
          comment.replies.map<Map<String, dynamic>>((reply) {
        if (reply.id == replyId) {
          return {
            'id': reply.id,
            'reply': reply.reply,
            'nameSender': reply.nameSender,
            'timestamp': reply.timestamp,
            'photo': reply.photo,
            'active': false,
            'userId': reply.userId,
          };
        }
        return {
          'id': reply.id,
          'reply': reply.reply,
          'nameSender': reply.nameSender,
          'timestamp': reply.timestamp,
          'photo': reply.photo,
          'active': reply.active,
          'userId': reply.userId,
        };
      }).toList();
      // Actualiza el documento del comentario con las respuestas filtradas
      await commentRef.update({
        "replies": updatedReplies,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/CommentModel.dart';
import '../providers/auth_service.dart';

class Comment {
  static Future<bool> addComment(CommentModel commentModel) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.settings = const Settings(persistenceEnabled: true);

      CollectionReference comments = db.collection('comments');

      await comments.add({
        'userId': (prefs.usuarioID != "") ? prefs.usuarioID : "0",
        'likes': [],
        'type': 'text',
        'comment': commentModel.comment,
        'timestamp': FieldValue.serverTimestamp(),
        'nameSender': (prefs.usuarioID != "")
            ? '${prefs.nombre} ${prefs.aPaterno}'
            : 'Invitado',
        'photo': (prefs.usuarioID != "")
            ? (prefs.foto_perfil != "")
                ? prefs.foto_perfil
                : "blank"
            : 'blank'
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

  static Stream<QuerySnapshot>? getComments() {
    try {
      return FirebaseFirestore.instance
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .withConverter(
            fromFirestore: CommentF.fromFirestore,
            toFirestore: (CommentF co, options) => co.toFirestore(),
          )
          .snapshots();
    } catch (e) {
      return null;
    }
  }
}

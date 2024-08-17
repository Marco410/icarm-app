import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/models/CommentModel.dart';
import 'package:icarm/presentation/screens/radio/widgets/comment_reder.dart';

import '../../../../../config/services/notification_ui_service.dart';
import '../../../../controllers/comments_controller.dart';

Widget BibleWidget(
    bool isSender, CommentF comment, String commentID, BuildContext context) {
  return Stack(
    children: [
      Container(
          alignment: Alignment.center,
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: BoxDecoration(
              color: ColorStyle.orange,
              boxShadow: ShadowStyle.boxShadow,
              borderRadius: BorderRadius.circular(15)),
          child: renderComment(comment.comment)),
      Positioned(
          top: 0,
          left: 10,
          child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: ShadowStyle.boxShadow,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(4))),
              child: Icon(
                Icons.book_rounded,
                color: ColorStyle.secondaryColor,
                size: 15,
              ))),
      (isSender)
          ? Positioned(
              bottom: 0,
              right: 10,
              child: Bounceable(
                onTap: () {
                  NotificationUI.instance.notificationToAcceptAction(
                      context, "¿Estás seguro de eliminar este versículo?",
                      () async {
                    context.pop();
                    final res = await Comment.deleteComment(commentID);
                    if (res) {
                      NotificationUI.instance
                          .notificationSuccess("Comentario eliminado.");
                    } else {
                      NotificationUI.instance.notificationError(
                          "No se pudo eliminar tu comentario.");
                    }
                  });
                },
                child: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                        boxShadow: ShadowStyle.boxShadow,
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Icon(
                      Icons.delete_rounded,
                      size: 15,
                      color: Colors.redAccent,
                    )),
              ),
            )
          : SizedBox()
    ],
  );
}

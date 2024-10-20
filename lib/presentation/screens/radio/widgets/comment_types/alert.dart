import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/models/CommentModel.dart';
import 'package:icarm/presentation/screens/radio/widgets/comment_reder.dart';
import 'package:sizer_pro/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../config/services/notification_ui_service.dart';
import '../../../../controllers/comments_controller.dart';

Widget AlertWidget(
    bool isSender, CommentF comment, String commentID, BuildContext context) {
  return Container(
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        bottom: 0, top: 27, left: 20, right: 20),
                    padding: EdgeInsets.only(
                        top: 10, bottom: 5, left: 15, right: 15),
                    decoration: BoxDecoration(
                        color: ColorStyle.alert,
                        boxShadow: ShadowStyle.boxShadow,
                        borderRadius: BorderRadius.circular(8)),
                    child: renderComment(comment.comment, Colors.white, 5.6.f)),
                Positioned(
                    top: 5,
                    child: Container(
                        padding: EdgeInsets.all(5),
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            color: ColorStyle.alert,
                            borderRadius: BorderRadius.circular(30)),
                        child: Icon(
                          Icons.article_rounded,
                          color: ColorStyle.whiteBacground,
                          size: 21,
                        ))),
              ],
            ),
            (comment.timestamp != null)
                ? Text(
                    timeago.format(comment.timestamp!.toDate(), locale: 'es'),
                    style: TxtStyle.hintText,
                  )
                : SizedBox(),
          ],
        ),
        (isSender)
            ? Positioned(
                bottom: 0,
                right: 10,
                child: Bounceable(
                  onTap: () {
                    NotificationUI.instance.notificationToAcceptAction(
                        context, "¿Estás seguro de eliminar este anuncio?",
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
                    }, false);
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
    ),
  );
}

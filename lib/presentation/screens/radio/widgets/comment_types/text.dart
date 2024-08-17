import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/models/CommentModel.dart';
import 'package:icarm/presentation/screens/radio/comments.dart';
import 'package:icarm/presentation/screens/radio/widgets/comment_bubble.dart';
import 'package:icarm/presentation/screens/radio/widgets/comment_dialog.dart';
import 'package:icarm/presentation/screens/radio/widgets/comment_reder.dart';
import 'package:sizer_pro/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../config/services/notification_ui_service.dart';
import '../../../../controllers/comments_controller.dart';
import '../../../../providers/auth_service.dart';

Widget TextComment(
    bool isSender, CommentF comment, String commentID, BuildContext context) {
  return Row(
    mainAxisAlignment:
        (isSender) ? MainAxisAlignment.end : MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      (!isSender)
          ? ImagePerfilWidget(
              photo: comment.photo,
              userID: comment.userId,
            )
          : SizedBox(),
      Column(
        crossAxisAlignment:
            (isSender) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            comment.nameSender,
            style: TxtStyle.labelText,
          ),
          Bounceable(
            onTap: () {
              showComment(context, comment, commentID, isSender);
            },
            child: Container(
              constraints: BoxConstraints(maxWidth: 55.w),
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    painter: OpenPainter(
                        isSender: isSender,
                        color: (isSender)
                            ? ColorStyle.secondaryColor
                            : ColorStyle.primaryColor),
                    child: Container(
                      padding: EdgeInsets.only(
                          right: (isSender) ? 15 : 5,
                          left: (isSender) ? 5 : 15),
                      child: renderComment(comment.comment),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: (isSender) ? null : -15,
                    left: (isSender) ? -15 : null,
                    child: GestureDetector(
                      onTap: () {
                        showComment(context, comment, commentID, isSender);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                                bottomLeft:
                                    Radius.circular((isSender) ? 50 : 15),
                                bottomRight:
                                    Radius.circular((isSender) ? 15 : 50)),
                            boxShadow: ShadowStyle.boxShadow,
                            color: Colors.white),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY((isSender) ? 3.14 : 0),
                          child: ImageIcon(
                            AssetImage(
                              "assets/icon/reply.png",
                            ),
                            color: ColorStyle.secondaryColor,
                            size: 10,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          (comment.timestamp != null)
              ? Row(
                  children: [
                    Text(
                      timeago.format(comment.timestamp!.toDate(), locale: 'es'),
                      style: TxtStyle.hintText,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ReplyWidget(
                      replies: comment.replies.length,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    LikesCountWidget(
                      likes: (comment.likes != null)
                          ? comment.likes!.length.toString()
                          : "0",
                      liked: (comment.likes != null)
                          ? comment.likes!.contains(prefs.usuarioID)
                          : false,
                      comment: comment,
                      docID: commentID,
                    ),
                  ],
                )
              : SizedBox()
        ],
      ),
      (isSender)
          ? Column(
              children: [
                ImagePerfilWidget(
                  photo: comment.photo,
                  userID: comment.userId,
                ),
                Transform.translate(
                  offset: Offset(0, -10),
                  child: GestureDetector(
                    onTap: () {
                      NotificationUI.instance.notificationToAcceptAction(
                          context, "¿Estás seguro de eliminar tu comentario?",
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
              ],
            )
          : SizedBox(),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:go_router/go_router.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icarm/presentation/screens/radio/comments.dart';
import 'package:icarm/presentation/screens/radio/widgets/comment_bubble.dart';
import 'package:icarm/presentation/screens/radio/widgets/comment_reder.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../../config/services/notification_ui_service.dart';
import '../../../../config/setting/style.dart';
import '../../../components/loading_widget.dart';
import '../../../components/text_field.dart';
import '../../../controllers/comments_controller.dart';
import '../../../models/CommentModel.dart';
import '../../../providers/auth_service.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> showComment(BuildContext context, CommentF comment,
    String commentID, bool isSender) async {
  // ignore: use_build_context_synchronously
  FocusNode myFocusNodeResena = FocusNode();
  await Haptics.vibrate(HapticsType.success);
  final TextEditingController replyController = TextEditingController();
  FocusNode replyFocus = FocusNode();
  bool loader = false;

  return showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: ((ctx, setState) => GestureDetector(
                onTap: () {
                  myFocusNodeResena.unfocus();
                },
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 55.h,
                      color: const Color(0xFF737373),
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        height: 90.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: (isSender)
                                ? ColorStyle.secondaryColor
                                : ColorStyle.primaryColor,
                            borderRadius: BorderRadius.circular(40)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              comment.nameSender,
                              style: TxtStyle.headerStyle.copyWith(
                                  color: Colors.white, fontSize: 6.sp),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: 60.w,
                                child: renderComment(comment.comment)),
                            Container(
                                height: 1,
                                margin: EdgeInsets.symmetric(vertical: 5),
                                color: Colors.grey),
                            Container(
                              child: StreamBuilder<CommentF>(
                                  stream: Comment.getComment(commentID),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Expanded(
                                          flex: 10,
                                          child: LoadingStandardWidget
                                              .loadingErrorWidget());
                                    }

                                    if (!snapshot.hasData ||
                                        snapshot.data!.replies.isEmpty) {
                                      return Expanded(
                                        flex: 10,
                                        child: Center(
                                          child: Text(
                                            "Este comentario aún no tiene respuestas.",
                                            textAlign: TextAlign.center,
                                            style: TxtStyle.labelText.copyWith(
                                                color: Colors.white,
                                                fontSize: 6.sp),
                                          ),
                                        ),
                                      );
                                    }
                                    final doc = snapshot.data!;

                                    return Expanded(
                                        flex: 10,
                                        child: ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: doc.replies.length,
                                          itemBuilder: (context, index) {
                                            bool isSenderReply =
                                                doc.replies[index].userId ==
                                                    prefs.usuarioID;

                                            return Container(
                                              width: double.infinity,
                                              margin:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0, horizontal: 0),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 3,
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      (isSenderReply)
                                                          ? MainAxisAlignment
                                                              .end
                                                          : MainAxisAlignment
                                                              .start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    (!isSenderReply)
                                                        ? ImagePerfilWidget(
                                                            photo:
                                                                comment.photo,
                                                            userID:
                                                                comment.userId,
                                                          )
                                                        : SizedBox(),
                                                    Column(
                                                      crossAxisAlignment:
                                                          (isSenderReply)
                                                              ? CrossAxisAlignment
                                                                  .end
                                                              : CrossAxisAlignment
                                                                  .start,
                                                      children: [
                                                        Text(
                                                          doc.replies[index]
                                                              .nameSender,
                                                          style: TxtStyle
                                                              .labelText
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        Container(
                                                          constraints:
                                                              BoxConstraints(
                                                                  maxWidth:
                                                                      55.w),
                                                          child: CustomPaint(
                                                            painter: OpenPainter(
                                                                isSender:
                                                                    isSenderReply,
                                                                color: Colors
                                                                    .white),
                                                            child: Container(
                                                              padding: EdgeInsets.only(
                                                                  right:
                                                                      (isSenderReply)
                                                                          ? 15
                                                                          : 5,
                                                                  left:
                                                                      (isSenderReply)
                                                                          ? 5
                                                                          : 15),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Text(
                                                                  doc
                                                                      .replies[
                                                                          index]
                                                                      .reply,
                                                                  style: TxtStyle
                                                                      .labelText
                                                                      .copyWith(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        (doc.replies[index]
                                                                    .timestamp !=
                                                                null)
                                                            ? Row(
                                                                children: [
                                                                  Text(
                                                                    timeago.format(
                                                                        doc
                                                                            .replies[
                                                                                index]
                                                                            .timestamp!
                                                                            .toDate(),
                                                                        locale:
                                                                            'es'),
                                                                    style: TxtStyle
                                                                        .hintText
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                ],
                                                              )
                                                            : SizedBox()
                                                      ],
                                                    ),
                                                    (isSenderReply)
                                                        ? Column(
                                                            children: [
                                                              ImagePerfilWidget(
                                                                photo: comment
                                                                    .photo,
                                                                userID: comment
                                                                    .userId,
                                                              ),
                                                              Transform
                                                                  .translate(
                                                                offset: Offset(
                                                                    0, -10),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    NotificationUI
                                                                        .instance
                                                                        .notificationToAcceptAction(
                                                                            context,
                                                                            "¿Estás seguro de eliminar tu respuesta?",
                                                                            () async {
                                                                      context
                                                                          .pop();
                                                                      final res = await Comment.deleteReply(
                                                                          doc,
                                                                          commentID,
                                                                          doc.replies[index]
                                                                              .id);
                                                                      if (res) {
                                                                        NotificationUI
                                                                            .instance
                                                                            .notificationSuccess("Respuesta eliminada.");
                                                                      } else {
                                                                        NotificationUI
                                                                            .instance
                                                                            .notificationError("No se pudo eliminar tu respuesta.");
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                          height:
                                                                              25,
                                                                          width:
                                                                              25,
                                                                          decoration: BoxDecoration(
                                                                              boxShadow: ShadowStyle.boxShadow,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: Colors.white),
                                                                          child: Icon(
                                                                            Icons.delete_rounded,
                                                                            size:
                                                                                15,
                                                                            color:
                                                                                Colors.redAccent,
                                                                          )),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        : SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ));
                                  }),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFieldWidget(
                                    border: false,
                                    isRequired: false,
                                    textInputType: TextInputType.number,
                                    hintText: 'Escribe tu respuesta',
                                    controller: replyController,
                                    focusNode: replyFocus,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                (!loader)
                                    ? SizedBox(
                                        height: 45,
                                        width: 45,
                                        child: Bounceable(
                                          onTap: () async {
                                            if (replyController.text == "") {
                                              return;
                                            }

                                            setState(() {
                                              loader = true;
                                            });

                                            final replySent =
                                                await Comment.addReply(
                                                    comment,
                                                    commentID,
                                                    replyController.text);

                                            if (replySent) {
                                              await Haptics.vibrate(
                                                  HapticsType.success);
                                              setState(() {
                                                replyController.text = "";
                                                loader = false;
                                              });
                                            } else {
                                              NotificationUI.instance
                                                  .notificationError(
                                                      "Ocurrió un error al añadir tu respuesta. Por favor intente de nuevo.");
                                              setState(() {
                                                loader = false;
                                              });
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: (!isSender)
                                                    ? ColorStyle.secondaryColor
                                                    : ColorStyle.primaryColor,
                                                boxShadow:
                                                    ShadowStyle.boxShadow,
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            child: const Icon(
                                              Icons.send_rounded,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      )
                                    : LoadingStandardWidget.loadingWidget(30),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: -40,
                      child: ImagePerfilWidget(
                        photo: comment.photo,
                        userID: comment.userId,
                        height: 70,
                        width: 70,
                      ),
                    ),
                    Positioned(
                        top: -10,
                        right: 10,
                        child: Bounceable(
                          onTap: () => context.pop(),
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: ShadowStyle.boxShadow),
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.redAccent,
                            ),
                          ),
                        ))
                  ],
                ),
              )));
    },
  );
}

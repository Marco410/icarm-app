import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_rte/flutter_rte.dart';
import 'package:flutter_svg/svg.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/icon_button.dart';
import 'package:icarm/presentation/components/loader_image_widget.dart';
import 'package:icarm/presentation/controllers/comments_controller.dart';
import 'package:icarm/presentation/models/CommentModel.dart';
import 'package:icarm/presentation/screens/radio/widgets/comment_types/alert.dart';
import 'package:icarm/presentation/screens/radio/widgets/comment_types/bible.dart';
import 'package:icarm/presentation/screens/screens.dart';
import 'package:sizer_pro/sizer.dart';

import '../../components/loading_widget.dart';
import '../../providers/auth_service.dart';

import 'widgets/comment_types/text.dart';

class CommentsScreenWidget extends StatefulWidget {
  final GlobalKey commnetKey;
  final HtmlEditorController editorController;
  const CommentsScreenWidget(
      {super.key, required this.commnetKey, required this.editorController});

  @override
  State<CommentsScreenWidget> createState() => _CommentsScreenWidgetState();
}

class _CommentsScreenWidgetState extends State<CommentsScreenWidget> {
  bool loader = false;
  bool showTypeMessage = false;
  String typeComment = 'text';

  addComment() async {
    if (widget.editorController.contentIsEmpty) return;

    setState(() {
      loader = true;
    });

    final commentSent = await Comment.addComment(CommentModel(
        comment: widget.editorController.content.trim(), type: typeComment));

    if (commentSent) {
      await Haptics.vibrate(HapticsType.success);
      setState(() {
        widget.editorController.setText("");
        loader = false;
        FocusScope.of(context).unfocus();
        showTypeMessage = false;
        widget.editorController.clearFocus();
      });
    } else {
      NotificationUI.instance.notificationError(
          "Ocurrió un error al añadir tu comentario. Por favor intente de nuevo.");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: widget.commnetKey,
        height: 50.h,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: EdgeInsets.only(top: 20, bottom: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: ShadowStyle.boxShadow),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              height: (widget.editorController.hasFocus) ? 35 : 0,
              child: Visibility(
                visible: widget.editorController.hasFocus,
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white),
                    child: ToolbarWidget(controller: widget.editorController)),
              ),
            ),
            (prefs.usuarioID == "")
                ? Expanded(
                    flex: 2,
                    child: NoLoginWidget(
                      showOnlyButton: true,
                      textToShow: "Inicia sesión para comentar sobre la radio.",
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: 18, top: 5),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Row(
                          children: [
                            IconButtonWidget(
                                onTap: () {
                                  setState(() {
                                    showTypeMessage = !showTypeMessage;
                                  });
                                },
                                icon: (!showTypeMessage)
                                    ? Icons.add_rounded
                                    : Icons.remove,
                                color: ColorStyle.whiteBacground,
                                iconColor: (!showTypeMessage)
                                    ? ColorStyle.primaryColor
                                    : ColorStyle.secondaryColor),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: ShadowStyle.boxShadow),
                                child: HtmlEditor(
                                  height: 74,
                                  hint: "Escribe tu comentario...",
                                  controller: widget.editorController
                                    ..callbacks = Callbacks(onFocus: () {
                                      Scrollable.ensureVisible(
                                              widget.commnetKey.currentContext!,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeOut)
                                          .whenComplete(() {
                                        widget.editorController.setFocus();
                                      });
                                    }),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            (!loader)
                                ? SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(50),
                                      color: ColorStyle.secondaryColor,
                                      child: InkWell(
                                        splashColor: Colors.black26,
                                        borderRadius: BorderRadius.circular(50),
                                        onTap: () async {
                                          addComment();
                                        },
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: Ink(
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              boxShadow: ShadowStyle.boxShadow,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Icon(
                                            Icons.send_rounded,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : LoadingStandardWidget.loadingWidget(30),
                          ],
                        ),
                        Positioned(
                          bottom: -15,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                  boxShadow: ShadowStyle.boxShadow,
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  Text("Tipo de comentario: ",
                                      style: TxtStyle.labelText.copyWith(
                                        fontSize: 4.5.f,
                                      )),
                                  Text(
                                    "${TypeComment[typeComment]}",
                                    style: TxtStyle.labelText.copyWith(
                                        fontSize: 4.5.f,
                                        color: (typeComment == 'text')
                                            ? Colors.black
                                            : (typeComment == 'alert')
                                                ? ColorStyle.alert
                                                : ColorStyle.bible),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              height: (showTypeMessage) ? 80 : 0,
              child: Visibility(
                visible: showTypeMessage,
                maintainState: true,
                maintainAnimation: true,
                child: Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  margin: EdgeInsets.only(top: 5, bottom: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: ShadowStyle.boxShadow),
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /* IconButtonWidget(
                            onTap: () {
                              setState(() {
                                typeComment = "image";
                              });
                            },
                            color: ColorStyle.whiteBacground,
                            iconColor: ColorStyle.primaryColor,
                            icon: Icons.image_rounded,
                            selected: typeComment == "image",
                          ),
                          SizedBox(
                            width: 10,
                          ), */
                          IconButtonWidget(
                            onTap: () {
                              setState(() {
                                typeComment = "text";
                              });
                            },
                            color: ColorStyle.whiteBacground,
                            iconColor: ColorStyle.primaryColor,
                            icon: Icons.text_fields_rounded,
                            selected: typeComment == "text",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButtonWidget(
                            onTap: () {
                              setState(() {
                                typeComment = "bible";
                              });
                            },
                            color: ColorStyle.whiteBacground,
                            iconColor: ColorStyle.primaryColor,
                            icon: Icons.book_rounded,
                            selected: typeComment == "bible",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButtonWidget(
                            onTap: () {
                              setState(() {
                                typeComment = "alert";
                              });
                            },
                            color: ColorStyle.whiteBacground,
                            iconColor: ColorStyle.primaryColor,
                            icon: Icons.warning_rounded,
                            selected: typeComment == "alert",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 11,
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: Comment.getComments(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: LoadingStandardWidget.loadingErrorWidget());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: LoadingStandardWidget.loadingNoDataWidget(
                              'comentarios'),
                        );
                      }
                      final doc = snapshot.data!.docs;

                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: doc.length,
                        itemBuilder: (context, index) {
                          bool isSender =
                              doc[index]['userId'] == prefs.usuarioID;
                          CommentF comment = doc[index].data() as CommentF;
                          return Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 5),
                            child: (comment.type == 'alert')
                                ? AlertWidget(
                                    isSender, comment, doc[index].id, context)
                                : (comment.type == 'bible')
                                    ? BibleWidget(isSender, comment,
                                        doc[index].id, context)
                                    : TextComment(isSender, comment,
                                        doc[index].id, context),
                          );
                        },
                      );
                    }),
              ),
            ),
          ],
        ));
  }
}

class LikesCountWidget extends StatelessWidget {
  final String likes;
  final bool liked;
  final CommentF comment;
  final String docID;
  const LikesCountWidget(
      {super.key,
      required this.likes,
      required this.liked,
      required this.comment,
      required this.docID});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          likes,
          style: TxtStyle.hintText,
        ),
        SizedBox(
          width: 3,
        ),
        Bounceable(
          onTap: () async {
            final like = await Comment.updateComment(comment, docID);

            if (like) {
              await Haptics.vibrate(HapticsType.success);
            }
          },
          child: ImageIcon(
            AssetImage(
                'assets/icon/${(liked) ? 'corazon_fill' : 'corazon'}.png'),
            size: 12,
            color: (liked) ? Colors.redAccent : Colors.black87,
          ),
        ),
      ],
    );
  }
}

class ReplyWidget extends StatelessWidget {
  final int replies;
  const ReplyWidget({
    super.key,
    required this.replies,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          replies.toString(),
          style: TxtStyle.hintText,
        ),
        SizedBox(
          width: 3,
        ),
        Bounceable(
          onTap: () async {},
          child: ImageIcon(
            AssetImage('assets/icon/reply.png'),
            size: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class ImagePerfilWidget extends StatelessWidget {
  final String photo;
  final String userID;
  final double height;
  final double width;
  const ImagePerfilWidget(
      {super.key,
      required this.photo,
      required this.userID,
      this.height = 45,
      this.width = 45});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.only(top: 7),
      child: (userID != '0' && photo != 'blank')
          ? ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl:
                    "${URL_MEDIA_FOTO_PERFIL}${userID}/${photo.toLowerCase()}",
                placeholder: (context, url) => LoaderImageWidget(),
                imageBuilder: (context, imageProvider) => Container(
                  width: 12.sp,
                  height: 13.sp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => SvgPicture.asset(
                  "assets/icon/user-icon.svg",
                  width: 45,
                  height: 45,
                ),
                height: 13.sp,
              ),
            )
          : SvgPicture.asset(
              "assets/icon/user-icon.svg",
              width: 45,
              height: 45,
            ),
    );
  }
}

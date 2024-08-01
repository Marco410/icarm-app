import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/controllers/comments_controller.dart';
import 'package:icarm/presentation/models/CommentModel.dart';
import 'package:icarm/presentation/screens/screens.dart';
import 'package:sizer_pro/sizer.dart';

import '../../components/loading_widget.dart';
import '../../providers/auth_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsScreenWidget extends StatefulWidget {
  final FocusNode commentField;
  final GlobalKey commnetKey;
  const CommentsScreenWidget(
      {super.key, required this.commentField, required this.commnetKey});

  @override
  State<CommentsScreenWidget> createState() => _CommentsScreenWidgetState();
}

class _CommentsScreenWidgetState extends State<CommentsScreenWidget> {
  final TextEditingController _controllerComment = TextEditingController();
  bool loader = false;

  addComment() async {
    if (_controllerComment.text == "") return;

    setState(() {
      loader = true;
    });

    final commentSent = await Comment.addComment(
        CommentModel(comment: _controllerComment.text.trim()));

    if (commentSent) {
      setState(() {
        _controllerComment.text = "";
        loader = false;
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
            (prefs.usuarioID == "")
                ? Expanded(
                    flex: 2,
                    child: NoLoginWidget(
                      showOnlyButton: true,
                      textToShow: "Inicia sesión para comentar sobre la radio.",
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                  color: ColorStyle.whiteBacground,
                                  borderRadius: BorderRadius.circular(15)),
                              child: TextField(
                                controller: _controllerComment,
                                focusNode: widget.commentField,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hoverColor: Colors.transparent,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: "Escribe un comentario...",
                                  filled: true,
                                  fillColor: ColorStyle.whiteBacground,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  constraints: BoxConstraints(
                                      maxHeight: double.infinity, minHeight: 3),
                                ),
                                autocorrect: true,
                                keyboardType: TextInputType.multiline,
                                textAlignVertical: TextAlignVertical.center,
                                minLines: 1,
                                maxLines: 3,
                                style: TxtStyle.labelText
                                    .copyWith(fontWeight: FontWeight.normal),
                                onSubmitted: (value) => addComment(),
                                onEditingComplete: () => addComment(),
                                onTapOutside: (event) =>
                                    FocusScope.of(context).unfocus(),
                                textCapitalization:
                                    TextCapitalization.sentences,
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
                    ),
                  ),
            Expanded(
              flex: 11,
              child: StreamBuilder<QuerySnapshot>(
                  stream: Comment.getComments(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Expanded(
                          flex: 10,
                          child: LoadingStandardWidget.loadingErrorWidget());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Expanded(
                        flex: 10,
                        child: Center(
                          child: LoadingStandardWidget.loadingNoDataWidget(
                              'comentarios'),
                        ),
                      );
                    }
                    final doc = snapshot.data!.docs;

                    return Expanded(
                        flex: 10,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: doc.length,
                          itemBuilder: (context, index) {
                            bool isSender =
                                doc[index]['userId'] == prefs.usuarioID;
                            CommentF comment = doc[index].data() as CommentF;
                            return GestureDetector(
                              onDoubleTap: () async {
                                await Comment.updateComment(
                                    comment, doc[index].id);
                              },
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment: (isSender)
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (!isSender)
                                        ? ImagePerfilWidget(
                                            photo: comment.photo,
                                            userID: comment.userId,
                                          )
                                        : SizedBox(),
                                    Column(
                                      crossAxisAlignment: (isSender)
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.nameSender,
                                          style: TxtStyle.labelText,
                                        ),
                                        BubbleSpecialOne(
                                          text: comment.comment,
                                          color: (isSender)
                                              ? ColorStyle.secondaryColor
                                              : ColorStyle.primaryColor,
                                          tail: true,
                                          isSender: isSender,
                                          textStyle: TxtStyle.labelText
                                              .copyWith(color: Colors.white),
                                          constraints:
                                              BoxConstraints(maxWidth: 55.w),
                                        ),
                                        (comment.timestamp != null)
                                            ? Row(
                                                children: [
                                                  Text(
                                                    timeago.format(
                                                        comment.timestamp!
                                                            .toDate(),
                                                        locale: 'es'),
                                                    style: TxtStyle.hintText,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  LikesCountWidget(
                                                    likes: (comment.likes !=
                                                            null)
                                                        ? comment.likes!.length
                                                            .toString()
                                                        : "0",
                                                    liked: (comment.likes !=
                                                            null)
                                                        ? comment.likes!
                                                            .contains(
                                                                prefs.usuarioID)
                                                        : false,
                                                  )
                                                ],
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                    (isSender)
                                        ? ImagePerfilWidget(
                                            photo: doc[index]['photo'],
                                            userID: doc[index]['userId'],
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
          ],
        ));
  }
}

class LikesCountWidget extends StatelessWidget {
  final String likes;
  final bool liked;
  const LikesCountWidget({super.key, required this.likes, required this.liked});

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
        ImageIcon(
          AssetImage('assets/icon/${(liked) ? 'corazon_fill' : 'corazon'}.png'),
          size: 12,
          color: (liked) ? Colors.redAccent : Colors.black87,
        ),
      ],
    );
  }
}

class ImagePerfilWidget extends StatelessWidget {
  final String photo;
  final String userID;
  const ImagePerfilWidget(
      {super.key, required this.photo, required this.userID});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      margin: EdgeInsets.only(top: 7),
      child: (userID != '0' && photo != 'blank')
          ? ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl:
                    "${URL_MEDIA_FOTO_PERFIL}${userID}/${photo.toLowerCase()}",
                placeholder: (context, url) =>
                    LoadingStandardWidget.loadingWidget(),
                imageBuilder: (context, imageProvider) => Container(
                  width: 12.sp,
                  height: 13.sp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
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

import 'package:flutter/material.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:sizer_pro/sizer.dart';

class CommentsScreenWidget extends StatefulWidget {
  const CommentsScreenWidget({super.key});

  @override
  State<CommentsScreenWidget> createState() => _CommentsScreenWidgetState();
}

class _CommentsScreenWidgetState extends State<CommentsScreenWidget> {
  final TextEditingController _controllerMessages = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90.h,
        margin: EdgeInsets.only(top: 30, bottom: 20, left: 10, right: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: ShadowStyle.boxShadow),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        color: ColorStyle.whiteBacground,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: _controllerMessages,
                      decoration: InputDecoration(
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        constraints: BoxConstraints(
                            maxHeight: double.infinity, minHeight: 3),
                      ),
                      autocorrect: true,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.center,
                      minLines: 1,
                      maxLines: 3,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 48,
                  width: 48,
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    color: ColorStyle.secondaryColor,
                    child: InkWell(
                      splashColor: Colors.black26,
                      borderRadius: BorderRadius.circular(50),
                      onTap: () async {},
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Ink(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            boxShadow: ShadowStyle.boxShadow,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}

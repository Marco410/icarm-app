import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/components/picker_file_image.dart';
import 'package:icarm/presentation/controllers/user_controller.dart';
import 'package:icarm/presentation/providers/user_provider.dart';
import 'package:sizer_pro/sizer.dart';

// ignore: must_be_immutable
class UserImageProfileWidget extends ConsumerStatefulWidget {
  late bool goToPerfil = false;
  late String? fotoPerfil = null;
  UserImageProfileWidget(
      {super.key, this.goToPerfil = false, this.fotoPerfil = null});

  @override
  ConsumerState<UserImageProfileWidget> createState() =>
      _UserImageProfileWidgetState();
}

class _UserImageProfileWidgetState
    extends ConsumerState<UserImageProfileWidget> {
  bool editingImage = false;
  @override
  Widget build(BuildContext context) {
    final prefs = PreferenciasUsuario();
    final image = ref.watch(imageSelectedProvider);

    if (prefs.foto_perfil == "") {
      if (widget.fotoPerfil != null) {
        setState(() {
          prefs.foto_perfil = widget.fotoPerfil!;
        });
      }
    }

    return GestureDetector(
      onTap: () {
        if (widget.goToPerfil) {
          context.pushNamed('perfil.detail');
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          (image != null ||
                  (prefs.foto_perfil != "" && widget.fotoPerfil != ""))
              ? Container(
                  height: 130,
                  width: 130,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: (image != null)
                          ? Image.file(
                              File(image.path),
                              fit: BoxFit.fitWidth,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${URL_MEDIA_FOTO_PERFIL}/${prefs.usuarioID}/${widget.fotoPerfil}",
                                placeholder: (context, url) =>
                                    LoadingStandardWidget.loadingWidget(),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 55.sp,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fitWidth),
                                  ),
                                ),
                                height: 55.sp,
                              ),
                            )))
              : SvgPicture.asset("assets/icon/user-icon.svg", height: 110),
          Positioned(
            bottom: -5,
            right: -5,
            child: GestureDetector(
              onTap: () {
                if (!widget.goToPerfil) {
                  PickerFileImage(context, ref, true, false, false, false);
                  setState(() {
                    editingImage = true;
                  });
                } else {
                  context.pushNamed('perfil.detail');
                }
              },
              child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: ColorStyle.secondaryColor,
                      borderRadius: BorderRadius.circular(100)),
                  child: Icon(
                    Icons.edit_rounded,
                    size: 20,
                    color: Colors.white,
                  )),
            ),
          ),
          ((image != null || prefs.foto_perfil != "") && !widget.goToPerfil)
              ? Positioned(
                  top: -5,
                  left: -5,
                  child: GestureDetector(
                    onTap: () {
                      if (!widget.goToPerfil) {
                        UserController.deleteFotoPerfil().then((value) {
                          ref
                              .read(imageSelectedProvider.notifier)
                              .update((state) => null);

                          setState(() {
                            prefs.foto_perfil = "";
                            widget.fotoPerfil = "";
                          });
                        });
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.red[300],
                            borderRadius: BorderRadius.circular(100)),
                        child: Icon(
                          Icons.delete_rounded,
                          size: 20,
                          color: Colors.white,
                        )),
                  ),
                )
              : SizedBox(),
          (image != null && !widget.goToPerfil && editingImage)
              ? Positioned(
                  bottom: -5,
                  left: -5,
                  child: GestureDetector(
                    onTap: () {
                      if (!widget.goToPerfil) {
                        UserController.updateFotoPerfil(foto_perfil: image.path)
                            .then((value) {
                          {
                            setState(() {
                              editingImage = false;
                              prefs.foto_perfil = image.name;
                            });
                            ref
                                .read(imageSelectedProvider.notifier)
                                .update((state) => null);
                          }
                        });
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: ColorStyle.primaryColor,
                            borderRadius: BorderRadius.circular(100)),
                        child: Icon(
                          Icons.save_rounded,
                          size: 20,
                          color: Colors.white,
                        )),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/controllers/user_controller.dart';
import 'package:icarm/presentation/providers/user_provider.dart';
import 'package:sizer_pro/sizer.dart';
import '../services/image_picker_service.dart';

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
  bool deletingImage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loadingPageCrop = ref.watch(loadingCropPageProvider);
    final prefs = PreferenciasUsuario();

    final namePhoto = ref.watch(namePhotoProfileProvider);

    if (namePhoto != "") {
      setState(() {
        prefs.foto_perfil = namePhoto;
      });
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
          ((prefs.foto_perfil != "" || prefs.foto_perfil != "null"))
              ? Container(
                  height: 130,
                  width: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      errorWidget: (context, url, error) => SvgPicture.asset(
                          "assets/icon/user-icon.svg",
                          height: 100),
                      imageUrl: "${URL_MEDIA_FOTO_PERFIL}${prefs.foto_perfil}",
                      placeholder: (context, url) =>
                          LoadingStandardWidget.loadingWidget(),
                      imageBuilder: (context, imageProvider) => Container(
                        width: 55.sp,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      height: 55.sp,
                    ),
                  ))
              : SvgPicture.asset("assets/icon/user-icon.svg", height: 110),
          Positioned(
            bottom: -5,
            right: -5,
            child: GestureDetector(
              onTap: () async {
                if (!widget.goToPerfil) {
                  ref
                      .read(loadingCropPageProvider.notifier)
                      .update((state) => true);
                  final res = await CustomImagePicker.pickImage(
                      context: context,
                      mounted: mounted,
                      ref: ref,
                      showDelete: true);
                  ref
                      .read(namePhotoProfileProvider.notifier)
                      .update((state) => "");

                  if (res != null && !res) {
                    ref
                        .read(loadingCropPageProvider.notifier)
                        .update((state) => false);
                  }

                  Future.delayed(Duration(seconds: 1), () {
                    CachedNetworkImage.evictFromCache(
                        "${URL_MEDIA_FOTO_PERFIL}${prefs.foto_perfil}");
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
                  child: (loadingPageCrop)
                      ? LoadingStandardWidget.loadingWidget(20, Colors.white)
                      : Icon(
                          Icons.edit_rounded,
                          size: 20,
                          color: Colors.white,
                        )),
            ),
          ),
          ((prefs.foto_perfil != "") && !widget.goToPerfil)
              ? Positioned(
                  top: -5,
                  left: -5,
                  child: GestureDetector(
                    onTap: () {
                      if (!widget.goToPerfil) {
                        setState(() {
                          deletingImage = true;
                        });
                        UserController.deleteFotoPerfil().then((value) async {
                          ref
                              .read(imageSelectedProvider.notifier)
                              .update((state) => null);

                          setState(() {
                            prefs.foto_perfil = "";
                            widget.fotoPerfil = "";
                            deletingImage = false;
                          });
                          ref
                              .read(namePhotoProfileProvider.notifier)
                              .update((state) => "");
                          Future.delayed(Duration(seconds: 1), () {
                            CachedNetworkImage.evictFromCache(
                                "${URL_MEDIA_FOTO_PERFIL}${prefs.foto_perfil}");
                          });
                        });
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.red[300],
                            borderRadius: BorderRadius.circular(100)),
                        child: (deletingImage)
                            ? LoadingStandardWidget.loadingWidget(
                                20, Colors.white)
                            : Icon(
                                Icons.delete_rounded,
                                size: 20,
                                color: Colors.white,
                              )),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

final loadingCropPageProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

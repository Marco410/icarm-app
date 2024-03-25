// ignore_for_file: prefer_const_constructors, non_constant_identifier_names
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/presentation/components/zcomponents.dart';
import 'package:icarm/presentation/providers/evento_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer_pro/sizer.dart';

import '../../config/setting/style.dart';
import '../providers/user_provider.dart';

Future<void> PickerFileImage(BuildContext context, WidgetRef ref,
    bool showImage, bool showFile, bool imgHorizontal, bool imgVertical) async {
  // ignore: use_build_context_synchronously
  FocusNode myFocusNodeResena = FocusNode();

  return showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: ((ctx, setState) => GestureDetector(
                onTap: () {
                  myFocusNodeResena.unfocus();
                },
                child: Container(
                  height: 55.h,
                  color: const Color(0xFF737373),
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    height: 90.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40)),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            "Selecciona un archivo",
                            style: TxtStyle.headerStyle.copyWith(
                                color: Colors.black87, fontSize: 7.sp),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          flex: 5,
                          child: Row(
                            children: [
                              (showFile)
                                  ? Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: () async {
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles();

                                          if (result == null) {
                                            ref
                                                .read(fileSelectedProvider
                                                    .notifier)
                                                .update((state) => null);
                                            ref
                                                .read(imageSelectedProvider
                                                    .notifier)
                                                .update((state) => null);
                                            return;
                                          } else {
                                            final file = result.files.first;
                                            ref
                                                .read(fileSelectedProvider
                                                    .notifier)
                                                .update((state) => file);
                                            ref
                                                .read(imageSelectedProvider
                                                    .notifier)
                                                .update((state) => null);
                                            context.pop();
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: ColorStyle.primaryColor),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.file_present_rounded,
                                                size: 35,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Archivo",
                                                style: TxtStyle.labelText
                                                    .copyWith(
                                                        fontSize: 6.sp,
                                                        color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                width: 10,
                              ),
                              (showImage)
                                  ? Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: () async {
                                          final image = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery,
                                                  imageQuality: 30);

                                          if (image == null) {
                                            ref
                                                .read(imageSelectedProvider
                                                    .notifier)
                                                .update((state) => null);

                                            ref
                                                .read(fileSelectedProvider
                                                    .notifier)
                                                .update((state) => null);
                                            return;
                                          }

                                          if (imgHorizontal) {
                                            ref
                                                .read(imgHorizontalProvider
                                                    .notifier)
                                                .update((state) => image);
                                          }

                                          if (imgVertical) {
                                            ref
                                                .read(imgVerticalProvider
                                                    .notifier)
                                                .update((state) => image);
                                          }

                                          if (!imgVertical && !imgHorizontal) {
                                            ref
                                                .read(imageSelectedProvider
                                                    .notifier)
                                                .update((state) => image);
                                          }

                                          ref
                                              .read(
                                                  fileSelectedProvider.notifier)
                                              .update((state) => null);
                                          context.pop();

                                          /*  final imageTemporary = File(image.path); */
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: ColorStyle.secondaryColor),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.image_search_rounded,
                                                size: 35,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              (imgHorizontal)
                                                  ? Text(
                                                      "Imagen horizontal",
                                                      style: TxtStyle.labelText
                                                          .copyWith(
                                                              fontSize: 5.sp,
                                                              color:
                                                                  Colors.white),
                                                    )
                                                  : (imgVertical)
                                                      ? Text(
                                                          "Imagen vertical",
                                                          style: TxtStyle
                                                              .labelText
                                                              .copyWith(
                                                                  fontSize:
                                                                      5.sp,
                                                                  color: Colors
                                                                      .white),
                                                        )
                                                      : Text(
                                                          "Imagen",
                                                          style: TxtStyle
                                                              .labelText
                                                              .copyWith(
                                                                  fontSize:
                                                                      5.sp,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                        CustomButton(
                          margin: EdgeInsets.only(
                              bottom: 0, left: 60, right: 60, top: 20),
                          loading: false,
                          text: "Cancelar",
                          textColor: Colors.white,
                          color: ColorStyle.hintColor,
                          onTap: () {
                            ctx.pop();
                          },
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
              )));
    },
  );
}

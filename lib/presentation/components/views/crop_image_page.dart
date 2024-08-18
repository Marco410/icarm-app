import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../config/setting/style.dart';
import '../../providers/user_provider.dart';
import '../loading_widget.dart';

class CropImagePage extends ConsumerWidget {
  CropImagePage(
      {super.key,
      required this.uint8List,
      required this.onCropped,
      required this.height,
      required this.width});

  final CropController cropController = CropController();
  final Uint8List uint8List;
  final void Function(Uint8List) onCropped;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
        backgroundColor: ColorStyle.whiteBacground,
        appBar: AppBar(
          backgroundColor: ColorStyle.secondaryColor,
          leading: Container(
            margin: const EdgeInsets.only(left: 5),
            child: Material(
              borderRadius: BorderRadius.circular(100),
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.white60,
                radius: 100,
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  if (isLoading == false) {
                    Navigator.pop(context);
                  }
                },
                highlightColor: Colors.transparent,
                child: Ink(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(100)),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            "Selecciona el área a cortar",
            style: TxtStyle.headerStyle
                .copyWith(fontSize: 6.5.f, color: Colors.white),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100)),
                    child: Crop(
                      controller: cropController,
                      baseColor: Colors.white,
                      maskColor: Colors.black54,
                      aspectRatio: 4 / 4,
                      radius: 20,
                      interactive: false,
                      progressIndicator: LoadingStandardWidget.loadingWidget(),
                      withCircleUi: true,
                      cornerDotBuilder: (size, edgeAlignment) {
                        return Align(
                          alignment: Alignment.center,
                          widthFactor: 1.5,
                          heightFactor: 1.5,
                          child: Container(
                            width: size / 1.5,
                            height: size / 1.5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        );
                      },
                      image: uint8List,
                      onCropped: onCropped,
                      initialArea: Rect.fromLTWH(0, 0, width, height),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (isLoading == false) {
                      ref
                          .read(isLoadingProvider.notifier)
                          .update((state) => true);
                      cropController.crop();
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      margin:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 50),
                      decoration: BoxDecoration(
                          color: ColorStyle.primaryColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          "Cortar y guardar",
                          style: TxtStyle.headerStyle
                              .copyWith(color: Colors.white, fontSize: 5.f),
                        ),
                      )),
                )
              ],
            ),
            if (isLoading)
              Center(
                child: Container(
                    alignment: Alignment.center,
                    height: 75,
                    width: 75,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: LoadingStandardWidget.loadingWidget()),
              ),
          ],
        ));
  }
}

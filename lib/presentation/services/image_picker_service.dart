// ignore_for_file: unused_result

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/presentation/controllers/user_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../config/services/notification_ui_service.dart';
import '../components/views/crop_image_page.dart';
import '../providers/user_provider.dart';

class CustomImagePicker {
  static Future<void> pickImage(
      {required BuildContext context,
      required bool mounted,
      required WidgetRef ref,
      required bool showDelete}) async {
    Future<void> processPickedImage(Uint8List uint8List) async {
      // extract dimensions
      ui.Codec codec = await ui.instantiateImageCodec(uint8List);
      ui.FrameInfo frameInfo = await codec.getNextFrame();
      double width = frameInfo.image.width.toDouble();
      double height = frameInfo.image.height.toDouble();

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          // ignore: deprecated_member_use
          builder: (context) => WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: CropImagePage(
              width: width,
              height: height,
              uint8List: uint8List,
              onCropped: (croppedData) async {
                final namePhoto = await UserController.updateFotoPerfil(
                    croppedData,
                    nbFoto: croppedData);
                if (namePhoto != "") {
                  if (mounted) {
                    Navigator.pop(context);
                  }

                  ref
                      .read(namePhotoProfileProvider.notifier)
                      .update((state) => namePhoto);

                  ref.read(isLoadingProvider.notifier).update((state) => false);
                } else {
                  NotificationUI.instance
                      .notificationWarning("No se pudo actualizar la imagen");
                }
              },
            ),
          ),
        ),
      );
    }

    Future<void> requestPermissionAndProceed(ImageSource source) async {
      final permitted = await PhotoManager.requestPermissionExtend();
      if (!permitted.hasAccess) {
        NotificationUI.instance.notificationWarning(
          source == ImageSource.gallery
              ? "Se negaron los permisos de acceso a la galería"
              : "Se negaron los permisos de acceso a la cámara",
        );
        return;
      }

      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
        source: source,
        imageQuality: 10,
        requestFullMetadata: false,
      );

      if (pickedFile != null) {
        final Uint8List uint8List = await pickedFile.readAsBytes();
        processPickedImage(uint8List);
      }
    }

    void takeGallery() async =>
        requestPermissionAndProceed(ImageSource.gallery);

    takeGallery();
  }
}

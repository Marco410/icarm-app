// ignore_for_file: unused_result

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/presentation/components/user_image_profile_widget.dart';
import 'package:icarm/presentation/controllers/user_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../config/services/notification_ui_service.dart';
import '../components/views/crop_image_page.dart';
import '../providers/user_provider.dart';

class CustomImagePicker {
  static Future<bool?> pickImage({
    required BuildContext context,
    required bool mounted,
    required WidgetRef ref,
    required bool showDelete,
  }) async {
    Future<bool?> processPickedImage(Uint8List uint8List) async {
      // extract dimensions
      ui.Codec codec = await ui.instantiateImageCodec(uint8List);
      ui.FrameInfo frameInfo = await codec.getNextFrame();
      double width = frameInfo.image.width.toDouble();
      double height = frameInfo.image.height.toDouble();

      if (!mounted) return false;

      print("Entraaaaa");
      ref.read(loadingCropPageProvider.notifier).update((state) => false);

      // Push CropImagePage and wait for result
      final result = Navigator.push<bool>(
        context,
        MaterialPageRoute(
          // ignore: deprecated_member_use
          builder: (context) => WillPopScope(
            onWillPop: () async {
              return false; // Prevent back navigation
            },
            child: CropImagePage(
              width: width,
              height: height,
              uint8List: uint8List,
              onCropped: (croppedData) async {
                final namePhoto = await UserController.updateFotoPerfil(
                  croppedData,
                  nbFoto: croppedData,
                );

                if (namePhoto != "") {
                  if (mounted) {
                    Navigator.pop(context, true); // Return true when success
                  }

                  ref
                      .read(namePhotoProfileProvider.notifier)
                      .update((state) => namePhoto);

                  ref.read(isLoadingProvider.notifier).update((state) => false);
                } else {
                  NotificationUI.instance
                      .notificationWarning("No se pudo actualizar la imagen");
                  Navigator.pop(context, false); // Return false on failure
                }
              },
            ),
          ),
        ),
      );
      return result;
    }

    Future<bool?> requestPermissionAndProceed(ImageSource source) async {
      final permitted2 = await Permission.camera.status;

      if (source == ImageSource.camera && permitted2.isDenied) {
        NotificationUI.instance.notificationWarning(
          "Se negaron los permisos de acceso a la cámara",
        );
        Permission.camera.request();
        return true;
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
      return pickedFile != null;
    }

    Future<bool?> takeGallery() =>
        requestPermissionAndProceed(ImageSource.gallery);

    return takeGallery();
  }
}

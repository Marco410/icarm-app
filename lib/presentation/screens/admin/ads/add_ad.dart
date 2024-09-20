// ignore_for_file: unused_result

import 'package:flutter/Material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/presentation/controllers/ad_controller.dart';
import 'package:icarm/presentation/models/AdsModel.dart';
import 'package:icarm/presentation/providers/ads_provider.dart';
import 'package:icarm/presentation/providers/catalog_service.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../../config/services/notification_ui_service.dart';
import '../../../../config/setting/style.dart';
import '../../../components/picker_file_image.dart';
import '../../../components/text_field.dart';
import '../../../components/zcomponents.dart';
import '../../../providers/user_provider.dart';

class AddAdAdminScreen extends ConsumerStatefulWidget {
  final String? type;
  final Ad? ad;

  const AddAdAdminScreen({
    super.key,
    required this.type,
    this.ad,
  });

  @override
  ConsumerState<AddAdAdminScreen> createState() => _AddAdAdminScreenState();
}

class _AddAdAdminScreenState extends ConsumerState<AddAdAdminScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();

  bool isPublic = false;
  bool isEditing = false;
  bool loadingAd = false;

  @override
  void initState() {
    isEditing = (widget.type == 'edit');

    print("widget.ad");
    print(widget.ad);

    if (isEditing) {
      setState(() {
        titleController.text = widget.ad!.title;
        subtitleController.text = widget.ad!.subtitle;
      });
    }

    Future.microtask(() => ref.watch(getIglesiasProvider));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imageSelected = ref.watch(imageSelectedProvider);

    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    (widget.type == 'edit')
                        ? "Detalles del anuncio"
                        : "Nuevo anuncio",
                    style: TxtStyle.headerStyle,
                    textAlign: TextAlign.center,
                  ),
                  TextFieldWidget(
                    label: 'Título',
                    border: true,
                    isRequired: true,
                    textInputType: TextInputType.text,
                    hintText: 'Escribe aquí',
                    controller: titleController,
                    readOnly: isEditing,
                    capitalize: false,
                  ),
                  SizedBox(height: 15),
                  TextFieldWidget(
                    label: 'Subtítulo',
                    border: true,
                    isRequired: true,
                    textInputType: TextInputType.text,
                    hintText: 'Escribe aquí',
                    controller: subtitleController,
                    readOnly: isEditing,
                    capitalize: false,
                  ),
                  SizedBox(height: 20),
                  (imageSelected == null && widget.type != "edit")
                      ? Bounceable(
                          onTap: () {
                            PickerFileImage(
                                context, ref, true, false, false, false);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: ColorStyle.secondaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.image_rounded,
                                  color: ColorStyle.whiteBacground,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Selecciona una imagen",
                                  style: TxtStyle.labelText.copyWith(
                                      color: ColorStyle.whiteBacground),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: (widget.type == "edit")
                                        ? Image.network(
                                            "${URL_MEDIA_ADS}${widget.ad!.img}",
                                            fit: BoxFit.fitWidth,
                                            width: 80.w,
                                            height: 22.h,
                                          )
                                        : Image.asset(
                                            imageSelected!.path,
                                            fit: BoxFit.fitWidth,
                                            width: 80.w,
                                            height: 24.h,
                                          )),
                                (widget.type != "edit")
                                    ? Positioned(
                                        top: -10,
                                        right: -10,
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: InkWell(
                                            onTap: () {
                                              ref
                                                  .read(imageSelectedProvider
                                                      .notifier)
                                                  .update((state) => null);
                                            },
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ],
                        ),
                  (!isEditing)
                      ? CustomButton(
                          margin: EdgeInsets.only(
                              bottom: 60, left: 60, right: 60, top: 20),
                          loading: loadingAd,
                          text: (widget.type == 'edit')
                              ? "Actualizar"
                              : "Guardar",
                          textColor: Colors.white,
                          color: ColorStyle.primaryColor,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              if (widget.type != 'edit') {
                                if (imageSelected == null) {
                                  NotificationUI.instance.notificationWarning(
                                      "Selecciona una imagen");
                                  return;
                                }
                              }
                              setState(() => loadingAd = true);

                              final res = await AdController.create(
                                  img: (imageSelected != null)
                                      ? imageSelected.path
                                      : "",
                                  title: titleController.text,
                                  subtitle: subtitleController.text,
                                  editing: isEditing);

                              if (res) {
                                NotificationUI.instance.notificationSuccess(
                                    'Anuncio guardado con éxito.');
                                ref.refresh(adsProvider);
                                context.pop();

                                setState(() => loadingAd = false);
                              } else {
                                setState(() => loadingAd = false);
                              }
                            } else {
                              NotificationUI.instance.notificationWarning(
                                  "Revisa los datos que ingresaste");
                            }
                          },
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

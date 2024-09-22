// ignore_for_file: unused_result

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/controllers/ad_controller.dart';
import 'package:icarm/presentation/providers/user_provider.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../../config/setting/style.dart';
import '../../../components/zcomponents.dart';
import '../../../providers/ads_provider.dart';

class AdsAdminScreen extends ConsumerStatefulWidget {
  const AdsAdminScreen({super.key});

  @override
  ConsumerState<AdsAdminScreen> createState() => _AdsAdminScreenState();
}

class _AdsAdminScreenState extends ConsumerState<AdsAdminScreen> {
  final TextEditingController msgController = TextEditingController();
  FocusNode msgNode = FocusNode();
  String roleSelected = "";
  bool deletingAd = false;
  @override
  void initState() {
    Future.microtask(() {});

    super.initState();
  }

  Future<void> onRefresh(WidgetRef ref) async {
    ref.refresh(adsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final ads = ref.watch(adsProvider);

    ref.watch(getUsersAllProvider);

    return Scaffold(
        backgroundColor: ColorStyle.whiteBacground,
        floatingActionButton: Bounceable(
          onTap: () =>
              context.pushNamed('new.ad', pathParameters: {"type": 'new'}),
          child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: ColorStyle.secondaryColor,
                  borderRadius: BorderRadius.circular(100)),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              )),
        ),
        appBar: AppBarWidget(
          backButton: true,
          rightButtons: false,
        ),
        body: Column(
          children: [
            Text(
              "Anuncios",
              style: TxtStyle.headerStyle,
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: ads.when(
                data: (data) {
                  if (data.isEmpty) {
                    return Center(
                        child: LoadingStandardWidget.loadingNoDataWidget(
                            'anuncios'));
                  }

                  return RefreshIndicator(
                    onRefresh: () => onRefresh(ref),
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) => Bounceable(
                          onTap: () => context.pushNamed('new.ad',
                              pathParameters: {"type": "edit"},
                              extra: data[index]),
                          child: Dismissible(
                            key: Key(data[index].id.toString()),
                            confirmDismiss: (DismissDirection direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setStat) {
                                    return AlertDialog(
                                      title: Text(
                                        "Alerta",
                                        style: TxtStyle.headerStyle,
                                      ),
                                      content: const Text(
                                          "¿Estás seguro de eliminar el anuncio?"),
                                      actions: <Widget>[
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomButton(
                                                  text: "Cancelar",
                                                  onTap: () =>
                                                      context.pop(false),
                                                  size: 'sm',
                                                  color:
                                                      ColorStyle.whiteBacground,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  loading: false),
                                            ),
                                            Expanded(
                                              child: CustomButton(
                                                  text: "Aceptar",
                                                  onTap: () {
                                                    setStat(() {
                                                      deletingAd = true;
                                                    });
                                                    AdController.delete(
                                                            data[index]
                                                                .id
                                                                .toString())
                                                        .then((val) {
                                                      ref.refresh(adsProvider);
                                                      NotificationUI.instance
                                                          .notificationSuccess(
                                                              "Anuncio eliminado con éxito");
                                                      context.pop(true);
                                                      setStat(() {
                                                        deletingAd = false;
                                                      });
                                                    });
                                                  },
                                                  size: 'sm',
                                                  textColor: Colors.white,
                                                  color:
                                                      ColorStyle.primaryColor,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  loading: deletingAd),
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  });
                                },
                              );
                            },
                            background: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.redAccent,
                              ),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {},
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                  color: ColorStyle.whiteBacground,
                                  boxShadow: ShadowStyle.boxShadow,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Hero(
                                        tag: data[index].id,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${URL_MEDIA_ADS}${data[index].img}",
                                          placeholder: (context, url) =>
                                              Container(
                                            width: 70,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                color:
                                                    ColorStyle.hintLightColor,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: LoadingStandardWidget
                                                .loadingWidget(),
                                          ),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 70,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            width: 70,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                color:
                                                    ColorStyle.hintLightColor,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Icon(
                                              Icons.image_not_supported_rounded,
                                              color: ColorStyle.hintDarkColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 55.w,
                                            child: Text(
                                              data[index].title,
                                              overflow: TextOverflow.fade,
                                              style: TxtStyle.headerStyle
                                                  .copyWith(fontSize: 6.5.sp),
                                            ),
                                          ),
                                          Text(
                                            data[index].subtitle,
                                            style: TxtStyle.labelText.copyWith(
                                                fontWeight: FontWeight.normal),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 30,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) => Center(
                  child: LoadingStandardWidget.loadingErrorWidget(),
                ),
                loading: () => Center(
                  child: LoadingStandardWidget.loadingWidget(),
                ),
              ),
            ),
          ],
        ));
  }
}

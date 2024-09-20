// ignore_for_file: unused_result

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/controllers/betel_controller.dart';
import 'package:icarm/presentation/providers/user_provider.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../../config/setting/style.dart';
import '../../../components/zcomponents.dart';
import '../../../providers/betel_provider.dart';

class BetelesAdminPage extends ConsumerStatefulWidget {
  const BetelesAdminPage({super.key});

  @override
  ConsumerState<BetelesAdminPage> createState() => _BetelesAdminPageState();
}

class _BetelesAdminPageState extends ConsumerState<BetelesAdminPage> {
  final TextEditingController msgController = TextEditingController();
  FocusNode msgNode = FocusNode();
  String roleSelected = "";
  @override
  void initState() {
    Future.microtask(() {});

    super.initState();
  }

  Future<void> onRefresh(WidgetRef ref) async {
    ref.refresh(betelesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final beteles = ref.watch(betelesProvider);

    ref.watch(getUsersAllProvider);

    return Scaffold(
        backgroundColor: ColorStyle.whiteBacground,
        floatingActionButton: Bounceable(
          onTap: () =>
              context.pushNamed('new.betel', pathParameters: {"type": 'new'}),
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
              "Beteles",
              style: TxtStyle.headerStyle,
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: beteles.when(
                data: (data) {
                  if (data.isEmpty) {
                    return Center(
                        child: LoadingStandardWidget.loadingNoDataWidget(
                            'beteles'));
                  }

                  return RefreshIndicator(
                    onRefresh: () => onRefresh(ref),
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) => Bounceable(
                          onTap: () => context.pushNamed('new.betel',
                              pathParameters: {"type": "edit"},
                              extra: data[index]),
                          child: Dismissible(
                            key: Key(data[index].id.toString()),
                            confirmDismiss: (DismissDirection direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Alerta",
                                      style: TxtStyle.headerStyle,
                                    ),
                                    content: const Text(
                                        "¿Estás seguro de eliminar el betel?"),
                                    actions: <Widget>[
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomButton(
                                                text: "Cancelar",
                                                onTap: () => context.pop(false),
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
                                                  BetelController.delete(
                                                          data[index]
                                                              .id
                                                              .toString())
                                                      .then((value) {
                                                    if (value) {
                                                      ref.refresh(
                                                          betelesProvider);
                                                      NotificationUI.instance
                                                          .notificationSuccess(
                                                              "Betel eliminado con éxito");
                                                      context.pop(true);
                                                    }
                                                  });
                                                },
                                                size: 'sm',
                                                textColor: Colors.white,
                                                color: ColorStyle.primaryColor,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                loading: false),
                                          )
                                        ],
                                      ),
                                    ],
                                  );
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
                                      CachedNetworkImage(
                                        imageUrl:
                                            "${URL_MEDIA_BETELES}${data[index].img}",
                                        placeholder: (context, url) =>
                                            LoadingStandardWidget
                                                .loadingWidget(),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (data[index].user2 != null ||
                                                    data[index].user2Name !=
                                                        null)
                                                ? ((data[index].user != null)
                                                        ? "${data[index].user!.nombre} ${data[index].user!.apellidoPaterno}"
                                                        : data[index]
                                                            .userName!) +
                                                    " &\n" +
                                                    ((data[index].user2 != null)
                                                        ? "${data[index].user2!.nombre} ${data[index].user2!.apellidoPaterno}"
                                                        : data[index]
                                                            .user2Name!)
                                                : ((data[index].user != null)
                                                    ? "${data[index].user!.nombre} ${data[index].user!.apellidoPaterno}"
                                                    : data[index].userName!),
                                            style: TxtStyle.labelText
                                                .copyWith(fontSize: 5.5.sp),
                                          ),
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

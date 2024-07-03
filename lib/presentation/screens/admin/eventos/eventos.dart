// ignore_for_file: unused_result

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/providers/evento_provider.dart';
import 'package:intl/intl.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../../config/setting/style.dart';
import '../../../components/zcomponents.dart';

class EventosAdminPage extends ConsumerStatefulWidget {
  const EventosAdminPage({super.key});

  @override
  ConsumerState<EventosAdminPage> createState() => _EventosAdminPageState();
}

class _EventosAdminPageState extends ConsumerState<EventosAdminPage> {
  @override
  Widget build(BuildContext context) {
    final listEventos = ref.watch(getEventosProvider("admin"));
    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      floatingActionButton: InkWell(
        onTap: () =>
            context.pushNamed('new.evento', pathParameters: {"type": 'new'}),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Eventos",
            style: TxtStyle.headerStyle,
            textAlign: TextAlign.center,
          ),
          listEventos.when(
            data: (data) {
              if (data.isEmpty) {
                return Center(
                    child:
                        LoadingStandardWidget.loadingNoDataWidget("eventos"));
              }
              return Expanded(
                flex: 10,
                child: RefreshIndicator(
                  onRefresh: () => refreshEventos(ref),
                  child: ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          context.pushNamed('new.evento',
                              pathParameters: {"type": 'edit'},
                              extra: data[index]);
                        },
                        child: FadedScaleAnimation(
                          child: Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: -9,
                                      offset: Offset(0, -1))
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  (data[index].imgHorizontal != null)
                                      ? Expanded(
                                          flex: 2,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${URL_MEDIA_EVENTO}${data[index].id}/${data[index].imgHorizontal}",
                                              placeholder: (context, url) =>
                                                  LoadingStandardWidget
                                                      .loadingWidget(),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: 40.sp,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fill),
                                                ),
                                              ),
                                              height: 28.sp,
                                            ),
                                          ),
                                        )
                                      : Expanded(
                                          flex: 2,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.asset(
                                                "assets/image/no-image.png",
                                                height: 28.sp,
                                                width: 40.sp,
                                                scale: 4.5),
                                          ),
                                        ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data[index].nombre,
                                          style: TxtStyle.labelText
                                              .copyWith(fontSize: 5.5.sp),
                                        ),
                                        Text(
                                          DateFormat('dd MMM').format(
                                                  data[index].fechaInicio) +
                                              "-" +
                                              DateFormat('dd MMM')
                                                  .format(data[index].fechaFin),
                                          style: TxtStyle.labelText.copyWith(
                                              fontSize: 4.sp,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child:
                                          Icon(Icons.arrow_forward_ios_rounded))
                                ],
                              )),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            loading: () => Center(child: LoadingStandardWidget.loadingWidget()),
            error: (error, stackTrace) =>
                Center(child: LoadingStandardWidget.loadingErrorWidget()),
          ),
        ],
      ),
    );
  }

  Future<void> refreshEventos(WidgetRef ref) async {
    ref.refresh(getEventosProvider("admin"));
  }
}

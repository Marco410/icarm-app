import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/components/zcomponents.dart';
import 'package:icarm/presentation/providers/kids_service.dart';

import '../../../models/kids/kidsModel.dart';

class KidsPage extends ConsumerStatefulWidget {
  const KidsPage({super.key});

  @override
  ConsumerState<KidsPage> createState() => _KidsPageState();
}

class _KidsPageState extends ConsumerState<KidsPage> {
  @override
  Widget build(BuildContext context) {
    final kidsList = ref.watch(getKidsProvider);

    return Scaffold(
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset("assets/image/kids.png"),
              Image.asset(
                "assets/image/logo-kids.png",
                scale: 1.5,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                Text(
                  "Registra a tus hijos",
                  style: TxtStyle.headerStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Pases de lista, eventos y más",
                  style: TxtStyle.hintText,
                ),
                LineWidget(),
              ],
            ),
          ),
          kidsList.when(
              data: (data) {
                if (data!.isEmpty) {
                  LoadingStandardWidget.loadingNoDataWidget(
                      "niños registrados");
                }

                return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return KidLinkWidget(
                            kid: data[index],
                          );
                        }));
              },
              error: (_, __) => LoadingStandardWidget.loadingErrorWidget(),
              loading: () =>
                  Expanded(child: LoadingStandardWidget.loadingWidget())),
          CustomButton(
            text: "Registrar nuevo",
            onTap: () {
              context.pushNamed('kidsAdd', pathParameters: {'type': 'create'});
            },
            loading: false,
            textColor: Colors.white,
            color: ColorStyle.secondaryColor,
          )
        ],
      ),
    );
  }
}

class KidLinkWidget extends StatelessWidget {
  final Kid kid;
  const KidLinkWidget({super.key, required this.kid});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed('kidsAdd',
          pathParameters: {'type': 'edit'}, extra: kid),
      child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${kid.nombre} ${kid.aPaterno} ${kid.aMaterno}',
                    style: TxtStyle.labelText,
                  ),
                  Text(
                    '${kid.sexo} ',
                    style: TxtStyle.hintText,
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios_rounded)
            ],
          )),
    );
  }
}

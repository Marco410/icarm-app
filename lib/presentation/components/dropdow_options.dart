// ignore_for_file: must_be_immutable

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../../presentation/providers/notification_service.dart';

Future<dynamic> showDropdownOptions(
    BuildContext context, double height, List<Option> options) async {
  int maxItemsToShowSearch = 15;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        height: (options.length > maxItemsToShowSearch)
            ? MediaQuery.of(context).size.height * 0.8
            : height,
        color: const Color(0xFF737373),
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(40)),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 50,
                height: 6,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100)),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Seleccione una opción:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        InkWell(
                          onTap: (() {
                            Navigator.of(context)
                                .pop([Option(id: 0, name: "Seleccione")]);
                          }),
                          child: Container(
                            padding: const EdgeInsets.all(6.5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: ColorStyle.secondaryColor),
                            child: const Text(
                              "Limpiar",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              (options.isNotEmpty)
                  ? Container(
                      height: (options.length > maxItemsToShowSearch)
                          ? MediaQuery.of(context).size.height * 0.65
                          : height - MediaQuery.of(context).size.height * 0.14,
                      margin: const EdgeInsets.only(top: 10),
                      child: (options.length > maxItemsToShowSearch)
                          ? Column(
                              children: [
                                Expanded(
                                    child:
                                        SearchableListWidget(options: options)),
                              ],
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  NormalListView(
                                    options: options,
                                  ),
                                ],
                              ),
                            ),
                    )
                  : LoadingStandardWidget.loadingNoDataWidget("datos"),
            ],
          ),
        ),
      );
    },
  );
}

class SearchableListWidget extends StatelessWidget {
  SearchableListWidget({
    required this.options,
    Key? key,
  }) : super(key: key);

  late List<Option> options;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SearchableList<Option>(
        initialList: options,
        loadingWidget: Center(
          child: CircularProgressIndicator(
            color: ColorStyle.primaryColor,
          ),
        ),
        filter: (value) => options
            .where(
              (e) => e.name.toLowerCase().contains(value.toLowerCase()),
            )
            .toList(),
        style: const TextStyle(fontSize: 13),
        builder: (List<Option> displayedList, int itemIndex, Option item) =>
            ItemOption(option: item),
        emptyWidget: const Text("Sin coincidencias"),
        inputDecoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            hintText: "Buscar...",
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: ColorStyle.hintColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: ColorStyle.hintColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusColor: Colors.black),
      ),
    );
  }
}

class NormalListView extends StatelessWidget {
  NormalListView({
    required this.options,
    Key? key,
  }) : super(key: key);

  late List<Option> options;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: options
          .map((e) => ItemOption(
                option: e,
              ))
          .toList(),
    );
  }
}

class ItemOption extends StatefulWidget {
  ItemOption({
    required this.option,
    Key? key,
  }) : super(key: key);

  late Option option;

  @override
  State<ItemOption> createState() => _ItemOptionState();
}

class _ItemOptionState extends State<ItemOption> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.black12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (widget.option.description != null)
                      ? InkWell(
                          onTap: () {
                            NotificationService.showAlertInfo(
                                widget.option.description!, context);
                          },
                          child: Icon(
                            Icons.info_rounded,
                            color: ColorStyle.secondaryColor,
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (widget.option.subOptions.isEmpty) {
                          context.pop([widget.option]);
                        } else {
                          setState(() {
                            visible = !visible;
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: Text(
                              widget.option.name,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          (widget.option.subOptions.isEmpty)
                              ? Icon(
                                  Icons.circle,
                                  color: ColorStyle.primaryColor,
                                  size: 10,
                                )
                              : Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: ColorStyle.primaryColor,
                                  size: 25,
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              (visible)
                  ? ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: widget.option.subOptions
                          .map((e) => FadedScaleAnimation(
                                child: InkWell(
                                  onTap: () {
                                    context.pop([widget.option, e]);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.all(3),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.black26),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            e.name,
                                            style: TxtStyle.labelText
                                                .copyWith(color: Colors.white),
                                          ),
                                          Icon(
                                            Icons.circle,
                                            color: ColorStyle.whiteBacground,
                                            size: 10,
                                          )
                                        ],
                                      )),
                                ),
                              ))
                          .toList(),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ],
    );
  }
}

class Option {
  Option(
      {required this.id,
      required this.name,
      this.description,
      this.subOptions = const []});

  int id;
  String name;
  String? description;
  List<SubOption> subOptions;
}

class SubOption {
  SubOption(
      {required this.id,
      required this.name,
      required this.optionID,
      this.description});
  int id;
  String name;
  String? description;
  int optionID;
}

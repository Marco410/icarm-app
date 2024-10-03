import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/presentation/components/content_ad_widget.dart';
import 'package:icarm/presentation/models/AdsModel.dart';

import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../../config/setting/api.dart';

final adsProvider = FutureProvider<List<Ad>>((ref) async {
  String decodedResp = await BaseHttpService.baseGet(
      url: GET_ADS, authorization: true, params: {"order": "desc"});

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      AdsModel listKids = adsModelFromJson(decodedResp);

      return listKids.data.ads;
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
      return [];
    }
  }
  return [];
});

final adsHomeProvider = FutureProvider<List<Widget>>((ref) async {
  String decodedResp = await BaseHttpService.baseGet(
      url: GET_ADS, authorization: true, params: {"order": "asc"});

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      AdsModel listKids = adsModelFromJson(decodedResp);

      List<Widget> textItems = [];

      for (int i = 0; i < listKids.data.ads.length; i++) {
        textItems.add(
          ContentAdWidget(
            image: listKids.data.ads[i].img,
            title: listKids.data.ads[i].title,
            subTitle: listKids.data.ads[i].subtitle,
            actionButton: () {},
          ),
        );
      }

      return textItems;
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
      return [];
    }
  }
  return [];
});

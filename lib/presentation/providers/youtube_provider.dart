import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/config/services/http_general_service.dart';
import 'package:icarm/config/setting/api.dart';
import 'package:icarm/presentation/models/YoutubeModel.dart';

import '../../config/setting/const.dart';

final isLiveProvider = StateProvider.autoDispose<List<Item>>((ref) {
  return [];
});

final liveProvider = FutureProvider.autoDispose<void>((ref) async {
  try {
    DateTime time = DateTime.now();
    //lun:1,mar:2,mier:3,juev:4,vier:5,sab:6,dom:7
    if ([3, 5, 6, 7].contains(time.weekday)) {
      String resp = await BaseHttpService.baseGetYoutube(
          url: YOUTUBE_API,
          authorization: false,
          params: {
            "key": GOOGLE_KEY,
            "eventType": "live",
            "channelId": CHANNEL_YOUTUBE_ID,
            "type": "video",
          });

      final Map<String, dynamic> decode = json.decode(resp);

      if (decode['error'] == null) {
        YoutubeModel isLive = youtubeModelFromJson(resp);
        ref.read(isLiveProvider.notifier).update((state) => isLive.items);
      } else {
        if (decode['error']['code'] == 403) {
          return;
        }
        return;
      }
    }
  } catch (e) {
    print("Error youtube");
    print(e);
  }
});

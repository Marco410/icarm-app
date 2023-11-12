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
    String resp = await BaseHttpService.baseGetYoutube(
        url: YOUTUBE_API,
        authorization: false,
        params: {
          "key": GOOGLE_KEY,
          "eventType": "live",
          "channelId": CHANNEL_YOUTUBE_ID,
          "type": "video",
        });
    YoutubeModel isLive = youtubeModelFromJson(resp);

    ref.read(isLiveProvider.notifier).update((state) => isLive.items);
  } catch (e) {
    print("Error youtube");
    print(e);
  }
});

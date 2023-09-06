import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/config/services/http_general_service.dart';
import 'package:icarm/config/setting/api.dart';
import 'package:icarm/presentation/models/YoutubeModel.dart';

final isLiveProvider = StateProvider.autoDispose<List<Item>>((ref) {
  return [];
});

final liveProvider = FutureProvider.autoDispose<void>((ref) async {
  String resp = await BaseHttpService.baseGetYoutube(
      url: YOUTUBE_API,
      authorization: false,
      params: {
        "key": "AIzaSyDm0BpLBLeitra16WD2X8DHZene06mJ_KM",
        "eventType": "live",
        "channelId": "UCWiKT0FHEO4wIVJhHJMECWA",
        "type": "video",
      });
  YoutubeModel isLive = youtubeModelFromJson(resp);

  ref.read(isLiveProvider.notifier).update((state) => isLive.items);
});

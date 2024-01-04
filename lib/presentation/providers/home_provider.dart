import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/screens.dart';

final currentIndexPage = StateProvider<int>((ref) {
  return 2;
});

final homeProvider = FutureProvider<Widget>((ref) async {
  final page = ref.watch(currentIndexPage);
  switch (page) {
    case 0:
      return PodcastPage();
    case 1:
      return BetelesPage();
    case 2:
      return Home();
    case 3:
      return RadioPage();
    case 4:
      return ChurchPage();
    default:
      return Home();
  }
});

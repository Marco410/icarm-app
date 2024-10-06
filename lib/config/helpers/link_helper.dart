import 'package:icarm/config/setting/api.dart';

class LinkHelper {
  static String linkRadio() {
    return 'https://$BASE_URL/radio';
  }

  static String linkApp() {
    return 'https://$BASE_URL/public/icarm-app';
  }
}

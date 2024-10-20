import 'package:intl/intl.dart';

class FormatsHelper {
  static String formatDateyMMMdh(DateTime date) {
    return "${DateFormat.yMMMEd('es_MX').format(date)} |  ${DateFormat.Hm('es_MX').format(date)} hrs";
  }
}

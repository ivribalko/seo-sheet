import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:gsheets/gsheets.dart';

import 'common.dart';

class Model extends GetxController with Log {
  final urls = <String>[].obs;
  final _GSheets = Get.find<GSheets>();
  final _GooglePlace = Get.find<GooglePlace>();

  @override
  void onInit() async {
    super.onInit();

    await _GSheets.spreadsheet('1_9FqFUwSYWLhLF-VEXJYMgD2CB8z0gKbP8BC8nHXa4Y')
        .then((value) => value.worksheetByTitle('Sheet1'))
        .then((value) async => await value?.values.column(1))
        .then((value) => urls.addAll(value!));

    await _GooglePlace.details
        .get('ChIJN1t_tDeuEmsRUsoyG83frY4', fields: 'user_ratings_total')
        .then((value) => print(value!.result!.userRatingsTotal));
  }

  @override
  void onClose() {
    super.onClose();
  }
}

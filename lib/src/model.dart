import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:gsheets/gsheets.dart';

import 'common.dart';

class Model extends GetxController with Log {
  final urls = <String>[].obs;

  @override
  void onInit() async {
    super.onInit();

    await GSheets(await rootBundle.loadString('assets/account-key.json'))
        .spreadsheet('1_9FqFUwSYWLhLF-VEXJYMgD2CB8z0gKbP8BC8nHXa4Y')
        .then((value) => value.worksheetByTitle('Sheet1'))
        .then((value) async => await value?.values.column(1))
        .then((value) => urls.addAll(value!));

    await GooglePlace(await rootBundle.loadString('assets/maps-key.txt'))
        .details
        .get('ChIJN1t_tDeuEmsRUsoyG83frY4', fields: 'user_ratings_total')
        .then((value) => print(value!.result!.userRatingsTotal));
  }

  @override
  void onClose() {
    super.onClose();
  }
}

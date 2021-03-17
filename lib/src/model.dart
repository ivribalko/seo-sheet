import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:gsheets/gsheets.dart';

import 'common.dart';

class Model extends GetxController with Log {
  final data = <String>[].obs;
  final _sheet = Get.find<GSheets>();
  final _place = Get.find<GooglePlace>();

  @override
  void onInit() async {
    super.onInit();
    await _sheet
        .spreadsheet('1_9FqFUwSYWLhLF-VEXJYMgD2CB8z0gKbP8BC8nHXa4Y')
        // get sheet
        .then((value) => value.worksheetByTitle('Sheet1'))
        // get places urls
        .then((value) async => await value?.values.column(1))
        .then((value) => value![1])
        // get place name
        .then((value) => Uri.parse(value).pathSegments[2])
        // get place id
        .then((value) async => await _place.search.getFindPlace(
              value,
              InputType.TextQuery,
            ))
        .then((value) {
          assert(value!.candidates!.length == 1);
          return value!.candidates![0].placeId;
        })
        .then((value) async => await _place.details.get(
              value!,
              fields: 'user_ratings_total',
            ))
        .then((value) => data.add(value!.result!.userRatingsTotal.toString()));
  }
}

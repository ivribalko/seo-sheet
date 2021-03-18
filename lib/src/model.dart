import 'dart:async';

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
        .then((value) => value.worksheetByTitle('Sheet1'))
        .then((value) async => await value?.values.column(1))
        .then((value) => value!.map((e) => Future.value(e)
            .then((value) => Uri.parse(value).pathSegments[2])
            .then(getPlaces)
            .then(toPlaceId)
            .then(toDetails)))
        .then((value) async => await Future.wait(value))
        .then(toData)
        .then(data.addAll);
  }

  FutureOr<DetailsResponse?> toDetails(String value) async {
    return await _place.details.get(
      value,
      fields: 'user_ratings_total',
    );
  }

  FutureOr<Iterable<String>> toData(Iterable<DetailsResponse?> value) {
    return value.map((e) => e!.result!.userRatingsTotal.toString());
  }

  FutureOr<String> toPlaceId(FindPlaceResponse? value) {
    // assert(value!.candidates!.length == 1);
    return value!.candidates![0].placeId!;
  }

  FutureOr<FindPlaceResponse?> getPlaces(String value) async {
    return await _place.search.getFindPlace(
      value,
      InputType.TextQuery,
    );
  }
}

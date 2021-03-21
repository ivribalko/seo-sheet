import 'dart:async';

import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';
import 'package:http/http.dart' as http;

import 'common.dart';

const _failed = 'failed';

class Listing {
  final String url;
  final String name;
  final String site;
  final String phone;

  Listing(this.url, this.name, this.site, this.phone);
}

class Verified {
  final bool failed;
  final String text;

  Verified(this.failed, this.text);
}

class Model extends GetxController with Log {
  final data = <Verified>[].obs;
  final _sheet = Get.find<GSheets>();
  final _regex = RegExp(r'(\d*) reviews');
  final _onlyNumbers = RegExp(r'[^0-9]');
  final _sheetId = Get.arguments;

  @override
  void onInit() async {
    super.onInit();
    await _sheet
        .spreadsheet(_sheetId)
        .then((value) => value.worksheetByTitle('Лист1'))
        .then(toListings)
        .then(toResult)
        .then((value) async => await Future.wait(value))
        .then(data.addAll);
  }

  FutureOr<Iterable<Listing>> toListings(Worksheet? value) async {
    final data = await value?.values.column(1);
    final urls = await value?.values.column(2);
    return data!
        .asMap()
        .map((key, value) => toListing(value, key, urls!))
        .values;
  }

  FutureOr<Iterable<Future<Verified>>> toResult(Iterable<Listing> value) {
    return value.map((listing) {
      return Future.value(listing.url)
          .then(Uri.parse)
          .then(http.get)
          .then((value) => value.body)
          .then((value) => toVerified(value, listing));
    });
  }

  Verified toVerified(String value, Listing listing) {
    final text = '${listing.name}\n'
        '${value.contains('${listing.name}" itemprop="name"') ? '' : 'name $_failed\n'}'
        '${value.contains(listing.site) || value.contains(listing.site.replaceAll('www.', '')) ? '' : 'site $_failed\n'}'
        '${value.contains(listing.phone) ? '' : 'phone $_failed\n'}'
        'reviews:${_regex.firstMatch(value)?[1] ?? _failed}';

    return Verified(text.contains(_failed), text);
  }

  MapEntry<int, Listing> toListing(String value, int key, List<String> urls) {
    final split = value.split('\n');
    return MapEntry(
      key,
      Listing(
        urls[key],
        split[0].trim(),
        'http://www.${split[4].trim()}',
        'tel:+1${split[3].trim().replaceAll(_onlyNumbers, '')}',
      ),
    );
  }
}

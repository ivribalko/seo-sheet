import 'dart:async';

import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';
import 'package:http/http.dart' as http;

import 'common.dart';

class Listing {
  final String url;
  final String name;
  final String site;
  final String phone;

  Listing(this.url, this.name, this.site, this.phone);
}

class Model extends GetxController with Log {
  final data = <String>[].obs;
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

  FutureOr<Iterable<Future<String>>> toResult(Iterable<Listing> value) {
    return value.map((e) {
      final name = e.name;
      final phone = e.phone;
      return Future.value(e.url)
          .then(Uri.parse)
          .then(http.get)
          .then((value) => value.body)
          .then((value) => '$name\n'
              'name:${value.contains('$name" itemprop="name"')}\n'
              'site:${value.contains(e.site) || value.contains(e.site.replaceAll('www.', ''))}\n'
              'phone:${value.contains(phone)}\n'
              'reviews:${_regex.firstMatch(value)![1]!}');
    });
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

import 'dart:async';

import "package:collection/collection.dart";
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
  final String image;

  Listing(this.url, this.name, this.site, this.phone, this.image);
}

class Verified {
  final bool failed;
  final String text;

  Verified(this.failed, this.text);
}

class Model extends GetxController with Log {
  final _googleSheet = Get.find<GSheets>();
  final _regexReview = RegExp(r'(\d*) reviews');
  final _onlyNumbers = RegExp(r'[^0-9]');

  Future<List<Verified>> verifyData(String worksheet, String sheet) =>
      _googleSheet
          .spreadsheet(worksheet)
          .then((value) => value.worksheetByTitle(sheet))
          .then(toListings)
          .then(toResultData)
          .then((value) async => await Future.wait(value));

  Future<List<Verified>> verifyDupe(String worksheet, String sheet) =>
      _googleSheet
          .spreadsheet(worksheet)
          .then((value) => value.worksheetByTitle(sheet))
          .then(toListings)
          .then(toResultDupe);

  FutureOr<Iterable<Listing>> toListings(Worksheet? value) async {
    final data = await value?.values.column(1);
    final urls = await value?.values.column(2);
    return data!
        .asMap()
        .map((key, value) => toListing(value, key, urls!))
        .values;
  }

  FutureOr<Iterable<Future<Verified>>> toResultData(Iterable<Listing> value) {
    return value.map((listing) {
      return Future.value(listing.url)
          .then(Uri.parse)
          .then(http.get)
          .then((value) => value.body)
          .then((value) => toVerified(value, listing))
          .catchError((e) => Verified(true, '$_failed: $e'));
    });
  }

  FutureOr<List<Verified>> toResultDupe(Iterable<Listing> list) {
    return list
        .groupListsBy((e) => e.phone)
        .entries
        .where((e) => e.value.length > 1)
        .map((e) => e.value)
        .map((e) => Verified(true, '$_failed ${e[0].phone}'))
        .toList();
  }

  Verified toVerified(String value, Listing listing) {
    final lower = value.toLowerCase();

    final text = '${listing.name}\n'
        '${lower.contains('${listing.name.toLowerCase()}" itemprop="name"') ? '' : 'name $_failed\n'}'
        '${lower.contains(listing.site) || lower.contains(listing.site.replaceAll('www.', '')) ? '' : 'site $_failed\n'}'
        '${lower.contains(listing.phone) ? '' : 'phone $_failed\n'}'
        '${lower.contains(listing.image) ? '' : 'image $_failed\n'}'
        'reviews ${_regexReview.firstMatch(lower)?[1] ?? _failed}';

    return Verified(text.contains(_failed), text);
  }

  MapEntry<int, Listing> toListing(String value, int key, List<String> urls) {
    final split = value.split('\n');
    return MapEntry(
      key,
      Listing(
        urls[key],
        split[0].trim(),
        split.length == 5
            ? 'http://www.${split[4].trim().toLowerCase().replaceFirst('http://', '').replaceFirst('www.', '')}'
            : _failed,
        split.length == 5
            ? 'tel:+1${split[3].trim().replaceAll(_onlyNumbers, '')}'
            : _failed,
        'lh5.googleusercontent.com',
      ),
    );
  }
}

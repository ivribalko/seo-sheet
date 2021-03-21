import 'dart:async';

import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';
import 'package:http/http.dart' as http;

import 'common.dart';

const _failed = 'failed';

class Params {
  final String worksheet;
  final String sheet;
  final int urlColumn;
  final int listingColumn;
  final int commentColumn;

  Params(this.worksheet, this.sheet, this.urlColumn, this.listingColumn,
      this.commentColumn);
}

class Listing {
  final String url;
  final String name;
  final String site;
  final String phone;
  final String image;
  final int index;

  Listing(this.url, this.name, this.site, this.phone, this.image, this.index);
}

class Verified {
  final bool failed;
  final String text;
  final int index;

  Verified(this.failed, this.text, this.index);
}

class Model extends GetxController with Log {
  final _googleSheet = Get.find<GSheets>();
  final _regexReview = RegExp(r'(\d*) reviews');
  final _onlyNumbers = RegExp(r'[^0-9]');

  Future<List<Verified>> verifyData(Params params) => _googleSheet
      .spreadsheet(params.worksheet)
      .then((value) => value.worksheetByTitle(params.sheet))
      .then((value) => toListings(value, params))
      .then(toResultData)
      .then((value) async => await Future.wait(value));

  Future<List<Verified>> verifyDupe(Params params) => _googleSheet
      .spreadsheet(params.worksheet)
      .then((value) => value.worksheetByTitle(params.sheet))
      .then((value) => toListings(value, params))
      .then(toResultDupe);

  FutureOr<Iterable<Listing>> toListings(
    Worksheet? value,
    Params params,
  ) async {
    final data = await value?.values.column(params.listingColumn);
    final urls = await value?.values.column(params.urlColumn);
    return data!
        // there can be fewer urls
        .take(urls!.length)
        .toList()
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
          .catchError((e) => Verified(true, '$_failed: $e', -1));
    });
  }

  FutureOr<List<Verified>> toResultDupe(Iterable<Listing> list) {
    return list
        .groupListsBy((e) => e.phone)
        .entries
        .where((e) => e.value.length > 1)
        .map((e) => e.value)
        .map(
          (e) => Verified(
            true,
            '$_failed ${e[0].phone}\nrows ${e.map((e) => e.index + 1).join(', ')}',
            -1,
          ),
        )
        .toList()
          ..addAll(
            list
                .map(
                  (e) => Verified(
                    true,
                    '${e.name} ${e.phone} ${e.site}',
                    e.index,
                  ),
                )
                .groupListsBy((e) => e.text)
                .entries
                .where((e) => e.value.length > 1)
                .map((e) => e.value)
                .map(
                  (e) => Verified(
                    true,
                    '$_failed ${e[0].text}\nrows ${e.map((e) => e.index + 1).join(', ')}',
                    -1,
                  ),
                ),
          );
  }

  Verified toVerified(String value, Listing listing) {
    final lower = value.toLowerCase();

    final text = '${listing.name}\n'
        '${lower.contains('${listing.name.toLowerCase()}" itemprop="name"') ? '' : 'name $_failed\n'}'
        '${lower.contains(listing.site) || lower.contains(listing.site.replaceAll('www.', '')) ? '' : 'site $_failed\n'}'
        '${lower.contains(listing.phone) ? '' : 'phone $_failed\n'}'
        '${lower.contains(listing.image) ? '' : 'image $_failed\n'}'
        'reviews ${_regexReview.firstMatch(lower)?[1] ?? _failed}';

    return Verified(text.contains(_failed), text, listing.index);
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
        key,
      ),
    );
  }
}

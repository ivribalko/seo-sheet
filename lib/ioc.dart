import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';
import 'package:logging/logging.dart';

import 'src/model.dart';

class IoC {
  static Future init() async {
    _initLog();

    Get.put(
      await rootBundle.loadString('assets/account-key.json'),
      tag: 'account-key',
    );
  }

  static void _initLog() {
    Logger.root.level = kDebugMode ? Level.FINE : Level.WARNING;
    Logger.root.onRecord.listen((record) {
      log(
        record.message,
        time: record.time,
        level: record.level.value,
        name: record.loggerName,
      );
    });
  }
}

class PageBind extends Bindings {
  @override
  void dependencies() {
    Get.put(GSheets(Get.find<String>(tag: 'account-key')));
    Get.put(Model());
  }
}

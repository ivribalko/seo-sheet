import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';

import 'src/model.dart';

class IoC {
  static Future init() {
    _initLog();

    Get.put(Model());

    return Future.value();
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

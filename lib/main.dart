import 'package:flutter/material.dart';

import 'ioc.dart';
import 'ui/app.dart';
import 'ui/common.dart';

void main() {
  runApp(
    CommonFutureBuilder(
      future: Future.wait([
        IoC.init(),
      ]),
      result: (dynamic _) => App(),
    ),
  );
}

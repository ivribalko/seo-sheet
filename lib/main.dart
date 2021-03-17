import 'package:flutter/material.dart';

import 'ioc.dart';
import 'ui/app.dart';
import 'ui/common.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    CommonFutureBuilder(
      future: Future.wait([
        IoC.init(),
      ]),
      result: (dynamic _) => App(),
    ),
  );
}

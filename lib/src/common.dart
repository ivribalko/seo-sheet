import 'package:logging/logging.dart';

mixin Log on Object {
  Logger get log => _log ?? (_log = Logger('${runtimeType}'));
  Logger? _log;
}

const double kPadding = 20.0;

import 'package:get/get.dart';

import 'common.dart';

class Model extends GetxController with Log {
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    count.listen(log.info);
  }

  @override
  void onClose() {
    count.close();
    super.onClose();
  }
}

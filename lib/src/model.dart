import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';

import 'common.dart';

class Model extends GetxController with Log {
  final _credentials = r'''
{
  "type": "service_account",
  "project_id": "",
  "private_key_id": "",
  "private_key": "",
  "client_email": "",
  "client_id": "",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": ""
}
''';

  final urls = <String>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await GSheets(_credentials)
        .spreadsheet('1_9FqFUwSYWLhLF-VEXJYMgD2CB8z0gKbP8BC8nHXa4Y')
        .then((value) => value.worksheetByTitle('Sheet1'))
        .then((value) async => await value?.values.column(1))
        .then((value) => urls.addAll(value!));
  }

  @override
  void onClose() {
    super.onClose();
  }
}

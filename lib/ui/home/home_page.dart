import 'package:flutter/material.dart';
import 'package:flutter_app/src/model.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final model = Get.find<Model>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }
}

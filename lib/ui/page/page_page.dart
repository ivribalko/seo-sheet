import 'package:flutter/material.dart';
import 'package:flutter_app/src/common.dart';
import 'package:flutter_app/src/model.dart';
import 'package:get/get.dart';

class PagePage extends StatelessWidget {
  final model = Get.find<Model>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return SafeArea(
          child: ListView(
            children: model.data.map(toTile).toList(),
          ).paddingAll(kPadding),
        );
      }),
    );
  }

  ListTile toTile(url) {
    return ListTile(
      title: Text(url),
    );
  }
}

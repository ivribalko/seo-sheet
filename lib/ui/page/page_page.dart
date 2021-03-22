import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seosheet/src/model.dart';
import 'package:seosheet/ui/common.dart';

class PagePage extends StatelessWidget {
  final model = Get.find<Model>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: CommonFutureBuilder<List<Verified>>(
          future: model.verifyData(Get.arguments),
          result: (result) {
            return Scrollbar(
              interactive: true,
              child: ListView(
                children: result!.map(toTile).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget toTile(Verified data) {
    return ListTile(
      title: Text(data.text),
      leading: Text('#${data.index + 1}'),
      tileColor: data.color,
    ).paddingAll(10);
  }
}

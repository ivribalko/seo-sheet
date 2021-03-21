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
          future: model.data(Get.arguments),
          result: (result) {
            return Scrollbar(
              child: ListView(
                children: result!.asMap().entries.map(toTile).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget toTile(MapEntry<int, Verified> data) {
    return ListTile(
      title: Text(data.value.text),
      leading: Text('#${data.key + 1}'),
      tileColor: data.value.failed ? Colors.yellow : Colors.transparent,
    ).paddingAll(10);
  }
}

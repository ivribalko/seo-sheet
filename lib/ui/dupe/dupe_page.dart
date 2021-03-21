import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seosheet/src/model.dart';
import 'package:seosheet/ui/common.dart';

class DupePage extends StatelessWidget {
  final model = Get.find<Model>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: CommonFutureBuilder<List<Verified>>(
          future: model.verifyDupe(
            Get.arguments[0],
            Get.arguments[1],
          ),
          result: (result) {
            return Scrollbar(
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
      tileColor: data.failed ? Colors.yellow : Colors.transparent,
    ).paddingAll(10);
  }
}
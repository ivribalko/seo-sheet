import 'package:flutter/material.dart';
import 'package:flutter_app/src/model.dart';
import 'package:flutter_app/ui/common.dart';
import 'package:get/get.dart';

class PagePage extends StatelessWidget {
  final model = Get.find<Model>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: CommonFutureBuilder<List<Verified>>(
          future: model.data(),
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
      tileColor: data.failed ? Colors.yellow : Colors.transparent,
    ).paddingAll(10);
  }
}

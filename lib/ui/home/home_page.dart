import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seosheet/ui/common.dart';
import 'package:seosheet/ui/routes.dart';

class HomePage extends StatelessWidget {
  final inputWorksheet = TextEditingController();
  final inputSheet = TextEditingController()..text = 'Sheet1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: inputWorksheet,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Worksheet',
              ),
            ),
            TextField(
              controller: inputSheet,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Sheet',
              ),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed(
                Routes.page,
                arguments: [
                  inputWorksheet.text,
                  inputSheet.text,
                ],
              ),
              child: Text('Check'),
            ),
          ].paddingBetween(),
        ).paddingAll(kPadding),
      ),
    );
  }
}

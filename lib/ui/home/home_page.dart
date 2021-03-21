import 'package:flutter/material.dart';
import 'package:flutter_app/src/common.dart';
import 'package:flutter_app/ui/routes.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: input,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Sheet id',
              ),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed(
                Routes.page,
                arguments: input.text,
              ),
              child: Text('Check'),
            ),
          ],
        ).paddingAll(kPadding),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/ui/routes.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: input,
            ),
            TextButton(
              onPressed: () => Get.toNamed(
                Routes.page,
                arguments: input.text,
              ),
              child: Text('Check'),
            ),
          ],
        ),
      ),
    );
  }
}

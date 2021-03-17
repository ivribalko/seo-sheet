import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}

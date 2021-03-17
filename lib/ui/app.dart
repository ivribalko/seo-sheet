import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home/home_page.dart';
import 'page/page_page.dart';
import 'routes.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      getPages: [
        GetPage(name: Routes.home, page: () => HomePage()),
        GetPage(name: Routes.page, page: () => PagePage()),
      ],
    );
  }
}

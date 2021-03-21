import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seosheet/ui/common.dart';
import 'package:seosheet/ui/routes.dart';

class HomePage extends StatelessWidget {
  final inputWorksheet = TextEditingController();
  final inputSheet = TextEditingController()..text = 'Sheet1';
  final inputUrlColumn = TextEditingController()..text = '5';
  final inputListingColumn = TextEditingController()..text = '4';
  final inputCommentColumn = TextEditingController()..text = '7';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TextField(
              inputWorksheet: inputWorksheet,
              label: 'Worksheet',
            ),
            _TextField(
              inputWorksheet: inputSheet,
              label: 'Sheet',
            ),
            _TextField(
              inputWorksheet: inputListingColumn,
              label: 'Listing',
            ),
            _TextField(
              inputWorksheet: inputUrlColumn,
              label: 'Url',
            ),
            _TextField(
              inputWorksheet: inputCommentColumn,
              label: 'Comment',
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed(
                Routes.page,
                arguments: [
                  inputWorksheet.text,
                  inputSheet.text,
                ],
              ),
              child: Text('Verify'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed(
                Routes.dupe,
                arguments: [
                  inputWorksheet.text,
                  inputSheet.text,
                ],
              ),
              child: Text('Dupes'),
            ),
          ].paddingBetween(),
        ).paddingAll(kPadding),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    Key? key,
    required this.inputWorksheet,
    required this.label,
  }) : super(key: key);

  final TextEditingController inputWorksheet;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: inputWorksheet,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
    );
  }
}

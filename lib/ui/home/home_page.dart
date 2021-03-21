import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seosheet/src/model.dart';
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
                arguments: params,
              ),
              child: Text('Verify'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed(
                Routes.dupe,
                arguments: params,
              ),
              child: Text('Dupes'),
            ),
          ].paddingBetween(),
        ).paddingAll(kPadding),
      ),
    );
  }

  Params get params {
    return Params(
      inputWorksheet.text,
      inputSheet.text,
      int.parse(inputUrlColumn.text),
      int.parse(inputListingColumn.text),
      int.parse(inputCommentColumn.text),
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

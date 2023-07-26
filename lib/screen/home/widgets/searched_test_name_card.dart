import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jonggack_state_certified_certificate/model/testInfo.dart';
import 'package:jonggack_state_certified_certificate/web_view.dart';

class SearchedTestNameCard extends StatelessWidget {
  const SearchedTestNameCard({
    super.key,
    required this.testInfo,
  });
  final TestInfo testInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
          onPressed: () {
            Get.to(
              () => WebView(url: testInfo.url),
            );
          },
          child: Text(testInfo.testName)),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jonggack_state_certified_certificate/controller/home_controller.dart';

class SearchTestNameWidget extends StatelessWidget {
  const SearchTestNameWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text('자격증 이름: '),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              onFieldSubmitted: (value) {
                homeController.onClickSearchingTestName();
              },
              controller: homeController.textEditingController,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                homeController.onClickSearchingTestName();
                FocusScope.of(context).unfocus();
              },
              child: const Text('검색'))
        ],
      ),
    );
  }
}

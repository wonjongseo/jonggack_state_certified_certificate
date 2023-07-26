import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jonggack_state_certified_certificate/controller/home_controller.dart';
import 'package:jonggack_state_certified_certificate/screen/home/widgets/my_test_card.dart';
import 'package:jonggack_state_certified_certificate/screen/home/widgets/search_test_name_widget.dart';
import 'package:jonggack_state_certified_certificate/screen/home/widgets/searched_test_name_card.dart';
import 'package:jonggack_state_certified_certificate/screen/home/widgets/test_name_dropdownButton.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  HomeController homeController = Get.put(HomeController());

  // late TextEditingController textEditingController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('국가공인자격증'),
        actions: [
          TextButton(
            onPressed: () {
              homeController.onClickLoadingFile();
            },
            child: const Text('파일 가져오기'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: GetBuilder<HomeController>(builder: (homeController) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const Spacer(flex: 1),
                      const TestNameDropdownButton(),
                      // const SizedBo/x(height: 5),
                      const SearchTestNameWidget(),
                      // const SizedBox(height: 10),
                      if (homeController.foundSelectTest.isNotEmpty)
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                    homeController.foundSelectTest.length,
                                    (index) {
                                  return SearchedTestNameCard(
                                    testInfo:
                                        homeController.foundSelectTest[index],
                                  );
                                }),
                              ),
                            ),
                          ),
                        )
                      else
                        const Spacer(flex: 2)
                    ],
                  ),
                ),
                const Divider(height: 10),
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.manual,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        homeController.myTestInfos.length,
                        (index) {
                          return MyTestCard(
                            index: index,
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}

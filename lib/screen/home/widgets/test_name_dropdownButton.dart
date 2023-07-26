import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jonggack_state_certified_certificate/controller/home_controller.dart';
import 'package:jonggack_state_certified_certificate/main.dart';

class TestNameDropdownButton extends StatelessWidget {
  const TestNameDropdownButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton(
            value: homeController.initDropdownButtonValue,
            items: List.generate(
                testName.length,
                (index) => DropdownMenuItem(
                    value: testName[index].testName,
                    child: Text(
                      testName[index].testName,
                    ))),
            onChanged: (value) {
              homeController.onChangedDropdownButton(value!);
            },
          ),
        ],
      ),
    );
  }
}

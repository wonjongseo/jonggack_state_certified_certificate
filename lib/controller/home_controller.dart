import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jonggack_state_certified_certificate/screen/test_screen/test_screen.dart';
import 'package:jonggack_state_certified_certificate/main.dart';
import 'package:jonggack_state_certified_certificate/model/my_test_info.dart';
import 'package:jonggack_state_certified_certificate/model/testInfo.dart';
import 'package:jonggack_state_certified_certificate/pdf_api.dart';
import 'package:jonggack_state_certified_certificate/repository.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  late TextEditingController textEditingController;
  late TextEditingController numberOfTestTextEditingController;

  late TextEditingController numberOfSelectorTextEditingController;
  late FocusNode numberOfTestTextEditingFocusNode;
  late String initDropdownButtonValue;
  // List<TestInfo> foundSelectTest = [];
  List<MyTestInfo> myTestInfos = [];
  List<TestInfo> foundSelectTest = [];
  GlobalKey formKey = GlobalKey();
  int currentIndx = 0;

  @override
  void onInit() {
    super.onInit();
    textEditingController = TextEditingController();
    numberOfTestTextEditingController = TextEditingController();
    numberOfTestTextEditingFocusNode = FocusNode();

    numberOfSelectorTextEditingController = TextEditingController(text: '4');
    numberOfTestTextEditingFocusNode = FocusNode();
    initDropdownButtonValue = testName[0].testName;

    getAllMyTestInfos();
  }

  @override
  void onClose() {
    textEditingController.dispose();
    numberOfTestTextEditingController.dispose();
    numberOfTestTextEditingFocusNode.dispose();

    numberOfSelectorTextEditingController.dispose();
  }

  deleteMyTestInfo(MyTestInfo myTestInfo) {
    myTestInfos.remove(myTestInfo);
    Repositry.delete(myTestInfo.fileName);
    update();
  }

  getAllMyTestInfos() async {
    myTestInfos = await Repositry.getAll();
    update();
  }

  onClickSearchingTestName() async {
    foundSelectTest = [];
    if (textEditingController.text.isEmpty ||
        textEditingController.text == '') {
      // 입력해주세요
      return;
    }
    String selectd = textEditingController.text;

    for (var element in testName) {
      if (element.testName == selectd || (element.testName).contains(selectd)) {
        foundSelectTest.add(element);
      }
    }
    if (foundSelectTest.isEmpty) {
      Get.dialog(AlertDialog(
          title: Text(
            '$selectd 라는 자격증을 찾을 수 없습니다.',
            style: const TextStyle(fontSize: 18),
          ),
          content: const Text('상단 목록의 자격증만을 취급합니다. 다시 시도해주세요.')));
      return;
    }

    update();
  }

  onChangedDropdownButton(String value) {
    initDropdownButtonValue = value;
    textEditingController.text = initDropdownButtonValue;
    update();
  }

  onClickLoadingFile() async {
    File? file = await PDFApi.pickFile();

    // if (file == null) return;
    // print('file.path: ${file.path}');
    // try {
    //   file = await file.writeAsString(file.path);
    // } catch (e) {
    //   print('e.toString(): ${e.toString()}');
    // }
    if (file == null) return;

// final directory=    await getApplicationDocumentsDirectory();
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    print(selectedDirectory);
    String fileName = (file.path.split('.pdf')[0]).split('tmp/')[1];

    if (selectedDirectory != null) {
      file.copySync('$selectedDirectory/$fileName');
    }

    numberOfTestTextEditingController.text = '';
    numberOfSelectorTextEditingController.text = '4';

    MyTestInfo? myTestInfo = await Repositry.get(fileName);

    bool isContinueTest = false;
    if (myTestInfo != null) {
      isContinueTest = await Get.dialog(
        AlertDialog(
          title: Text(
            myTestInfo.fileName,
            style: const TextStyle(fontSize: 18),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${myTestInfo.getCreateDateYYYYMMDD()}에 작성된 데이터가 존재합니다.'),
              const SizedBox(height: 10),
              const Text('이어서 진행하시겠습니까?')
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  bool isSuccess = await Repositry.save(
                      fileName,
                      file!.path,
                      myTestInfo.numberOfAnswer,
                      int.parse(numberOfSelectorTextEditingController.text));

                  if (!isSuccess) {
                    // TODO
                    print('ERROR!');
                    return;
                  } else {
                    Get.back(result: true);
                  }
                },
                child: const Text('네')),
            ElevatedButton(
                onPressed: () {
                  Get.back(result: false);
                },
                child: const Text('아니요'))
          ],
        ),
      );
    }
    if (isContinueTest == true) {
      Get.to(() => TestScreen());
    } else {
      bool result = await Get.dialog(
          barrierDismissible: false,
          AlertDialog(
            title: Text(
              '$fileName 이름으로 데이터를 생성하시겠습니까?',
              style: const TextStyle(fontSize: 16),
            ),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text("문제의 개수를 입력 해주세요"),
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: numberOfTestTextEditingFocusNode,
                          controller: numberOfTestTextEditingController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("선택지 개수를 입력 해주세요"),
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: numberOfSelectorTextEditingController,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    Get.back(result: true);
                  },
                  child: const Text('네')),
              ElevatedButton(
                  onPressed: () {
                    Get.back(result: false);
                  },
                  child: const Text('아니요')),
            ],
          ));

      if (result) {
        if (numberOfTestTextEditingController.text.isEmpty || //
            numberOfTestTextEditingController.text == '') {
          numberOfTestTextEditingFocusNode.requestFocus();
          return;
        }

        int selectorCnt = int.parse(numberOfSelectorTextEditingController.text);
        if (selectorCnt > 5) {
          // Get.dialog(widget)
          return;
        }

        int numberOfAnswer = int.parse(numberOfTestTextEditingController.text);

        bool onSuccess = await Repositry.save(
            fileName, file.path, numberOfAnswer, selectorCnt);

        if (!onSuccess) {
          print("onError");
          return;
        }
        myTestInfos.remove(myTestInfo);
        MyTestInfo? myTestInfo2 = await Repositry.get(fileName);
        myTestInfos.add(myTestInfo2!);
        currentIndx = myTestInfos.length - 1;
        update();
        Get.to(
          () => TestScreen(),
        );
      }
    }
  }
}

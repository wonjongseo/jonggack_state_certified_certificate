import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jonggack_state_certified_certificate/answer_controller.dart';
import 'package:jonggack_state_certified_certificate/controller/home_controller.dart';
import 'package:jonggack_state_certified_certificate/model/my_test_info.dart';
import 'package:jonggack_state_certified_certificate/repository.dart';
import 'package:pdfx/pdfx.dart';
import 'package:open_filex/open_filex.dart';

class TestScreenController extends GetxController {
  late PdfControllerPinch pdfController;
  late PageController pageController;
  static const int _initialPage = 1;
  int actualPageNumber = _initialPage, totalPagesCount = 0;

  late MyTestInfo myTestInfo;
  HomeController homeController = Get.find<HomeController>();
  // TestScreenController();
  File? file;
  @override
  void onInit() {
    super.onInit();

    myTestInfo = homeController.myTestInfos[homeController.currentIndx];
    pageController = PageController();
    print('myTestInfo.filePath: ${myTestInfo.filePath}');
    file = File(myTestInfo.filePath);
    print('file: ${file}');

    bool isEx = file!.existsSync();

    print('isEx: ${isEx}');
    pdfController = PdfControllerPinch(
      document: PdfDocument.openFile(
          myTestInfo.filePath), //  myTestInfo.filePath is saved in Hive.DB
      initialPage: _initialPage,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    pdfController.dispose();
    myTestInfo.selectAnsweredCnt = 0;
    for (int a in myTestInfo.isCorrentList) {
      if (a != 0) {
        myTestInfo.selectAnsweredCnt++;
      }
    }
    homeController.update();
    Repositry.update(myTestInfo);
    super.onClose();
  }

  previousPage() {
    pdfController.previousPage(
      curve: Curves.ease,
      duration: const Duration(milliseconds: 100),
    );
    update();
  }

  nextPage() {
    pdfController.nextPage(
      curve: Curves.ease,
      duration: const Duration(milliseconds: 100),
    );
    update();
  }

  onPageChanged(int page) {
    actualPageNumber = page;
    update();
  }

  previousBottomPage() {
    pageController.animateToPage(pageController.page!.toInt() - 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  nextBottomPage() {
    pageController.animateToPage(pageController.page!.toInt() + 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  onChangeRadio(int index, int answer) {
    myTestInfo.answerList[index] = answer;
    update();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jonggack_state_certified_certificate/controller/test_page_controller.dart';
import 'package:pdfx/pdfx.dart';

const String JLPT_REAL_TEST_PAGE = '/test';

class TestScreen extends StatelessWidget {
  const TestScreen({
    Key? key,
  }) : super(key: key);

  // late PdfControllerPinch pdfController;
  @override
  Widget build(BuildContext context) {
    Get.put(TestScreenController());
    return GetBuilder<TestScreenController>(builder: (testScreenController) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.navigate_before),
                onPressed: () {
                  testScreenController.previousPage();
                },
              ),
              PdfPageNumber(
                controller: testScreenController.pdfController,
                builder: (_, loadingState, page, pagesCount) {
                  testScreenController.actualPageNumber = page;
                  testScreenController.totalPagesCount = pagesCount ?? 0;
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      '$page/${pagesCount ?? 0}',
                      style: const TextStyle(fontSize: 22),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.navigate_next),
                onPressed: () {
                  testScreenController.nextPage();
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: InteractiveViewer(
                  child: PdfViewPinch(
                    onPageChanged: (page) {
                      testScreenController.onPageChanged(page);
                    },
                    builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
                      options: const DefaultBuilderOptions(),
                      documentLoaderBuilder: (_) {
                        return const Center(child: CircularProgressIndicator());
                      },
                      pageLoaderBuilder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                      errorBuilder: (_, error) {
                        print(
                            'error.toString(): ${error.toString()}'); // <- Error Occur
                        return Center(child: Text(error.toString()));
                      },
                    ),
                    controller: testScreenController.pdfController,
                  ),
                ),
              ),
              const Divider(thickness: 5),
              if (testScreenController.actualPageNumber == // 마지막 페이지에 갔는가
                      testScreenController.totalPagesCount ||
                  testScreenController
                          .myTestInfo.selectAnsweredCnt == // 모든 문제의 채점을 완료 했는가
                      testScreenController.myTestInfo.numberOfAnswer)
                SizedBox(
                  height: 300,
                  child: GridView.count(
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 5,
                    children: List.generate(
                      testScreenController.myTestInfo.answerList.length,
                      (index) {
                        return InkWell(
                          onTap: () {
                            testScreenController
                                .myTestInfo.isCorrentList[index] = 1;
                            testScreenController.update();
                          },
                          onLongPress: () {
                            testScreenController
                                .myTestInfo.isCorrentList[index] = 2;
                            testScreenController.update();
                          },
                          child: Center(
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                testScreenController
                                            .myTestInfo.isCorrentList[index] ==
                                        0
                                    ? Container()
                                    : testScreenController.myTestInfo
                                                .isCorrentList[index] ==
                                            1
                                        ? Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.red,
                                              ),
                                            ),
                                          )
                                        : SvgPicture.asset(
                                            'assets/svg/incorrect-icon.svg',
                                            height: 50,
                                            width: 50,
                                          ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          style: const TextStyle(
                                              color: Colors.black),
                                          text: '${index + 1}번: ',
                                        ),
                                        TextSpan(
                                          style: const TextStyle(
                                              color: Colors.black),
                                          text: testScreenController
                                              .myTestInfo.answerList[index]
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 80,
                    child: PageView(
                      controller: testScreenController.pageController,
                      children: List.generate(
                          testScreenController.myTestInfo.answerList.length,
                          (index) {
                        return SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('${(index + 1).toString()}번'),
                              Row(children: [
                                if (index != 0)
                                  SizedBox(
                                    width: 30,
                                    child: IconButton(
                                        onPressed: () {
                                          testScreenController
                                              .previousBottomPage(); // nextPage;
                                        },
                                        icon: const Icon(Icons.arrow_back_ios)),
                                  ),
                                ...[
                                  Expanded(
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Transform.scale(
                                          scale: 1.8,
                                          child: Radio<String>(
                                            groupValue: testScreenController
                                                .myTestInfo.answerList[index]
                                                .toString(),
                                            visualDensity:
                                                VisualDensity.compact,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.padded,
                                            value: '1',
                                            onChanged: (String? value) {
                                              testScreenController
                                                  .onChangeRadio(index, 1);
                                            },
                                          ),
                                        ),
                                        const Text(
                                          '1',
                                          style: TextStyle(fontSize: 22),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Transform.scale(
                                          scale: 1.8,
                                          child: Radio<String>(
                                            groupValue: testScreenController
                                                .myTestInfo.answerList[index]
                                                .toString(),
                                            visualDensity:
                                                VisualDensity.compact,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.padded,
                                            value: '2',
                                            onChanged: (String? value) {
                                              testScreenController
                                                  .onChangeRadio(index, 2);
                                            },
                                          ),
                                        ),
                                        const Text('2'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Transform.scale(
                                          scale: 1.8,
                                          child: Radio<String>(
                                            groupValue: testScreenController
                                                .myTestInfo.answerList[index]
                                                .toString(),
                                            visualDensity:
                                                VisualDensity.compact,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.padded,
                                            value: '3',
                                            onChanged: (String? value) {
                                              testScreenController
                                                  .onChangeRadio(index, 3);
                                            },
                                          ),
                                        ),
                                        const Text('3'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Transform.scale(
                                          scale: 1.8,
                                          child: Radio<String>(
                                            groupValue: testScreenController
                                                .myTestInfo.answerList[index]
                                                .toString(),
                                            visualDensity:
                                                VisualDensity.compact,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.padded,
                                            value: '4',
                                            onChanged: (String? value) {
                                              testScreenController
                                                  .onChangeRadio(index, 4);
                                            },
                                          ),
                                        ),
                                        const Text('4'),
                                      ],
                                    ),
                                  ),
                                  if (testScreenController
                                          .myTestInfo.selectorCnt ==
                                      5)
                                    Expanded(
                                      child: Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: [
                                          Transform.scale(
                                            scale: 1.8,
                                            child: Radio<String>(
                                              groupValue: testScreenController
                                                  .myTestInfo.answerList[index]
                                                  .toString(),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize.padded,
                                              value: '5',
                                              onChanged: (String? value) {
                                                testScreenController
                                                    .onChangeRadio(index, 5);
                                              },
                                            ),
                                          ),
                                          const Text('5'),
                                        ],
                                      ),
                                    ),
                                ],
                                if (index !=
                                    testScreenController
                                            .myTestInfo.answerList.length -
                                        1)
                                  SizedBox(
                                    width: 30,
                                    child: IconButton(
                                      onPressed: () {
                                        testScreenController.nextBottomPage();
                                        // nextPage;
                                        // pageController.animateToPage(
                                        //     pageController.page!.toInt() + 1,
                                        //     duration: Duration(milliseconds: 400),
                                        //     curve: Curves.easeIn);
                                      },
                                      icon: const Icon(Icons.arrow_forward_ios),
                                    ),
                                  ),
                              ])
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                )
            ],
          ),
        ),
      );
    });
  }
}

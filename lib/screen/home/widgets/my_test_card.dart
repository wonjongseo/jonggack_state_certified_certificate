import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jonggack_state_certified_certificate/controller/home_controller.dart';
import 'package:jonggack_state_certified_certificate/screen/test_screen/test_screen.dart';
import 'package:jonggack_state_certified_certificate/model/my_test_info.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyTestCard extends StatelessWidget {
  const MyTestCard({
    super.key,
    required this.index,
    // required this.myTestInfo,
  });
  final int index;
  //  final MyTestInfo myTestInfo;

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        key: ValueKey(homeController.myTestInfos[index].fileName),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                homeController
                    .deleteMyTestInfo(homeController.myTestInfos[index]);
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: '삭제',
            ),
          ],
        ),
        child: InkWell(
          onTap: () async {
            homeController.currentIndx = index;
            Get.to(() => const TestScreen());
          },
          child: GetBuilder<HomeController>(builder: (homeController) {
            return Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(homeController.myTestInfos[index].fileName),
                        Text(homeController
                                    .myTestInfos[index].selectAnsweredCnt ==
                                homeController.myTestInfos[index].numberOfAnswer
                            ? '완료'
                            : "진행중"),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: homeController
                                    .myTestInfos[index].selectAnsweredCnt /
                                homeController
                                    .myTestInfos[index].numberOfAnswer,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                            '${homeController.myTestInfos[index].selectAnsweredCnt}/${homeController.myTestInfos[index].numberOfAnswer}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${homeController.myTestInfos[index].getCreateDateYYYYMMDD()}에 작성됨',
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

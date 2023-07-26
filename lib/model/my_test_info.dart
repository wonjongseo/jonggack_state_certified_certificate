import 'package:hive_flutter/adapters.dart';

part 'my_test_info.g.dart';

const MyTestInfoTypeId = 0;

@HiveType(typeId: MyTestInfoTypeId)
class MyTestInfo {
  static String key = 'MyTestInfoKey';

  @HiveField(0)
  late String filePath;

  @HiveField(1)
  DateTime createDate = DateTime.now();

  @HiveField(2)
  late int numberOfAnswer;

  @HiveField(3)
  late List<int> answerList;

  @HiveField(4)
  late String fileName;

  @HiveField(5)
  late List<int> isCorrentList;

  @HiveField(6)
  int selectAnsweredCnt = 0;

  @HiveField(7)
  late int selectorCnt;

  MyTestInfo({
    required this.fileName,
    required this.filePath,
    required this.numberOfAnswer,
    required this.selectorCnt,
  }) {
    answerList = List.generate(numberOfAnswer, (index) => 0);
    isCorrentList = List.generate(numberOfAnswer, (index) => 0);
  }

  String getCreateDateYYYYMMDD() {
    return createDate.toString().substring(0, 10);
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'MyTestInfo(filePath: $filePath)';
  }
}

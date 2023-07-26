import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:jonggack_state_certified_certificate/model/my_test_info.dart';

class Repositry {
  static Future<bool> save(String fileName, String filePath, int numberOfAnswer,
      int selectorCnt) async {
    try {
      final myTestInfoBox = await Hive.openBox<MyTestInfo>(MyTestInfo.key);

      MyTestInfo myTest = MyTestInfo(
          filePath: filePath, // filePath is PDF file's Path using File picker
          fileName: fileName,
          numberOfAnswer: numberOfAnswer,
          selectorCnt: selectorCnt);

      await myTestInfoBox.put(fileName, myTest);
      return true;
    } catch (e) {
      log('e.toString: ${e.toString}');
      return false;
    }
  }

  static Future<bool> update(MyTestInfo myTestInfo) async {
    try {
      final myTestInfoBox = await Hive.openBox<MyTestInfo>(MyTestInfo.key);

      await myTestInfoBox.put(myTestInfo.fileName, myTestInfo);
      return true;
    } catch (e) {
      log('e.toString: ${e.toString}');
      return false;
    }
  }

  static Future<void> delete(String fileName) async {
    final myTestInfoBox = await Hive.openBox<MyTestInfo>(MyTestInfo.key);
    myTestInfoBox.delete(fileName);
  }

  static Future<MyTestInfo?> get(String fileName) async {
    try {
      final myTestInfoBox = await Hive.openBox<MyTestInfo>(MyTestInfo.key);

      MyTestInfo? myTest = myTestInfoBox.get(fileName);
      if (myTest == null) return null;

      return myTest;
    } catch (e) {
      log('e.toString: ${e.toString}');
      return null;
    }
  }

  static Future<List<MyTestInfo>> getAll() async {
    try {
      final myTestInfoBox = await Hive.openBox<MyTestInfo>(MyTestInfo.key);

      List<MyTestInfo> myTestinfoList = [];
      myTestinfoList = List.generate(
          myTestInfoBox.length, (index) => myTestInfoBox.getAt(index)!);
      myTestinfoList.sort((a, b) => a.createDate.compareTo(b.createDate));
      return myTestinfoList;
    } catch (e) {
      log('e.toString: ${e.toString}');
      return [];
    }
  }
}

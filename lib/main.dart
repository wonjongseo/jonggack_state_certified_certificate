import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jonggack_state_certified_certificate/datas.dart';
import 'package:jonggack_state_certified_certificate/model/my_test_info.dart';
import 'package:jonggack_state_certified_certificate/model/testInfo.dart';
import 'package:jonggack_state_certified_certificate/screen/home/home_screen.dart';

List<TestInfo> testName = List.generate(
    jsonData.length, (index) => TestInfo.fromJson(jsonData[index]));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MyTestInfoAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

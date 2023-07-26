class TestInfo {
  final String testName;
  final String url;

  factory TestInfo.fromJson(Map<String, dynamic> json) => TestInfo(
        testName: json["testName"],
        url: json["url"],
      );

  TestInfo({
    required this.testName,
    required this.url,
  });
}

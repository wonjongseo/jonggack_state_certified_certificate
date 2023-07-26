// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_test_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyTestInfoAdapter extends TypeAdapter<MyTestInfo> {
  @override
  final int typeId = 0;

  @override
  MyTestInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyTestInfo(
      fileName: fields[4] as String,
      filePath: fields[0] as String,
      numberOfAnswer: fields[2] as int,
      selectorCnt: fields[7] as int,
    )
      ..createDate = fields[1] as DateTime
      ..answerList = (fields[3] as List).cast<int>()
      ..isCorrentList = (fields[5] as List).cast<int>()
      ..selectAnsweredCnt = fields[6] as int;
  }

  @override
  void write(BinaryWriter writer, MyTestInfo obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.filePath)
      ..writeByte(1)
      ..write(obj.createDate)
      ..writeByte(2)
      ..write(obj.numberOfAnswer)
      ..writeByte(3)
      ..write(obj.answerList)
      ..writeByte(4)
      ..write(obj.fileName)
      ..writeByte(5)
      ..write(obj.isCorrentList)
      ..writeByte(6)
      ..write(obj.selectAnsweredCnt)
      ..writeByte(7)
      ..write(obj.selectorCnt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyTestInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

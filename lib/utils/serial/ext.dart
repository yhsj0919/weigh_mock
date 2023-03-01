import 'dart:math';
import 'dart:typed_data';

extension SerialExt on Uint8List {
  String get hex {
    return map((e) => e.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
  }

  String get str {
    return String.fromCharCodes(this);
  }

  double s3168({int? dataStart, int? length, int? decimal}) {
    try {
      var num = map((e) => e.toRadixString(16).padLeft(2, '0')).toList().sublist(dataStart ?? 2).reversed.join();
      return int.parse(num) / pow(10, decimal ?? 3);
    } catch (e) {
      return -1;
    }
  }

  double parse3190({int? dataStart, int? length, int? decimal}) {
    try {
      var num = String.fromCharCodes(this).substring(dataStart ?? 2, (dataStart ?? 2) + (length ?? 6));

      return int.parse(num) / pow(10, decimal ?? 2);
    } catch (e) {
      return -1;
    }
  }

  String rfid({int? dataStart, int? length}) {
    try {
      return sublist(dataStart ?? 6, (dataStart ?? 6) + (length ?? 12)).map((e) => e.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
    } catch (e) {
      return "";
    }
  }
}

extension NumExt on double {
  String restore3190({int? dataStart, int? length, int? decimal}) {
    try {
      var data = (this * pow(10, decimal ?? 2)).toInt().toString().padLeft(6, "0");
      return "+${data}217";
    } catch (e) {
      return "";
    }
  }

  String restore3168({int? dataStart, int? length, int? decimal}) {
    try {
      var data = (this * pow(10, decimal ?? 2)).toInt().toString().padLeft(6, "0");

      var list = [];
      for (var i = 0; i < data.length; i += 2) {
        list.add("${data[i]}${data[i + 1]}");
      }

      return "FF11${list.reversed.join()}";
    } catch (e) {
      return "";
    }
  }
}

extension Uint8ListExt on String {
  Uint8List get uint8List {
    var ss = Uint8List.fromList(codeUnits);
    return ss;
  }

  Uint8List get hexToUint8List {
    if (isEmpty == true) {
      return Uint8List.fromList([]);
    }
    var tmpHex = toUpperCase();

    var array = <int>[];

    var str = StringBuffer();
    for (int i = 0; i < length; i++) {
      str.write(tmpHex[i]);

      if (str.length == 2 || i == length - 1) {
        var num = int.parse(str.toString(), radix: 16);
        array.add(num);

        str.clear();
      }
    }

    return Uint8List.fromList(array);
  }
}

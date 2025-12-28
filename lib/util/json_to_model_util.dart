import 'package:flutter/material.dart';

enum DataType {
  string,
  int,
  double,
  bool,
  unknown,
}

class JsonToModelUtil {
  static String toStr(dynamic json, {String defaultValue = ''}) {
    final dataType = getDataType(json);
    switch (dataType) {
      case DataType.string:
        return json;
      case DataType.int:
        return json.toString();
      case DataType.double:
        return json.toString();
      case DataType.bool:
        return json.toString();
      default:
        return defaultValue;
    }
  }

  static int toInt(dynamic json, {int defaultValue = 0}) {
    final dataType = getDataType(json);
    switch (dataType) {
      case DataType.string:
        if (json.isEmpty) return 0;
        if (json.contains('.')) {
          return double.tryParse(json)?.toInt() ?? 0;
        }
        return int.tryParse(json) ?? 0;
      case DataType.int:
        return json;
      case DataType.double:
        return json.toInt();
      case DataType.bool:
        return json ? 1 : 0;
      default:
        return defaultValue;
    }
  }

  static double toDouble(dynamic json, {double defaultValue = 0.0}) {
    final dataType = getDataType(json);
    switch (dataType) {
      case DataType.string:
        return double.tryParse(json) ?? 0.0;
      case DataType.int:
        return json.toDouble();
      case DataType.double:
        return json;
      case DataType.bool:
        return json ? 1.0 : 0.0;
      default:
        return defaultValue;
    }
  }

  static bool toBool(dynamic json, {bool defaultValue = false}) {
    final dataType = getDataType(json);
    switch (dataType) {
      case DataType.string:
        return json == 'true';
      case DataType.int:
        return json == 1;
      case DataType.double:
        return json == 1.0;
      case DataType.bool:
        return json;
      default:
        return defaultValue;
    }
  }

  static DataType getDataType(dynamic json) {
    if (json is String) {
      return DataType.string;
    } else if (json is int) {
      return DataType.int;
    } else if (json is double) {
      return DataType.double;
    } else if (json is bool) {
      return DataType.bool;
    }
    return DataType.unknown;
  }

  static bool validMap(dynamic json) {
    return json is Map && json.isNotEmpty;
  }

  static bool validList(dynamic json) {
    return json is List && json.isNotEmpty;
  }

  static List<T> toList<T>(dynamic json, T Function(dynamic) converter) {
    if (!validList(json)) {
      return <T>[];
    }

    try {
      final list = json.map<T>((item) {
        T res = converter(item);
        return res;
      }).toList();
      return list;
    } catch (e) {
      debugPrint(e.toString());
      return <T>[];
    }
  }
}


import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class SaveImage {
  static Future<void> saveImage(Uint8List image) async {
    try {
      // 获取下载目录
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        debugPrint('无法获取下载目录');
        return;
      }

      // 获取今天的日期并格式化为 "YYYY-MM-DD" 格式
      DateTime now = DateTime.now();
      String today =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      // 创建今日文件夹路径
      String todayFolderPath = '${downloadsDir.path}/$today';
      Directory todayDir = Directory(todayFolderPath);

      // 检查文件夹是否存在，如果不存在则创建
      if (!await todayDir.exists()) {
        await todayDir.create(recursive: true);
      }

      // 生成时间戳文件名
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      String fullPath = '$todayFolderPath/$fileName';

      // 保存文件
      File file = File(fullPath);
      await file.writeAsBytes(image);

      debugPrint('图片已保存到: $fullPath');
    } catch (e) {
      debugPrint('保存图片失败: $e');
    }
  }
}
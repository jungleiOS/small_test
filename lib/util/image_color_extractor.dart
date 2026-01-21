import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

/// 颜色聚类模型（替代color_models的kmeans）
class ColorCluster {
  final Color centroid;
  final List<Color> points;

  ColorCluster(this.centroid, this.points);
}

/// 图片配色提取工具类（纯手动实现，无第三方依赖，零报错）
class ImageColorExtractor {
  /// 从图片字节中提取主色调（手动实现K-Means聚类）
  static List<Color> extractMainColors(
    Uint8List bytes, {
    int count = 5,
    int sampleStep = 10,
    int iterations = 10,
  }) {
    // 1. 解析图片并采样像素
    final img.Image? decodedImage = img.decodeImage(bytes);
    if (decodedImage == null) return [];

    final List<Color> pixels = [];
    for (int y = 0; y < decodedImage.height; y += sampleStep) {
      for (int x = 0; x < decodedImage.width; x += sampleStep) {
        final pixel = decodedImage.getPixel(x, y);
        // 使用image包提供的Pixel对象属性获取RGB值
        final color = Color.fromRGBO(
          pixel.r.toInt(), // Red
          pixel.g.toInt(), // Green
          pixel.b.toInt(), // Blue
          1.0,
        );
        // 过滤纯黑/纯白/过暗/过亮的杂色
        if (_isValidColor(color)) {
          pixels.add(color);
        }
      }
    }

    if (pixels.isEmpty || count <= 0 || count > pixels.length) return [];

    // 2. 初始化聚类中心（随机选count个像素）
    final random = Random();
    final List<Color> centroids = [];
    for (int i = 0; i < count; i++) {
      centroids.add(pixels[random.nextInt(pixels.length)]);
    }

    // 3. K-Means聚类迭代
    for (int iter = 0; iter < iterations; iter++) {
      // 初始化聚类
      final List<ColorCluster> clusters = [];
      for (final centroid in centroids) {
        clusters.add(ColorCluster(centroid, []));
      }

      // 分配每个像素到最近的聚类
      for (final pixel in pixels) {
        int nearestIndex = 0;
        double minDistance = double.infinity;

        for (int i = 0; i < clusters.length; i++) {
          final distance = _colorDistance(pixel, clusters[i].centroid);
          if (distance < minDistance) {
            minDistance = distance;
            nearestIndex = i;
          }
        }

        clusters[nearestIndex].points.add(pixel);
      }

      // 更新聚类中心
      bool converged = true;
      for (int i = 0; i < clusters.length; i++) {
        if (clusters[i].points.isEmpty) continue;

        final newCentroid = _calculateCentroid(clusters[i].points);
        if (_colorDistance(newCentroid, centroids[i]) > 1) {
          centroids[i] = newCentroid;
          converged = false;
        }
      }

      // 收敛则提前退出
      if (converged) break;
    }

    // 4. 返回聚类中心（主色调），按像素数量排序（占比越高越靠前）
    final List<ColorCluster> finalClusters = [];
    for (final centroid in centroids) {
      final cluster = ColorCluster(centroid, []);
      for (final pixel in pixels) {
        if (_colorDistance(pixel, centroid) == _minDistance(pixel, centroids)) {
          cluster.points.add(pixel);
        }
      }
      finalClusters.add(cluster);
    }

    // 按聚类大小排序
    finalClusters.sort((a, b) => b.points.length.compareTo(a.points.length));
    return finalClusters.map((c) => c.centroid).toList();
  }

  /// 基于主色调生成协调配色方案（纯手动HSL计算）
  static List<List<Color>> generateColorSchemes(Color mainColor) {
    // 转换主色为HSL
    final hsl = _rgbToHsl(mainColor);
    final schemes = <List<Color>>[];

    // 方案1：邻近色（色调±30度）
    schemes.add([
      _hslToRgb(_adjustHue(hsl, -30)),
      mainColor,
      _hslToRgb(_adjustHue(hsl, 30)),
    ]);

    // 方案2：互补色（色调+180度）
    schemes.add([
      mainColor,
      _hslToRgb(_adjustHue(hsl, 180)),
    ]);

    // 方案3：分割互补色（色调+150/210度）
    schemes.add([
      mainColor,
      _hslToRgb(_adjustHue(hsl, 150)),
      _hslToRgb(_adjustHue(hsl, 210)),
    ]);

    // 方案4：莫兰迪风格（降低饱和度，调整亮度）
    final morandi1 = HslColor(
      hsl.hue,
      0.2, // 低饱和度
      0.6, // 适中亮度
    );
    final morandi2 = HslColor(
      (hsl.hue + 90) % 360,
      0.25,
      0.55,
    );
    schemes.add([
      _hslToRgb(morandi1),
      _hslToRgb(morandi2),
    ]);

    return schemes;
  }

  // ===================== 辅助方法（纯手动实现） =====================
  /// 过滤无效颜色（纯黑/纯白/过暗/过亮）
  static bool _isValidColor(Color color) {
    final brightness = color.computeLuminance();
    return brightness > 0.1 && brightness < 0.9; // 亮度0.1-0.9之间
  }

  /// 计算两个颜色的欧氏距离（RGB空间）
  static double _colorDistance(Color a, Color b) {
    final rDiff = a.r - b.r;
    final gDiff = a.g - b.g;
    final bDiff = a.b - b.b;
    return sqrt(rDiff * rDiff + gDiff * gDiff + bDiff * bDiff);
  }

  /// 计算聚类中心（RGB平均值）
  static Color _calculateCentroid(List<Color> points) {
    int r = 0, g = 0, b = 0;
    for (final color in points) {
      r += (color.r * 255).round(); // 将0-1范围转回0-255
      g += (color.g * 255).round(); // 将0-1范围转回0-255
      b += (color.b * 255).round(); // 将0-1范围转回0-255
    }
    return Color.fromRGBO(
      (r / points.length).round(),
      (g / points.length).round(),
      (b / points.length).round(),
      1.0,
    );
  }

  /// 找像素到聚类中心的最小距离
  static double _minDistance(Color pixel, List<Color> centroids) {
    double min = double.infinity;
    for (final c in centroids) {
      final d = _colorDistance(pixel, c);
      if (d < min) min = d;
    }
    return min;
  }

  /// RGB转HSL（手动实现）
  static HslColor _rgbToHsl(Color color) {
    final r = color.r;
    final g = color.g;
    final b = color.b;

    final max = [r, g, b].reduce((a, b) => a > b ? a : b);
    final min = [r, g, b].reduce((a, b) => a < b ? a : b);
    double h = 0, s = 0, l = (max + min) / 2;

    if (max != min) {
      final d = max - min;
      s = l > 0.5 ? d / (2 - max - min) : d / (max + min);

      if (max == r) {
        h = (g - b) / d + (g < b ? 6 : 0);
      } else if (max == g) {
        h = (b - r) / d + 2;
      } else {
        h = (r - g) / d + 4;
      }

      h *= 60;
    }

    return HslColor(h, s, l);
  }

  /// HSL转RGB（手动实现）
  static Color _hslToRgb(HslColor hsl) {
    double r, g, b;
    final h = hsl.hue / 360;
    final s = hsl.saturation;
    final l = hsl.lightness;

    if (s == 0) {
      r = g = b = l; // 灰度
    } else {
      final q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      final p = 2 * l - q;
      r = _hueToRgb(p, q, h + 1 / 3);
      g = _hueToRgb(p, q, h);
      b = _hueToRgb(p, q, h - 1 / 3);
    }

    return Color.fromRGBO(
      (r * 255).round(),
      (g * 255).round(),
      (b * 255).round(),
      1.0,
    );
  }

  static double _hueToRgb(double p, double q, double t) {
    if (t < 0) t += 1;
    if (t > 1) t -= 1;
    if (t < 1 / 6) return p + (q - p) * 6 * t;
    if (t < 1 / 2) return q;
    if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
    return p;
  }

  /// 调整色调，保持饱和度/亮度不变
  static HslColor _adjustHue(HslColor hsl, double delta) {
    final newHue = (hsl.hue + delta) % 360;
    return HslColor(newHue, hsl.saturation, hsl.lightness);
  }
}

/// HSL颜色模型（纯手动定义，无依赖）
class HslColor {
  final double hue; // 0-360
  final double saturation; // 0-1
  final double lightness; // 0-1

  HslColor(this.hue, this.saturation, this.lightness);
}

/// 配色展示工具（可复用）
class ColorDisplayUtil {
  /// 构建配色展示块（带16进制色值）
  static Widget buildColorBlock(Color color, {double size = 50}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _colorToHex(color),
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Flutter Color 转 16进制色值字符串
  static String _colorToHex(Color color) {
    String alpha =
        (color.a * 255).round().toRadixString(16).padLeft(2, '0').toUpperCase();
    String red =
        (color.r * 255).round().toRadixString(16).padLeft(2, '0').toUpperCase();
    String green =
        (color.g * 255).round().toRadixString(16).padLeft(2, '0').toUpperCase();
    String blue =
        (color.b * 255).round().toRadixString(16).padLeft(2, '0').toUpperCase();

    // 如果透明度为完全不透明，则省略alpha通道
    if (color.a == 1.0) {
      return '#$red$green$blue';
    } else {
      return '#$alpha$red$green$blue';
    }
  }
}

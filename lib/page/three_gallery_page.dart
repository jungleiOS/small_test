import 'package:flutter/material.dart';
import 'dart:math' as math;

class ThreeDGallery extends StatefulWidget {
  const ThreeDGallery({super.key});

  @override
  State<ThreeDGallery> createState() => _ThreeDGalleryState();
}

class _ThreeDGalleryState extends State<ThreeDGallery> {
  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.cyan,
    Colors.pink,
    Colors.amber,
    Colors.lime,
  ];

  // 控制整体Z轴旋转角度
  double _galleryRotation = 0.0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 375.0,
          height: 500.0,
          child: Container(
            color: Colors.black,
            child: Transform(
              transform: Matrix4.identity()..setEntry(3, 2, 0.001),
              child: Stack(
                children: List.generate(10, (index) {
                  return Container(
                    color: _colors[index],
                    alignment: Alignment.center,
                    child: Text((index + 1).toString()),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 自定义绘制坐标轴的Painter
class AxisPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // X轴 - 红色
    final xAxisPaint = Paint()
      ..color = Colors.red.withOpacity(0.6)
      ..strokeWidth = 2.0;
    canvas.drawLine(
      Offset(center.dx - 150, center.dy),
      Offset(center.dx + 150, center.dy),
      xAxisPaint,
    );

    // X轴箭头（正方向向右）
    drawArrow(canvas, Offset(center.dx + 145, center.dy),
        Offset(center.dx + 155, center.dy - 5), xAxisPaint);
    drawArrow(canvas, Offset(center.dx + 145, center.dy),
        Offset(center.dx + 155, center.dy + 5), xAxisPaint);

    // X轴正方向标注
    drawText(canvas, "X+", center.dx + 160, center.dy - 10, Colors.red);

    // Y轴 - 绿色
    final yAxisPaint = Paint()
      ..color = Colors.green.withOpacity(0.6)
      ..strokeWidth = 2.0;
    canvas.drawLine(
      Offset(center.dx, center.dy - 150),
      Offset(center.dx, center.dy + 150),
      yAxisPaint,
    );

    // Y轴箭头（正方向向上）
    drawArrow(canvas, Offset(center.dx, center.dy - 145),
        Offset(center.dx - 5, center.dy - 155), yAxisPaint);
    drawArrow(canvas, Offset(center.dx, center.dy - 145),
        Offset(center.dx + 5, center.dy - 155), yAxisPaint);

    // Y轴正方向标注
    drawText(canvas, "Y+", center.dx + 5, center.dy - 170, Colors.green);

    // Z轴中心点 - 蓝色
    final zAxisPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 5, zAxisPaint);

    // Z轴正方向标注（垂直于屏幕向外）
    drawText(canvas, "Z+", center.dx + 10, center.dy + 10, Colors.blue);
  }

  // 绘制箭头的方法
  void drawArrow(Canvas canvas, Offset start, Offset end, Paint paint) {
    canvas.drawLine(start, end, paint);
  }

  // 绘制文本的方法
  void drawText(Canvas canvas, String text, double x, double y, Color color) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

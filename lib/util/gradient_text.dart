import 'package:flutter/widgets.dart';

/// 渐变文字组件
class GradientText extends StatelessWidget {
  /// 显示的文字内容
  final String text;

  /// 渐变颜色数组
  final List<Color> colors;

  /// 文字样式（大小、粗细等）
  final TextStyle? style;

  /// 渐变开始位置（默认从左到右）
  final Alignment begin;

  /// 渐变结束位置（默认从左到右）
  final Alignment end;

  /// 文本对齐方式
  final TextAlign? textAlign;

  /// 文本最大行数
  final int? maxLines;

  /// 文本溢出处理
  final TextOverflow? overflow;

  const GradientText(
      this.text, {
        super.key,
        required this.colors,
        this.style,
        this.begin = Alignment.centerLeft,
        this.end = Alignment.centerRight,
        this.textAlign,
        this.maxLines,
        this.overflow,
      });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      // 创建线性渐变着色器
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: begin,
        end: end,
      ).createShader(bounds),
      // 混合模式：使用渐变颜色覆盖文字原有颜色
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
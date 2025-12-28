import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ImageGradientBackground extends StatefulWidget {
  final Image imageWidget;
  final GradientType gradientType;

  const ImageGradientBackground({
    super.key,
    required this.imageWidget,
    this.gradientType = GradientType.diagonal,
  });

  @override
  State<ImageGradientBackground> createState() => _ImageGradientBackgroundState();
}

class _ImageGradientBackgroundState extends State<ImageGradientBackground> {
  Color? vibrantColor;
  Color? mutedColor;
  Color? dominantColor;

  @override
  void initState() {
    super.initState();
    _extractColors();
  }

  Future<void> _extractColors() async {
    // 获取图片的 ImageProvider
    final imageProvider = _getImageProvider();
    if (imageProvider == null) return;

    final palette = await PaletteGenerator.fromImageProvider(
      imageProvider,
      size: Size(100, 100),
    );

    setState(() {
      vibrantColor = palette.vibrantColor?.color;
      mutedColor = palette.mutedColor?.color;
      dominantColor = palette.dominantColor?.color;
    });
  }

  ImageProvider? _getImageProvider() {
    return widget.imageWidget.image;
  }

  List<Color> _getGradientColors() {
    final colors = <Color>[];

    if (vibrantColor != null) colors.add(vibrantColor!);
    if (mutedColor != null) colors.add(mutedColor!);
    if (dominantColor != null && colors.length < 2) {
      colors.add(dominantColor!);
    }

    if (colors.length < 2) {
      colors.addAll([Colors.blue, Colors.purple]);
    }

    return colors;
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: _getGradientBegin(),
          end: _getGradientEnd(),
        ),
      ),
      child: widget.imageWidget,
    );
  }

  Alignment _getGradientBegin() {
    switch (widget.gradientType) {
      case GradientType.topToBottom:
        return Alignment.topCenter;
      case GradientType.leftToRight:
        return Alignment.centerLeft;
      case GradientType.diagonal:
        return Alignment.topLeft;
    }
  }

  Alignment _getGradientEnd() {
    switch (widget.gradientType) {
      case GradientType.topToBottom:
        return Alignment.bottomCenter;
      case GradientType.leftToRight:
        return Alignment.centerRight;
      case GradientType.diagonal:
        return Alignment.bottomRight;
    }
  }
}

enum GradientType { topToBottom, leftToRight, diagonal }
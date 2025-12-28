import 'dart:convert';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:small_test/model/template.dart';
import 'package:small_test/res/template_json_path.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:flutter/src/rendering/sliver_padding.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final _imageLoadCompleteDebounce = 'imageLoadCompleteDebounce';
  bool _takingScreenshot = false;

  @override
  void initState() {
    super.initState();
    _loadTemplateData();
  }

  Future<List<Template>> _loadTemplateData() async {
    List<Template> templates = [];
    try {
      // 读取 template.json 文件
      String jsonString =
          await rootBundle.loadString(TemplateJsonPath.template);
      // 解析 JSON 数据
      List<dynamic> data = json.decode(jsonString);
      templates = Template.fromJsonList(data);
    } catch (e) {
      debugPrint('读取 template.json 失败: $e');
    }
    return templates;
  }

  @override
  void dispose() {
    EasyDebounce.cancel(_imageLoadCompleteDebounce);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // 浅灰色背景
      appBar: AppBar(
        title: const Text('config'),
      ),
      body: FutureBuilder(
        future: _loadTemplateData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 375.0,
                    child: Screenshot(
                      controller: _screenshotController,
                      child: WaterfallFlow.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final Template template = snapshot.data![index];
                          return ItemWidget(
                            template: template,
                            index: index,
                            imageLoadComplete: () => _calculateHeight(() {
                              final RenderSliverPadding? renderSliverPadding =
                                  context.findAncestorRenderObjectOfType<
                                      RenderSliverPadding>();
                              final paintExtent =
                                  renderSliverPadding?.geometry?.paintExtent;
                              debugPrint('paintExtent：$paintExtent');
                              if (!_takingScreenshot) {
                                _screenshot(paintExtent);
                              }
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                );
              } else {
                return Center(child: Text('加载失败'));
              }
          }
        },
      ),
    );
  }

  void _screenshot(double? cropHeight) async {
    final image = await _screenshotController.capture();
    if (image != null && cropHeight != null && mounted) {
      final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
      final newImage =
          await _cropImageToHeight(image, cropHeight, devicePixelRatio);
      if (newImage != null && mounted) {
        _takingScreenshot = true;
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return Scaffold(
            body: Center(
              child: Image.memory(
                newImage,
                fit: BoxFit.cover,
              ),
            ),
          );
        }));
        _takingScreenshot = false;
      }
    }
  }

  void _calculateHeight(VoidCallback callback) {
    debugPrint('开始计算高度');
    EasyDebounce.debounce(
        _imageLoadCompleteDebounce, const Duration(seconds: 1), callback);
  }

  /// 从图片顶部开始截取指定高度的图片
  ///
  /// [originalImage] 原始图像的 Uint8List 数据
  /// [targetHeight] 目标截取高度
  /// [devicePixelRatio] 设备像素比
  ///
  /// 返回截取后的图像 Uint8List 数据
  Future<Uint8List?> _cropImageToHeight(Uint8List originalImage,
      double targetHeight, double devicePixelRatio) async {
    try {
      // 解码原始图像
      img.Image? original = img.decodeImage(originalImage);

      if (original != null) {
        // 确保目标高度不超过原图高度
        int cropHeight = targetHeight.floor();
        if (cropHeight > original.height) {
          cropHeight = original.height;
        }

        // 创建新的图像，只包含顶部指定高度的部分
        img.Image croppedImage = img.copyCrop(original,
            x: 0, // 从左边开始
            y: 0, // 从顶部开始
            width: original.width, // 保持原宽度
            height: cropHeight * devicePixelRatio.toInt() // 指定截取高度
            );

        // 编码为 Uint8List
        Uint8List croppedImageData =
            Uint8List.fromList(img.encodePng(croppedImage));

        return croppedImageData;
      }
    } catch (e) {
      debugPrint('图片截取失败：$e');
    }

    return null; // 处理失败时返回 null
  }
}

class ItemWidget extends StatelessWidget {
  final Template template;
  final int index;
  final VoidCallback? imageLoadComplete;

  const ItemWidget({
    super.key,
    required this.template,
    required this.index,
    this.imageLoadComplete,
  });

  // Flutter示例（小红书内容卡片文字样式）
  static TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Color(0xFF212121),
    height: 1.3, // 调整标题行高
  );
  static TextStyle descStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF757575),
    height: 1.4, // 调整描述行高
  );
  static TextStyle priceStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: Color(0xFF43A047),
    height: 1.2, // 调整价格行高
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0), // 圆角
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1), // 轻微阴影
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1), // 阴影偏移
          ),
        ],
      ),
      child: Column(
        children: [
          ExtendedImage.network(
            template.image,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
            shape: BoxShape.rectangle,
            loadStateChanged: (state) {
              if (state.extendedImageLoadState == LoadState.completed) {
                imageLoadComplete?.call();
              }
              return null;
            },
          ),
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                    child: Text(template.title, style: titleStyle),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 4.0),
                    child: Text(template.price, style: priceStyle),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                    child: Text(
                      template.highlight,
                      style: descStyle,
                      strutStyle: StrutStyle(
                          height: 1.5,
                          leadingDistribution: TextLeadingDistribution.even),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -12.0,
                right: -18.0,
                child: Container(
                  width: 36.0,
                  height: 36.0,
                  padding: const EdgeInsets.only(right: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.25),
                  ),
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.rotationZ(35 * pi / 180),
                  // 旋转45度
                  child: Transform(
                    transform: Matrix4.rotationZ(-35 * pi / 180),
                    child: Text(
                      '0${index + 1}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

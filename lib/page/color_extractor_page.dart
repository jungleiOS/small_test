import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:small_test/util/image_color_extractor.dart';

class ColorExtractorPage extends StatefulWidget {
  const ColorExtractorPage({super.key});

  @override
  State<ColorExtractorPage> createState() => _ColorExtractorPageState();
}

class _ColorExtractorPageState extends State<ColorExtractorPage> {
  XFile? _selectedImage;
  List<Color> _mainColors = [];
  List<List<Color>> _colorSchemes = [];
  final ImagePicker _picker = ImagePicker();
  String _imageUrl = '';

  // 从相册选择图片提取配色
  Future<void> pickImageAndExtract() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _selectedImage = image;
      _mainColors = [];
      _colorSchemes = [];
    });

    try {
      final Uint8List bytes = await image.readAsBytes();
      final List<Color> mainColors =
          ImageColorExtractor.extractMainColors(bytes);
      if (mainColors.isEmpty) {
        _showSnackBar('未提取到有效主色调');
        return;
      }
      final List<List<Color>> schemes =
          ImageColorExtractor.generateColorSchemes(mainColors.first);

      setState(() {
        _mainColors = mainColors;
        _colorSchemes = schemes;
      });
    } catch (e) {
      _showSnackBar('提取配色失败：$e');
    }
  }

  // 从本地资源图片提取配色
  Future<void> extractFromAssetImage() async {
    try {
      final ByteData data =
          await rootBundle.load('assets/test.jpg'); // 替换为你的图片路径
      final Uint8List bytes = data.buffer.asUint8List();
      final List<Color> mainColors =
          ImageColorExtractor.extractMainColors(bytes);
      if (mainColors.isEmpty) {
        _showSnackBar('未提取到有效主色调');
        return;
      }
      final List<List<Color>> schemes =
          ImageColorExtractor.generateColorSchemes(mainColors.first);

      setState(() {
        _selectedImage = null;
        _mainColors = mainColors;
        _colorSchemes = schemes;
      });
    } catch (e) {
      _showSnackBar('加载本地图片失败：$e');
    }
  }

  // 从网络图片提取配色
  Future<void> extractFromNetworkImage(String url) async {
    try {
      final Uint8List? bytes =
          await ExtendedNetworkImageProvider(url).getNetworkImageData();
      if (bytes == null) {
        _showSnackBar('未提取到有效主色调');
        return;
      }
      final List<Color> mainColors =
          ImageColorExtractor.extractMainColors(bytes);
      if (mainColors.isEmpty) {
        _showSnackBar('未提取到有效主色调');
        return;
      }
      final List<List<Color>> schemes =
          ImageColorExtractor.generateColorSchemes(mainColors.first);

      setState(() {
        _mainColors = mainColors;
        _colorSchemes = schemes;
        _imageUrl = url;
      });
    } on Exception catch (e) {
      _showSnackBar('加载网络图片失败：$e');
    }
  }

  // 显示提示
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('图片配色生成器')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 操作按钮
            Row(
              children: [
                ElevatedButton(
                  onPressed: pickImageAndExtract,
                  child: const Text('从相册选择'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: extractFromAssetImage,
                  child: const Text('加载本地图片'),
                ),
                ElevatedButton(
                  onPressed: () {
                    extractFromNetworkImage(
                        'https://emoji.cdn.bcebos.com/yige-aigc/index_aigc/final/toolspics/0.png');
                  },
                  child: const Text('加载网络图片'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 选中的图片
            if (_selectedImage != null)
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: FileImage(File(_selectedImage!.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // 选中的图片
            if (_imageUrl.isNotEmpty)
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: ExtendedNetworkImageProvider(_imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            // 提取的主色调
            if (_mainColors.isNotEmpty) ...[
              const SizedBox(height: 30),
              const Text('提取的主色调',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _mainColors
                      .map(ColorDisplayUtil.buildColorBlock)
                      .toList(),
                ),
              ),
            ],

            // 生成的配色方案
            if (_colorSchemes.isNotEmpty) ...[
              const SizedBox(height: 30),
              const Text('生成的配色方案',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ..._colorSchemes.asMap().entries.map((entry) {
                final schemeNames = ['邻近色', '互补色', '分割互补色', '莫兰迪风格'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(schemeNames[entry.key],
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 5),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: entry.value
                            .map((color) => ColorDisplayUtil.buildColorBlock(
                                color,
                                size: 80))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }),

              // 配色效果示例
              const SizedBox(height: 30),
              const Text('配色效果示例',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: _colorSchemes.first,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Text('渐变效果',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

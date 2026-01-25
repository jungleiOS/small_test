import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:small_test/util/extensions.dart';
import 'package:small_test/util/gradient_text.dart';
import 'package:small_test/util/save_image.dart';

class SinglePage extends StatefulWidget {
  const SinglePage({super.key});

  static const routeName = 'single_page';

  @override
  State<SinglePage> createState() => _SinglePageState();
}

class _SinglePageState extends State<SinglePage> {
  final ScreenshotController _screenshotController = ScreenshotController();
  File? _mainImageFile;
  File? _imageFile1;
  File? _imageFile2;
  File? _imageFile3;
  File? _imageFile4;

  final List<Color> _colors = [
    Color(0xFF8e81e3),
    Color(0xFF6055ae),
    Color(0xFF7266c2),
    Color(0xFF837dd1),
    Color(0xFF8f81d2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single Page'),
      ),
      body: Center(
        child: Screenshot(
          controller: _screenshotController,
          child: Container(
            color: Colors.white,
            width: 375.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.bottom,
                          child: GradientText(
                            '真我 neo8',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: _colors,
                          ),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.bottom,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 4.0,
                              bottom: 3.0,
                            ),
                            child: Text(
                              '',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 200.0,
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 0.0,
                          right: 0.0,
                          height: 200.0,
                          child: SingleImage(
                            defaultImageFile: _mainImageFile,
                            onSelected: (file) {
                              _mainImageFile = file;
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 8.0,
                          right: 8.0,
                          child: Text(
                            '三重防护 满级防水',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: [
                      SizedBox(
                        width: 172.5,
                        height: 100.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              width: 172.5,
                              height: 100.0,
                              child: SingleImage(
                                defaultImageFile: _imageFile1,
                                onSelected: (file) {
                                  _imageFile1 = file;
                                },
                              ),
                            ),
                            Positioned(
                              top: 8.0,
                              left: 8.0,
                              bottom: 8.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GradientText(
                                    '超声解锁 疾速灵敏',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0),
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: _colors,
                                  ),
                                  // Text(
                                  //   '泰坦电池',
                                  //   style: TextStyle(
                                  //     fontSize: 14.0,
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                  // GradientText(
                                  //   '五年耐用',
                                  //   style: TextStyle(
                                  //       color: Colors.white, fontSize: 14.0),
                                  //   begin: Alignment.topLeft,
                                  //   end: Alignment.bottomRight,
                                  //   colors: _colors,
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 172.5,
                        height: 100.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              width: 172.5,
                              height: 100.0,
                              child: SingleImage(
                                defaultImageFile: _imageFile2,
                                onSelected: (file) {
                                  _imageFile2 = file;
                                },
                              ),
                            ),
                            Positioned(
                              top: 4.0,
                              width: 172.5,
                              bottom: 4.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GradientText(
                                    '红外遥控 万物可控',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0),
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: _colors,
                                  ),
                                  // Text(
                                  //   '边充变玩不烫手',
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //     fontSize: 12.0,
                                  //   ),
                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 172.5,
                        height: 100.0,
                        child: Stack(
                          children: [
                            Positioned(
                              width: 172.5,
                              height: 100.0,
                              child: SingleImage(
                                defaultImageFile: _imageFile3,
                                onSelected: (file) {
                                  _imageFile3 = file;
                                },
                              ),
                            ),
                            Positioned(
                              top: 4.0,
                              left: 8.0,
                              width: 172.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GradientText(
                                    '立体双扬 音质清晰',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0),
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: _colors,
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Positioned(
                            //   bottom: 4.0,
                            //   right: 8.0,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: [
                            //       GradientText(
                            //         '7 小时',
                            //         style: TextStyle(
                            //             color: Colors.white, fontSize: 14.0),
                            //         begin: Alignment.topLeft,
                            //         end: Alignment.bottomRight,
                            //         colors: _colors,
                            //       ),
                            //       Text(
                            //         'MOBA网游',
                            //         style: TextStyle(
                            //           color: Colors.white,
                            //           fontSize: 14.0,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 172.5,
                        height: 100.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: SingleImage(
                                defaultImageFile: _imageFile4,
                                onSelected: (file) {
                                  _imageFile4 = file;
                                },
                              ),
                            ),
                            Positioned(
                              left: 8.0,
                              top: 4.0,
                              child: Text(
                                'X 轴马达 振感细腻',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 8.0,
                              bottom: 4.0,
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final image = await _screenshotController.capture();
          if (image != null) {
            SaveImage.saveImage(image);
          }
        },
        child: const Icon(Icons.save_alt),
      ),
    );
  }
}

class SingleImage extends StatefulWidget {
  final ValueChanged<File>? onSelected;

  final File? defaultImageFile;

  const SingleImage({
    super.key,
    this.defaultImageFile,
    this.onSelected,
  });

  @override
  State<SingleImage> createState() => _SingleImageState();
}

class _SingleImageState extends State<SingleImage> {
  File? _imageFile;

  File? get defaultImageFile => widget.defaultImageFile;

  ValueChanged<File>? get onSelected => widget.onSelected;

  @override
  void initState() {
    super.initState();
    _imageFile = defaultImageFile;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
        if (result != null) {
          _imageFile = File(result.files.single.path!);
          safeSetState(() {});
          onSelected?.call(_imageFile!);
        }
      },
      child: Builder(
        builder: (context) {
          if (_imageFile != null) {
            return ExtendedImage.file(
              _imageFile!,
              fit: BoxFit.cover,
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            );
          } else {
            return Text('选择图片');
          }
        },
      ),
    );
  }
}

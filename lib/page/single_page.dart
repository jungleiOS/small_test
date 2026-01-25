import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:small_test/util/extensions.dart';

class SinglePage extends StatefulWidget {
  const SinglePage({super.key});

  static const routeName = 'single_page';

  @override
  State<SinglePage> createState() => _SinglePageState();
}

class _SinglePageState extends State<SinglePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single Page'),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          width: 375.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  text: TextSpan(
                    text: '真我Neo8',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: '续航巨无霸',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200.0,
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: SingleImage(),
                ),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: [
                    SizedBox(
                      width: 172.5,
                      height: 100.0,
                      child: SingleImage(),
                    ),
                    SizedBox(
                      width: 172.5,
                      height: 100.0,
                      child: SingleImage(),
                    ),
                    SizedBox(
                      width: 172.5,
                      height: 100.0,
                      child: SingleImage(),
                    ),
                    SizedBox(
                      width: 172.5,
                      height: 100.0,
                      child: SingleImage(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
            return Text('选者图片');
          }
        },
      ),
    );
  }
}

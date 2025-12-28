import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:small_test/component/image_gradient_background.dart';
import 'package:small_test/util/extensions.dart';

class InputImageWidget extends StatefulWidget {
  const InputImageWidget({super.key});

  @override
  State<InputImageWidget> createState() => _InputImageWidgetState();
}

class _InputImageWidgetState extends State<InputImageWidget> {
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return SizedBox(
        width: constraint.maxWidth,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              InkWell(
                onTap: _pickImage,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8.0))),
                  alignment: Alignment.center,
                  child: Icon(Icons.add),
                ),
              ),
              if (_imagePath != null)
                ImageGradientBackground(
                  gradientType: GradientType.leftToRight,
                  imageWidget: Image.file(
                    File(_imagePath!),
                    fit: BoxFit.contain,
                    width: constraint.maxWidth,
                    height: constraint.maxHeight,
                  ),
                ),
              Positioned(
                right: 8.0,
                top: 8.0,
                child: Offstage(
                  offstage: _imagePath == null,
                  child: TextButton(
                    onPressed: () {
                      _imagePath = null;
                      safeSetState((){});
                    },
                    child: Text('clear'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _pickImage() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (res != null) {
      _imagePath = res.files.first.path;
      safeSetState(() {});
    }
  }
}

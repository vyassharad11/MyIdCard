import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import '../screens/utils_crop.dart';

Future<CroppedFile> imageCropperFunc(filePath) async {
  CroppedFile? imageCropper = await ImageCropper().cropImage(
    sourcePath: filePath,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'MyDiCard Cropper',
        toolbarColor: Colors.blueGrey,
        toolbarWidgetColor: Colors.white,
        showCropGrid: true,
        cropStyle: CropStyle.rectangle,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPresetCustom(),
        ],
      ),
      IOSUiSettings(
        title: 'MyDiCard Cropper',
        cropStyle: CropStyle.rectangle,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          CropAspectRatioPresetCustom(),
        ],
      ),
    ],
  );
  return imageCropper ?? CroppedFile("$filePath");
}

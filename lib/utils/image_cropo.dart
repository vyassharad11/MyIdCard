import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import '../screens/utils_crop.dart';

Future<CroppedFile>  imageCropperFunc(filePath,{bool? isCompanyLogo = false,bool? isCircle = false}) async {
  print("isCompanyLogo>>>>>>>>>>>>>$isCompanyLogo");
  CroppedFile? imageCropper = await ImageCropper().cropImage(
    sourcePath: filePath,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'MyDiCard Cropper',
        toolbarColor: Colors.blueGrey,
        toolbarWidgetColor: Colors.white,
        showCropGrid: true,
        cropStyle:isCircle == false ?CropStyle.rectangle:CropStyle.circle,
        aspectRatioPresets:isCompanyLogo == false? [
           CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPresetCustom(),
        ]:
        [CropAspectRatioPreset.ratio3x2,CropAspectRatioPreset.square,],
      ),
      IOSUiSettings(
        title: 'MyDiCard Cropper',
        cropStyle:isCircle == false ?CropStyle.rectangle:CropStyle.circle,
        aspectRatioPresets: isCompanyLogo == false?[
           CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          CropAspectRatioPresetCustom(),
        ]:
        [CropAspectRatioPreset.ratio3x2,CropAspectRatioPreset.square,],
      ),
    ],
  );
  return imageCropper ?? CroppedFile("$filePath");
}

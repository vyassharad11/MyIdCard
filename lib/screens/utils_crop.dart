import 'package:image_cropper/image_cropper.dart';

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (3, 3);

  @override
  String get name => '3x3';
}

// import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';

import 'dart:io';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_di_card/bloc/cubit/contact_cubit.dart';
import 'package:my_di_card/data/repository/contact_repository.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../bloc/api_resp_state.dart';
import '../../models/utility_dto.dart';
import '../../utils/image_cropo.dart';
import '../../utils/utility.dart';
import '../../utils/widgets/network.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
class ScanQrCodeBottomSheet extends StatefulWidget {
  Function callBack;
   ScanQrCodeBottomSheet({super.key,required this.callBack});

  @override
  State<ScanQrCodeBottomSheet> createState() => _ScanQrCodeBottomSheetState();
}

class _ScanQrCodeBottomSheetState extends State<ScanQrCodeBottomSheet> {
  ContactCubit?_contactCubit;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

@override
  void initState() {
  _contactCubit = ContactCubit(ContactRepository());
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactCubit, ResponseState>(
      bloc:_contactCubit,
      listener: (context, state) {
        if (state is ResponseStateLoading) {
        } else if (state is ResponseStateEmpty) {
          Utility.hideLoader(context);
          Utility().showFlushBar(context: context, message: state.message,isError: true);
        } else if (state is ResponseStateNoInternet) {
          Utility.hideLoader(context);
          Utility().showFlushBar(context: context, message: state.message,isError: true);
        } else if (state is ResponseStateError) {
          Utility.hideLoader(context);
          Utility().showFlushBar(context: context, message: state.errorMessage,isError: true);
        } else if (state is ResponseStateSuccess) {
          var dto = state.data as UtilityDto;
          Utility.hideLoader(context);
          Navigator.pop(context);
          Utility().showFlushBar(context: context, message: dto.message ?? "");
        }
        setState(() {});
      },
      child: Container(
       constraints: BoxConstraints(minHeight: 500,maxHeight: MediaQuery.of(context).size.height - 100),
        child: Padding(
          padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,top: 16,left: 16,right: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        children: [
                          const Text(
                            softWrap: true,
                            'Scan ',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            softWrap: true,
                            'QR Code',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontSize: 22,
                              color: ColoursUtils.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const Text(
                            softWrap: true,
                            'to add in your Contacts',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                          height: 30,
                          width: 30,
                          margin: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(22)),
                          child: const Icon(
                            Icons.clear,
                            size: 18,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                InkWell(       onTap:() async {
                  // scanQR();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => AiBarcodeScanner(
                        onDispose: () {
                    /// This is called when the barcode scanner is disposed.
                    /// You can write your own logic here.
                    debugPrint("Barcode scanner disposed!");
                },
                  hideGalleryButton: false,
                  controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.noDuplicates,
                  ),
                  onDetect: (BarcodeCapture capture) {
                  /// The row string scanned barcode value
                  final String? scannedValue =
                  capture.barcodes.first.rawValue;
                  RegExp regExp = RegExp(r"(\d+)$");
                  String? extractedNumber = regExp.firstMatch(scannedValue ?? "")?.group(0);
                  Navigator.pop(context,);
                  widget.callBack.call(extractedNumber);
                  debugPrint("Barcode scanned: $extractedNumber");

                  /// The `Uint8List` image is only available if `returnImage` is set to `true`.
                  // final Uint8List? image = capture.image;
                  // debugPrint("Barcode image: $image");

                  /// row data of the barcode
                  final Object? raw = capture.raw;
                  debugPrint("Barcode raw: $raw");

                  /// List of scanned barcodes if any
                  final List<Barcode> barcodes = capture.barcodes;
                  debugPrint("Barcode list: $barcodes");
                  },
                  validator: (value) {
                  if (value.barcodes.isEmpty) {
                  return false;
                  }
                  if (!(value.barcodes.first.rawValue
                      ?.contains('flutter.dev') ??
                  false)) {
                  return false;
                  }
                  return true;
                  })));
                  },
                  child: const Center(
                    child: Icon(
                      Icons.qr_code_2, // QR Code Icon
                      size: 120,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'or',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                // Scan Physical Card
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scan ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      ' Physical Card',
                      style: TextStyle(
                        fontSize: 18,
                        color: ColoursUtils.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // First Name Input
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            labelText: 'First Name',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Last Name Input
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 20),
                    child: InkWell(
                      onTap: (){
                        _showBottomSheet(context);
                      },
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _selectedImage != null &&
                                _selectedImage!.path.isNotEmpty &&
                                !_selectedImage!.path
                                    .contains("storage")
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  50), // Adjust the radius as needed
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: MediaQuery.sizeOf(context)
                                    .width /
                                    1.1,
                                height: 80,
                              ),
                            )
                                : _selectedImage != null &&
                                _selectedImage!.path.isNotEmpty &&
                                _selectedImage!.path
                                    .contains("storage")
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  50), // Adjust the radius as needed
                              child: Image.network(
                                "${Network.imgUrl}${_selectedImage!.path}",
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                            )
                                :
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Top + Icon
                                CircleAvatar(
                                  radius: 18,
                                  child: Image.asset("assets/images/add button.png"),
                                ),
                                const SizedBox(
                                    height: 20), // Space between icon and text
                                // Text below the icon
                                const Text(
                                  'Upload Physical Card',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(
                                    height: 4), // Space between icon and text
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                 Container(
                     margin: const EdgeInsets.symmetric(horizontal: 2),
                     child: SizedBox(
                       height: 45,
                       width: MediaQuery.of(context).size.width,
                       child: ElevatedButton(
                         // iconAlignment: IconAlignment.start,
                         onPressed: () {
                           if(firstNameController.text.isNotEmpty && lastNameController.text.isNotEmpty && _selectedImage != null){
                           Utility.showLoader(context);
                           submitData(firstName: firstNameController.text,context: context,lastName: lastNameController.text,cardImage: _selectedImage ?? File(""));}
                           else{
                             Utility().showFlushBar(context: context, message: "please fill all field",isError: true);
                           }
                           // Handle button press
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.blue, // Background color
                           shape: RoundedRectangleBorder(
                             borderRadius:
                             BorderRadius.circular(30), // Rounded corners
                           ),
                         ),
                         child: const Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Text(
                               "Continue", // Right side text
                               style: TextStyle(color: Colors.white, fontSize: 16),
                             ),
                           ],
                         ),
                       ),
                     ),),
                 const SizedBox(
                  height: 20,
                ),

                // Upload Physical Card Button
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitData({
    required String firstName,
    required String lastName,
    required BuildContext context,
    required File cardImage, // Card image file
  }) async {
    var data=null;
    if (!cardImage.path.contains("storage")) {
      data = FormData.fromMap({
        if(_selectedImage != null && cardImage.path.isNotEmpty)  'card_image':
        await MultipartFile.fromFile(cardImage.path, filename: "demo.png")
        ,
        'first_name': firstName,
        'last_name': lastName
      });
    }else{
      data = FormData.fromMap({
        'first_name': firstName,
        'last_name': lastName
      });
    }
    _contactCubit?.apiAddPhysicalCard(data);
  }

  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;

// Function to handle image selection
  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop(); // Close the bottom sheet

    // Request permission

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      final permissionStatus = source == ImageSource.camera
          ? await Permission.camera.request()
          : androidInfo.version.sdkInt <= 32
          ? await Permission.storage.request()
          : await Permission.photos.request();

      if (permissionStatus.isGranted) {
        try {
          final XFile? pickedFile = await _picker.pickImage(
            source: source,
            preferredCameraDevice: CameraDevice.front,
          );
          if (pickedFile != null) {
            final value = await imageCropperFunc(pickedFile.path);
            setState(() {
              _selectedImage = File(value.path);
            });
            debugPrint("Image Path: ${pickedFile.path}");
          }
        } catch (e) {
          debugPrint("Error picking image: $e");
        }
      } else {
        debugPrint("Permission denied.");
        await Permission.photos.request();
        _showPermissionDeniedMessage();
      }
    } else if (Platform.isIOS) {
      final permissionStatus = source == ImageSource.camera
          ? await Permission.camera.request()
          : await Permission.photos.request();
      if (permissionStatus.isGranted) {
        try {
          final XFile? pickedFile = await _picker.pickImage(
            source: source,
            preferredCameraDevice: CameraDevice.front,
          );
          if (pickedFile != null) {
            final value = await imageCropperFunc(pickedFile.path);
            setState(() {
              _selectedImage = File(value.path);
            });
            debugPrint("Image Path: ${pickedFile.path}");
          }
        } catch (e) {
          debugPrint("Error picking image: $e");
        }
      } else {
        debugPrint("Permission denied.");
        _showPermissionDeniedMessage();
      }
    }
  }

  // Function to show permission denied message
  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Permission denied. Please enable it from settings.'),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Option for using the camera
              ListTile(
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 10,
                leading: Image.asset(
                  "assets/images/camera-01.png",
                  width: 20,
                  height: 20,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: const Text('Use Camera'),
                ),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  // Add your logic for opening the camera
                },
              ),
              const Divider(
                color: Colors.grey,
              ),
              // Option for choosing from the library
              ListTile(
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 10,
                leading: Image.asset(
                  "assets/images/image-plus.png",
                  width: 20,
                  height: 20,
                ),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: const Text('Choose from Library'),
                ),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  // Add your logic for picking an image from the gallery
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

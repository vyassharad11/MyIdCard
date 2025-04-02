import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/localStorage/storage.dart';
import 'package:my_di_card/screens/utils_crop.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:my_di_card/utils/common_utils.dart';
import 'package:my_di_card/utils/widgets/network.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/auth_cubit.dart';
import '../../data/repository/auth_repository.dart';
import '../../models/signup_dto.dart';
import '../../models/user_data_model.dart';
import '../../utils/utility.dart';



class EditProfile extends StatefulWidget {
  User? user;
   EditProfile(
      {super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  AuthCubit? _completeProfileCubit;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, ResponseState>(
      bloc: _completeProfileCubit,
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
          Utility.hideLoader(context);
          var dto = state.data as SignupDto;
          if(dto.data != null) {
            Storage().saveUserToPreferences(dto.data as User);
          }
          Navigator.pop(context,2);
          Utility().showFlushBar(context: context, message: "Profile Update Successfully");
        }
        setState(() {});
      },
      child: GestureDetector(
        onTap: CommonUtils.closeKeyBoard,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pop(),
                        // showDeleteDialog(context), // Default action: Go back
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 2,
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.arrow_back,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Edit Profile",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        final isShowRemovePhoto = _selectedImage != null &&
                            _selectedImage!.path.isNotEmpty &&
                            (!_selectedImage!.path.contains("storage") ||
                                _selectedImage!.path.contains("storage"));
                        _showBottomSheet(context, isShowRemovePhoto);
                      },
                      child: Stack(
                        children: [
                          // Rounded user icon with grey background
                          _selectedImage != null &&
                              _selectedImage!.path.isNotEmpty &&
                              !_selectedImage!.path.contains("storage")
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                                50), // Adjust the radius as needed
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                            ),
                          )
                              : _selectedImage != null &&
                              _selectedImage!.path.isNotEmpty &&
                              _selectedImage!.path.contains("storage")
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
                              : Container(
                            width: 80, // Adjust the size as needed
                            height: 80,
                            decoration: BoxDecoration(
                              color: ColoursUtils
                                  .background, // Grey background color
                              shape: BoxShape.circle, // Circular shape
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(22.0),
                              child: Image.asset(
                                "assets/images/user.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          // Positioned plus icon at the bottom right corner
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors
                                    .blue, // Background color of the plus icon
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors
                                      .white, // White border around the plus icon
                                  width: 3,
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(
                                    4.0), // Padding around the plus icon
                                child: Icon(
                                  Icons.add, // Plus icon
                                  size: 12, // Size of the plus icon
                                  color: Colors.white, // Color of the plus icon
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Profile Picture",
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  bottomSheetDropdown(context),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: ColoursUtils.background, // Light white color
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: firstname,
                      decoration: const InputDecoration(
                        hintText: 'First Name *',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: ColoursUtils.background, // Light white color
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: lastName,
                      decoration: const InputDecoration(
                        hintText: 'Last Name *',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    // margin: const EdgeInsets.symmetric(horizontal: 0),
                    child: SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        // iconAlignment: IconAlignment.start,
                        onPressed: () {
                          if (firstname.text.isNotEmpty) {
                            if (lastName.text.isNotEmpty) {
                                Utility.showLoader(context);
                                submitData(
                                    cardImage:
                                    _selectedImage ?? File("invalidpath"),
                                    firstName: firstname.text,
                                    lastName: lastName.text,
                                    teamCode: teamCode.text);
                            } else {
                              Fluttertoast.showToast(msg: "Please Enter Last Name");
                            }
                          } else {
                            Fluttertoast.showToast(msg: "Please Enter First Name");
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _completeProfileCubit = AuthCubit(AuthRepository());
    fetchLoginUserData();

    super.initState();
  }

  @override
  void dispose() {
    _completeProfileCubit?.close();
    _completeProfileCubit = null;
    if (firstname.text.isEmpty || lastName.text.isEmpty) {
      Storage().removeTokenFromPreferences();
    }
    super.dispose();
  }

  TextEditingController teamCode = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastName = TextEditingController();


  Future<void> fetchLoginUserData() async {
    try {
      if (widget.user != null) {
        setState(() {
          firstname.text = widget.user?.firstName ?? '';
          // selectedLanguag = widget.user?.la ?? '';
          lastName.text = widget.user?.lastName ?? '';
          _selectedImage =
          widget.user?.avatar != null ? File(widget.user?.avatar) : null;
        });
      }
    } catch (error) {
      // Handle any exceptions
      debugPrint("fetchLoginUserData Error: $error");
    }
  }


  Future<void> submitData({  String? teamCode,
    required String firstName,
    required String lastName,
    required File cardImage,}) async
  {
    // Map<String, dynamic> data = {
    //   'first_name': firstName.toString().trim(),
    //   'last_name': lastName.toString(),
    //   'team_code': teamCode.toString()
    // };
    var data=null;

    if (!cardImage.path.contains("storage")) {
      data =  FormData.fromMap({
        if(_selectedImage != null && cardImage.path.isNotEmpty ) 'avatar':
        await MultipartFile.fromFile(cardImage.path, filename: "demo.png")
        ,
        'first_name': firstName.toString().trim(),
        'last_name': lastName.toString(),
        'team_code': teamCode.toString(),
        'language_id': selectedLanguage == 'French'?"2":"1"
      });
    }else{
      data = FormData.fromMap({
        'first_name': firstName.toString().trim(),
        'last_name': lastName.toString(),
        'team_code': teamCode.toString(),
        'language_id': selectedLanguage == 'French'?"2":"1"
      });
    }

    _completeProfileCubit?.completeProfileApiNew(data,);
  }


  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Card'),
          content: Text('Are you sure you want to delete this card?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform delete action here
                // Navigator.of(context).pop();
                Navigator.pop(context);

                // deleteCardApiCalling();
                // Close the dialog
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

String selectedLanguage = "";
  Widget bottomSheetDropdown(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          builder: (BuildContext context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Select any language',
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text(
                    'English',
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    setState(() {
                      // _selectedValue = 'English';
                      // _selectedLanguageId = '1';
                      selectedLanguage = 'English';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(
                    'French',
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    setState(() {
                      // _selectedValue = 'French';
                      // _selectedLanguageId = '2';
                      selectedLanguage = 'French';
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white70, width: 1),
          color: ColoursUtils.background,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedLanguage.isEmpty ? "Select Language" : selectedLanguage,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                // color: title.isEmpty ? Colors.grey[500] : Colors.black,
              ),
            ),
            Image.asset(
              "assets/images/chevron-down.png",
              height: 20,
              width: 20,
            ),
          ],
        ),
      ),
    );
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
            final value = await imageCroperFunc(pickedFile.path);
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
            final value = await imageCroperFunc(pickedFile.path);
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

  Future<CroppedFile> imageCroperFunc(filePath) async {
    CroppedFile? imageCropper = await ImageCropper().cropImage(
      sourcePath: filePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'MyDicard Croper',
          toolbarColor: Colors.blueGrey,
          toolbarWidgetColor: Colors.white,
          showCropGrid: false,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'MyDicard Croper',
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          ],
        ),
      ],
    );
    return imageCropper ?? CroppedFile("$filePath");
  }

  // Function to show permission denied message
  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Permission denied. Please enable it from settings.'),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, bool isShowRemovePhoto) {
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
              if(isShowRemovePhoto) ...[
                const Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 10,
                  leading: Icon(Icons.delete_outline_outlined, color: Colors.black,),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: const Text('Remove Picture'),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedImage = null;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

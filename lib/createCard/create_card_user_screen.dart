import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

import '../language/app_localizations.dart';
import '../models/ard_id.dart';
import '../models/card_get_model.dart';
import '../utils/utility.dart';
import 'create_card_company_screen.dart';

class CreateCardScreen1 extends StatefulWidget {
  final bool isEdit;
  final String cardId;
  const CreateCardScreen1(
      {super.key, required this.isEdit, required this.cardId});

  @override
  State<CreateCardScreen1> createState() => _CreateCardScreen1State();
}

class _CreateCardScreen1State extends State<CreateCardScreen1> {
  String _selectedValue = "English";
  String title = "English";
  String _selectedLanguageId = "1";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                        AppLocalizations.of(context)
                            .translate('createCardOn'),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 3,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Container(
                      width: 10,
                      height: 3,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Container(
                      width: 10,
                      height: 3,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Container(
                      width: 10,
                      height: 3,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Container(
                      width: 10,
                      height: 3,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('personal'),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
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
                    AppLocalizations.of(context)
                        .translate('profilePicture'),
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
                    maxLength: 15,
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
                    maxLength: 15,
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
                            if (widget.isEdit) {
                              Utility.showLoader(context);

                              submitData(
                                cardId: widget.cardId.toString(),
                                cardImage: _selectedImage ?? File(""),
                                firstName: firstname.text.trim(),
                                lastName: lastName.text.trim(),
                                languageId: _selectedLanguageId.toString(),
                              );
                            } else {
                              Utility.showLoader(context);

                              getUserId(
                                  languageId: _selectedLanguageId.toString(),
                                  firstName: firstname.text.trim(),
                                  lastName: lastName.text.trim(),
                                  cardImage: _selectedImage ?? File(""));
                            }
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
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate('continue'), // Right side text
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
    );
  }

  @override
  void initState() {
    if (widget.isEdit) {
      fetchEditData();
    } else {
      fetchLoginUserData();
    }
    super.initState();
  }

  TextEditingController teamCode = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastName = TextEditingController();

String cardImageF = "";

  Future<void> fetchEditData() async {
    var token = await Storage().getToken();
    String apiUrl =
        "${Network.baseUrl}card/get/${widget.cardId}"; // Replace with your API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
         Utility.hideLoader(context);

        // Successfully fetched data
        final jsonResponse = jsonDecode(response.body);

        GetCardModel getCardModel = GetCardModel.fromJson(jsonResponse);
        setState(() {
          firstname.text = getCardModel.data?.firstName ?? "";
          lastName.text = getCardModel.data?.lastName ?? "";
          cardImageF = getCardModel.data?.cardImage ?? "";
          _selectedLanguageId = getCardModel.data?.languageId?.toString() ?? "";
          if (getCardModel.data?.cardImage != null) {
            debugPrint("${getCardModel.data?.cardImage}");
            _selectedImage = File(getCardModel.data?.cardImage);
          }
        });

        debugPrint("Data fetched successfully: $getCardModel");
      } else {
         Utility.hideLoader(context);

        // Handle error response
        debugPrint("Failed to fetch data. Status Code: ${response.statusCode}");
        debugPrint("Error: ${response.body}");
      }
    } catch (error) {
       Utility.hideLoader(context);

      // Handle any exceptions
      debugPrint("An error occurred: $error");
    }
  }

  Future<void> fetchLoginUserData() async {
    try {
      final loginUser = await Storage().getUserFromPreferences();
      debugPrint("loginUser : ${loginUser?.toJson()}");
      if (loginUser != null) {
        setState(() {
          firstname.text = loginUser.firstName ?? '';
          lastName.text = loginUser.lastName ?? '';
          _selectedImage =
          loginUser.avatar != null ? File(loginUser.avatar) : null;
        });
      }
    } catch (error) {
      // Handle any exceptions
      debugPrint("fetchLoginUserData Error: $error");
    }
  }

  Future<void> submitData({
    required String languageId,
    required String cardId,
    required String firstName,
    required String lastName,
    required File cardImage, // Card image file
  }) async {
    var token = await Storage().getToken();

    String apiUrl =
        "${Network.baseUrl}card/update/$cardId"; // Replace with your API endpoint

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add fields to the request
      request.fields['step_no'] = "1";
      request.fields['language_id'] = languageId;
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;

      // Add the image to the request
      if (cardImage.path != "" && !cardImage.path.contains("storage")) {
        var file = await http.MultipartFile.fromPath(
          'card_image',
          cardImage.path,
        );

        debugPrint("${cardImage.path}---");

        request.files.add(file);
      }

      // Add headers, including Authorization token
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        // final responseData = await response.stream.bytesToString();
        // final data = jsonDecode(responseData);
         Utility.hideLoader(context);
        await Storage().setFirstCardSkip(true);
        debugPrint("Data submitted successfully:");
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (builder) => CreateCardScreen2(
              cardId: cardId,
              isEdit: widget.isEdit,
            ),
          ),
        );
      } else {
         Utility.hideLoader(context);

        debugPrint("Failed to submit data. Status Code: ${response.statusCode}");
      }
    } catch (error) {
       Utility.hideLoader(context);

      debugPrint("An error occurred: $error");
    }
  }

  Future<void> getUserId(
      {required String languageId,
      required String firstName,
      required String lastName,
      required File cardImage}) async {
    var token = await Storage().getToken();

    const String apiUrl =
        "${Network.baseUrl}card/store"; // Replace with your API endpoint

    try {
      // Prepare the multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..fields['language_id'] = languageId.toString()
        ..fields['first_name'] = firstName
        ..fields['last_name'] = lastName
        ..headers.addAll({
          'Authorization': 'Bearer $token', // Add your authorization token
        });

      // Send the request
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        GetCardId getCardId = GetCardId.fromJson(data);

        submitData(
            cardId: getCardId.data!.id.toString(),
            cardImage: cardImage,
            firstName: firstName,
            lastName: lastName,
            languageId: languageId.toString());
        debugPrint("Data submitted successfully: $data");
      } else {
        debugPrint("Failed to submit data. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      debugPrint("An error occurred: $error");
    }
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

  Future<void> deleteCardApiCalling() async {
    if (widget.cardId.isNotEmpty) {
      Utility.showLoader(context);
      var url =
          "${Network.baseUrl}card/destroy/${widget.cardId.toString()}"; // Replace with your API endpoint

      var token = await Storage().getToken();

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          FocusManager.instance.primaryFocus?.unfocus();

           Utility.hideLoader(context);
          Fluttertoast.showToast(
              msg: "Card Delection successfully",
              toastLength: Toast.LENGTH_LONG,
              textColor: Colors.white,
              backgroundColor: Colors.green);
          Navigator.pop(context);
        } else {
           Utility.hideLoader(context);
          Fluttertoast.showToast(
              msg: "Card Delection Failed",
              toastLength: Toast.LENGTH_LONG,
              textColor: Colors.white,
              backgroundColor: Colors.grey);
          debugPrint('Failed to register: ${response.statusCode}');
          debugPrint('Response: ${response.body}');
          Navigator.of(context).pop();
        }
      } catch (e) {
         Utility.hideLoader(context);
        Fluttertoast.showToast(
            msg: "Card Delection Failed",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.white,
            backgroundColor: Colors.grey);
        Navigator.of(context).pop();
        debugPrint('Error: $e');
      }
    } else {
      Navigator.pop(context);
    }
  }

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
                    AppLocalizations.of(context)
                        .translate('selectAnyLanguage'),
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
                      _selectedValue = 'English';
                      _selectedLanguageId = '1';
                      title = 'English';
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
                      _selectedValue = 'French';
                      _selectedLanguageId = '2';
                      title = 'French';
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
              title.isEmpty ?   AppLocalizations.of(context)
                  .translate('selectLanguage') : title,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: title.isEmpty ? Colors.grey[500] : Colors.black,
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
       SnackBar(
        content: Text(  AppLocalizations.of(context)
            .translate('permissionText')),
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
                  child:  Text(  AppLocalizations.of(context)
                      .translate('useCamera')),
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
                  child:  Text(AppLocalizations.of(context)
                      .translate('chooseFromLibrary')),
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
                    child:  Text(AppLocalizations.of(context)
                        .translate('removePicture')),
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

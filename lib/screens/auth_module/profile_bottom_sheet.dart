import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/models/user_data_model.dart';
import 'package:my_di_card/utils/common_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../language/app_localizations.dart';
import '../../localStorage/storage.dart';
import '../../utils/colors/colors.dart';
import '../../utils/image_cropo.dart';
import '../../utils/url_lancher.dart';
import '../../utils/widgets/button_primary.dart';
import '../../utils/widgets/network.dart';
import '../home_module/first_card.dart';

class ProfileBottomSheet extends StatefulWidget {
  const ProfileBottomSheet({super.key});

  @override
  State<ProfileBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<ProfileBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  bool agreeToTerms = false;
  bool agreeToPrivacy = false;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  TextEditingController teamCode = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastName = TextEditingController();

  Future<void> submitData({
    String? teamCode,
    required String firstName,
    required String lastName,
    required File cardImage, // Card image file
  }) async {
    context.loaderOverlay.show();
    String token = await Storage().getToken();

    const String apiUrl =
        "${Network.baseUrl}user/complete-profile"; // Replace with your API endpoint

    try {
      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields.addAll({
        'first_name': firstName.toString().trim(),
        'last_name': lastName.toString(),
        'team_code': teamCode.toString()
      });
      if (_selectedImage != null && _selectedImage!.path.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('avatar', cardImage.path));
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        context.loaderOverlay.hide();
        final data = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(data);
        final userData = User.fromJson(jsonResponse['data']);
        Storage().saveUserToPreferences(userData);
        debugPrint("Data submitted successfully: $data");
        Navigator.push(context,
            CupertinoPageRoute(builder: (builder) => FirstCardScreen()));
      } else {
        debugPrint("Failed to submit data. Status Code: ${response.statusCode}");
        context.loaderOverlay.hide();

        print(response.reasonPhrase);
      }

      // Handle the response
    } catch (error) {
      context.loaderOverlay.hide();

      debugPrint("An error occurred: $error");
    }
  }

  @override
  void dispose() {
    if (firstname.text.isEmpty || lastName.text.isEmpty) {
      Storage().removeTokenFromPreferences();
    }
    super.dispose();
  }

  @override
  void deactivate() {
    if (firstname.text.isEmpty || lastName.text.isEmpty) {
      Storage().removeTokenFromPreferences();
    }
    super.deactivate();
  }

  @override
  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
        ),
        child: GestureDetector(
          onTap: CommonUtils.closeKeyBoard,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context).translate('complteProfile'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _showBottomSheet(context),
                      child: Center(
                        child: _selectedImage != null &&
                                _selectedImage!.path.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    50), // Adjust the radius as needed
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                  width: 65,
                                  height: 65,
                                ),
                              )
                            : CircleAvatar(
                                radius: 65,
                                backgroundColor: ColoursUtils.background,
                                child: Image.asset(
                                  "assets/images/Icon.png",
                                  width: 30,
                                  height: 30,
                                )),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(AppLocalizations.of(context).translate('firstName')),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: firstname,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('EnterfirstName'),
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          borderSide: BorderSide(color: Colors.white, width: 0),
                        ),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(width: 0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(14))),
                        alignLabelWithHint: true,
                        fillColor: ColoursUtils.background,
                        hintStyle: TextStyle(
                            color: ColoursUtils.greyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Text(AppLocalizations.of(context).translate('lastName')),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: lastName,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('EnterlastName'),
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          borderSide: BorderSide(color: Colors.white, width: 0),
                        ),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(width: 0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(14))),
                        alignLabelWithHint: true,
                        fillColor: ColoursUtils.background,
                        hintStyle: TextStyle(
                            color: ColoursUtils.greyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(AppLocalizations.of(context).translate('teamCode')),
                    const SizedBox(height: 4),
                    TextField(
                      controller: teamCode,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate('EnterteamCode'),
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          borderSide: BorderSide(color: Colors.white, width: 0),
                        ),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(width: 0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(14))),
                        alignLabelWithHint: true,
                        fillColor: ColoursUtils.background,
                        hintStyle: TextStyle(
                            color: ColoursUtils.greyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const SizedBox(
                          width: 6,
                        ),
                        SizedBox(
                            width: 16,
                            height: 16,
                            child: Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Colors.white,
                                ),
                                child: Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    side: const BorderSide(
                                        color: Colors.grey,
                                        style: BorderStyle.solid,
                                        width: 1),
                                    value: agreeToTerms,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        agreeToTerms = value!;
                                      });
                                    }))),
                        const SizedBox(
                          width: 12,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'I agree to ',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: 'Terms and Condition',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrlGet(
                                      "${Network.baseUrlLaunch}terms-conditions",
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const SizedBox(width: 6),
                        SizedBox(
                            width: 16,
                            height: 16,
                            child: Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Colors.white,
                                ),
                                child: Checkbox(
                                    shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: const BorderSide(
                                color: Colors.grey,
                                        style: BorderStyle.solid,
                                width: 1,
                              ),
                              value: agreeToPrivacy,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        agreeToPrivacy = value!;
                                      });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'I agree to ',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrlGet(
                                      "${Network.baseUrlLaunch}privacy-policy",
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Utils().primaryButton(
                        onClick: () {
                          if (_formKey.currentState!.validate()) {
                            if (agreeToTerms && agreeToPrivacy) {
                              submitData(
                                  cardImage:
                                      _selectedImage ?? File("invalidpath"),
                                  firstName: firstname.text,
                                  lastName: lastName.text,
                                  teamCode: teamCode.text);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please accept privacy and conditions",
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG);
                            }

                            // Perform the submission logic here
                          } else {
                            // Show a message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please fill all fields and agree to terms')),
                            );
                          }
                        },
                        text: "Next"),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              source: source, preferredCameraDevice: CameraDevice.front);
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
    } else if (Platform.isIOS) {
      final permissionStatus = source == ImageSource.camera
          ? await Permission.camera.request()
          : await Permission.photos.request();
      if (permissionStatus.isGranted) {
        try {
          final XFile? pickedFile = await _picker.pickImage(
              source: source, preferredCameraDevice: CameraDevice.front);
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
                title: const Text('Use Camera'),
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
                title: const Text('Choose from Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  // Add your logic for picking an image from the gallery
                },
              ),
              if(_selectedImage != null) ...[
                const Divider(color: Colors.grey),
                // Remove Picture
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 10,
                  leading: Icon(Icons.delete_outline, color: Colors.black),
                  title: const Text('Remove Picture'),
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

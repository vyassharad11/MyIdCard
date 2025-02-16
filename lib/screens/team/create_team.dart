import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/bloc/cubit/card_cubit.dart';
import 'package:my_di_card/bloc/cubit/team_cubit.dart';
import 'package:my_di_card/data/repository/card_repository.dart';
import 'package:my_di_card/data/repository/team_repository.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../bloc/api_resp_state.dart';
import '../../localStorage/storage.dart';
import '../../models/utility_dto.dart';
import '../../utils/image_cropo.dart';
import '../../utils/utility.dart';
import '../../utils/widgets/network.dart';

class CreateTeamPage extends StatefulWidget {
  const CreateTeamPage({super.key});

  @override
  State<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  final title = TextEditingController();
  final description = TextEditingController();
  TeamCubit? createTeamCubit;
  
  @override
  void initState() {
    createTeamCubit = TeamCubit(TeamRepository());
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    title.clear();
    createTeamCubit?.close();
    createTeamCubit = null;
    description.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeamCubit, ResponseState>(
      bloc:createTeamCubit,
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
      child: Scaffold(
        backgroundColor: ColoursUtils.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.pop(context), // Default action: Go back
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
                    const SizedBox(
                      width: 12,
                    ),
                    Center(
                      child: Text(
                        "Create Team",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Team Name',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextField(
                          controller: title,
                          decoration: InputDecoration(
                            // labelText: 'Team Name',
      
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 16),
                            filled: true,
                            hintText: "Team Name",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Description',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        // Description Input
                        TextField(
                          maxLines: 3,
                          controller: description,
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 16),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            filled: true,
                            hintText: "Description",
                            alignLabelWithHint: false,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Logo',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        // Logo Upload Section
                        DottedBorder(
                          color: Colors.grey.shade300,
                          strokeWidth: 1,
                          dashPattern: [6, 3], // Customize the dash pattern
                          borderType: BorderType.RRect,
                          radius: Radius.circular(8),
                          child: SizedBox(
                            height: 120,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context);
                                },
                                child: Stack(
                                  children: [
                                    // Rounded user icon with grey background
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
                                            : Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/upload.png",
                                                      height: 45,
                                                      width: 45,
                                                    ),
                                                    // Icon(Icons.cloud_upload, color: Colors.grey),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      'Upload Logo',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.grey.shade100,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.grey.shade300, width: 1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {
                                  submitData(
                                      cardImage: _selectedImage ?? File(""),
                                      description: description.text,
                                      title: title.text);
                                },
                                child: const Text('Create'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                // Team Name Input
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitData({
    required String title,
    required String description,
    required File cardImage, // Card image file
  }) async {
    Utility.showLoader(context);
    Map<String, dynamic> data = {
    'team_name' : title,
    'team_description' : description,
  };
    // Add the image to the request
    // if (!cardImage.path.contains("storage")) {
    //   var file = await http.MultipartFile.fromPath(
    //     'team_logo',
    //     cardImage.path,
    //   );
    createTeamCubit?.apiCreateUpdateTeam(data,"11");
      
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
            // setState(() {
            //   _selectedImage = File(pickedFile.path);
            // });
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
            // setState(() {
            //   _selectedImage = File(pickedFile.path);
            // });
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

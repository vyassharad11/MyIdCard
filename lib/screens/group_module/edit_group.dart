import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/data/repository/group_repository.dart';
import 'package:my_di_card/localStorage/storage.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:my_di_card/utils/widgets/network.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/group_cubit.dart';
import '../../models/group_response.dart';
import '../../utils/utility.dart';

class EditGroupPage extends StatefulWidget {
  const EditGroupPage({super.key});

  @override
  State<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  String selecteValie = "Member";
  GroupCubit? _editGroup,getGroupCubit;
  GroupDataModel? groupDataModel;

  final title = TextEditingController();
  final description = TextEditingController();

@override
  void initState() {
  _editGroup = GroupCubit(GroupRepository());
  getGroupCubit = GroupCubit(GroupRepository());
  fetchGroupData();
    // TODO: implement initState
    super.initState();
  }


  Future<void> fetchGroupData() async {
  Utility.showLoader(context);
    getGroupCubit?.apiGetGroupDetails("15");
  }

  Future<void> editGroup() async {
  Utility.showLoader(context);
    Map<String, dynamic> data = {
      'group_name': title.text,
      'admin_id': "1",
      'group_description': description.text,

    };
    _editGroup?.apiUpdateGroup(data,"15");
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GroupCubit, ResponseState>(
          bloc: getGroupCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              Utility.hideLoader(context);
            } else if (state is ResponseStateNoInternet) {
              Utility.hideLoader(context);
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as GroupDataModel;
              groupDataModel = dto;
              title.text = groupDataModel?.data?.groupName ?? "";
              description.text = groupDataModel?.data?.groupDescription ?? "";
            }
            setState(() {});
          },
        ),
        BlocListener<GroupCubit, ResponseState>(
          bloc: _editGroup,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
            } else if (state is ResponseStateNoInternet) {
              Utility.hideLoader(context);
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
             Navigator.pop(context);
            }
            setState(() {});
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ColoursUtils.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            children: [
              // Team Name Input
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
                      "Edit Group",
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
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Group Name',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      TextField(controller: title,
                        onChanged: (v){
                        setState(() {

                        });
                        },
                        decoration: InputDecoration(
                          // labelText: 'Team Name',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                          filled: true,
                          hintText: "Group Name",
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          fillColor: ColoursUtils.background,
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
                        onChanged: (v){
                          setState(() {

                          });
                        },
                        controller: description,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          filled: true,
                          hintText: "Description",
                          alignLabelWithHint: false,
                          fillColor: ColoursUtils.background,
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
                                            width:
                                                MediaQuery.sizeOf(context).width /
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
                              onPressed: () {Navigator.pop(context);},
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
                                editGroup();
                              },
                              child: const Text('Save'),
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
              const SizedBox(height: 14),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Members & Roles',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Search Box
                      TextField(
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: ColoursUtils.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // List of Members
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height / 2,
                        child: ListView.builder(
                          itemCount: 10,
                          padding: EdgeInsets.only(),
                          itemBuilder: (ctx, index) {
                            return CustomRowWidget(
                              description: "Product Manager with vialinms",
                              imageUrl: "asd",
                              onDelete: () {},
                              onRoleChanged: (value) {
                                setState(() {
                                  selecteValie = value;
                                });
                              },
                              title: "Delbert Wyman",
                              initialRole: selecteValie,
                            );
                          },
                          physics: AlwaysScrollableScrollPhysics(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
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

    var token = await Storage().getToken();

    String apiUrl =
        "${Network.baseUrl}card/update/"; // Replace with your API endpoint

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add fields to the request

      request.fields['title'] = title;
      request.fields['description'] = description;

      // Add the image to the request
      if (!cardImage.path.contains("storage")) {
        var file = await http.MultipartFile.fromPath(
          'logo',
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
         Utility.hideLoader(context);

        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
         Utility.hideLoader(context);

        debugPrint("Data submitted successfully: $data");
      } else {
        debugPrint("Failed to submit data. Status Code: ${response.statusCode}");
      }
    } catch (error) {
       Utility.hideLoader(context);

      debugPrint("An error occurred: $error");
    }
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
            setState(() {
              _selectedImage = File(pickedFile.path);
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
            setState(() {
              _selectedImage = File(pickedFile.path);
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

class CustomRowWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String initialRole;
  final Function(String) onRoleChanged;
  final VoidCallback onDelete;

  const CustomRowWidget({super.key, 
    required this.imageUrl,
    required this.title,
    required this.description,
    this.initialRole = "Member",
    required this.onRoleChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circle Image
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: Colors.grey.shade200,
          ),
          const SizedBox(width: 16),

          // Title and Description Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Dropdown for Role Selection
          DropdownButton<String>(
            value: initialRole,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.blue,
              size: 16,
            ),
            underline: SizedBox(),
            items: ["Admin", "Member"].map((String role) {
              return DropdownMenuItem<String>(
                value: role,
                child: Text(
                  role,
                  style: TextStyle(color: Colors.blue, fontSize: 12),
                ),
              );
            }).toList(),
            onChanged: (String? newRole) {
              if (newRole != null) onRoleChanged(newRole);
            },
          ),

          // const SizedBox(width: 16),

          // Delete Icon
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: onDelete,
            iconSize: 16,
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class MemberTile extends StatefulWidget {
  final String name;
  final String role;
  final bool isRemovable;

  const MemberTile(
      {super.key, required this.name, required this.role, this.isRemovable = false});

  @override
  State<MemberTile> createState() => _MemberTileState();
}

class _MemberTileState extends State<MemberTile> {
  @override
  Widget build(BuildContext context) {
    String selectedRole = widget.role; // Default role to avoid null issues

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        maxRadius: 18,
        backgroundColor: Colors.grey[300],
        child: Text(widget.name[0]),
      ),
      title: Text(widget.name),
      subtitle: const Text(
        'Product Solutions Manager',
        style: TextStyle(fontSize: 10),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedRole,
              elevation: 0,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.blue,
                size: 16,
              ),
              // style: TextStyle(color: Colors.black),
              dropdownColor: Colors.white,
              items: ['Admin', 'Member'].map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(
                    role,
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                );
              }).toList(),
              onChanged: (String? newRole) {
                setState(() {
                  if (newRole != null) {
                    selectedRole = newRole;
                  }
                });
              },
            ),
          ),
          // if (isRemovable)
          //   IconButton(
          //     icon: const Icon(Icons.delete, color: Colors.red),
          //     onPressed: () {},
          //   ),
        ],
      ),
    );
  }
}

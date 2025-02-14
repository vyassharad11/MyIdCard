import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/localStorage/storage.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:my_di_card/utils/widgets/network.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../models/team_member.dart';
import '../../models/team_response.dart';
import '../../utils/image_cropo.dart';

class EditTeamPage extends StatefulWidget {
  const EditTeamPage({super.key});

  @override
  State<EditTeamPage> createState() => _EditTeamPageState();
}

class _EditTeamPageState extends State<EditTeamPage> {
  String selecteValie = "Member";
  final title = TextEditingController();
  final description = TextEditingController();
  final String apiUrlTeam = "${Network.baseUrl}team/get-my-team";
  final String apiUrlTeamGetTeamMember =
      "${Network.baseUrl}team/get-team-member";
  List<Member> teamMember = [];

  @override
  void dispose() {
    title.clear();
    description.clear();

    super.dispose();
  }

  bool isLoading = true;
  bool isLoadingTeam = true;
  TeamResponse? teamResponse;
  Future<void> fetchTeamData() async {
    try {
      String token = await Storage().getToken();
      debugPrint("token---$token");
      final response = await http.get(Uri.parse(apiUrlTeam), headers: {
        'Authorization': 'Bearer $token', // Add your authorization token
      });
      // JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      // String prettyprint = encoder.convert(response.body);
      // print(prettyprint);
      // context.loaderOverlay.hide();
      if (response.statusCode == 200) {
        // Parse the response body
         final Map<String, dynamic> jsonResponse = json.decode(response.body);

        setState(() {
          isLoading = false;

          teamResponse = TeamResponse.fromJson(jsonResponse);
          title.text = teamResponse?.data.teamName.toString() ?? "";
          description.text =
              teamResponse?.data.teamDescription.toString() ?? "";

          if (teamResponse != null &&
              teamResponse!.data.teamLogo != null) {
            _selectedImage = File(teamResponse!.data.teamLogo);
            getTeamMembers(0, "");
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load team data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Error: $e');
    }
  }

  Future<TeamMembersResponse> fetchTeamMembers(page, keyword) async {
    String token = await Storage().getToken();

    try {
      final response =
          await http.post(Uri.parse(apiUrlTeamGetTeamMember), body: {
        "key_word": keyword.toString(),
        "page": page.toString(),
      }, headers: {
        'Authorization': 'Bearer $token', // Add your authorization token
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return TeamMembersResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load team members');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void getTeamMembers(int page, String keyword) async {
    try {
      final teamMembersResponse = await fetchTeamMembers(page, keyword);

      if (teamMembersResponse.status) {
        debugPrint("Current Page: ${teamMembersResponse.data}");
        JsonEncoder encoder = new JsonEncoder.withIndent('  ');
        String prettyprint = encoder.convert(teamMembersResponse);
        print(prettyprint);
        setState(() {
          isLoadingTeam = false;
          teamMember.clear();
          teamMember.addAll(teamMembersResponse.data.members);
        });
        // for (var member in teamMembersResponse.data.members) {
        //   debugPrint("Member Email: ${member.email}");
        //   debugPrint("Member First Name: ${member.firstName}");
        // }
      } else {
        setState(() {
          isLoadingTeam = false;
        });
        debugPrint("Failed to fetch team members");
      }
    } catch (e) {
      setState(() {
        isLoadingTeam = false;
      });
      debugPrint("Exception: $e");
    }
  }

  @override
  void initState() {
    fetchTeamData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "Edit Team",
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
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16), // Rounded corners
                    ),
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
                            controller: description,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 12),
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
                                                  20), // Adjust the radius as needed
                                              child: Image.file(
                                                _selectedImage!,
                                                fit: BoxFit.cover,
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width /
                                                        1.1,
                                                height: 80,
                                              ),
                                            )
                                          : _selectedImage != null &&
                                                  _selectedImage!
                                                      .path.isNotEmpty &&
                                                  _selectedImage!.path
                                                      .contains("storage")
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20), // Adjust the radius as needed
                                                  child: Image.network(
                                                    "${Network.imgUrl}${_selectedImage!.path}",
                                                    fit: BoxFit.cover,
                                                    width:
                                                    MediaQuery.sizeOf(context)
                                                        .width /
                                                        1.1,
                                                    height: 90,
                                                  ),
                                                )
                                              : Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                          color: Colors.grey.shade300,
                                          width: 1),
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
                                  child: const Text('Update'),
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
            if (!isLoadingTeam)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
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
                          itemCount: teamMember.length,
                          padding: EdgeInsets.only(),
                          itemBuilder: (ctx, index) {
                            return CustomRowWidget(
                              description: teamMember[index].lastName,
                              imageUrl: teamMember[index].avatar,
                              onDelete: () {},
                              onRoleChanged: (value) {
                                setState(() {
                                  selecteValie = value;
                                });
                              },
                              title: teamMember[index].firstName,
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
    );
  }

  Future<void> submitData({
    required String title,
    required String description,
    required File cardImage, // Card image file
  }) async {
    // context.loaderOverlay.show();

    var token = await Storage().getToken();

    String apiUrl =
        "${Network.baseUrl}team/update/${teamResponse?.data.id.toString()}"; // Replace with your API endpoint

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add fields to the request

      request.fields['team_name'] = title;
      request.fields['team_description'] = description;

      // Add the image to the request
      if (!cardImage.path.contains("storage")) {
        var file = await http.MultipartFile.fromPath(
          'team_logo',
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
        // context.loaderOverlay.hide();

        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        // context.loaderOverlay.hide();
        Navigator.pop(context);
        debugPrint("Data submitted successfully: $data");
      } else {
        final responseData = await response.stream.bytesToString();

        debugPrint("Failed to submit data. Status Code: ${responseData }");
      }
    } catch (error) {
      // context.loaderOverlay.hide();

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

class CustomRowWidget extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String description;
  final String initialRole;
  final Function(String) onRoleChanged;
  final VoidCallback onDelete;

  const CustomRowWidget({super.key, 
    this.imageUrl,
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
            backgroundImage: NetworkImage(imageUrl ?? ""),
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

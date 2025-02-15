import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/localStorage/storage.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:my_di_card/utils/widgets/network.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../utils/utility.dart';
import '../contact/contact_home.dart';

class GroupMemberPage extends StatefulWidget {
  const GroupMemberPage({super.key});

  @override
  State<GroupMemberPage> createState() => _GroupMemberPageState();
}

class _GroupMemberPageState extends State<GroupMemberPage> {
  String selecteValie = "Member";

  final List<Person> people = [
    Person('Janice Schneider Sr.', 'Product Solutions Manager',
        'assets/images/user_dummy.png'),
    Person(
        'Delbert Wyman', 'Corporate Web Agent', 'assets/images/user_dummy.png'),
    Person('Delia Wolff', 'Dynamic Directives Analyst',
        'assets/images/user_dummy.png'),
    Person('Angelica Nikolaus', 'Dynamic Mobility Executive',
        'assets/images/user_dummy.png'),
    Person('Rachel Purdy', 'National Program Supervisor',
        'assets/images/user_dummy.png'),
    Person('Alejandro Kuphal', 'Chief Applications Liaison',
        'assets/images/user_dummy.png'),
    Person('Cody Lind', 'National Web Officer', 'assets/images/user_dummy.png'),
    Person('Toby Von', 'District Identity Orchestrator',
        'assets/images/user_dummy.png'),
  ];
  final List<Person> peopleHori = [
    Person('Janice Schneider Sr.', 'Product Solutions Manager',
        'assets/images/user_dummy.png'),
    Person(
        'Delbert Wyman', 'Corporate Web Agent', 'assets/images/user_dummy.png'),
    Person('Delia Wolff', 'Dynamic Directives Analyst',
        'assets/images/user_dummy.png'),
    Person('Angelica Nikolaus', 'Dynamic Mobility Executive',
        'assets/images/user_dummy.png'),
    Person('Rachel Purdy', 'National Program Supervisor',
        'assets/images/user_dummy.png'),
    Person('Alejandro Kuphal', 'Chief Applications Liaison',
        'assets/images/user_dummy.png'),
    Person('Cody Lind', 'National Web Officer', 'assets/images/user_dummy.png'),
    Person('Toby Von', 'District Identity Orchestrator',
        'assets/images/user_dummy.png'),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ColoursUtils.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            children: [
              // Team Name Input
              const SizedBox(
                height: 35,
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
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 1.3,
                    child: Center(
                      child: Text(
                        "GROUP AND MEMBERS MANAGEMENT",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'Your Groups',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20, top: 6),
                            child: ClipOval(
                              child: Material(
                                color: Colors.blue, // Button color
                                child: InkWell(
                                  splashColor: Colors.blue, // Splash color
                                  onTap: () {},
                                  child: const SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        itemCount: 2,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(),
                        itemBuilder: (ctx, index) {
                          return ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  AssetImage(people[index].imageUrl.toString()),
                            ),
                            title: Text(
                              people[index].name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            subtitle: Text(
                              people[index].description,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13,
                                  color: Colors.black),
                            ),
                            trailing: const Icon(Icons.more_vert),
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   CupertinoPageRoute(
                              //     builder: (builder) => const ContactDetails(),
                              //   ),
                              // );
                              // Add your onTap functionality here if needed
                            },
                          );
                        },
                        physics: NeverScrollableScrollPhysics(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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
                          'Members',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        margin: const EdgeInsets.all(
                            16), // Optional margin around the tab bar
                        width: double.infinity, // Full width of the screen
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ColoursUtils.background,
                              width: 3), // Outline border
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                        child: TabBar(
                          tabAlignment: TabAlignment.fill,

                          automaticIndicatorColorAdjustment: true,
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          unselectedLabelColor:
                              Colors.black, // Inactive label color
                          isScrollable:
                              false, // Disables scrolling, makes the tabs equal width
                          indicatorPadding: const EdgeInsets.symmetric(
                              horizontal: 3, vertical: 3),
                          labelStyle: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            // Creates rounded indicator
                            // color: Colors.grey.withOpacity(0.2), // Indicator color
                            color: ColoursUtils.background, // Indicator color
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            Tab(text: "All"),
                            Tab(text: "Without Group"),
                          ],
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
                        child: TabBarView(
                          children: [
                            ListView.builder(
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
                            ListView.builder(
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
                          ],
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
          final XFile? pickedFile = await _picker.pickImage(source: source);
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
          final XFile? pickedFile = await _picker.pickImage(source: source);
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

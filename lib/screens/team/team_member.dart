import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/localStorage/storage.dart';
import 'package:my_di_card/models/utility_dto.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:my_di_card/utils/widgets/network.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/team_cubit.dart';
import '../../data/repository/team_repository.dart';
import '../../models/team_member.dart';
import '../../utils/utility.dart';

class TeamMemberPage extends StatefulWidget {
  const TeamMemberPage({super.key});

  @override
  State<TeamMemberPage> createState() => _TeamMemberPageState();
}

class _TeamMemberPageState extends State<TeamMemberPage> {
  String selecteValie = "Member";
  TeamCubit? _getTeamMember,_removeMember,_approvedCubit , _getUnApprovedCubit;
  List<Member> teamMember = [];
  List<Member> unApprovedMember = [];
  int selectedIndex =0 ,unApprovedSelectedIndex = 0;

  @override
  void initState() {
    _getTeamMember = TeamCubit(TeamRepository());
    _removeMember = TeamCubit(TeamRepository());
    _getUnApprovedCubit = TeamCubit(TeamRepository());
    _approvedCubit = TeamCubit(TeamRepository());
    getTeamMembers(0,"");
    apiGetUnApproveTeamMember();

    // apiGetUnApproveTeamMember();
    // TODO: implement initState
    super.initState();
  }

@override
  void dispose() {
  _getTeamMember?.close();
  _removeMember?.close();
  _getUnApprovedCubit?.close();
  _getTeamMember = null;
  _getUnApprovedCubit = null;
  _removeMember = null;
    // TODO: implement dispose
    super.dispose();
  }



  void getTeamMembers(int page, String keyword) async {
    Utility.showLoader(context);
    Map<String, dynamic> data = {
      "key_word": keyword.toString(),
      "page": page.toString(),
    };
    _getTeamMember?.apiGetTeamMember(data);
  }


  void apiGetUnApproveTeamMember() async {
    Utility.showLoader(context);
    Map<String, dynamic> data = {
      "key_word": "",
      "page": 1,
    };
    _getUnApprovedCubit?.apiGetUnApproveTeamMember(data);
  }

  void apiRemoveTeamMember(String userId) async {
    Utility.showLoader(context);
    Map<String, dynamic> data = {
      "user_id": userId.toString(),
    };
    _removeMember?.apiRemoveTeamMember(data);
  }

  void apiApproveTeamMember(String userId,String status) async {
    Utility.showLoader(context);
    Map<String, dynamic> data = {
      "user_id": userId.toString(),
      "status": status,
    };
    _approvedCubit?.apiApproveTeamMember(data);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TeamCubit, ResponseState>(
          bloc: _getTeamMember,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              Utility.hideLoader(context);
              Utility().showFlushBar(context: context, message: state.message,isError: true);
            } else if (state is ResponseStateNoInternet) {
              Utility().showFlushBar(context: context, message: state.message,isError: true);
              Utility.hideLoader(context);
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
              Utility().showFlushBar(context: context, message: state.errorMessage,isError: true);
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as TeamMembersResponse;
              teamMember.clear();
              teamMember.addAll(dto.data.members);
            }
            setState(() {});
          },
        ),
        BlocListener<TeamCubit, ResponseState>(
          bloc: _getUnApprovedCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              Utility.hideLoader(context);
              Utility().showFlushBar(context: context, message: state.message,isError: true);
            } else if (state is ResponseStateNoInternet) {
              Utility().showFlushBar(context: context, message: state.message,isError: true);
              Utility.hideLoader(context);
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
              Utility().showFlushBar(context: context, message: state.errorMessage,isError: true);
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as TeamMembersResponse;
              unApprovedMember.clear();
              unApprovedMember = dto.data.members ?? [];
              // teamMember.clear();
            }
            setState(() {});
          },
        ),
        BlocListener<TeamCubit, ResponseState>(
          bloc: _removeMember,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              Utility().showFlushBar(context: context, message: state.message,isError: true);
              Utility.hideLoader(context);
            } else if (state is ResponseStateNoInternet) {
              Utility.hideLoader(context);
              Utility().showFlushBar(context: context, message: state.message,isError: true);
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
              Utility().showFlushBar(context: context, message: state.errorMessage,isError: true);
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as UtilityDto;
              Utility().showFlushBar(context: context, message: dto.message ?? "");
              teamMember.removeAt(selectedIndex);
            }
            setState(() {});
          },
        ),
        BlocListener<TeamCubit, ResponseState>(
          bloc: _approvedCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              Utility().showFlushBar(context: context, message: state.message,isError: true);
              Utility.hideLoader(context);
            } else if (state is ResponseStateNoInternet) {
              Utility.hideLoader(context);
              Utility().showFlushBar(context: context, message: state.message,isError: true);
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
              Utility().showFlushBar(context: context, message: state.errorMessage,isError: true);
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as UtilityDto;
              unApprovedMember.removeAt(unApprovedSelectedIndex);
              Utility().showFlushBar(context: context, message: dto.message ?? "");
              getTeamMembers(0,"");
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
                      "Team Members",
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
                height: 25,
              ),

              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Invite Members',
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
                              onTap: () {
                                // FlutterShare.share(
                                //     title: "Share on Other App", text: "invite your friend" ?? '', linkUrl: "google.com");
                              },
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
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending Request',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                     ListView.separated(itemBuilder: (context, index) {
                       return  Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(left: 4.0),
                             child: Text(
                             unApprovedMember[index].firstName ?? "",
                               style: TextStyle(
                                 color: Colors.black87,
                                 fontSize: 14,
                                 fontWeight: FontWeight.w600,
                               ),
                             ),
                           ),
                           Row(
                             children: [
                               SizedBox(
                                 height: 25,
                                 child: ElevatedButton(
                                   style: ElevatedButton.styleFrom(
                                     padding: EdgeInsets.symmetric(
                                         horizontal: 8, vertical: 0),
                                     elevation: 0,
                                     backgroundColor: Colors.blue,
                                     shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(16),
                                     ),
                                   ),
                                   onPressed: () {
                                     setState(() {
                                       unApprovedSelectedIndex = index;
                                     });
                                     apiApproveTeamMember(unApprovedMember[index].id,"1");
                                   },
                                   child: const Text(
                                     'Approve',
                                     style: TextStyle(fontSize: 12),
                                   ),
                                 ),
                               ),
                               SizedBox(
                                 width: 8,
                               ),
                               Padding(
                                 padding: const EdgeInsets.only(right: 4.0),
                                 child: Container(
                                   height: 21, // Diameter of the circle
                                   width: 21,
                                   decoration: BoxDecoration(
                                     shape: BoxShape.circle,
                                     border: Border.all(
                                         color: Colors.red.shade400, width: 2),
                                   ),
                                   child: Center(
                                     child: IconButton(
                                       padding: EdgeInsets.zero,
                                       icon: Icon(
                                         Icons.clear,
                                         size: 16,
                                         color: Colors.red,
                                       ),
                                       onPressed: () {
                                         setState(() {
                                           unApprovedSelectedIndex = index;
                                         });
                                         apiApproveTeamMember(unApprovedMember[index].id,"0");
                                         // Add your logic here
                                       },
                                     ),
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ],
                       );
                     }, separatorBuilder: (context, index) {
                       return SizedBox(height: 12,);
                     }, itemCount: unApprovedMember.length)
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
                    if(teamMember.isNotEmpty)  SizedBox(
                        height: MediaQuery.sizeOf(context).height / 2,
                        child: ListView.builder(
                          itemCount: teamMember.length,
                          padding: EdgeInsets.only(),
                          itemBuilder: (ctx, index) {
                            return CustomRowWidget(
                              description: teamMember[index].lastName ?? "",
                              imageUrl: teamMember[index].avatar ?? "",
                              onDelete: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                                apiRemoveTeamMember(teamMember[index].id.toString() ?? "");
                              },
                              onRoleChanged: (value) {
                                setState(() {
                                  selecteValie = value;
                                });
                              },
                              title: teamMember[index].name ?? "",
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
          Row(
            children: [
              SizedBox(
                width: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: InkWell(
                  onTap: onDelete,
                  child: Container(
                    height: 21, // Diameter of the circle
                    width: 21,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.clear,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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

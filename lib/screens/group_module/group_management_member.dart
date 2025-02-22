import 'dart:convert';
import 'dart:io';
// import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/bloc/cubit/group_cubit.dart';
import 'package:my_di_card/data/repository/group_repository.dart';
import 'package:my_di_card/localStorage/storage.dart';
import 'package:my_di_card/models/utility_dto.dart';
import 'package:my_di_card/screens/group_module/create_group.dart';
import 'package:my_di_card/screens/group_module/edit_group.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:my_di_card/utils/widgets/network.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../bloc/api_resp_state.dart';
import '../../models/group_member_model.dart';
import '../../models/my_group_list_model.dart';
import '../../utils/utility.dart';
import '../contact/contact_home.dart';

class GroupMemberPage extends StatefulWidget {
  const GroupMemberPage({super.key});

  @override
  State<GroupMemberPage> createState() => _GroupMemberPageState();
}

class _GroupMemberPageState extends State<GroupMemberPage> {
  String selecteValie = "Member";
  List<MemberDatum> groupMember = [];
  List<MemberDatum> groupAllMember = [];
  GroupCubit? _getActiveMember,_groupMemberCubit, getGroupCubit , _deleteGroupCubit;
  List<MyGroupListDatum> myGroupList = [];

int selectedIndex = 0;





@override
  void initState() {
  _getActiveMember = GroupCubit(GroupRepository());
  _groupMemberCubit = GroupCubit(GroupRepository());
  getGroupCubit = GroupCubit(GroupRepository());
  _deleteGroupCubit = GroupCubit(GroupRepository());
  apiGetActiveMemberForGroup();
  fetchGroupData();
  fetchGroupMember();
    // TODO: implement initState
    super.initState();
  }

  Future<void> fetchGroupData() async {
    getGroupCubit?.apiGetMyGroups();
  }


  Future<void> apiDeleteGroup(groupId) async {
    _deleteGroupCubit?.apiDeleteGroup(groupId);
  }


  Future<void> apiGetActiveMemberForGroup() async {
    Utility.showLoader(context);
    _getActiveMember?.apiGetActiveMemberForGroup();
  }


  Future<void> fetchGroupMember() async {
    _groupMemberCubit?.apiGetAllGroupMembers();
  }
  // Future<void> share() async {
  // print("object");
  //   // await FlutterShare.share(
  //   //     title: 'Example share',
  //   //     text: 'Example share text',
  //   //     linkUrl: 'https://flutter.dev/',
  //   //     chooserTitle: 'Example Chooser Title'
  //   // );
  // }
  @override
  Widget build(BuildContext context) {
    return  MultiBlocListener(
      listeners: [
       BlocListener<GroupCubit, ResponseState>(
        bloc: _getActiveMember,
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
            var dto = state.data as GroupMember;
            groupMember.clear();
            groupMember.addAll(dto.data ?? []);
          }
          setState(() {});
        },),
       BlocListener<GroupCubit, ResponseState>(
        bloc: _deleteGroupCubit,
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
            var dto = state.data as UtilityDto;
            myGroupList.removeAt(selectedIndex);
           Utility().showFlushBar(context: context, message: dto.message ?? "");
          }
          setState(() {});
        },),
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
              var dto = state.data as MyGroupListModel;
              myGroupList = dto.data ?? [];
            }
            setState(() {});
          },
        ),
       BlocListener<GroupCubit, ResponseState>(
        bloc: _groupMemberCubit,
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
            var dto = state.data as GroupMember;
            groupAllMember.clear();
            groupAllMember.addAll(dto.data ?? []);
          }
          setState(() {});
        },),

      ],
        child: DefaultTabController(
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
                                    onTap: () => {print('InkWell clicked!')},

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
                       if(myGroupList.isNotEmpty) ListView.builder(
                          itemCount: myGroupList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(),
                          itemBuilder: (ctx, index) {
                            return ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                NetworkImage(myGroupList[index].groupLogo ?? ""),
                              ),
                              title: Text(
                                myGroupList[index].groupName ?? "",
                               style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                              subtitle: Text(
                                  myGroupList[index].groupDescription ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                    color: Colors.black),
                              ),
                              trailing:   PopupMenuButton<String>(
                                onSelected: (String value) {
                                  switch (value) {
                                    case 'Edit':
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditGroupPage(groupId: myGroupList[index].id.toString(),role: "tadmin",),)).then((value) {
                                        fetchGroupData();
                                      },);
                                      break;
                                    case 'Delete':
                                      selectedIndex   = index;
                                      setState(() {

                                      });
                                      Utility.showLoader(context);
                                      apiDeleteGroup(myGroupList[index].id);
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'Edit',
                                    child: Text('Edit'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'Delete',
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ),
                                ],
                              ),
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
                                  itemCount: groupMember.length,
                                  padding: EdgeInsets.only(),
                                  itemBuilder: (ctx, index) {
                                    return CustomRowWidget(
                                      description: groupMember[index].lastName,
                                      imageUrl: "asd",
                                      onDelete: () {},
                                      onRoleChanged: (value) {
                                        setState(() {
                                          selecteValie = value;
                                        });
                                      },
                                      title: groupMember[index].firstName,
                                      initialRole: selecteValie,
                                    );
                                  },
                                  physics: AlwaysScrollableScrollPhysics(),
                                ),
                                ListView.builder(
                                  itemCount: groupAllMember.length,
                                  padding: EdgeInsets.only(),
                                  itemBuilder: (ctx, index) {
                                    return CustomRowWidget(
                                      description: groupAllMember[index].lastName,
                                      imageUrl: "asd",
                                      onDelete: () {},
                                      onRoleChanged: (value) {
                                        setState(() {
                                          selecteValie = value;
                                        });
                                      },
                                      title: groupAllMember[index].firstName,
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
        ),
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

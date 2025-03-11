import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/group_cubit.dart';
import '../../bloc/cubit/team_cubit.dart';
import '../../data/repository/group_repository.dart';
import '../../data/repository/team_repository.dart';
import '../../models/my_group_list_model.dart';
import '../../models/team_member.dart';
import '../../utils/utility.dart';
import '../../utils/widgets/network.dart';

class TeamMemberContact extends StatefulWidget {
  const TeamMemberContact({super.key});

  @override
  State<TeamMemberContact> createState() => _TeamMemberContactState();
}

class _TeamMemberContactState extends State<TeamMemberContact> {
  TeamCubit?_getTeamMember;
  bool isLoadingTeam = true;
  List<Member> teamMember = [];
  GroupCubit? getGroupCubit;
  List<MyGroupListDatum> myGroupList = [];


  void getTeamMembers(int page, String keyword) async {
    Map<String, dynamic> data = {
      "key_word": keyword.toString(),
      "page": page.toString(),
    };
    _getTeamMember?.apiGetTeamMember(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    getGroupCubit = GroupCubit(GroupRepository());
    _getTeamMember = TeamCubit(TeamRepository());
    fetchGroupData();
    getTeamMembers(0,"");
    super.initState();
  }

  Future<void> fetchGroupData() async {
    getGroupCubit?.apiGetMyGroups();
  }



  @override
  Widget build(BuildContext context) {
    return  MultiBlocListener(
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
              var dto = state.data as MyGroupListModel;
              myGroupList = dto.data ?? [];
            }
            setState(() {});
          },
        ),
        BlocListener<TeamCubit, ResponseState>(
          bloc: _getTeamMember,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              Utility.hideLoader(context);
              isLoadingTeam = false;
            } else if (state is ResponseStateNoInternet) {
              isLoadingTeam = false;
              Utility.hideLoader(context);
            } else if (state is ResponseStateError) {
              isLoadingTeam = false;
              Utility.hideLoader(context);
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as TeamMembersResponse;
              teamMember.clear();
              teamMember.addAll(dto.data.members);
              isLoadingTeam = false;
            }
            setState(() {});
          },
        ),
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Search Box
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Light white color
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                    width: 10), // Space between search box and filter icon
                // Filter Icon Button
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.black),
                  onPressed: () {
                    // Filter button functionality
                    // showModalBottomSheet(
                    //   context: context,
                    //   isScrollControlled: true,
                    //   backgroundColor:
                    //   Colors.transparent, // To make corners rounded
                    //   builder: (context) => FullScreenBottomSheet(),
                    // );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Groups",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Add some space between title and list
         if(myGroupList.isNotEmpty) SizedBox(
            height: 35, // Fixed height for tag list items
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: myGroupList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Light background color
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: Center(
                      child: Text(
                        myGroupList[index].groupName ?? "",
                        style: const TextStyle(
                          color: Colors.black, // Text color
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          isLoadingTeam == true?
          Padding(padding: EdgeInsets.symmetric(horizontal: 20),child:
          Utility.userListShimmer()):
          teamMember.isNotEmpty?
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: teamMember.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage("${Network.imgUrl}${teamMember[index].avatar ?? ""}"),
                    backgroundColor: Colors.grey.shade200,

                  ),
                  title: Text(
                    teamMember[index].firstName ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                  subtitle: Text(
                    teamMember[index].lastName ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: Colors.black),
                  ),
                  trailing: InkWell(
                      onTap: (){
                      //   showModalBottomSheet(
                      //   context: context,
                      //   shape: const RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.vertical(
                      //       top: Radius.circular(25.0),
                      //     ),
                      //   ),
                      //   builder: (context) {
                      //     return buildContactBottomSheetContent(context,myContactList[index].id,index);
                      //   },
                      // );
                      },
                      child: const Icon(Icons.more_vert)),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                      // CupertinoPageRoute(
                      //   builder: (builder) =>  ContactDetails(contactId: myContactList[index].cardId ?? 0,contactIdForMeeting: myContactList[index].id,tags: tags,),
                      // ),
                    // ).then((value) {
                    //   if(value == 2){
                        // apiGetMyContact();
                      // }
                    // },);
                    // Add your onTap functionality here if needed
                  },
                );
              },
            ),
          ):SizedBox(),
        ],
      ),
    );
  }
}

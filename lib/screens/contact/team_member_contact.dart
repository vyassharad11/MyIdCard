import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/contact_cubit.dart';
import '../../bloc/cubit/group_cubit.dart';
import '../../bloc/cubit/team_cubit.dart';
import '../../data/repository/contact_repository.dart';
import '../../data/repository/group_repository.dart';
import '../../data/repository/team_repository.dart';
import '../../language/app_localizations.dart';
import '../../models/my_group_list_model.dart';
import '../../models/team_member.dart';
import '../../models/utility_dto.dart';
import '../../utils/utility.dart';
import '../../utils/widgets/network.dart';
import 'contact_details_screen.dart';
import 'other_card_details.dart';
import 'package:flutter_contacts/contact.dart' as contact;

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
  TextEditingController searchController = TextEditingController();
  ContactCubit? _addContactCubit;


  void getTeamMembers(int page, String keyword) async {
    List<int> myGroupListId = [];
    myGroupList.forEach(
          (element) {
        if (element.isCheck == true) {
          myGroupListId.add(element.id ?? 0);
        }
      },
    );
    String group_ids = myGroupListId.join(',');
    Map<String, dynamic> data = {
      "key_word": keyword.toString(),
      "page": page.toString(),
      "group_ids":group_ids

    };
    _getTeamMember?.apiGetTeamMember(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    getGroupCubit = GroupCubit(GroupRepository());
    _getTeamMember = TeamCubit(TeamRepository());
    _addContactCubit = ContactCubit(ContactRepository());
    fetchGroupData();
    getTeamMembers(0,"");
    super.initState();
  }

  Future<void> fetchGroupData() async {
    getGroupCubit?.apiGetMyGroups();
  }

  Future<void> requestPermissions() async {
    PermissionStatus permission = await Permission.contacts.request();
    if (!permission.isGranted) {
      // Handle the case where the user denies permission
    }
  }


  Future<void> addContact(firstName, lastName, mobileNumber) async {
    // Make sure permissions are granted
    if (await FlutterContacts.requestPermission()) {
      // Create a new contact
      final newContact = contact.Contact()
        ..name.first = firstName
        ..name.last = lastName
        ..phones = [Phone(mobileNumber)]; // Add the phone number here

      try {
        await FlutterContacts.insertContact(newContact);
        Utility().showFlushBar(
          context: context, message:  AppLocalizations.of(context)
            .translate('contactAddSuccessfully'),);
      } catch (e) {
        print('Error adding contact: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return  MultiBlocListener(
      listeners: [
        BlocListener<ContactCubit, ResponseState>(
    bloc: _addContactCubit,
    listener: (context, state) {
      if (state is ResponseStateLoading) {
      } else if (state is ResponseStateEmpty) {
        Utility.hideLoader(context);
        Utility().showFlushBar(
            context: context, message: state.message, isError: true);
      } else if (state is ResponseStateNoInternet) {
        Utility.hideLoader(context);
        Utility().showFlushBar(
            context: context, message: state.message, isError: true);
      } else if (state is ResponseStateError) {
        Utility.hideLoader(context);
        Utility().showFlushBar(
            context: context, message: state.errorMessage, isError: true);
      } else if (state is ResponseStateSuccess) {
        Utility.hideLoader(context);
        var dto = state.data as UtilityDto;
        Utility()
            .showFlushBar(context: context, message: dto.message ?? "");
      }
      setState(() {});
    }),
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
                    child:  Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(onChanged: (value) {
                            getTeamMembers(0,value);
                          },
                            controller: searchController,
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
                // const SizedBox(
                //     width: 10), // Space between search box and filter icon
                // Filter Icon Button
                // IconButton(
                //   icon: const Icon(Icons.filter_list, color: Colors.black),
                //   onPressed: () {
                //     // Filter button functionality
                //     // showModalBottomSheet(
                //     //   context: context,
                //     //   isScrollControlled: true,
                //     //   backgroundColor:
                //     //   Colors.transparent, // To make corners rounded
                //     //   builder: (context) => FullScreenBottomSheet(),
                //     // );
                //   },
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).translate('groups'),
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
                  child: InkWell(
                    onTap: (){
                      myGroupList[index].isCheck =
                      myGroupList[index].isCheck == false ? true : false;
                      setState(() {

                      });
                      getTeamMembers(1,searchController.text);
                    },
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
                        if(teamMember[index]
                            .cardId != null && teamMember[index]
                            .cardId!.toString().isNotEmpty)
                          showModalBottomSheet(
                            context: context,
                            useSafeArea: true,
                            isScrollControlled: false,
                            constraints: BoxConstraints(maxHeight: MediaQuery
                                .of(context)
                                .size
                                .height - 100, minHeight: 10),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                  title:  Text(
                                    AppLocalizations.of(context).translate('exportToContactsApp'),
                                    style: TextStyle(color: Colors.black, fontSize: 14),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    requestPermissions().then((value) {
                                      addContact(teamMember[index].firstName ?? "",
                                          teamMember[index].lastName ?? "",
                                          teamMember[index].phoneNumber.toString());
                                    },); // Add functionality here
                                  },
                                ),
                                  if(teamMember[index]
                                      .cardId != null && teamMember[index]
                                      .cardId!.toString().isNotEmpty)     const Divider(
                                  color: Colors.grey,
                                ),
                                  if(teamMember[index]
                                      .cardId != null && teamMember[index]
                                      .cardId!.toString().isNotEmpty)     ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                  title:  Text(
                                    AppLocalizations.of(context).translate('addPrivate'),
                                    style: TextStyle(color: Colors.black, fontSize: 14),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Utility.showLoader(context);
                                    Map<String, dynamic> data = {
                                      "card_id": teamMember[index].cardId,
                                    };
                                    _addContactCubit?.apiAddContact(data);
                                  },
                                ),
                              ],);
                            });
                      },
                      child: const Icon(Icons.more_vert)),
                  onTap: () {
                    if(teamMember[index]
                        .cardId != null && teamMember[index]
                        .cardId!.toString().isNotEmpty) {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (builder) =>
                              OtherCardDetails(
                                cardId: teamMember[index]
                                    .cardId
                                    .toString() ??
                                    "",
                                isOtherCard: true,
                              ),
                        ),
                      );
    }else{
      Utility().showFlushBar(context: context, message: AppLocalizations.of(context)
          .translate('thisUserDoesnt'),);
    }

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

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:my_di_card/bloc/cubit/auth_cubit.dart';
import 'package:my_di_card/bloc/cubit/group_cubit.dart';
import 'package:my_di_card/data/repository/auth_repository.dart';
import 'package:my_di_card/data/repository/group_repository.dart';
import 'package:my_di_card/data/repository/team_repository.dart';
import 'package:my_di_card/models/my_group_list_model.dart';
import 'package:my_di_card/models/user_data_model.dart';
import 'package:my_di_card/models/utility_dto.dart';
import 'package:my_di_card/screens/group_module/edit_group.dart';
import 'package:my_di_card/screens/setting_module/setting_screen.dart';
import 'package:my_di_card/screens/team/team_member.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/team_cubit.dart';
import '../../language/app_localizations.dart';
import '../../localStorage/storage.dart';
import '../../models/group_response.dart';
import '../../models/login_dto.dart';
import '../../models/team_member.dart';
import '../../models/team_response.dart';
import '../../notifire_class.dart';
import '../../utils/utility.dart';
import '../../utils/widgets/network.dart';
import '../auth_module/welcome_screen.dart';
import '../group_module/create_group.dart';
import '../group_module/group_management_member.dart';
import '../subscription_module/buy_preview_subscription.dart';
import '../subscription_module/subscription_screen.dart';
import '../tag/tag_management_screen.dart';
import '../team/edit_team.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_profile.dart';


class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late SharedPreferences prefs;

  TeamCubit? getTeamCubit, _getTeamMember, _deleteTeamCubit, _removeMember;
  GroupCubit? getGroupCubit;
  AuthCubit?_authCubit, _completeProfileCubit;
  List<Member> teamMember = [];
  TextEditingController controller = TextEditingController();
  bool isLoad = true;
  User? user;

  Future<void> fetchUserData() async {
    _authCubit?.apiUserProfile();
  }

  TeamResponse? teamResponse;
  List<MyGroupListDatum> myGroupList = [];

  Future<void> fetchTeamData() async {
    getTeamCubit?.apiGetMyTeam();
  }
  void sharedPreInit() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> fetchGroupData() async {
    getGroupCubit?.apiGetMyGroups();
  }


  void apiLeaveTeam() async {
    // Map<String, dynamic> data = {
    //   "user_id": userId.toString(),
    // };
    _removeMember?.apiLeaveTeam();
  }

  void getTeamMembers() async {
    Map<String, dynamic> data = {
      "key_word": "",
      "page": 1
    };
    _getTeamMember?.apiGetTeamMember(data);
  }

  void apiDeleteTeam(teamId) async {
    _deleteTeamCubit?.apiDeleteTeam(teamId);
  }


  @override
  void initState() {
    sharedPreInit();
    getTeamCubit = TeamCubit(TeamRepository());
    _getTeamMember = TeamCubit(TeamRepository());
    _deleteTeamCubit = TeamCubit(TeamRepository());
    _removeMember = TeamCubit(TeamRepository());
    getGroupCubit = GroupCubit(GroupRepository());
    _authCubit = AuthCubit(AuthRepository());
    _completeProfileCubit = AuthCubit(AuthRepository());
    fetchUserData();
    // fetchGroupData();
    super.initState();
  }

  Future<void> clearSharedPreferences() async {

    bool success = await prefs.clear(); // Clears all key-value pairs
    if (success) {
      Future.delayed(
        const Duration(seconds: 2),
            () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => WelcomePage()),
                (route) => false,
          );
          Utility.hideLoader(context);
        },
      );

      debugPrint("SharedPreferences cleared successfully.");
    } else {
      debugPrint("Failed to clear SharedPreferences.");
    }
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, ResponseState>(
            bloc: _completeProfileCubit,
            listener: (context, state) {
              if (state is ResponseStateLoading) {} else
              if (state is ResponseStateEmpty) {
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
                    context: context,
                    message: state.errorMessage,
                    isError: true);
              } else if (state is ResponseStateSuccess) {
                var dto = state.data as LoginDto;
                // if (dto.user != null) {
                fetchUserData();
                Utility().showFlushBar(
                    context: context, message: dto.message ?? "");
                // }else{
                //   Utility.hideLoader(context);
                // }
              }
              setState(() {

              });
            }),
        BlocListener<TeamCubit, ResponseState>(
            bloc: _deleteTeamCubit,
            listener: (context, state) {
              if (state is ResponseStateLoading) {} else
              if (state is ResponseStateEmpty) {
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
                    context: context,
                    message: state.errorMessage,
                    isError: true);
              } else if (state is ResponseStateSuccess) {
                var dto = state.data as UtilityDto;
                // fetchUserData();
                // fetchTeamData();
                clearSharedPreferences();


              }
              setState(() {

              });
            }),
        BlocListener<TeamCubit, ResponseState>(
            bloc: _removeMember,
            listener: (context, state) {
              if (state is ResponseStateLoading) {} else
              if (state is ResponseStateEmpty) {
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
                    context: context,
                    message: state.errorMessage,
                    isError: true);
              } else if (state is ResponseStateSuccess) {
                Utility.hideLoader(context);
                var dto = state.data as UtilityDto;
                clearSharedPreferences();
              }
              setState(() {

              });
            }),
        BlocListener<TeamCubit, ResponseState>(
          bloc: _getTeamMember,
          listener: (context, state) {
            if (state is ResponseStateLoading) {} else
            if (state is ResponseStateEmpty) {
              Utility().showFlushBar(
                  context: context, message: state.message, isError: true);
            } else if (state is ResponseStateNoInternet) {
              Utility().showFlushBar(
                  context: context, message: state.message, isError: true);
            } else if (state is ResponseStateError) {
              Utility().showFlushBar(
                  context: context, message: state.errorMessage, isError: true);
            } else if (state is ResponseStateSuccess) {
              var dto = state.data as TeamMembersResponse;
              teamMember.clear();
              teamMember.addAll(dto.data.members);
            }
            setState(() {});
          },
        ),
        BlocListener<TeamCubit, ResponseState>(
          bloc: getTeamCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {} else
            if (state is ResponseStateEmpty) {
            } else if (state is ResponseStateNoInternet) {
            } else if (state is ResponseStateError) {
            } else if (state is ResponseStateSuccess) {
              var dto = state.data as TeamResponse;
              teamResponse = dto;
            }
            setState(() {});
          },
        ),
        BlocListener<AuthCubit, ResponseState>(
          bloc: _authCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {} else
            if (state is ResponseStateEmpty) {
              isLoad = false;
            } else if (state is ResponseStateNoInternet) {
              isLoad = false;
            } else if (state is ResponseStateError) {
              isLoad = false;
            } else if (state is ResponseStateSuccess) {
              var dto = state.data as User;
              user = dto;
              Storage().setIsIndivisual(user != null && user?.role != Role.individual.name);
              if(user != null) {
                Storage().saveUserToPreferences(user!);
              }
              if (user != null && user?.role != Role.individual.name) {
                getTeamMembers();
                fetchTeamData();
                fetchGroupData();
              }
              isLoad = false;
            }
            setState(() {});
          },
        ),
        BlocListener<GroupCubit, ResponseState>(
          bloc: getGroupCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {} else
            if (state is ResponseStateEmpty) {
            } else if (state is ResponseStateNoInternet) {
            } else if (state is ResponseStateError) {
            } else if (state is ResponseStateSuccess) {
              var dto = state.data as MyGroupListModel;
              myGroupList = dto.data ?? [];
            }
            setState(() {});
          },
        ),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    Center(
                      child: Text(
                          AppLocalizations.of(context).translate('myaccount'),
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (builder) => SettingScreen()));
                      }, // Default action: Go back
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 2,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.settings_outlined,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),


                isLoad ? _getShimmerView() :
                // Profile Picture and Name
                Column(
                  children: [
                    InkWell(

                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(user: user,),)).then((value) {
                            if(value != null && value == 2) {
                              fetchUserData();
                            }
                          },);
                        },
                        child:
                    user != null && user!.avatar != null
                      ? Stack(
                        children: [
                          ClipRRect(
                                              borderRadius: BorderRadius.circular(
                            10000.0),
                                              child: CachedNetworkImage(
                          height: 100,
                          width: 100,
                          fit: BoxFit.fitWidth,
                          imageUrl: "${Network.imgUrl}${user!.avatar}",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                              Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
                              ),
                          errorWidget: (context, url, error) =>
                              Image.asset(
                                "assets/images/user_dummy.png",
                                height: 80,
                                fit: BoxFit.fill,
                                width: double.infinity,
                              ),
                                              ),
                                            ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.edit_outlined,
                                  size: 15, color: Colors.white),
                            ),
                          ),
                        ],
                      )
                      : const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/images/user_dummy.png'),
                    // Replace with actual image URL
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.edit_outlined,
                            size: 15, color: Colors.white),
                      ),
                    ),
                  )),

                    const SizedBox(height: 10),
                    Text(
                      "${user?.firstName ?? ""} ${user?.lastName ?? ""}",
                      style:
                      const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // Text(
                    //   user?.lastName ?? "",
                    //   style: const TextStyle(color: Colors.grey),
                    // ),
                    const SizedBox(height: 20),

                    // Subscription Info
                    if(user?.planId != 3 &&
                        (user?.role == Role.individual.name ||
                            user?.role == Role.towner.name)) Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1),
                        color:
                        const Color.fromARGB(255, 133, 189, 236).withOpacity(
                            0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.black26),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (builder) =>
                                          SubscriptionScreen())).then((
                                  onValue) {
                                if (user != null &&
                                    user?.role != Role.individual.name) {
                                  getTeamMembers();
                                  fetchTeamData();
                                }
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 196,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?.planName ?? "ddd",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),

                                      Text(
                                        AppLocalizations.of(context).translate(
                                            'manage'),
                                        style: const TextStyle(
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: Provider.of<LocalizationNotifier>(context).appLocal == Locale("en")?25:40,
                                  width: 94,
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
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => EditTeamPage(),));
                                    },
                                    child:  Text(
                                        AppLocalizations.of(context).translate('upgrade'),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if(user?.planId != 3) const SizedBox(height: 20),
                    // Team Information
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "(${ user?.role == Role.tadmin.name ?  AppLocalizations.of(context).translate('teamAdmin') :
                        user?.role == Role.towner.name ?  AppLocalizations.of(context).translate('teamOwner') :user?.role == Role.member.name ?  AppLocalizations.of(context).translate('member'):user?.role == Role.individual.name?  AppLocalizations.of(context).translate('individual'): user?.role.toString()})",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if(user?.role != Role.individual.name) const SizedBox(
                        height: 10),
                    teamResponse != null &&
                        teamResponse!.data.teamDescription != null &&
                        teamResponse!
                            .data.teamDescription
                            .toString()
                            .isNotEmpty ? InkWell(
                      onTap: () {
                        if (teamResponse == null) {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (builder) => SubscriptionScreen()))
                              .then((onValue) {
                            // if(user != null && user?.role != Role.individual.name){
                            getTeamMembers();
                            fetchTeamData();
                            // }
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.withOpacity(0.2)),
                        child:


                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                teamResponse != null &&
                                    teamResponse!.data.teamLogo != null
                                    ? SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      "${Network.imgUrl}${teamResponse!.data
                                          .teamLogo ?? ""}",
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                          stackTrace) {
                                        return Container(height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius
                                                  .circular(50)),);
                                      },
                                    ),
                                  ),
                                )
                                    : SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.asset(
                                      "assets/images/Ellipse 5.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      teamResponse?.data.teamName ?? "-",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      teamResponse?.data.teamDescription ?? "-",
                                      style: TextStyle(
                                          color: Color(0xFF949494)),
                                    ),
                                    Row(children: [
                                      if(teamMember.isNotEmpty) ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          "${Network.imgUrl}${teamMember[0]
                                              .avatar ?? ""}",
                                          fit: BoxFit.cover,
                                          width: 16,height: 16,
                                          errorBuilder: (context, error,
                                              stackTrace) {
                                            return Container(height: 16,
                                              width: 16,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius: BorderRadius
                                                      .circular(16)),);
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      if(teamMember.isNotEmpty) Text(
                                        teamMember[0].firstName ?? "",
                                      ),
                                      if(teamMember.isNotEmpty &&
                                          teamMember.length > 1) SizedBox(
                                        width: 8,),
                                      if(teamMember.isNotEmpty &&
                                          teamMember.length > 1) Container(
                                        width: 1,
                                        height: 5,
                                        color: Colors.grey,),
                                      if(teamMember.isNotEmpty &&
                                          teamMember.length > 1) ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          height: 16,width: 16,
                                          "${Network.imgUrl}${teamMember[1]
                                              .avatar ?? ""}",
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error,
                                              stackTrace) {
                                            return Container(height: 16,
                                              width: 16,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius: BorderRadius
                                                      .circular(16)),);
                                          },
                                        ),
                                      ),
                                      if(teamMember.isNotEmpty &&
                                          teamMember.length > 1) SizedBox(
                                        width: 5,),
                                      if(teamMember.isNotEmpty &&
                                          teamMember.length > 1) Text(
                                        teamMember[1].firstName ?? "",
                                      ),
                                    ],)
                                  ],
                                ),
                                Spacer(),
                                // if(user?.role != Role.individual.name && user?.role != Role.member.name && (user?.role != Role.towner.name || user?.role != Role.tadmin.name))
                                if(user?.role == Role.towner.name)
                                  InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (builder) =>
                                                    EditTeamPage()))
                                            .then((onValue) {
                                          fetchTeamData();
                                        });
                                      },
                                      child: Image.asset(
                                        "assets/images/edit-05.png", width: 20,
                                        height: 20,
                                        color: Color(0xFF949494),))
                              ],),

                          ],
                        ),
                      ),
                    ) :
                    isLoad == false && teamResponse != null && user?.planId == 3
                        ? Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(top: 14),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/create_team_icon.png",
                            width: 40,
                            height: 40,
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          Text( AppLocalizations.of(context).translate("noTeamAdded"),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          Text( AppLocalizations.of(context).translate('createTeamFeature'),
                              style: TextStyle(
                                  color: Color(0xFF667085))),
                          SizedBox(height: 10,),
                          SizedBox(
                            height: 41,
                            width: 137,
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
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      EditTeamPage(isCreate: true,),)).then((
                                    value) {
                                  fetchTeamData();
                                },);
                              },
                              child:  Text(
                                  AppLocalizations.of(context).translate('createTeam2'),
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : SizedBox(),
                    if(user?.role != Role.individual.name) const SizedBox(
                        height: 10),
                    if(user?.role != Role.individual.name &&
                        myGroupList.isNotEmpty) Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.withOpacity(0.2)),
                      child: ListTile(
                        onTap: () {
                          if (user?.role != Role.individual.name &&
                              user?.role != Role.member.name &&
                              (user?.role != Role.towner.name ||
                                  user?.role != Role.tadmin.name ||
                                  (myGroupList.isNotEmpty &&
                                      myGroupList[0].adminId == user?.id))) {
                            if (myGroupList.isEmpty) {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => CreateGroupPage(),))
                                  .then((value) {
                                fetchGroupData();
                              },);
                            } else {

                            }
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: myGroupList.isNotEmpty &&
                            myGroupList[0].groupLogo != null
                            ? SizedBox(
                          height: 50,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              "${Network.imgUrl}${myGroupList[0].groupLogo ??
                                  ""}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(color: Colors.grey,
                                      borderRadius: BorderRadius.circular(
                                          50)),);
                              },
                            ),
                          ),
                        )
                            : SizedBox(
                          height: 50,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              "assets/images/Ellipse 5.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              myGroupList[0].groupName ?? "-",
                            ),
                            if( user?.role != Role.individual.name &&
                                user?.role != Role.member.name &&
                                (user?.role != Role.towner.name ||
                                    user?.role != Role.tadmin.name ||
                                    (myGroupList.isNotEmpty &&
                                        myGroupList[0].adminId == user?.id)))
                              InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => EditGroupPage(
                                        groupId: myGroupList[0].id?.toString(),
                                        role: user?.role ?? "",),)).then((
                                        value) {
                                      fetchGroupData();
                                    },);
                                  },
                                  child: Image.asset(
                                    "assets/images/edit-05.png", width: 20,
                                    height: 20,
                                    color: Color(0xFF949494),))
                          ],
                        ),
                        subtitle: Text(
                          myGroupList[0].groupDescription ?? "-",
                        ),
                      ),
                    ),
                    if((user?.role == Role.tadmin.name ||
                        user?.role == Role.towner.name) &&
                        myGroupList.isEmpty) InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CreateGroupPage(),)).then((
                            value) {
                          fetchGroupData();
                        },);
                      },
                      child: Container(height: 55,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.withOpacity(0.2)),
                        child: Text( AppLocalizations.of(context).translate('createGroup'), style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),),),
                    ),
                    if(user?.role != Role.individual.name &&
                        user?.role != Role.member.name) const SizedBox(
                        height: 20),
                    if(user?.role == Role.individual.name &&
                        user?.userStatusId == 2 &&
                        user?.role != Role.member.name) ApprovalCard(),
                    if(user?.role.toString() == Role.individual.name &&
                        user?.teamId == null && user?.userStatusId == 1) Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                  AppLocalizations.of(context).translate('teamCode1'),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                // labelText: 'Team Name',
                                hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 14),
                                filled: true,
                                hintText: "Enter a team code to join team",
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Description Input

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding: EdgeInsets.all(12),
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () {
                                  Utility.showLoader(context);
                                  Map<String, dynamic> data = {
                                    'first_name': user?.firstName ?? "",
                                    'last_name': user?.lastName ?? "",
                                    'team_code': controller.text,
                                  };
                                  _completeProfileCubit?.completeProfileApi(
                                    data,);
                                },
                                child: Text( AppLocalizations.of(context).translate('join')),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Options
                    if(user?.role == Role.tadmin.name ||
                        user?.role == Role.towner.name) GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (builder) => TeamMemberPage(
                                  teamCode: teamResponse?.data?.teamCode
                                      .toString(),)));
                      },
                      child: OptionTile(
                        icon: Icons.group_add,
                        title: 'Invite Members',
                      ),
                    ),
                    if((user?.role == Role.tadmin.name ||
                        user?.role == Role.towner.name) &&
                        myGroupList.isNotEmpty) GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (builder) => GroupMemberPage()));
                      },
                      child: OptionTile(
                        icon: Icons.people,
                        title: 'Manage groups & Members',
                      ),
                    ),

                    if(user?.role != Role.individual.name &&
                        user?.role != Role.member.name) GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (builder) =>
                                const BuySubscriptionPreviewScreen()));
                      },
                      child: OptionTile(
                        icon: Icons.credit_card,
                        title: 'Manage Team card template',
                      ),
                    ),
                    if(user?.role == Role.towner.name ||
                        user?.role == Role.tadmin.name || user?.role ==   Role.gadmin.name) GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (builder) => TagManagementScreen(isFromCard: false,)));
                      },
                      child: ListTile(
                        leading: Image.asset(
                          "assets/images/tag_icon.png", height: 22, width: 22,),
                        title: Text( AppLocalizations.of(context).translate('manageTeamTags')),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ),
                    if(user?.role != null &&
                        user?.role == Role.towner.name) GestureDetector(
                      onTap: () {
                        // showLogoutDialogForDeleteTeam(context);
                      },
                      child: Container(
                        height: 53,
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(top: 14),
                        decoration: BoxDecoration(color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/delete_icon.png",
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 14,),
                            Text( AppLocalizations.of(context).translate('deleteTeam'),
                                style: TextStyle(color: Colors.redAccent)),

                          ],
                        ),
                      ),
                    ),
                    if(user?.role != null &&
                        user?.role != Role.individual.name &&
                        user?.role != Role.towner.name) GestureDetector(
                      onTap: () {
                        showLogoutDialogForLeaveTeam(context);
                      },
                      child: Container(
                        height: 53,
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(top: 14),
                        decoration: BoxDecoration(color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/leave_icon.png",
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 14,),
                            Text( AppLocalizations.of(context).translate('leaveTeam'),
                                style: TextStyle(color: Colors.redAccent)),

                          ],
                        ),
                      ),
                    )

                  ],)
              ],
            ),
          ),
        ),
      ),
    );
  }


  void showLogoutDialogForLeaveTeam(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text( AppLocalizations.of(context).translate('leaveTeam'),),
          content: Text( AppLocalizations.of(context).translate('doYouWLeave'),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform delete action here
                Utility.showLoader(context);
                Navigator.of(context).pop();
                apiLeaveTeam();
                // Close the dialog
              },
              child: Text( AppLocalizations.of(context).translate('leave')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text( AppLocalizations.of(context).translate('cancel')),
            ),
          ],
        );
      },
    );
  }
  void showLogoutDialogForDeleteTeam(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text( AppLocalizations.of(context).translate('deleteTeam')),
          content: Text( AppLocalizations.of(context).translate('doYouWDelete')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform delete action here
                Utility.showLoader(context);

                apiDeleteTeam(
                    teamResponse?.data.id.toString() ?? "");
                // Close the dialog
              },
              child: Text( AppLocalizations.of(context).translate('delete'),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text( AppLocalizations.of(context).translate('cancel'),),
            ),
          ],
        );
      },
    );
  }

  Widget _getShimmerView() {
    return Shimmer.fromColors(
      baseColor: Color(0x72231532),
      highlightColor: Color(0xFF463B5C), child: Column(
      children: [
        Center(
          child: Container(height: 100,
            margin: EdgeInsets.symmetric(vertical: 16),
            width: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),
                color: Color(0x72231532)),),
        ),
        Container(height: 20,
          width: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
              color: Color(0x72231532)),),
        SizedBox(height: 5,),
        Container(height: 20,
          width: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
              color: Color(0x72231532)),),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          padding:
          const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
          decoration: BoxDecoration(
            color:
            const Color(0x72231532),
            borderRadius: BorderRadius.circular(20),
          ),),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          padding:
          const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
          decoration: BoxDecoration(
            color:
            const Color(0x72231532),
            borderRadius: BorderRadius.circular(20),
          ),),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          padding:
          const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
          decoration: BoxDecoration(
            color:
            const Color(0x72231532),
            borderRadius: BorderRadius.circular(20),
          ),), Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          padding:
          const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
          decoration: BoxDecoration(
            color:
            const Color(0x72231532),
            borderRadius: BorderRadius.circular(20),
          ),), Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          padding:
          const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
          decoration: BoxDecoration(
            color:
            const Color(0x72231532),
            borderRadius: BorderRadius.circular(20),
          ),)
      ],
    ),);
  }

  Widget ApprovalCard() {
    return SizedBox(
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 1,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              // First Row
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.yellow.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).translate('approvalPending'),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Second Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                        AppLocalizations.of(context).translate('manufacturingTeam'),
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Container(
                      height: 24, // Diameter of the circle
                      width: 24,
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
                            // Add your logic here
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const OptionTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}


enum Role{individual,member,tadmin,towner,gadmin}

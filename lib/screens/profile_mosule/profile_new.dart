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
import 'package:shimmer/shimmer.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/team_cubit.dart';
import '../../language/app_localizations.dart';
import '../../localStorage/storage.dart';
import '../../models/group_response.dart';
import '../../models/login_dto.dart';
import '../../models/team_member.dart';
import '../../models/team_response.dart';
import '../../utils/utility.dart';
import '../../utils/widgets/network.dart';
import '../group_module/create_group.dart';
import '../group_module/group_management_member.dart';
import '../subscription_module/buy_preview_subscription.dart';
import '../subscription_module/subscription_screen.dart';
import '../tag/tag_management_screen.dart';
import '../team/edit_team.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TeamCubit? getTeamCubit,_getTeamMember,_deleteTeamCubit;
  GroupCubit? getGroupCubit;
  AuthCubit?_authCubit,_completeProfileCubit;
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

  Future<void> fetchGroupData() async {
    getGroupCubit?.apiGetMyGroups();
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
    getTeamCubit =TeamCubit(TeamRepository());
    _getTeamMember =TeamCubit(TeamRepository());
    _deleteTeamCubit =TeamCubit(TeamRepository());
    getGroupCubit =GroupCubit(GroupRepository());
    _authCubit =AuthCubit(AuthRepository());
    _completeProfileCubit =AuthCubit(AuthRepository());
    fetchUserData();
    // fetchGroupData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, ResponseState>(
            bloc: _completeProfileCubit,
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
                    context: context,
                    message: state.errorMessage,
                    isError: true);
              } else if (state is ResponseStateSuccess) {
                var dto = state.data as LoginDto;
                if (dto.user != null) {
                  fetchUserData();
                  Utility().showFlushBar(
                      context: context, message: dto.message ?? "");
                }else{
                  Utility.hideLoader(context);
                }
              }setState(() {

              });
            }),
        BlocListener<TeamCubit, ResponseState>(
            bloc: _deleteTeamCubit,
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
                    context: context,
                    message: state.errorMessage,
                    isError: true);
              } else if (state is ResponseStateSuccess) {
                var dto = state.data as UtilityDto;
                  fetchUserData();
                  fetchTeamData();
                  Utility().showFlushBar(
                      context: context, message: dto.message ?? "");
              }setState(() {

              });
            }),
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
          bloc: getTeamCubit,
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
              var dto = state.data as TeamResponse;
              teamResponse = dto;
            }
            setState(() {});
          },
        ),
        BlocListener<AuthCubit, ResponseState>(
          bloc: _authCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              isLoad = false;
              Utility.hideLoader(context);
            } else if (state is ResponseStateNoInternet) {
              isLoad = false;
              Utility.hideLoader(context);
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
              isLoad = false;
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as User;
              user = dto;
              if(user != null && user?.role != Role.individual.name){
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
                        "My Account",
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


                isLoad?_getShimmerView():
                // Profile Picture and Name
               Column(
               children: [ user != null && user!.avatar != null
                   ? ClipRRect(
                 borderRadius: BorderRadius.circular(
                     10000.0),
                 child: CachedNetworkImage(
                   height: 100,
                   width: 100,
                   fit: BoxFit.fitWidth,
                   imageUrl: "${Network.imgUrl}${user!.avatar}",
                   progressIndicatorBuilder:
                       (context, url, downloadProgress) => Center(
                     child: CircularProgressIndicator(
                         value: downloadProgress.progress),
                   ),
                   errorWidget: (context, url, error) => Image.asset(
                     "assets/images/user_dummy.png",
                     height: 80,
                     fit: BoxFit.fill,
                     width: double.infinity,
                   ),
                 ),
               )
                   : const CircleAvatar(
                 radius: 50,
                 backgroundImage: AssetImage(
                     'assets/images/user_dummy.png'), // Replace with actual image URL
                 child: Align(
                   alignment: Alignment.bottomRight,
                   child: CircleAvatar(
                     radius: 15,
                     backgroundColor: Colors.blue,
                     child: Icon(Icons.edit_outlined,
                         size: 15, color: Colors.white),
                   ),
                 ),
               ),

                 const SizedBox(height: 10),
                 Text(
                   user?.firstName ?? "",
                   style:
                   const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                 ),
                 Text(
                   user?.lastName ?? "",
                   style: const TextStyle(color: Colors.grey),
                 ),
                 const SizedBox(height: 20),

                 // Subscription Info
                 if(user?.planId != 3)   Container(
                   padding:
                   const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
                   decoration: BoxDecoration(
                     border: Border.all(color: Colors.blue, width: 1),
                     color:
                     const Color.fromARGB(255, 133, 189, 236).withOpacity(0.1),
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
                                   builder: (builder) => SubscriptionScreen())).then((onValue) {
                             if(user != null && user?.role != Role.individual.name){
                               getTeamMembers();
                               fetchTeamData();
                             }
                           });
                         },
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               AppLocalizations.of(context)
                                   .translate('Subscribed'),
                               style: const TextStyle(fontWeight: FontWeight.bold),
                             ),
                             Text(
                               AppLocalizations.of(context).translate('manage'),
                               style: const TextStyle(color: Colors.grey),
                             ),
                           ],
                         ),
                       ),
                     ],
                   ),
                 ),
                 if(user?.planId != 3)    const SizedBox(height: 20),

                 // Team Information
                 Align(
                   alignment: Alignment.centerLeft,
                   child: Text(
                     user?.role == Role.tadmin.name?  "Team Admin":
                     user?.role == Role.towner.name ? "Team Owner": user!.role.toString() ,
                     style: const TextStyle(fontWeight: FontWeight.bold),
                   ),
                 ),
                 if(user?.role != Role.individual.name)               const SizedBox(height: 10),
                 if(user?.role != Role.individual.name)             InkWell(
                   onTap: (){
                     if (teamResponse == null) {
                       Navigator.push(
                           context,
                           CupertinoPageRoute(
                               builder: (builder) => SubscriptionScreen()))
                           .then((onValue) {
                         if(user != null && user?.role != Role.individual.name){
                           getTeamMembers();
                           fetchTeamData();
                         }
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
                                   "${Network.imgUrl}${teamResponse!.data.teamLogo ?? ""}",
                                   fit: BoxFit.cover,
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
                                   style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),
                                 ),
                                 Text(
                                   teamResponse?.data.teamDescription ?? "-",style: TextStyle(color:Color(0xFF949494) ),
                                 ),
                                 Row(children: [
                                   if(teamMember.isNotEmpty)  ClipRRect(
                                     borderRadius: BorderRadius.circular(16),
                                     child: Image.network(
                                       "${Network.imgUrl}${teamMember[0].avatar ??""}",
                                       fit: BoxFit.cover,
                                       errorBuilder: (context, error, stackTrace) {
                                         return Container(color: Colors.grey);
                                       },
                                     ),
                                   ),
                                   SizedBox(width: 5,),
                                   if(teamMember.isNotEmpty) Text(
                                     teamMember[0].name ?? "",
                                   ),
                                   if(teamMember.isNotEmpty && teamMember.length > 1)   SizedBox(width: 8,),
                                   if(teamMember.isNotEmpty && teamMember.length > 1)  Container(width: 1,height: 5,color: Colors.grey,),
                                   if(teamMember.isNotEmpty && teamMember.length > 1)   ClipRRect(
                                     borderRadius: BorderRadius.circular(16),
                                     child: Image.network(
                                       "${Network.imgUrl}${teamMember[1].avatar ??""}",
                                       fit: BoxFit.cover,
                                     ),
                                   ),
                                   if(teamMember.isNotEmpty && teamMember.length > 1)  SizedBox(width: 5,),
                                   if(teamMember.isNotEmpty && teamMember.length > 1)  Text(
                                     teamMember[1].name ?? "",
                                   ),
                                 ],)
                               ],
                             ),
                             Spacer(),
                             // if(user?.role != Role.individual.name && user?.role != Role.member.name && (user?.role != Role.towner.name || user?.role != Role.tadmin.name))
                             if(user?.role == Role.towner.name)
                               InkWell(
                                 onTap: (){
                                   Navigator.push(
                                       context,
                                       CupertinoPageRoute(
                                           builder: (builder) => EditTeamPage()))
                                       .then((onValue) {
                                     fetchTeamData();
                                   });
                                 },
                                 child: Image.asset("assets/images/edit-05.png",width: 20,height: 20,color: Color(0xFF949494),))
                           ],),

                       ],
                     ),
                   ),
                 ),
                 if(user?.role != Role.individual.name)        const SizedBox(height: 10),
                 if(user?.role != Role.individual.name && myGroupList.isNotEmpty)          Container(
                   padding: const EdgeInsets.all(8),
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(12),
                       color: Colors.grey.withOpacity(0.2)),
                   child: ListTile(
                     onTap: () {
                       if( user?.role != Role.individual.name && user?.role != Role.member.name && (user?.role != Role.towner.name || user?.role != Role.tadmin.name || (myGroupList.isNotEmpty && myGroupList[0].adminId == user?.id))){
                         if(myGroupList.isEmpty){
                           Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroupPage(),)).then((value) {
                             fetchGroupData();
                           },);
                         }else {
                           Navigator.push(context, MaterialPageRoute(
                             builder: (context) => EditGroupPage(groupId:myGroupList[0].id?.toString() ,role: user?.role ?? "",),)).then((value) {
                             fetchGroupData();
                           },);
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
                           "${Network.imgUrl}${myGroupList[0].groupLogo ?? ""}",
                           fit: BoxFit.cover,
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
                       children: [
                         Text(
                           myGroupList[0].groupName ?? "-",
                         ),
                         Image.asset("assets/images/edit-05.png",width: 20,height: 20,color: Color(0xFF949494),)
                       ],
                     ),
                     subtitle: Text(
                       myGroupList[0].groupDescription ?? "-",
                     ),
                   ),
                 ),
                 if((user?.role == Role.tadmin.name || user?.role == Role.towner.name) && myGroupList.isEmpty)      InkWell(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroupPage(),));
                   },
                   child: Container(height: 55,
                     width: MediaQuery.of(context).size.width,
                     padding: const EdgeInsets.all(16),
                     alignment: Alignment.centerLeft,
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(12),
                         color: Colors.grey.withOpacity(0.2)),child: Text("Create Group",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),),
                 ),
                 if(user?.role != Role.individual.name &&  user?.role != Role.member.name)       const SizedBox(height: 20),
                 if(user?.role == Role.individual.name && user?.userStatusId == 2 &&  user?.role != Role.member.name)     ApprovalCard(),
                 if(user?.role.toString() == Role.individual.name && user?.teamId == null && user?.userStatusId == 1)       Card(
                   elevation: 0,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                           padding: const EdgeInsets.symmetric(vertical: 10),
                           child: Text(
                             'Team code',
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
                                 'first_name':user?.firstName ?? "",
                                 'last_name':user?.lastName ?? "",
                                 'team_code' : controller.text,
                               };
                               _completeProfileCubit?.completeProfileApi(data,);
                             },
                             child: const Text('Join'),
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
                 if(user?.role == Role.tadmin.name ||  user?.role == Role.towner.name)    GestureDetector(
                   onTap: () {
                     Navigator.push(
                         context,
                         CupertinoPageRoute(
                             builder: (builder) => TeamMemberPage()));
                   },
                   child: OptionTile(
                     icon: Icons.group_add,
                     title: 'Invite Members',
                   ),
                 ),
                 if(user?.role != Role.towner.name &&  user?.role != Role.tadmin.name && myGroupList.isNotEmpty)            GestureDetector(
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

                 if(user?.role != Role.individual.name &&  user?.role != Role.member.name)           GestureDetector(
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
                 if(user?.role != Role.individual.name &&  user?.role == Role.towner.name)           GestureDetector(
                   onTap: () {
                     Navigator.push(
                         context,
                         CupertinoPageRoute(
                             builder: (builder) => TagManagementScreen()));
                   },
                   child: ListTile(
                     leading: Image.asset("assets/images/tag_icon.png",height: 22,width: 22,),
                     title: Text("Manage Team Tags"),
                     trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                   ),
                 ),
                 if(user?.role == Role.towner.name)   Container(
                   height: 53,
                   padding: EdgeInsets.all(16),
                   margin: EdgeInsets.only(top: 14),
                   decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(16)),
                   child: Row(
                     children: [
                       Image.asset(
                         "assets/images/delete_icon.png",
                         width: 20,
                         height: 20,
                       ),
                       SizedBox(width: 14,),
                       Text("Delete Team",style: TextStyle(color: Colors.redAccent)),

                     ],
                   ),
                 ),
                 if(user?.role != Role.individual.name && user?.role == Role.towner.name)   Container(
                   height: 53,
                   padding: EdgeInsets.all(16),
                   margin: EdgeInsets.only(top: 14),
                   decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(16)),
                   child: Row(
                     children: [
                       Image.asset(
                         "assets/images/leave_icon.png",
                         width: 20,
                         height: 20,
                       ),
                       SizedBox(width: 14,),
                       Text("Leave Team",style: TextStyle(color: Colors.redAccent)),

                     ],
                   ),
                 )],)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
Widget _getShimmerView() {
  return Shimmer.fromColors(
      baseColor:  Color(0x72231532),
      highlightColor: Color(0xFF463B5C), child: Column(
    children: [
     Center(
       child: Container(height: 100,
         margin: EdgeInsets.symmetric(vertical: 16),
         width: 100,decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: Color(0x72231532)),),
     ),
      Container(height: 20,
       width: 60,decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Color(0x72231532)),),
      SizedBox(height: 5,),
      Container(height: 20,
       width: 60,decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color: Color(0x72231532)),),
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
  ),);}
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
                  "Approval Pending",
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
                    "Manufacturing Team",
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
                      border: Border.all(color: Colors.red.shade400, width: 2),
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


enum Role{individual,member,tadmin,towner}

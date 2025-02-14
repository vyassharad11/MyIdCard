import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:my_di_card/models/user_data_model.dart';
import 'package:my_di_card/screens/group_module/edit_group.dart';
import 'package:my_di_card/screens/setting_module/setting_screen.dart';
import 'package:my_di_card/screens/team/team_member.dart';

import '../../language/app_localizations.dart';
import '../../localStorage/storage.dart';
import '../../models/group_response.dart';
import '../../models/team_response.dart';
import '../../utils/widgets/network.dart';
import '../group_module/create_group.dart';
import '../group_module/group_management_member.dart';
import '../subscription_module/buy_preview_subscription.dart';
import '../subscription_module/subscription_screen.dart';
import '../team/edit_team.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final String apiUrl = "${Network.baseUrl}user";
  final String apiUrlTeam = "${Network.baseUrl}team/get-my-team";
  final String apiUrlGroup = "${Network.baseUrl}group/get/12";

  User? user;
  Future<void> fetchCard() async {
    String token = await Storage().getToken();
    debugPrint("token---$token");
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer $token', // Add your authorization token
    });

    if (response.statusCode == 200) {
      setState(() {
        debugPrint("user---${json.decode(response.body)}");

        user = User.fromJson(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load localization data');
    }
  }

  TeamResponse? teamResponse;
  GroupDataModel? groupDataModel;
  Future<void> fetchTeamData() async {
    try {
      String token = await Storage().getToken();
      debugPrint("token---$token");
      final response = await http.get(Uri.parse(apiUrlTeam), headers: {
        'Authorization': 'Bearer $token', // Add your authorization token
      });

      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          teamResponse = TeamResponse.fromJson(jsonResponse);
        });
      } else {
        throw Exception('Failed to load team data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> fetchGroupData() async {
    try {
      String token = await Storage().getToken();
      debugPrint("token---$token");
      final response = await http.get(Uri.parse(apiUrlGroup), headers: {
        'Authorization': 'Bearer $token', // Add your authorization token
      });

      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          groupDataModel = GroupDataModel.fromJson(jsonResponse);
        });
      } else {
        throw Exception('Failed to load team data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  void initState() {
    fetchCard();
    // fetchTeamData();
    // fetchGroupData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Profile Picture and Name
              user != null && user!.avatar != null
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
              Container(
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
                                builder: (builder) => EditTeamPage()));
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
              const SizedBox(height: 20),

              // Team Information
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).translate('teamadmin'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.withOpacity(0.2)),
                child: ListTile(
                  onTap: () {
                    if (teamResponse == null) {
                      Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (builder) => SubscriptionScreen()))
                          .then((onValue) {
                        fetchTeamData();
                      });
                    } else {
                      Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (builder) => EditTeamPage()))
                          .then((onValue) {
                        fetchTeamData();
                      });
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: teamResponse != null &&
                          teamResponse!.data.teamLogo != null
                      ? SizedBox(
                          height: 50,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              "${Network.imgUrl}${teamResponse!.data.teamLogo}",
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
                  title: Text(
                    teamResponse?.data.teamName ?? "-",
                  ),
                  subtitle: Text(
                    teamResponse?.data.teamDescription ?? "-",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.withOpacity(0.2)),
                child: ListTile(
                  onTap: () {
                    if (teamResponse == null) {
                      Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (builder) => CreateGroupPage()))
                          .then((onValue) {
                        fetchGroupData();
                      });
                    } else {
                      Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (builder) => EditGroupPage()))
                          .then((onValue) {
                        fetchGroupData();
                      });
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: groupDataModel != null &&
                          groupDataModel!.data != null &&
                          groupDataModel!.data!.groupLogo != null
                      ? SizedBox(
                          height: 50,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              "${Network.imgUrl}${groupDataModel!.data!.groupLogo}",
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
                  title: Text(
                    groupDataModel?.data?.groupName ?? "-",
                  ),
                  subtitle: Text(
                    groupDataModel?.data?.groupDescription ?? "-",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ApprovalCard(),
              Card(
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
                          onPressed: () {},
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
              GestureDetector(
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
              GestureDetector(
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
              GestureDetector(
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
            ],
          ),
        ),
      ),
    );
  }
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

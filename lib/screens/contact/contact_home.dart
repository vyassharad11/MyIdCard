import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/bloc/cubit/contact_cubit.dart';
import 'package:my_di_card/data/repository/contact_repository.dart';
import 'package:my_di_card/data/repository/group_repository.dart';
import 'package:my_di_card/models/my_contact_model.dart';
import 'package:my_di_card/models/utility_dto.dart';
import 'package:my_di_card/screens/contact/contact_details_screen.dart';
import 'package:my_di_card/utils/widgets/network.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/group_cubit.dart';
import '../../models/tag_model.dart';
import '../../utils/utility.dart';
import '../home_module/add_new_contact.dart';
import '../tag/tag_management_screen.dart';
import 'contact_notes.dart';

class ContactHomeScreen extends StatefulWidget {
  @override
  State<ContactHomeScreen> createState() => _ContactHomeScreenState();

  const ContactHomeScreen({super.key});
}

class _ContactHomeScreenState extends State<ContactHomeScreen> {
  GroupCubit? _getTagCubit;
  ContactCubit? _getMyContact,_addContactCubit;

  List<Datum> tags = [];
  List<ContactDetailsDatum> myContactList = [];


  @override
  void initState() {
    _getTagCubit = GroupCubit(GroupRepository());
    _getMyContact = ContactCubit(ContactRepository());
    _addContactCubit = ContactCubit(ContactRepository());
    apiTagList();
    apiGetMyContact();
    // TODO: implement initState
    super.initState();
  }

  @override
  dispose(){
    _getTagCubit?.close();
    _addContactCubit?.close();
    _addContactCubit = null;
    _getTagCubit = null;
    super.dispose();
  }

  Future<void> apiTagList() async {
    Map<String, dynamic> data = {
      "key_word": "",
      "page": 1,
    };
    _getTagCubit?.apiGetTeamTag(data);
  }

  Future<void> apiAddContact(cardId) async {
    Map<String, dynamic> data = {
      "card_id": cardId,
    };
    _addContactCubit?.apiAddContact(data);
  }

  Future<void> apiGetMyContact() async {
    _getMyContact?.apiGetMyContact();
  }

  int selectIndec = 0;
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GroupCubit, ResponseState>(
          bloc: _getTagCubit,
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
              var dto = state.data as TagModel;
              tags = dto.data?.data ?? [];
            }
            setState(() {});
          },
        ),
        BlocListener<ContactCubit, ResponseState>(
          bloc: _getMyContact,
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
              var dto = state.data as MyContactDto;
              myContactList = [];
              myContactList = dto.data ?? [];
            }
            setState(() {});
          },
        ),
        BlocListener<ContactCubit, ResponseState>(
          bloc: _addContactCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              Utility.hideLoader(context);
              Navigator.pop(context);
              Utility().showFlushBar(context: context,message: state.message,isError: true);
            } else if (state is ResponseStateNoInternet) {
              Utility.hideLoader(context);
              Navigator.pop(context);
              Utility().showFlushBar(context: context,message: state.message,isError: true);
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
              Navigator.pop(context);
              Utility().showFlushBar(context: context,message: state.errorMessage,isError: true);
                  } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as UtilityDto;
              Utility().showFlushBar(context: context, message: dto.message ?? "");
              apiGetMyContact();
            }
            setState(() {});
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text(
            'Contacts',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20, top: 6),
              padding: const EdgeInsets.only(right: 0, top: 6, bottom: 6),
              child: ClipOval(
                child: Material(
                  color: Colors.blue, // Button color
                  child: InkWell(
                    splashColor: Colors.blue, // Splash color
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => ScanQrCodeBottomSheet(callBack: (v){
                          Navigator.pop(context);
                          context.loaderOverlay.show();
                          apiAddContact(v);
                        },),
                      );
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
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              tabBarWidget(context),
              tabBarTile(selectIndec == 0 ? "Tags" : "Groups",
                  selectIndec == 0 ? true : false),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabBarTile(String tilre, bool value) {
    return Column(
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
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor:
                        Colors.transparent, // To make corners rounded
                    builder: (context) => FullScreenBottomSheet(),
                  );
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
                tilre,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              if (value)
                IconButton(
                  icon: Image.asset(
                    "assets/images/edit-05.png",
                    color: Colors.grey,
                    height: 20,
                    width: 20,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (builder) => TagManagementScreen()));
                    // Edit button functionality
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Add some space between title and list
        SizedBox(
          height: 35, // Fixed height for tag list items
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: tags.length,
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
                      tags[index].tag ?? "",
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
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Recent',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal: 18),
          child: ListView.separated(
            separatorBuilder: (ctx, index) {
              return const SizedBox(
                width: 16,
              );
            },
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: peopleHori.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          AssetImage(peopleHori[index].imageUrl.toString()),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    peopleHori[index].name.toString().substring(0, 5),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 8,
                        color: Colors.black),
                  ),
                ],
              );
            },
          ),
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: myContactList.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage:
                      AssetImage("${Network.imgUrl}${myContactList[index].cardImage ?? ""}"),
                ),
                title: Text(
                  myContactList[index].firstName ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black),
                ),
                subtitle: Text(
                  "",
                 style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: Colors.black),
                ),
                trailing: const Icon(Icons.more_vert),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (builder) =>  ContactDetails(contactId: myContactList[index].cardId ?? 0,),
                    ),
                  );
                  // Add your onTap functionality here if needed
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget tabBarWidget(BuildContext context) {
    return Center(
      child: CustomSlidingSegmentedControl<int>(
        initialValue: 1,
        fixedWidth: 150,
        innerPadding: const EdgeInsets.all(3),
        children: {
          1: Text(
            'Private Contact',
            style: TextStyle(
                color: Colors.black,
                fontWeight:
                    selectIndec == 1 ? FontWeight.bold : FontWeight.normal),
          ),
          2: Text('Team Contacts',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight:
                      selectIndec == 2 ? FontWeight.bold : FontWeight.normal)),
        },
        decoration: BoxDecoration(
          color: CupertinoColors.lightBackgroundGray,
          borderRadius: BorderRadius.circular(8),
        ),
        thumbDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.3),
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: const Offset(
                0.0,
                2.0,
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
        onValueChanged: (v) {
          setState(() {
            selectIndec = v;
          });
        },
      ),
    );
  }

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
}

class Person {
  final String name;
  final String description;
  final String imageUrl;

  Person(this.name, this.description, this.imageUrl);
}

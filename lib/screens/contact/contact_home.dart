import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/bloc/cubit/contact_cubit.dart';
import 'package:my_di_card/data/repository/contact_repository.dart';
import 'package:my_di_card/data/repository/group_repository.dart';
import 'package:my_di_card/models/my_contact_model.dart';
import 'package:my_di_card/models/utility_dto.dart';
import 'package:my_di_card/screens/contact/contact_details_screen.dart';
import 'package:my_di_card/screens/contact/team_member_contact.dart';
import 'package:my_di_card/utils/widgets/network.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/group_cubit.dart';
import '../../localStorage/storage.dart';
import '../../models/recent_contact_mode.dart';
import '../../models/tag_model.dart';
import '../../utils/utility.dart';
import '../home_module/add_new_contact.dart';
import '../tag/tag_management_screen.dart';
import 'add_tag_in_contact_bottom_sheet.dart';
import 'contact_notes.dart';

class ContactHomeScreen extends StatefulWidget {
  @override
  State<ContactHomeScreen> createState() => _ContactHomeScreenState();

  const ContactHomeScreen({super.key});
}

class _ContactHomeScreenState extends State<ContactHomeScreen> {
  ContactCubit? _getTagCubit;
  ContactCubit? _getRecentContact, _getMyContact, _addContactCubit,
      deleteContactCubit, _favCubit;
  int selectedIndex = 0;
  List<TagDatum> tags = [];
  List<ContactDatum> myContactList = [];
  List<RecentDatum> recentContactList = [];
  bool isLoad = true;
  TextEditingController controller = TextEditingController();
bool isHideF = false;
bool isPhisical = false;
bool isInTeam = false;
  String companyTypeIdF = "",companyNameF = "",cardTypeId ="",selectedValueF = "";

  @override
  void initState() {
    Storage().getIsIndivisual().then((value) {
      isInTeam = value;
      setState(() {

      });
    },);
    _getTagCubit = ContactCubit(ContactRepository());
    _getMyContact = ContactCubit(ContactRepository());
    _addContactCubit = ContactCubit(ContactRepository());
    deleteContactCubit = ContactCubit(ContactRepository());
    _getRecentContact = ContactCubit(ContactRepository());
    _favCubit = ContactCubit(ContactRepository());
    apiTagList();
    apiGetRecentContact();
    apiGetMyContact("", false,"","");
    // TODO: implement initState
    super.initState();
  }

  @override
  dispose() {
    _getTagCubit?.close();
    _getMyContact?.close();
    deleteContactCubit?.close();
    _addContactCubit?.close();
    _getRecentContact?.close();
    _favCubit?.close();
    _addContactCubit = null;
    _getMyContact = null;
    _favCubit = null;
    _getTagCubit = null;
    _getRecentContact = null;
    deleteContactCubit = null;
    super.dispose();
  }

  Future<void> apiTagList() async {
    Map<String, dynamic> data = {
      "key_word": "",
      "page": 1,
    };
    _getTagCubit?.apiGetCardTag(data);
  }

  Future<void> apiAddContact(cardId) async {
    Map<String, dynamic> data = {
      "card_id": cardId,
    };
    _addContactCubit?.apiAddContact(data);
  }

  Future<void> apiGetMyContact(key, hide,companyTypeId,cardTypeId) async {
    List<int> tagId = [];
    tags.forEach(
          (element) {
        if (element.isCheck == true) {
          tagId.add(element.id ?? 0);
        }
      },
    );
    String contactTagIdsString = tagId.join(',');
    Map<String, dynamic> data = {
      "key_word": key,
      "tag_ids": contactTagIdsString,
      "company_type_id": companyTypeId ?? "",
      "contact_status": hide == true ? "2" : "1",
      "contact_type_id":cardTypeId,
      "favorite": ""
    };

    _getMyContact?.apiGetMyContact(data);
  }

  Future<void> apiGetRecentContact() async {
    _getRecentContact?.apiGetRecentContact();
  }


  Future<void> apiDeleteContact(contactIdForMeeting) async {
    deleteContactCubit?.apiDeleteContact(contactIdForMeeting ?? "");
  }


  Future<void> apiContactFavUnFav(cardId, fav) async {
    Map<String, dynamic> data = {
      "favorite": fav.toString(),
    };
    _favCubit?.apiContactFavUnFav(cardId, data);
  }

  Future<void> apiContactHideUnHide(cardId, hide) async {
    Map<String, dynamic> data = {
      "contact_status": hide,
    };
    _favCubit?.apiContactHideUnHide(cardId, data);
  }


  int selectIndec = 1;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ContactCubit, ResponseState>(
          bloc: deleteContactCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {} else
            if (state is ResponseStateEmpty) {
              Utility.hideLoader(context);
            } else if (state is ResponseStateNoInternet) {
              Utility.hideLoader(context);
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as UtilityDto;
              myContactList.removeAt(selectedIndex);
              Utility().showFlushBar(
                  context: context, message: dto.message ?? "");
            }
            setState(() {});
          },
        ),
        BlocListener<ContactCubit, ResponseState>(
          bloc: _favCubit,
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
                  context: context, message: state.errorMessage, isError: true);
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as UtilityDto;
              Utility()
                  .showFlushBar(context: context, message: dto.message ?? "");
              apiGetMyContact("", false,"","");
            }
            setState(() {});
          },
        ),
        BlocListener<ContactCubit, ResponseState>(
          bloc: _getTagCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {} else
            if (state is ResponseStateEmpty) {
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
            if (state is ResponseStateLoading) {} else
            if (state is ResponseStateEmpty) {
              isLoad = false;
              Utility.hideLoader(context);
            } else if (state is ResponseStateNoInternet) {
              isLoad = false;
              Utility.hideLoader(context);
            } else if (state is ResponseStateError) {
              isLoad = false;
              Utility.hideLoader(context);
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as MyContactDto;
              myContactList = [];
              myContactList = dto.data?.data ?? [];
              isLoad = false;
            }
            setState(() {});
          },
        ),
        BlocListener<ContactCubit, ResponseState>(
          bloc: _getRecentContact,
          listener: (context, state) {
            if (state is ResponseStateLoading) {} else
            if (state is ResponseStateEmpty) {
              isLoad = false;
              Utility.hideLoader(context);
            } else if (state is ResponseStateNoInternet) {
              isLoad = false;
              Utility.hideLoader(context);
            } else if (state is ResponseStateError) {
              isLoad = false;
              Utility.hideLoader(context);
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as RecentContactDto;
              recentContactList = [];
              recentContactList = dto.data ?? [];
              isLoad = false;
            }
            setState(() {});
          },
        ),
        BlocListener<ContactCubit, ResponseState>(
          bloc: _addContactCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {} else
            if (state is ResponseStateEmpty) {
              Utility.hideLoader(context);
              Navigator.pop(context);
              Utility().showFlushBar(
                  context: context, message: state.message, isError: true);
            } else if (state is ResponseStateNoInternet) {
              Utility.hideLoader(context);
              Navigator.pop(context);
              Utility().showFlushBar(
                  context: context, message: state.message, isError: true);
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
              Navigator.pop(context);
              Utility().showFlushBar(
                  context: context, message: state.errorMessage, isError: true);
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as UtilityDto;
              Utility().showFlushBar(
                  context: context, message: dto.message ?? "");
              apiGetMyContact("", false,"","");
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
                        builder: (context) =>
                            ScanQrCodeBottomSheet(callBack: (v) {
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
              tabBarView()
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
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          onChanged: (v) {
                            apiGetMyContact(v, false,"","");
                          },
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
                    builder: (context) => FullScreenBottomSheet(
                      companyName: companyNameF,
                      isHowPhysical: isPhisical,
                      selectedValue: selectedValueF,
                      companyTypeId: companyTypeIdF,
                      isHide: isHideF,
                      callBack: (isHide, companyTypeId,companyName,isPhisica,selectedValue) {
                      isHideF = isHide;
                      isPhisical = isPhisica;
                      companyTypeIdF = companyTypeId;
                      selectedValueF = selectedValue;
                      companyNameF = companyName;
                      setState(() {

                      });
                      apiGetMyContact(controller.text, isHide,companyTypeId,isPhisica == true?"2":"");
                    },),
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
                            builder: (builder) =>
                                TagManagementScreen(isFromCard: true,))).then((value) {
                      apiTagList();                          },);
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
                child: InkWell(
                  onTap: () {
                    tags[index].isCheck =
                    tags[index].isCheck == false ? true : false;
                    setState(() {

                    });
                    apiGetMyContact(controller.text, false,"","");
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Light background color
                      border: Border.all(color: tags[index].isCheck == true
                          ? Colors.blue
                          : Colors.transparent),
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
        if(recentContactList.isNotEmpty)Container(
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
            itemCount: recentContactList.length,
            itemBuilder: (context, index) {
              return InkWell(onTap: (){
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (builder) =>
                        ContactDetails(contactId: recentContactList[index]
                            .id ?? 0,
                          isPhysicalContact: recentContactList[index].phoneNo == null ||  recentContactList[index].phoneNo!.isEmpty,
                          contactIdForMeeting: recentContactList[index].id,
                          tags: tags,),
                  ),
                ).then((value) {
                  if (value == 2) {
                    tags.forEach((element) {
                      element.isCheck = false;setState(() {

                      });
                    },);
                    apiGetMyContact(controller.text, false,"","");
                  }
                },);
              },
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            "${Network.imgUrl}${recentContactList[index].cardImage ??
                                ""}"),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      recentContactList[index].firstName.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 8,
                          color: Colors.black),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        isLoad == true ?
        Padding(padding: EdgeInsets.symmetric(horizontal: 20), child:
        Utility.userListShimmer()) :
        myContactList.isNotEmpty ?
        SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: myContactList.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                      "${Network.imgUrl}${myContactList[index].cardImage ??
                          ""}"),
                  backgroundColor: Colors.grey.shade200,

                ),
                title: Text(
                  "${myContactList[index].firstName} ${myContactList[index].lastName}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black),
                ),
                subtitle: Text(
                  myContactList[index].jobTitle ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: Colors.black),
                ),
                trailing: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (context) {
                          return buildContactBottomSheetContent(
                              context, myContactList[index].id, index);
                        },
                      );
                    },
                    child: const Icon(Icons.more_vert)),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (builder) =>
                          ContactDetails(contactId: myContactList[index]
                              .id ?? 0,
                            isPhysicalContact:
                            myContactList[index].phoneNo == null ||  myContactList[index].phoneNo!.isEmpty,
                            contactIdForMeeting: myContactList[index].id,
                            tags: tags,),
                    ),
                  ).then((value) {
                    if (value == 2) {
                      apiGetMyContact(controller.text, false,"","");
                    }
                  },);
                  // Add your onTap functionality here if needed
                },
              );
            },
          ),
        ) : SizedBox(),
      ],
    );
  }

  Widget tabBarView() {
    return  selectIndec == 1 ? tabBarTile("Tags",
        true) :
    TeamMemberContact();
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
      final newContact = Contact()
        ..name.first = firstName
        ..name.last = lastName
        ..phones = [Phone(mobileNumber)]; // Add the phone number here

      try {
        await FlutterContacts.insertContact(newContact);
        Utility().showFlushBar(
            context: context, message: 'Contact added successfully');
      } catch (e) {
        print('Error adding contact: $e');
      }
    }
  }

  Widget buildContactBottomSheetContent(BuildContext context,
      contactIdForMeeting, index) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              myContactList[index].favorite == 1
                  ? 'Add to favorites'
                  : 'UnFavorite',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              Utility.showLoader(context);
              apiContactFavUnFav(contactIdForMeeting,
                  myContactList[index].favorite == 1 ? 2 : 1);
              // Add functionality here
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title:  Text(
              myContactList[index].contactTags != null && myContactList[index].contactTags!.isNotEmpty  ? "Remove tag":'Add tag',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
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
                builder: (context) =>
                    AddTagInContactBottomSheet(
                      tags: tags,
                      contactTags:
                      myContactList[index].contactTags ?? [],
                      contactId: contactIdForMeeting ?? 0,
                    ),
              ).then((value) {
                tags.forEach((element) {
                  element.isCheck = false;setState(() {

                  });
                },);
                apiGetMyContact("", false,"","");
              },);

              // Add functionality here
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: Text(
              '${myContactList[index].contactStatus == 1
                  ? "Hide"
                  : "Un-hide"} Contact',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              Utility.showLoader(context);
              apiContactHideUnHide(myContactList[index].id.toString(),
                  myContactList[index].contactStatus == 1 ? "2" : "1");
              // Add functionality here
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            title: const Text(
              'Export to Contacts App',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              requestPermissions().then((value) {
                addContact(myContactList[index].firstName ?? "",
                    myContactList[index].lastName ?? "",
                    myContactList[index].phoneNo ?? "");
              },); // Add functionality here
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: const Text(
              'Delete Contact',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              Navigator.pop(context);
              Utility.showLoader(context);
              apiDeleteContact(contactIdForMeeting.toString());
              // Add delete functionality here
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget tabBarWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Color(0xFFEEF0F3),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: (){
                  setState(() {
                    selectIndec = 1;
                  });
              },
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                    color: selectIndec == 1 ? Colors.white :Colors.transparent,
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Center(
                  child: Text( 'Private Contact',
                    style: TextStyle(
                        color: selectIndec == 1 ? Colors.black : Color(0xFF949494),
                        fontWeight:
                        selectIndec == 1 ? FontWeight.bold : FontWeight.normal)),
                )
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: (){
                if(isInTeam) {
                  setState(() {
                    selectIndec = 2;
                  });
                }
              },
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                    color: selectIndec == 2 ? Colors.white :Colors.transparent,
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Center(
                  child: Text( 'Team Contacts',
                    style: TextStyle(
                        color: selectIndec == 2 ? Colors.black : Color(0xFF949494),
                        fontWeight:
                        selectIndec == 2 ? FontWeight.bold : FontWeight.normal)),
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}

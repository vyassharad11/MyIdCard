import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geocoding/geocoding.dart';
import 'package:my_di_card/models/utility_dto.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/contact_cubit.dart';
import '../../createCard/create_card_final_preview.dart';
import '../../data/repository/contact_repository.dart';
import '../../language/app_localizations.dart';
import '../../models/contact_details_dto.dart';
import '../../models/my_contact_model.dart';
import '../../models/my_meetings_model.dart';
import '../../models/tag_model.dart';
import '../../utils/colors/colors.dart';
import '../../utils/url_lancher.dart';
import '../../utils/utility.dart';
import '../../utils/widgets/network.dart';
import '../add_card_module/share_card_bottom_sheet.dart';
import '../meetings/create_edit_meeting.dart';
import '../meetings/metting_details.dart';
import '../meetings/metting_list.dart';
import 'add_tag_in_contact_bottom_sheet.dart';
import 'document_preivew.dart';
import 'other_card_details.dart';

class ContactDetails extends StatefulWidget {
  final int contactId;
  final int? contactIdForMeeting;
  final bool isPhysicalContact;
  final List<TagDatum> tags;

  const ContactDetails(
      {super.key,
      required this.contactId,
      required this.isPhysicalContact,
      this.contactIdForMeeting,
      required this.tags});

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  ContactCubit? _contactDetailCubit,
      deleteContactCubit,
      _favCubit,
      _updateNotesCubit;
  DataContact? contactDetailsDatum;
  ContactCubit? meetingCubit;
  List<MeetingDatum> meetings = [];
  TextEditingController notesController = TextEditingController();
  bool isEdit = false;
  bool isLoad = true;

  @override
  initState() {
    _contactDetailCubit = ContactCubit(ContactRepository());
    deleteContactCubit = ContactCubit(ContactRepository());
    meetingCubit = ContactCubit(ContactRepository());
    _favCubit = ContactCubit(ContactRepository());
    _updateNotesCubit = ContactCubit(ContactRepository());
    getContactDetail();
    apiGetMyMeetings();
    super.initState();
  }

  @override
  dispose() {
    _contactDetailCubit?.close();
    deleteContactCubit?.close();
    _updateNotesCubit?.close();
    meetingCubit?.close();
    _favCubit?.close();
    _contactDetailCubit = null;
    _updateNotesCubit = null;
    deleteContactCubit = null;
    _favCubit = null;
    meetingCubit = null;
    super.dispose();
  }

  Future<void> apiContactFavUnFav(cardId, fav) async {
    Map<String, dynamic> data = {
      "favorite": fav.toString(),
    };
    _favCubit?.apiContactFavUnFav(cardId, data);
  }

  Future<void> apiUpdateNotes(
    cardId,text
  ) async {
    Map<String, dynamic> data = {
      "notes": text,
    };
    _updateNotesCubit?.apiUpdateNotes(widget.contactIdForMeeting, data);
  }

  String? twitterLink, instaLink, faceBookLink, linkdinLink;

  setLink() {
    contactDetailsDatum?.cardSocials?.forEach((action) {
      if (action.socialName == "Twitter") {
        twitterLink =
            action.socialUrl.toString() + action.socialLink.toString();
      }
      if (action.socialName == "Instagram") {
        instaLink = action.socialUrl.toString() + action.socialLink.toString();
      }
      if (action.socialName == "Facebook") {
        faceBookLink =
            action.socialUrl.toString() + action.socialLink.toString();
      }
      if (action.socialName == "LinkedIn") {
        linkdinLink =
            action.socialUrl.toString() + action.socialLink.toString();
      }
    });
  }

  Future<void> getContactDetail() async {
    _contactDetailCubit?.apiGetContactDetail(widget.contactId);
  }

  Future<void> apiDeleteContact() async {
    deleteContactCubit?.apiDeleteContact(widget.contactIdForMeeting ?? "");
  }

  Future<void> apiGetMyMeetings() async {
    Map<String, dynamic> data = {
      "key_word": "",
      "page": 1,
      "contact_id": widget.contactId.toString()
    };
    meetingCubit?.apiGetMyMeetings(data);
  }

  Future<void> dialNumber(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> openSMS(String phoneNumber) async {
    final Uri url = Uri.parse('sms:$phoneNumber');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $url');
      throw 'Could not launch $url';
    }
  }

  Future<void> openGmail({String? email, String? subject, String? body}) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email ?? '',
      queryParameters: {
        'subject': subject ?? '',
        'body': body ?? '',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  Widget buildContactBottomSheetContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              contactDetailsDatum?.favorite == 1
                  ?AppLocalizations.of(context).translate('addToFavorites')
                  : AppLocalizations.of(context).translate('unFavorite'),
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              Utility.showLoader(context);
              apiContactFavUnFav(widget.contactIdForMeeting,
                  contactDetailsDatum?.favorite == 1 ? 2 : 1);
              // Add functionality here
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: Text(
              contactDetailsDatum != null &&
                      contactDetailsDatum!.contactTags != null &&
                      contactDetailsDatum!.contactTags!.isNotEmpty
                  ? AppLocalizations.of(context).translate('editTag')
                  : AppLocalizations.of(context).translate('addTag'),
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: false,
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 100,
                    minHeight: 10),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => AddTagInContactBottomSheet(
                  tags: widget.tags,
                  contactId: widget.contactIdForMeeting ?? 0,
                  contactTags: contactDetailsDatum?.contactTags ?? [],
                ),
              ).whenComplete(
                () {
                  getContactDetail();
                },
              );

              // Add functionality here
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: Text(
              '${contactDetailsDatum?.contactStatus == 1 ? AppLocalizations.of(context).translate('hide') : AppLocalizations.of(context).translate('unHide')} ${AppLocalizations.of(context).translate('contact')}',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              Utility.showLoader(context);
              apiContactHideUnHide(contactDetailsDatum?.id.toString(),
                  contactDetailsDatum?.contactStatus == 1 ? "2" : "1");
              // Add functionality here
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          if (widget.isPhysicalContact == false)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              title:  Text(
                AppLocalizations.of(context).translate('exportToContactsApp'),
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
                requestPermissions().then(
                  (value) {
                    addContact(
                        contactDetailsDatum?.firstName ?? "",
                        contactDetailsDatum?.lastName ?? "",
                        contactDetailsDatum?.phoneNo ?? "");
                  },
                ); // Add functionality here
              },
            ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title:  Text(
              AppLocalizations.of(context).translate('deleteContact'),
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              Utility.showLoader(context);
              apiDeleteContact();
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

  Future<void> _openMap(address) async {
    if (address.isEmpty) {
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;

        String googleMapsUrl =
            "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
        launch(googleMapsUrl);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> apiContactHideUnHide(cardId, hide) async {
    Map<String, dynamic> data = {
      "contact_status": hide,
    };
    _favCubit?.apiContactHideUnHide(cardId, data);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ContactCubit, ResponseState>(
          bloc: _favCubit,
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
              getContactDetail();
            }
            setState(() {});
          },
        ),
        BlocListener<ContactCubit, ResponseState>(
          bloc: _updateNotesCubit,
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
              isEdit = false;
              Utility()
                  .showFlushBar(context: context, message: dto.message ?? "");
              getContactDetail();
            }
            setState(() {});
          },
        ),
        BlocListener<ContactCubit, ResponseState>(
          bloc: _contactDetailCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              isLoad = false;
              Utility.hideLoader(context);
            } else if (state is ResponseStateNoInternet) {
              Utility.hideLoader(context);
              isLoad = false;
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
              isLoad = false;
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              isLoad = false;
              var dto = state.data as ContactDetailsDto;
              contactDetailsDatum = dto.data;
              notesController.text = contactDetailsDatum?.notes ?? "";
              setLink();
            }
            setState(() {});
          },
        ),
        BlocListener<ContactCubit, ResponseState>(
          bloc: deleteContactCubit,
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
              Navigator.pop(context, 2);
              Utility()
                  .showFlushBar(context: context, message: dto.message ?? "");
            }
            setState(() {});
          },
        ),
        BlocListener<ContactCubit, ResponseState>(
          bloc: meetingCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
            } else if (state is ResponseStateNoInternet) {
            } else if (state is ResponseStateError) {
            } else if (state is ResponseStateSuccess) {
              var dto = state.data as MyMeetingModel;
              meetings = [];
              meetings = dto.data?.data ?? [];
            }
            setState(() {});
          },
        ),
      ],
      child: Scaffold(
        // backgroundColor:  contactDetailsDatum
        //     ?.cardStyle !=
        //     null
        //     ? Color(int.parse(
        //     '0xFF${contactDetailsDatum!.cardStyle!}'))
        //     : Colors
        //     .white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          actionsIconTheme: const IconThemeData(color: Colors.black),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          title: Text(
            "${contactDetailsDatum?.cardName ?? ""}",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          actions: [
            if (contactDetailsDatum != null)
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      builder: (context) {
                        return buildContactBottomSheetContent(context);
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert))
          ],
        ),
        body: SingleChildScrollView(
          child: isLoad
              ? shimmerView()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12),
                      child: widget.isPhysicalContact
                          ? ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              child: CachedNetworkImage(
                                height: 170,
                                width: double.infinity,
                                fit: BoxFit.fitWidth,
                                imageUrl:
                                    "${Network.imgUrl}${contactDetailsDatum?.cardImage ?? ""}",
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "assets/logo/Central icon.png",
                                  height: 80,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                ),
                              ),
                            )
                          : Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    18), // if you need this
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  contactDetailsDatum?.backgroungImage != null
                                      ? Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(18),
                                                      topRight:
                                                          Radius.circular(18)),
                                              child: CachedNetworkImage(
                                                height: 80,
                                                width: double.infinity,
                                                fit: BoxFit.fitWidth,
                                                imageUrl:
                                                    "${Network.imgUrl}${contactDetailsDatum?.backgroungImage}",
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                  "assets/logo/Top with a picture.png",
                                                  height: 80,
                                                  fit: BoxFit.fill,
                                                  width: double.infinity,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12.0, left: 12),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                60)),
                                                    child: CachedNetworkImage(
                                                      height: 80,
                                                      width: 80,
                                                      fit: BoxFit.fitWidth,
                                                      imageUrl:
                                                          "${Network.imgUrl}${contactDetailsDatum?.cardImage}",
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              Center(
                                                        child: CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                        "assets/logo/Central icon.png",
                                                        height: 100,
                                                        fit: BoxFit.fill,
                                                        width: 100,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (builder) =>
                                                                  OtherCardDetails(
                                                                cardId: contactDetailsDatum
                                                                        ?.cardId
                                                                        .toString() ??
                                                                    "",
                                                                isOtherCard: true,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.info_rounded,
                                                          color: Colors.white,
                                                          size: 20,
                                                        )),
                                                    InkWell(
                                                      onTap: (){
                                                        showModalBottomSheet(
                                                          context: context,
                                                          useSafeArea: true,
                                                          isScrollControlled: true,
                                                          shape:
                                                          const RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                    20)),
                                                          ),
                                                          builder: (context) =>
                                                              ShareOtherCardBottomSheet(
                                                                cardData:
                                                                contactDetailsDatum,
                                                              ),
                                                        );
                                                      },
                                                      child: Image.asset(
                                                        "assets/images/send-01.png",
                                                        height: 16,
                                                        width: 16,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(18),
                                                      topRight:
                                                          Radius.circular(18)),
                                              child: Image.asset(
                                                "assets/logo/Top with a picture.png",
                                                height: 80,
                                                width: double.infinity,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0, left: 8),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                50)),
                                                    child: Image.asset(
                                                      "assets/logo/Central icon.png",
                                                      height: 55,
                                                      width: 55,
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 17,
                                                ),
                                                Text(
                                                  "${contactDetailsDatum?.firstName ?? ""} ${contactDetailsDatum?.lastName ?? ""}",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  contactDetailsDatum
                                                          ?.jobTitle ??
                                                      "",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black45),
                                                ),
                                                Text(
                                                  contactDetailsDatum
                                                          ?.companyName ??
                                                      "",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black45),
                                                ),
                                              ],
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(
                                                      75)),
                                              child: CachedNetworkImage(
                                                height: 75,
                                                width: 75,
                                                fit: BoxFit.fitWidth,
                                                imageUrl:
                                                "${Network.imgUrl}${contactDetailsDatum?.companyLogo ?? ""}",
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                    downloadProgress) =>
                                                    Center(
                                                      child: CircularProgressIndicator(
                                                          value:
                                                          downloadProgress
                                                              .progress),
                                                    ),
                                                errorWidget: (context,
                                                    url, error) =>
                                                    Image.asset(
                                                      "assets/logo/Central icon.png",
                                                      height: 80,
                                                      fit: BoxFit.fill,
                                                      width: double.infinity,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 1,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 18),
                                          color: Colors.black12,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                _showBottomSheet(context, () {
                                                  dialNumber(contactDetailsDatum
                                                          ?.phoneNo
                                                          .toString() ??
                                                      "");
                                                },
                                                    "Phone",
                                                    contactDetailsDatum?.phoneNo
                                                            .toString() ??
                                                        "",
                                                    false);
                                              },
                                              child: Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              45),
                                                      color: contactDetailsDatum
                                                                  ?.cardStyle !=
                                                              null
                                                          ? Color(int.parse(
                                                              '0xFF${contactDetailsDatum!.cardStyle!}'))
                                                          : Colors.blue),
                                                  child: Icon(
                                                    Icons.call,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _showBottomSheet(context,
                                                    () async {
                                                  // await launch("${contactDetailsDatum
                                                  //     ?.workEmail ??
                                                  //     ""}?subject=&body=");
                                                  await launch(
                                                      "mailto:${contactDetailsDatum?.workEmail ?? ""}?subject=&body=");
                                                  // openGmail(
                                                  //     body: "",
                                                  //     email: contactDetailsDatum
                                                  //             ?.workEmail ??
                                                  //         "",
                                                  //     subject: "");
                                                },
                                                    "Send Email",
                                                    contactDetailsDatum
                                                            ?.workEmail
                                                            .toString() ??
                                                        "",
                                                    false);
                                              },
                                              child: Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              45),
                                                      color: contactDetailsDatum
                                                                  ?.cardStyle !=
                                                              null
                                                          ? Color(int.parse(
                                                              '0xFF${contactDetailsDatum!.cardStyle!}'))
                                                          : Colors.blue),
                                                  child: Icon(
                                                    Icons.mail_outline_outlined,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _showBottomSheet(context,
                                                    () async {
                                                  // openSMS(contactDetailsDatum?.phoneNo
                                                  //         .toString() ??
                                                  //     "");

                                                  await launch(
                                                      "sms:${contactDetailsDatum?.phoneNo.toString() ?? ""}?body=");
                                                },
                                                    "Send Message",
                                                    contactDetailsDatum?.phoneNo
                                                            .toString() ??
                                                        "",
                                                    false);
                                              },
                                              child: Container(
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            45),
                                                    color: contactDetailsDatum
                                                                ?.cardStyle !=
                                                            null
                                                        ? Color(int.parse(
                                                            '0xFF${contactDetailsDatum!.cardStyle!}'))
                                                        : Colors.blue),
                                                child: Center(
                                                    child: Image.asset(
                                                  "assets/images/message_ic.png",
                                                  color: Colors.white,
                                                  width: 24,
                                                  height: 24,
                                                )),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _showBottomSheet(context, () {
                                                  _openMap(contactDetailsDatum
                                                          ?.companyAddress ??
                                                      "");
                                                },
                                                    "Send Location",
                                                    contactDetailsDatum
                                                            ?.companyAddress
                                                            .toString() ??
                                                        "",
                                                    false);
                                              },
                                              child: Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              45),
                                                      color: contactDetailsDatum
                                                                  ?.cardStyle !=
                                                              null
                                                          ? Color(int.parse(
                                                              '0xFF${contactDetailsDatum!.cardStyle!}'))
                                                          : Colors.blue),
                                                  child: Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.white,
                                                    size: 28,
                                                  )),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                launchUrlGet(
                                                  contactDetailsDatum
                                                          ?.companyWebsite ??
                                                      "",
                                                );
                                              },
                                              child: Container(
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            45),
                                                    color: contactDetailsDatum
                                                                ?.cardStyle !=
                                                            null
                                                        ? Color(int.parse(
                                                            '0xFF${contactDetailsDatum!.cardStyle!}'))
                                                        : Colors.blue),
                                                child: Center(
                                                    child: Image.asset(
                                                  "assets/images/link_ic.png",
                                                  width: 24,
                                                  height: 24,
                                                  color: Colors.white,
                                                )),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                     if(linkdinLink != null && linkdinLink!.isNotEmpty)       InkWell(
                                              onTap: () {
                                                print("setLink??>sssssss>>>>>>>>>>$linkdinLink");
                                                launchUrlGet(
                                                  linkdinLink ?? "",
                                                );
                                              },
                                              child: Image.asset(
                                                "assets/images/linkdin.png",
                                                height: 55,
                                                width: 45,
                                              ),
                                            ),
                                            if(faceBookLink != null && faceBookLink!.isNotEmpty)           InkWell(
                                              onTap: () {
                                                launchUrlGet(
                                                  faceBookLink ?? "",
                                                );
                                              },
                                              child: Image.asset(
                                                "assets/images/fb.png",
                                                height: 55,
                                                width: 45,
                                              ),
                                            ),
                                            if(twitterLink != null && twitterLink!.isNotEmpty)       InkWell(
                                              onTap: () {
                                                launchUrlGet(
                                                  twitterLink ?? "",
                                                );
                                              },
                                              child: Image.asset(
                                                "assets/images/x_fill.png",
                                                height: 55,
                                                width: 45,
                                              ),
                                            ),
                                            if(instaLink != null && instaLink!.isNotEmpty)               InkWell(
                                              onTap: () {
                                                launchUrlGet(
                                                  instaLink ?? "",
                                                );
                                              },
                                              child: Image.asset(
                                                "assets/images/insta.png",
                                                height: 55,
                                                width: 45,
                                              ),
                                            ),
                                            if (contactDetailsDatum != null &&
                                                contactDetailsDatum!.cardDocuments != null && contactDetailsDatum!.cardDocuments!.isNotEmpty)    InkWell(
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
                                                       Container(
                                                         decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
                                                         constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 200,minHeight: 100),
                                                         padding: EdgeInsets.only(bottom: 12),
                                                         child: ListView.separated(
                                                           shrinkWrap: true,
                                                           physics: const NeverScrollableScrollPhysics(),
                                                           separatorBuilder: (crtx, index) {
                                                             return Container(
                                                               height: 1,
                                                               color: ColoursUtils.background,
                                                               margin: const EdgeInsets.symmetric(
                                                                   horizontal: 12, vertical: 8),
                                                             );
                                                           },
                                                           padding: EdgeInsets.zero,
                                                           itemCount: contactDetailsDatum!.cardDocuments!.length,
                                                           itemBuilder: (context, index) {
                                                             return InkWell(
                                                               onTap: (){
                                                                 Navigator.pop(context);
                                                                 if(
                                                                 contactDetailsDatum!.cardDocuments![index].document.toString().contains("png") ||
                                                                     contactDetailsDatum!.cardDocuments![index].document.toString().contains("jpg") ||
                                                                     contactDetailsDatum!.cardDocuments![index].document.toString().contains("jpeg")
                                                                 ) {
                                                                   Navigator.push(context, MaterialPageRoute(
                                                                     builder: (context) =>
                                                                         DocumentPreview(
                                                                           imageUrl: contactDetailsDatum!
                                                                               .cardDocuments![index]
                                                                               .document ?? "",),));
                                                                   // Handle delete action
                                                                 }else{
                                                                   launch(contactDetailsDatum!.cardDocuments![index].document ?? "");
                                                                 }
                                                               },
                                                               child: ListTile(
                                                                 leading: SizedBox(
                                                                   width: 40,
                                                                   height: 40,
                                                                   child: ClipRRect(
                                                                       borderRadius: BorderRadius.circular(
                                                                           30), // Rounded corners for image
                                                                       child: SizedBox(
                                                                         height: 40,
                                                                         child: CachedNetworkImage(
                                                                           height: 40,
                                                                           fit: BoxFit.fitWidth,
                                                                           imageUrl:
                                                                           "${Network.imgUrl}${contactDetailsDatum!.cardDocuments![index].document.toString()}",
                                                                           progressIndicatorBuilder:
                                                                               (context, url,
                                                                               downloadProgress) =>
                                                                               Center(
                                                                                 child:
                                                                                 CircularProgressIndicator(
                                                                                     value: downloadProgress
                                                                                         .progress),
                                                                               ),
                                                                           errorWidget:
                                                                               (context, url, error) =>
                                                                               Image.asset(
                                                                                 "assets/images/Frame 508.png",
                                                                                 height: 40,
                                                                                 fit: BoxFit.fill,
                                                                                 width: double.infinity,
                                                                               ),
                                                                         ),
                                                                       )),
                                                                 ),
                                                                 title: Text(
                                                                   contactDetailsDatum!
                                                                       .cardDocuments![index].document
                                                                       .toString(),
                                                                   overflow: TextOverflow.ellipsis,
                                                                 ),
                                                                 // trailing: IconButton(
                                                                 //   icon: Padding(
                                                                 //     padding: const EdgeInsets.all(4),
                                                                 //     child: Image.asset(
                                                                 //         "assets/images/Frame 415.png"),
                                                                 //   ),
                                                                 //   color: Colors.grey,
                                                                 //   onPressed: () {
                                                                 //     // Handle delete action
                                                                 //   },
                                                                 // ),
                                                               ),
                                                             );

                                                             // return SizedBox();
                                                           },
                                                         ),
                                                       )
                                                );
                                              },
                                              child: Image.asset(
                                                "assets/images/other.png",
                                                height: 55,
                                                width: 45,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate('notes'),
                            style: TextStyle(
                              color: Colors.black, // Text color
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          contactDetailsDatum == null ||
                                  contactDetailsDatum?.notes == null ||
                                  contactDetailsDatum!.notes!.isEmpty
                              ? InkWell(
                                  onTap: () {
                                    if (notesController.text.isNotEmpty) {
                                      Utility.showLoader(context);
                                      apiUpdateNotes(
                                          contactDetailsDatum?.id.toString() ??
                                              "",notesController.text);
                                    } else {
                                      Utility().showFlushBar(
                                          context: context,
                                          message: AppLocalizations.of(context).translate('enterNotes'),
                                          isError: true);
                                    }
                                  },
                                  child: Text(
                                    AppLocalizations.of(context).translate('add'), // Right side text
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 16),
                                  ),
                                )
                              : isEdit == true
                                  ? InkWell(
                                      onTap: () {
                                        if (notesController.text.isNotEmpty) {
                                          Utility.showLoader(context);
                                          apiUpdateNotes(contactDetailsDatum?.id
                                                  .toString() ??
                                              "",notesController.text);
                                        } else {
                                          Utility().showFlushBar(
                                              context: context,
                                              message: AppLocalizations.of(context).translate('enterNotes'),
                                              isError: true);
                                        }
                                      },
                                      child: Text(
                                        AppLocalizations.of(context).translate('update'), // Right side text
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 16),
                                      ),
                                    )
                                  : SizedBox(),
                          if (contactDetailsDatum != null &&
                              contactDetailsDatum?.notes != null &&
                              contactDetailsDatum!.notes!.isNotEmpty &&
                              isEdit == false)
                               InkWell(
                                 onTap: (){
                                   isEdit = true;
                                   setState(() {});
                                 },
                                 child: Image.asset(
                                  "assets/images/edit-05.png",
                                  color: Colors.grey,
                                  height: 20,
                                  width: 20,
                                                             ),
                               ), if (contactDetailsDatum != null &&
                              contactDetailsDatum?.notes != null &&
                              contactDetailsDatum!.notes!.isNotEmpty &&
                              isEdit == false)
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: InkWell(
                                onTap: (){
                                  Utility.showLoader(context);
                                  apiUpdateNotes(contactDetailsDatum?.id
                                      .toString() ??
                                      "","");
                                },
                                child: Image.asset(
                                    "assets/images/delete_icon.png",
                                    color: Colors.grey,
                                    height: 20,
                                    width: 20,
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: contactDetailsDatum != null &&
                              contactDetailsDatum?.notes != null &&
                              contactDetailsDatum!.notes!.isNotEmpty &&
                              isEdit == false
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color:
                                    Colors.grey[200], // Light background color
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                              ),
                              child: Text(
                                contactDetailsDatum?.notes ?? "",
                                style: TextStyle(
                                  color: Colors.black, // Text color
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 100,
                              child: TextField(
                                maxLines: 3,
                                controller: notesController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  labelText: 'Enter note',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                   Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Text(
                                      AppLocalizations.of(context).translate('meetings'),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 20, top: 6),
                                    child: ClipOval(
                                      child: Material(
                                        color: Colors.blue, // Button color
                                        child: InkWell(
                                          splashColor:
                                              Colors.blue, // Splash color
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateEditMeeting(
                                                    contactId: widget
                                                        .contactIdForMeeting
                                                        .toString(),
                                                  ),
                                                )).then(
                                              (value) {
                                                apiGetMyMeetings();
                                              },
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
                                  ),
                                ],
                              ),
                              if (meetings.isNotEmpty)
                                SizedBox(
                                  height: 200,
                                  child: ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (ctx, index) {
                                      return Container(
                                        color: Colors.black12,
                                        height: 1,
                                      );
                                    },
                                    itemCount: meetings.length,
                                    itemBuilder: (context, index) {
                                      final meeting = meetings[index];
                                      return ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (builder) =>
                                                  MeetingDetailsScreen(
                                                meetingId:
                                                    meetings[index].id ?? 0,
                                                contactId: contactDetailsDatum
                                                    ?.id
                                                    .toString(),
                                              ),
                                            ),
                                          ).then(
                                            (value) {
                                              apiGetMyMeetings();
                                            },
                                          );
                                        },
                                        title: Text(
                                          meeting.title ?? '',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        subtitle: Text(
                                          meeting.purpose ?? '',
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        trailing: Text(
                                          DateFormat('d MMMM yyyy').format(
                                              meeting.dateTime ??
                                                  DateTime.now()),
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 14),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              const SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (builder) => MeetingsScreen(
                                        contactId: contactDetailsDatum?.id ?? 0,
                                      ),
                                    ),
                                  );
                                },
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate('viewAllMeetings'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.black,
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget shimmerView() {
    return Shimmer.fromColors(
      baseColor: Color(0x72231532),
      highlightColor: Color(0xFF463B5C),
      child: Column(
        children: [
          Container(
            height: widget.isPhysicalContact ? 170 : 310,
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(0x72231532),
                borderRadius: BorderRadius.circular(8)),
            child: widget.isPhysicalContact?SizedBox():
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                     Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.only(
                            topLeft:
                            Radius.circular(18),
                            topRight:
                            Radius.circular(18)),
                        color:  Color(0x72231532),
                      ),
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(
                              top: 12.0, left: 12),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color:Color(0x72231532),
                            borderRadius:
                            const BorderRadius.all(
                                Radius.circular(
                                    50)),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 17,
                              ),
                              Container(
                                height: 22,
                                width: 120,
                                decoration: BoxDecoration(
                                  color:Color(0x72231532),
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(
                                          8)),),
                              ),
                              SizedBox(height: 8,),
                              Container(
                                height: 22,
                                width: 120,
                                decoration: BoxDecoration(
                                  color:Color(0x72231532),
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(
                                          8)),),
                              ),
                            ],
                          ),
                          Container(
                            height: 35,
                            width: 90,
                            decoration: BoxDecoration(
                              color:Color(0x72231532),
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(
                                      8)),),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(
                            vertical: 18),
                        color: Colors.black12,
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color:Color(0x72231532),
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(
                                      50)),),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color:Color(0x72231532),
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(
                                      50)),),),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color:Color(0x72231532),
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(
                                      50)),),),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color:Color(0x72231532),
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(
                                      50)),),),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color:Color(0x72231532),
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(
                                      50)),),),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color:Color(0x72231532),
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(
                                      50)),),),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color:Color(0x72231532),
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(
                                      50)),),),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color:Color(0x72231532),
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(
                                      50)),),),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color:Color(0x72231532),
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(
                                      50)),),),
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color:Color(0x72231532),
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(
                                      50)),),),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12,),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 24,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Color(0x72231532),
                          borderRadius: BorderRadius.circular(8)),
                    ), Container(
                      height: 24,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Color(0x72231532),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: double.infinity,
                height: 60,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0x72231532), // Light background color
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              )) ,
          SizedBox(height: 24,),

          Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 24,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Color(0x72231532),
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ])),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: double.infinity,
                height: 100,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0x72231532), // Light background color
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ))
        ],
      ),
    );
  }

  void _showBottomSheet(
    BuildContext context,
    Function callBack,
    title,
    link,
    isLocation,
  ) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.only(
                  right: 16.0,
                  left: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: !isLocation
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          // Add Tag Input Field
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                              onTap: () {
                                callBack.call();
                                Navigator.pop(context);
                              },
                              child: !isLocation
                                  ? Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width -
                                          30,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(title))
                                  : null),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: link));
                                Navigator.pop(context);
                                Utility().showFlushBar(
                                    context: context,
                                    message: "copy into clipboard");
                              },
                              child: Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width - 30,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text("Copy $title"))),
                          SizedBox(
                            height: 30,
                          )
                        ])
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          // Add Tag Input Field
                          SizedBox(
                            height: 20,
                          ),

                          InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: link));
                                Navigator.pop(context);
                                Utility().showFlushBar(
                                    context: context,
                                    message: "copy into clipboard");
                              },
                              child: Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width - 30,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text("Copy $title"))),
                          SizedBox(
                            height: 10,
                          ),

                          SizedBox(
                            height: 40,
                          )
                        ]));
        });
  }
}

// Bottom Sheet content

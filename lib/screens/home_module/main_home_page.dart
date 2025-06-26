import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/bloc/cubit/card_cubit.dart';
import 'package:my_di_card/data/repository/card_repository.dart';
import 'package:my_di_card/localStorage/storage.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/contact_cubit.dart';
import '../../createCard/create_card_final_preview.dart';
import '../../createCard/create_card_user_screen.dart';
import '../../data/repository/contact_repository.dart';
import '../../language/app_localizations.dart';
import '../../models/card_list.dart';
import '../../models/my_contact_model.dart';
import '../../models/utility_dto.dart';
import '../../notifire_class.dart';
import '../../utils/utility.dart';
import '../../utils/widgets/network.dart';
import '../add_card_module/share_card_bottom_sheet.dart';
import '../contact/add_contact_preview.dart';
import '../contact/contact_details_screen.dart';
import '../profile_mosule/profile_new.dart';
import '../add_card_module/add_new_card.dart';
import '../contact/contact_home.dart';
import '../setting_module/notification_screen.dart';
import 'add_new_contact.dart';
import 'package:http/http.dart' as http;

class BottomNavBarExample extends StatefulWidget {
  const BottomNavBarExample({super.key});

  @override
  State<BottomNavBarExample> createState() => _BottomNavBarExampleState();
}

class _BottomNavBarExampleState extends State<BottomNavBarExample> {
  int _selectedIndex = 0;
  StreamSubscription<Uri>? _linkSubscription;
  late AppLinks _appLinks;
  ContactCubit? _addContactCubit;
  bool isApiStart = false;

  @override
  initState(){
    _addContactCubit = ContactCubit(ContactRepository());
    _initUniLinkStream();
    super.initState();
  }
  _initUniLinkStream() async
  {
    _appLinks = AppLinks();
    await Future.delayed(Duration(seconds: 2));
    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((link) {
      if (link == null) return;
      String url = "$link";
      RegExp regExp = RegExp(r'\d+$'); // Matches digits at the end of the string
      Match? match = regExp.firstMatch(url);

      if (match != null) {
        String numberString = match.group(0)!;
        if(isApiStart == false) {
          isApiStart = true;
          setState(() {

          });
          showModalBottomSheet(
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => AddContactPreview(contactId: numberString.toString(),callBack: (){},));
        }
      }
    }, onError: (err) {
    });
  }


  Future<void> apiAddContact(cardId) async {
    Map<String, dynamic> data = {
      "card_id": cardId,
    };
    _addContactCubit?.apiAddContact(data);
  }


  // List of pages corresponding to each tabutil
  static final List<Widget> _pages = <Widget>[
    HomeScreen(),
    ContactHomeScreen(),
    AddNewCardHome(),
    AccountPage(),
  ];

  // Method to change the selected index on tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return   BlocListener<ContactCubit, ResponseState>(
      bloc: _addContactCubit,
      listener: (context, state) {
        if (state is ResponseStateLoading) {
        } else if (state is ResponseStateEmpty) {
          Utility.hideLoader(context);
          isApiStart = false;
          Utility().showFlushBar(
              context: context, message: state.message, isError: true);
        } else if (state is ResponseStateNoInternet) {
          isApiStart = false;
          Utility.hideLoader(context);
          Utility().showFlushBar(
              context: context, message: state.message, isError: true);
        } else if (state is ResponseStateError) {
          isApiStart = false;
          Utility.hideLoader(context);
          Utility().showFlushBar(
              context: context, message: state.errorMessage, isError: true);
        } else if (state is ResponseStateSuccess) {
          Utility.hideLoader(context);
          var dto = state.data as UtilityDto;
          Utility()
              .showFlushBar(context: context, message: dto.message ?? "");
          isApiStart = false;
        }
        setState(() {});
      },
      child: Scaffold(
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: SizedBox(
          height: Platform.isAndroid?68:72,
          child: BottomNavigationBar(
            elevation: 8,
            backgroundColor: Colors.white,
            iconSize: 30,
            selectedFontSize: 0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                  color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/users-03.png",
                  height: 24,
                  width: 24,
                  color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/credit-card-02.png",
                  height: 24,
                  width: 24,
                  color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/Frame 415 (1).png",
                  height: 28,
                  width: 28,
                  color: _selectedIndex == 3 ? Colors.blue : Colors.grey,
                ),
                label: '',
              ),
            ],

            currentIndex: _selectedIndex,
            // Set the current selected index
            selectedItemColor: Colors.blue,
            // Selected item color
            unselectedItemColor: Colors.grey,
            // Unselected item color
            showUnselectedLabels: true,
            // Show labels for unselected items
            onTap: _onItemTapped,
            // Handle item tap
            type: BottomNavigationBarType
                .fixed, // Use fixed type for more than 3 items
          ),
        ),
      ),
    );
  }
}

// Dummy screen widgets for each tab
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CardCubit? _getCardCubit;
  CardListModel? cardList;
  ContactCubit? _getMyContact,_unFavContact;
  bool isLoad = true,isLoadFav = true;
  List<ContactDatum> myContactList = [];
  int selectedIndex = 0;

  @override
  void initState() {
    _getCardCubit = CardCubit(CardRepository());
    _getMyContact = ContactCubit(ContactRepository());
    _unFavContact = ContactCubit(ContactRepository());
    getMyCard();
    apiGetMyContact("");
    super.initState();
  }

  // Handle links
  // _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
  //
  // });

  Future<void> getMyCard() async {
    _getCardCubit?.apiGetMyCard();
  }



  Future<void> apiContactFavUnFav(cardId) async {
    Map<String, dynamic> data = {
      "favorite": "1",
    };
    _unFavContact?.apiContactFavUnFav(cardId,data);
  }

  Future<void> apiGetMyContact(key) async {
    Map<String, dynamic> data = {
      "key_word":key,
      "tag_ids":"",
      "company_type_id":"",
      "contact_status":"",
      "favorite":"2"

    };
    _getMyContact?.apiGetMyContact(data);
  }


Color getTextColorFromHex(String hexColor) {
  // Remove # if it exists and ensure it's 6 or 8 characters
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor"; // Add full opacity if not present
  }

  final color = Color(int.parse("$hexColor"));

  // Convert to HSL to better identify colors like purple
  final hslColor = HSLColor.fromColor(color);
  final luminance = color.computeLuminance();

  // If color is in the purple hue range (e.g. 260°–290°), return white
  if (hslColor.hue >= 260 && hslColor.hue <= 290) {
    return Colors.white;
  }

  // Otherwise, use luminance to decide text color
  return luminance > 0.5 ? Colors.black : Colors.white;
}


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ContactCubit, ResponseState>(
          bloc: _getMyContact,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              isLoadFav = false;
            } else if (state is ResponseStateNoInternet) {
              isLoadFav = false;
            } else if (state is ResponseStateError) {
              isLoadFav = false;
            } else if (state is ResponseStateSuccess) {
              var dto = state.data as MyContactDto;
              myContactList = [];
              myContactList = dto.data?.data ?? [];
              isLoadFav = false;
            }
            setState(() {});
          },
        ),
        BlocListener<CardCubit, ResponseState>(
          bloc: _getCardCubit,
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
              var dto = state.data as CardListModel;
              cardList = dto;
              isLoad = false;
            }
            setState(() {});
          },
        ),
     BlocListener<ContactCubit, ResponseState>(
          bloc: _unFavContact,
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
              myContactList.removeAt(selectedIndex);
            }
            setState(() {});
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ColoursUtils.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (builder) => NotificationScreen()));
                },
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                  size: 30,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isLoad == true ? _getShimmerView():
              cardList != null && cardList!.data!.isNotEmpty?
                SizedBox(
                  height: 330,
                  child: Swiper(
                    itemCount: cardList!.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => CreateCardFinalPreview(
                                  cardId: cardList!.data![index].id.toString(),
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(18), // if you need this
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                cardList!.data![index].backgroungImage != null ||  cardList!.data![index].cardImage != null
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
                                              height: 110,
                                              width: double.infinity,
                                              fit: BoxFit.fitWidth,
                                              imageUrl:
                                                  "${Network.imgUrl}${cardList!.data![index].backgroungImage}",
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
                                                "assets/logo/Top with a picture.png",
                                                height: 80,
                                                fit: BoxFit.fill,
                                                width: double.infinity,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12.0, left: 12),
                                                child:  cardList!.data![index].cardImage != null && cardList!.data![index].cardImage.toString().isNotEmpty?ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(80)),
                                                  child: CachedNetworkImage(
                                                    height: 80,
                                                    width: 80,
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                        "${Network.imgUrl}${cardList!.data![index].cardImage}",
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                downloadProgress) =>
                                                            Center(
                                                      child: CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      "assets/logo/Central icon.png",
                                                      height: 80,
                                                      fit: BoxFit.fill,
                                                      width: 80,
                                                    ),
                                                  ),
                                                ): Image.asset(
                                                  "assets/logo/Central icon.png",
                                                  height: 80,
                                                  fit: BoxFit.fill,
                                                  width: 80,
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (builder) =>
                                                            CreateCardFinalPreview(
                                                          cardId: cardList!
                                                              .data![index].id
                                                              .toString(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.info_rounded,
                                                    color: Colors.white,
                                                    size: 20,
                                                  )),
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
                                              height: 100,
                                              width: double.infinity,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0, left: 8),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(50)),
                                                  child: Image.asset(
                                                    "assets/logo/Central icon.png",
                                                    height: 100,
                                                    width: 100,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (builder) =>
                                                            CreateCardFinalPreview(
                                                              cardId: cardList!
                                                                  .data![index].id
                                                                  .toString(),
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.info_rounded,
                                                    color: Colors.white,
                                                    size: 20,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0,bottom: 2,left: 20,right: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 17,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width - 173,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${cardList!.data![index].firstName} ${cardList!.data![index].lastName}",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                // Text(
                                                //   cardList!.data![index]
                                                //       .companyName ??
                                                //       "",
                                                //   style: TextStyle(
                                                //       fontSize: 14,
                                                //       fontWeight:
                                                //       FontWeight.normal,
                                                //       color: Colors.black45),
                                                // ),
                                                // Text(
                                                //   cardList!.data![index].companyTypeId.toString() == "1"
                                                //       ? "IT"
                                                //       : "Finance",
                                                //   style: const TextStyle(
                                                //     fontSize: 16,
                                                //     color: Colors.grey,
                                                //   ),
                                                // ),
                                                Text(
                                                  cardList!.data![index].jobTitle
                                                      .toString(),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.normal,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                                SizedBox(height: 3,),
                                                Text(
                                                  cardList!.data![index].companyName
                                                      .toString(),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.normal,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  cardList!.data![index].companyLogo != null && cardList!.data![index].companyLogo.toString().isNotEmpty?ClipRRect(
                                            borderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(
                                                    75)),
                                            child: CachedNetworkImage(
                                              height: 75,
                                              width: 75,
                                              fit: BoxFit.fitWidth,
                                              imageUrl:
                                              "${Network.imgUrl}${cardList!.data![index].companyLogo ?? ""}",
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
                                                    width:100,
                                                  ))): Image.asset(
                                              "assets/logo/Central icon.png",
                                              height: 100,
                                              fit: BoxFit.fill,
                                              width:100,
                                            ),
                                        ],
                                      ),
                                      Container(
                                        height: 1,
                                        margin: const EdgeInsets.only(
                                            top: 12,bottom: 18),
                                        color: Colors.black12,
                                      ),
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
                                              Text(
                                                cardList!.data![index].contactCount.toString()
                                                    ?? "0",
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Text(
                                                AppLocalizations.of(context).translate('connections'),
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black45),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 35,
                                            width: Provider.of<LocalizationNotifier>(context).appLocal == Locale("en")?90:118,
                                            child: ElevatedButton(
                                              // iconAlignment: IconAlignment.start,
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  useSafeArea: true,
                                                  isScrollControlled: true,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.vertical(top: Radius.circular(20)),
                                                  ),
                                                  builder: (context) => ShareCardBottomSheet(
                                                    cardData:  cardList!.data![index],
                                                  ),
                                                );                                                },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: cardList!.data![index].cardStyle != null ?Color(int.parse('0xFF${cardList!.data![index].cardStyle!}')):Colors
                                                    .blue, // Background color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30), // Rounded corners
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/images/send-01.png",
                                                    height: 16,
                                                    width: 16,
                                                    color: getTextColorFromHex(
                                                  '0xFF${cardList!.data![index].cardStyle ?? ""}'),
                                                  ),
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  // Space between icon and text
                                                   Text(
                                                    AppLocalizations.of(context).translate('Send'), // Right side text
                                                    style: TextStyle(
                                                        color: getTextColorFromHex(
                                                            '0xFF${cardList!.data![index].cardStyle ?? ""}'),
                                                        fontSize: 13),
                                                  ),
                                                ],
                                              ),
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
                      );
                    },
                    itemWidth: MediaQuery.sizeOf(context).width / 1.1,
                    axisDirection: AxisDirection.right,
                    layout: SwiperLayout.STACK,
                    allowImplicitScrolling: false,
                  ),
                ):
              SizedBox(),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const CreateCardScreen1(
                                      cardId: "",
                                      isEdit: false,
                                    )));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Rounded corners
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Top + Icon
                              CircleAvatar(
                                radius: 18,
                                child:
                                    Image.asset("assets/images/add button.png"),
                              ),
                              const SizedBox(
                                  height: 20), // Space between icon and text
                              // Text below the icon
                              Text(
                                AppLocalizations.of(context).translate('newCard'),
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          useSafeArea: true,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => ScanQrCodeBottomSheet(
                            callBack: (v) {Navigator.pop(context);
                            showModalBottomSheet(
                                context: context,
                                useSafeArea: true,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (context) => AddContactPreview(contactId: v.toString(),callBack: (){},));
                           }
                            ,
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Rounded corners
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Top + Icon
                              CircleAvatar(
                                radius: 18,
                                child:
                                    Image.asset("assets/images/add button.png"),
                              ),
                              const SizedBox(
                                  height: 20), // Space between icon and text
                              // Text below the icon
                              Text(
                                AppLocalizations.of(context).translate('newContact'),
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title of the card
                        Text(
                          AppLocalizations.of(context).translate('favoriteContacts'),
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // ListView for the items inside the card

                        isLoadFav == true?Utility.userListShimmer():
                        myContactList.isNotEmpty?      ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          shrinkWrap: true,
                          itemCount: myContactList.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                    builder: (builder) =>
                                    ContactDetails(contactId: myContactList[index]
                                        .id ?? 0,
                                      isPhysicalContact:myContactList[index].contactTypeId ==2,
                                      contactIdForMeeting: myContactList[index].id,
                                      tags: [],),
                                ));
                              },
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                leading:

                                ClipRRect(
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(50)),
                                  child: CachedNetworkImage(
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                    "${Network.imgUrl}${myContactList[index].cardImage ?? ""}",
                                    progressIndicatorBuilder:
                                        (context, url,
                                        downloadProgress) =>
                                        Center(
                                          child: CircularProgressIndicator(
                                              value:
                                              downloadProgress
                                                  .progress),
                                        ),
                                    errorWidget:
                                        (context, url, error) =>
                                        Image.asset(
                                          "assets/logo/Central icon.png",
                                          height: 50,
                                          fit: BoxFit.fill,
                                          width: 50,
                                        ),
                                  ),
                                ),
                                title: Text(
                                  "${myContactList[index].firstName} ${myContactList[index].lastName}",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  myContactList[index].jobTitle ?? "",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                                trailing: InkWell(
                                    onTap: (){
                                      showModalBottomSheet(
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25.0),
                                          ),
                                        ),
                                        builder: (context) {
                                          return  Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      title:  Text(
                                                        AppLocalizations.of(context).translate('unfavoriteD'),
                                                        style: TextStyle(color: Colors.black, fontSize: 14),
                                                      ),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        selectedIndex = index;
                                                        setState(() {

                                                        });
                                                        Utility.showLoader(context);
                                                        apiContactFavUnFav(myContactList[index].id.toString());
                                                        // Add functionality here
                                                      },
                                                    ),SizedBox(height: 16,)]));
                                        },
                                      );
                                    },
                                    child: const Icon(Icons.more_vert)),
                              ),
                            );
                          },
                        ):Center(child: Text(AppLocalizations.of(context).translate('noRecordFound'))),
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

  Widget _getShimmerView() {
    return Shimmer.fromColors(
        baseColor: Color(0x72231532),
    highlightColor: Color(0xFF463B5C),
      child: showCardShimmer(),
    );
    }
  Widget showCardShimmer(){
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(18), // if you need this
        side: const BorderSide(
          color: Colors.white,
          width: 2,
        ),
      ),
      elevation: 0,
      margin: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                    const BorderRadius.only(
                        topLeft:
                        Radius.circular(18),
                        topRight:
                        Radius.circular(18)),
                    color: Color(0x72231532),
                  ),child:
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 55,
                  width: 55,
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(55)),
                    color: Color(0x72231532),
                  ),
                ),
              ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 16.0, horizontal: 20),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 0,
                ),
                Container(
                  height: 20,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(4)),
                    color: Color(0x72231532),
                  ),
                ),
                Container(
                  height: 20,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(4)),
                    color: Color(0x72231532),
                  ),
                ),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(
                      vertical: 18),
                  color: Colors.black12,
                ),
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
                        Container(
                          height: 18,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(4)),
                            color: Color(0x72231532),
                          ),
                        ),
                        Container(
                          height: 20,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(4)),
                            color: Color(0x72231532),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 35,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(4)),
                        color: Color(0x72231532),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  final List<Map<String, String>> items = [
    {
      'title': 'Item 1',
      'description': 'This is the description ',
    },
    {
      'title': 'Item 2',
      'description': 'This is the description ',
    },
    {
      'title': 'Item 3',
      'description': 'This is the description ',
    },
    {
      'title': 'Item 3',
      'description': 'This is the description ',
    },
    {
      'title': 'Item 3',
      'description': 'This is the description ',
    },
    {
      'title': 'Item 3',
      'description': 'This is the description',
    },
    {
      'title': 'Item 3',
      'description': 'This is the description ',
    },
  ];
}

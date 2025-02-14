import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_di_card/localStorage/storage.dart';
import 'package:my_di_card/utils/colors/colors.dart';

import '../../createCard/create_card_final_preview.dart';
import '../../createCard/create_card_user_screen.dart';
import '../../models/card_list.dart';
import '../../utils/widgets/network.dart';
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

  // List of pages corresponding to each tab
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
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8,
        backgroundColor: Colors.white,
        iconSize: 30,

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
            icon: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "assets/images/credit-card-02.png",
                height: 24,
                width: 24,
                color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
              ),
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
        selectedItemColor: Colors.blue, // Selected item color
        unselectedItemColor: Colors.grey, // Unselected item color
        showUnselectedLabels: true, // Show labels for unselected items
        onTap: _onItemTapped, // Handle item tap
        type: BottomNavigationBarType
            .fixed, // Use fixed type for more than 3 items
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
  CardListModel? cardList;
  final String apiUrl = "${Network.baseUrl}card/get-my-card";

  Future<void> fetchCard() async {
    String token = await Storage().getToken();
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer $token', // Add your authorization token
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(jsonResponse);
      print(prettyprint);
      setState(() {
        cardList = CardListModel.fromJson(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load localization data');
    }
  }

  @override
  void initState() {
    fetchCard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            if (cardList != null && cardList!.data!.isNotEmpty)
              SizedBox(
                height: 300,
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
                              cardList!.data![index].backgroungImage != null
                                  ? Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(18),
                                              topRight: Radius.circular(18)),
                                          child: CachedNetworkImage(
                                            height: 100,
                                            width: double.infinity,
                                            fit: BoxFit.fitWidth,
                                            imageUrl:
                                                "${Network.imgUrl}${cardList!.data![index].backgroungImage}",
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Center(
                                              child: CircularProgressIndicator(
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
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(50)),
                                                child: CachedNetworkImage(
                                                  height: 55,
                                                  width: 55,
                                                  fit: BoxFit.fitWidth,
                                                  imageUrl:
                                                      "${Network.imgUrl}${cardList!.data![index].cardImage}",
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
                                                    "assets/logo/Central icon.png",
                                                    height: 80,
                                                    fit: BoxFit.fill,
                                                    width: double.infinity,
                                                  ),
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
                                    )
                                  : Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(18),
                                              topRight: Radius.circular(18)),
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
                                    vertical: 2.0, horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 17,
                                    ),
                                    Text(
                                      "${cardList!.data![index].firstName} ${cardList!.data![index].lastName}",
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Text(
                                      cardList!.data![index].jobTitle
                                          .toString(),
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black45),
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
                                            Text(
                                              "0",
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Text(
                                              "Connections",
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
                                          width: 90,
                                          child: ElevatedButton(
                                            iconAlignment: IconAlignment.start,
                                            onPressed: () {
                                              // Handle button press
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
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
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ), // Space between icon and text
                                                const Text(
                                                  "Send", // Right side text
                                                  style: TextStyle(
                                                      color: Colors.white,
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
              ),
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
                    onTap: () {
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
                              'New Card',
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
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => ScanQrCodeBottomSheet(),
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
                              'New Contact',
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
                        'Favorite Contacts',
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
                      ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        shrinkWrap: true,
                        itemCount: items.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 2),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child:
                                  Image.asset("assets/images/user_dummy.png"),
                            ),
                            title: Text(
                              items[index]['title']!,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              items[index]['description']!,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                            trailing: const Icon(Icons.more_vert),
                            onTap: () {
                              // Handle tap on the list item
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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

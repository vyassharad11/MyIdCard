import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_di_card/screens/add_card_module/create_card_user.dart';
import 'package:my_di_card/screens/add_card_module/share_card_bottom_sheet.dart';

import '../../language/app_localizations.dart';
import '../../models/card_list.dart';
import '../../utils/url_lancher.dart';
import '../meetings/metting_details.dart';

class CardDetails extends StatefulWidget {
  final CardData? cardData;
  const CardDetails({super.key,this.cardData});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  @override
  void initState() {
    setLink();
    // TODO: implement initState
    super.initState();
  }

  String? twitterLink,instaLink,faceBookLink,linkdinLink;

  setLink(){
    widget.cardData?.cardSocials?.forEach((action) {
      if (action.socialName == "Twitter") {
        twitterLink = action.socialLink.toString();
      }
      if (action.socialName == "Instagram") {
        instaLink = action.socialLink.toString();
      }
      if (action.socialName == "Facebook") {
        faceBookLink = action.socialLink.toString();
      }
      if (action.socialName == "LinkedIn") {
        linkdinLink = action.socialLink.toString();
      }});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          AppLocalizations.of(context).translate('CardName'),
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (builder) => MeetingDetailsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.more_vert))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => CreateCardScreen()));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18), // if you need this
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
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18)),
                        child: Image.asset(
                          "assets/images/card_header.png",
                          height: 80,
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 17,
                                    ),
                                    Text(
                                    widget.cardData?.firstName ?? "",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      widget.cardData?.lastName ?? "",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black45),
                                    ),
                                    // Text(
                                    //   AppLocalizations.of(context)
                                    //       .translate('userName'),
                                    //   style: TextStyle(
                                    //       fontSize: 14,
                                    //       fontWeight: FontWeight.normal,
                                    //       color: Colors.black45),
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: 35,
                                  width: 90,
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
                                          cardData: widget.cardData,
                                        ),
                                      );                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.blue, // Background color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
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
                                         Text(
                                        AppLocalizations.of(context)
                                              .translate('Send'), // Right side text
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
                            Container(
                              height: 1,
                              margin: const EdgeInsets.symmetric(vertical: 18),
                              color: Colors.black12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: (){
                                    launchUrlGet(
                                      linkdinLink ?? "",
                                    );
                                  },
                                  child: Image.asset(
                                    "assets/social/linkedin.png",
                                    height: 55,
                                    width: 45,
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    launchUrlGet(
                                      faceBookLink ?? "",
                                    );
                                  },
                                  child: Image.asset(
                                    "assets/social/facebook.png",
                                    height: 55,
                                    width: 45,
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    launchUrlGet(
                                      instaLink ?? "",
                                    );
                                  },
                                  child: Image.asset(
                                    "assets/social/insta.png",
                                    height: 55,
                                    width: 45,
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    launchUrlGet(
                                      linkdinLink ?? "",
                                    );
                                  },
                                  child: Image.asset(
                                    "assets/social/whats.png",
                                    height: 55,
                                    width: 45,
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    launchUrlGet(
                                      linkdinLink ?? "",
                                    );
                                  },
                                  child: Image.asset(
                                    "assets/social/applew.png",
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
            ),
          ],
        ),
      ),
    );
  }
}

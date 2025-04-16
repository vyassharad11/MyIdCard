import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_di_card/screens/add_card_module/create_card_user.dart';
import 'package:my_di_card/screens/add_card_module/share_card_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

import '../../language/app_localizations.dart';
import '../../models/card_list.dart';
import '../../utils/url_lancher.dart';
import '../../utils/widgets/network.dart';
import '../meetings/metting_details.dart';

class CardDetails extends StatefulWidget {
  final CardData? cardData;

  const CardDetails({super.key, this.cardData});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                          builder: (builder) => CreateCardScreen(cardData: widget.cardData,)));
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
                      widget.cardData!.backgroungImage != null
                          ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18)),
                            child: CachedNetworkImage(
                              height: 80,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                              imageUrl:
                              "${Network.imgUrl}${widget.cardData!.backgroungImage}",
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
                                    "${Network.imgUrl}${widget.cardData?.cardImage}",
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
                              height: 80,
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
                                      "${widget.cardData?.firstName ?? ""} ${  widget.cardData?.lastName ?? ""}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      widget.cardData?.jobTitle ?? "",
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
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        builder: (context) =>
                                            ShareCardBottomSheet(
                                          cardData: widget.cardData,
                                        ),
                                      );
                                    },
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
                                              .translate('Send'),
                                          // Right side text
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
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 24),
                              child: SizedBox(
                                height: 45,
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  // iconAlignment: IconAlignment.start,
                                  onPressed: () async {
                                    final box = context.findRenderObject() as RenderBox?;

                                    await Share.share(
                                      "${Network.shareUrl}${widget.cardData?.id.toString()}",
                                      subject: "Share your card",
                                      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                                    );                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue, // Background color
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30), // Rounded corners
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('share'), // Right side text
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),),
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

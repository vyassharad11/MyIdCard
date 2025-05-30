import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_di_card/localStorage/storage.dart';

import '../../createCard/create_card_user_screen.dart';
import '../../language/app_localizations.dart';
import '../../models/card_list.dart';
import '../../utils/constant.dart';
import '../../utils/widgets/network.dart';

class CreateCardScreen extends StatefulWidget {
  final CardData? cardData;
  const CreateCardScreen({super.key,this.cardData});

  @override
  State<CreateCardScreen> createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends State<CreateCardScreen> {

  bool isTeamMember= false;

  @override
  void initState() {
    Storage().getIsIndivisual().then((value) {
      isTeamMember = value;
      setState(() {

      });
    },);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
          AppLocalizations.of(context).translate('createCardOn'),
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, fontFamily: Constants.fontFamily, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                    widget.cardData != null&& widget.cardData!.backgroungImage != null
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
                          Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(vertical: 18),
                            color: Colors.black12,
                          ),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.cardData?.contactCount.toString() ?? "",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('connections'),
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black54),
                                  ),
                                ],
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                 // iconAlignment: IconAlignment.start,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const CreateCardScreen1(
                              cardId: "",
                              isEdit: false,
                            )));                  },
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
                      Icon(
                        Icons.add, // Left side icon
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 6,
                      ), // Space between icon and text
                      Text(
                        AppLocalizations.of(context)
                            .translate('createCardScratch'), // Right side text
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            if(isTeamMember)         Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                 // iconAlignment: IconAlignment.start,
                  onPressed: () {
                    // Handle button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
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
                            .translate('createTeam'), // Right side text
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if(isTeamMember)         const SizedBox(
              height: 18,
            ),
       if(isTeamMember)     Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                 // iconAlignment: IconAlignment.start,
                  onPressed: () {
                    // Handle button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
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
                            .translate('createCardGroup'), // Right side text
                        style: TextStyle(color: Colors.black, fontSize: 16),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../createCard/create_card_user_screen.dart';
import '../../localStorage/storage.dart';
import '../../models/card_list.dart' as card;
import '../../models/my_card_get.dart';
import '../../utils/widgets/network.dart';
import 'main_home_page.dart';

class FirstCardScreen extends StatefulWidget {
  final Cards? cardData;

  const FirstCardScreen({super.key, this.cardData});
  @override
  State<FirstCardScreen> createState() => _FirstCardScreenState();
}

class _FirstCardScreenState extends State<FirstCardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
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
                  widget.cardData != null &&
                      widget.cardData!.backgroungImage != null
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
                          "${Network.imgUrl}${widget.cardData?.backgroungImage}",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) =>
                              Image.asset(
                                "assets/images/card_header.png",
                                height: 80,
                                fit: BoxFit.fill,
                                width: double.infinity,
                              ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 14.0, left: 12),
                        child: ClipRRect(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(50)),
                          child: CachedNetworkImage(
                            height: 55,
                            width: 55,
                            fit: BoxFit.fitWidth,
                            imageUrl:
                            "${Network.imgUrl}${widget.cardData?.cardImage}",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                Center(
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress),
                                ),
                            errorWidget: (context, url, error) =>
                                Image.asset(
                                  "assets/images/card_header.png",
                                  height: 80,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                ),
                          ),
                        ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 10.0, left: 8),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
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
                          widget.cardData?.firstName ?? "",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                        Text(
                          widget.cardData?.jobTitle ?? "",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black45),
                          ),
                        ),
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(vertical: 18),
                          color: Colors.black45,
                        ),
                        Text(
                          "0+",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                        Text(
                          "Connections",
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
                ],
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            ElevatedButton(
              onPressed: () {
                // Logic to create your first card
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const CreateCardScreen1(
                          cardId: "",
                          isEdit: false,
                        )));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue, // Button color
                textStyle: const TextStyle(fontSize: 18), // Button text size
              ),
              child: Text(
                widget.cardData != null && widget.cardData!.firstName != null
                    ? "+ Create card"
                    : '+ Create my first card',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between the buttons
            TextButton(
              onPressed: () async {
                await Storage().setFirstCardSkip(true);
                // Logic to skip
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (builder) => BottomNavBarExample()));
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500), // Text size
              ),
              child: Text(
                'Skip for now',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
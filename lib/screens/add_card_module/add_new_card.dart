import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_di_card/screens/add_card_module/card_details.dart';

import '../../language/app_localizations.dart';

class AddNewCardHome extends StatelessWidget {
  const AddNewCardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).translate('addNewCard'),
          style: const TextStyle(
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
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (builder) => const CardDetails(),
                      ),
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
              height: MediaQuery.of(context).size.height / 1.3,
              width: MediaQuery.of(context).size.width,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18), // if you need this
                        side: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 4),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 17,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('userName'),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('userName'),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black45),
                                ),
                                Container(
                                  height: 1,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  color: Colors.black12,
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('shareCard'),
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const Center(
                            child: Icon(
                              Icons.qr_code_2_outlined,
                              size: 200,
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              height: 35,
                              width: 160,
                              child: ElevatedButton(
                                iconAlignment: IconAlignment.start,
                                onPressed: () {
                                  // Handle button press
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
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.copy, // Left side icon
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ), // Space between icon and text
                                    Text(
                                      AppLocalizations.of(context).translate(
                                          'copyQrCode'), // Right side text
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                              Image.asset(
                                "assets/social/linkedin.png",
                                height: 65,
                                width: 65,
                              ),
                              Image.asset(
                                "assets/social/facebook.png",
                                height: 65,
                                width: 65,
                              ),
                              Image.asset(
                                "assets/social/insta.png",
                                height: 65,
                                width: 65,
                              ),
                              Image.asset(
                                "assets/social/whats.png",
                                height: 65,
                                width: 65,
                              ),
                              Image.asset(
                                "assets/social/applew.png",
                                height: 70,
                                width: 65,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: 10,
                itemWidth: MediaQuery.sizeOf(context).width / 1.1,
                axisDirection: AxisDirection.right,
                layout: SwiperLayout.STACK,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

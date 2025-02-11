import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/utils/colors/colors.dart';

import '../language/app_localizations.dart';
import '../localStorage/storage.dart';
import '../models/card_get_model.dart' as dataModel;
import '../screens/home_module/main_home_page.dart';
import '../utils/widgets/network.dart';
import 'create_card_user_screen.dart';

class CreateCardFinalPreview extends StatefulWidget {
  final String cardId;
  const CreateCardFinalPreview({super.key, required this.cardId});

  @override
  State<CreateCardFinalPreview> createState() => _CreateCardFinalPreviewState();
}

class _CreateCardFinalPreviewState extends State<CreateCardFinalPreview> {
  @override
  initState() {
    getUserToken();
    super.initState();
  }

  void getUserToken() async {
    fetchData();
  }

  String token = "";
  String input = "";
  Color? extractedColor = Colors.blue;

  // Define a RegExp pattern to extract `Color(0xff2196f3)`

  dataModel.Data? getCardModel;
  Future<void> fetchData() async {
    var token = await Storage().getToken();

    print(widget.cardId.toString());
    String apiUrl =
        "${Network.baseUrl}card/get/${widget.cardId}"; // Replace with your API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $token', // Add your authorization token
      });

      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonResponse = jsonDecode(response.body);

        final apiResponse = dataModel.GetCardModel.fromJson(jsonResponse);
        setState(() {
          getCardModel = apiResponse.data;

          // int colorName = int.parse("0xFF2196F3");
          // extractedColor = Color(colorName);
          debugPrint("Data fetched successfully: ${getCardModel?.cardName}");
        });
      } else {

        // Handle error response
        debugPrint("Failed to fetch data. Status Code: ${response.statusCode}");
        debugPrint("Error: ${response.body}");
      }
    } catch (error) {

      // Handle any exceptions
      debugPrint("An error occurred: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoursUtils.whiteLightColor.withOpacity(1.0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16),
          child: getCardModel == null
              ? SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(
                                context), // Default action: Go back
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              elevation: 3,
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                getCardModel?.cardName.toString() ?? "",
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (builder) =>
                                              CreateCardScreen1(
                                                cardId: widget.cardId,
                                                isEdit: true,
                                              )));
                                },
                                child: const Icon(Icons.edit_outlined)),
                          ],
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.sizeOf(context).width),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate('CardStyle'),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                  height: 16), // Space between text and row

                              Container(
                                width: 30,
                                decoration: BoxDecoration(
                                  color: getCardModel?.cardStyle == null
                                      ? Colors.blue
                                      : Color(
                                          int.parse(
                                            '0xFF${getCardModel?.cardStyle!}',
                                          ),
                                        ),
                                  shape: BoxShape.circle,
                                ),
                                height: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18), // if you need this
                        side: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Image',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(18),
                                      topRight: Radius.circular(18)),
                                  child: getCardModel != null &&
                                          getCardModel!.backgroungImage != null
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
                                                height: 100,
                                                width: double.infinity,
                                                fit: BoxFit.fitWidth,
                                                imageUrl:
                                                    "${Network.imgUrl}${getCardModel!.backgroungImage}",
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12.0, left: 12),
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(50)),
                                                child: CachedNetworkImage(
                                                  height: 75,
                                                  width: 75,
                                                  fit: BoxFit.fitWidth,
                                                  imageUrl:
                                                      "${Network.imgUrl}${getCardModel!.cardImage}",
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
                                        )
                                      : ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(18),
                                              topRight: Radius.circular(18)),
                                          child: Image.asset(
                                            "assets/logo/Central icon.png",
                                            height: 80,
                                            fit: BoxFit.fitWidth,
                                            width: double.infinity,
                                          ),
                                        )),
                            ),
                            const SizedBox(
                              height: 0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 75,
                                    width: 75,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50)),
                                        child: getCardModel != null &&
                                                getCardModel!.company_logo !=
                                                    null
                                            ? SizedBox(
                                                height: 55,
                                                child: CachedNetworkImage(
                                                  height: 350,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  imageUrl:
                                                      "${Network.imgUrl}${getCardModel!.company_logo}",
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
                                                    height: 100,
                                                    fit: BoxFit.fill,
                                                    width: double.infinity,
                                                  ),
                                                ),
                                              )
                                            : Image.asset(
                                                "assets/logo/Central icon.png",
                                                height: 35,
                                                fit: BoxFit.fill,
                                                width: double.infinity,
                                              ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 35,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context).translate(
                                              'companylogo'), // Right side text
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate('personal'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),

                            Text(
                              getCardModel!.languageId == "1"
                                  ? "English"
                                  : "French",
                              style: const TextStyle(color: Colors.black87),
                            ),
                            const Divider(thickness: 1), // Horizontal line

                            Text(
                              getCardModel?.firstName ?? "",
                              style: const TextStyle(color: Colors.black87),
                            ),
                            const Divider(thickness: 1), // Horizontal line

                            Text(
                              getCardModel?.lastName ?? "",
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate('companyDetails'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              getCardModel?.companyName ?? "",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Divider(thickness: 1),
                            Text(
                              getCardModel?.companyTypeId == "1"
                                  ? "IT"
                                  : "Finance",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const Divider(thickness: 1),
                            Text(
                              getCardModel?.jobTitle ?? "",
                              style: const TextStyle(fontSize: 16),
                            ),
                            // Divider(thickness: 1), // Horizontal line
                            // Text(
                            //   'CEO',
                            //   style:
                            //       TextStyle(fontSize: 16, color: Colors.black),
                            // ),
                            const Divider(thickness: 1),
                            Text(
                              getCardModel?.companyAddress ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const Divider(thickness: 1), // Horizontal line
                            Text(
                              getCardModel?.companyWebsite ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const Divider(thickness: 1),
                            Text(
                              getCardModel?.workEmail ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const Divider(thickness: 1), // Horizontal line
                            Text(
                              getCardModel?.phoneNo ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (getCardModel != null &&
                        getCardModel!.cardSocials != null)
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Rounded corners
                        ),
                        child: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.0, vertical: 8),
                                  child: Text(
                                    "Social Media",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                ListView.separated(
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
                                  itemCount: getCardModel!.cardSocials!.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      minLeadingWidth: 10,
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            15), // Rounded corners for image
                                        child: Image.asset(
                                          getCardModel!.cardSocials![index]
                                                      .socialName ==
                                                  "Instagram"
                                              ? "assets/images/instagram.png"
                                              : getCardModel!
                                                          .cardSocials![index]
                                                          .socialName ==
                                                      "LinkedIn"
                                                  ? "assets/images/fi_1384014.png"
                                                  : getCardModel!
                                                              .cardSocials![
                                                                  index]
                                                              .socialName ==
                                                          "Twitter"
                                                      ? "assets/images/x.png"
                                                      : getCardModel!
                                                                  .cardSocials![
                                                                      index]
                                                                  .socialName ==
                                                              "Facebook"
                                                          ? "assets/images/fi_1384005.png"
                                                          : "assets/images/browser.png",
                                          width: 25,
                                          height: 25,
                                          color: Colors.black,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(
                                        getCardModel!
                                            .cardSocials![index].socialLink
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (getCardModel != null &&
                        getCardModel!.cardDocuments != null)
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Rounded corners
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 8),
                                child: Text(
                                  "Your Uploads",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              ListView.separated(
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
                                itemCount: getCardModel!.cardDocuments!.length,
                                itemBuilder: (context, index) {
                                  print(
                                      "image-----${getCardModel!.cardDocuments![index].document.toString()}");
                                  print(
                                      "image-----${getCardModel!.cardDocuments![index].cardId.toString()}");
                                  return ListTile(
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
                                                  "${Network.imgUrl}${getCardModel!.cardDocuments![index].document.toString()}",
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
                                      getCardModel!
                                          .cardDocuments![index].document
                                          .toString(),
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
                                  );

                                  // return SizedBox();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: SizedBox(
                              height: 45,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                iconAlignment: IconAlignment.start,
                                onPressed: () {
                                  showDeleteDialog(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent, // Background color
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(
                                        30), // Rounded corners
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Delete", // Right side text
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: SizedBox(
                              height: 45,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                iconAlignment: IconAlignment.start,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (builder) =>
                                              BottomNavBarExample()));
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
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Finish", // Right side text
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Card'),
          content: Text('Are you sure you want to delete this card?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform delete action here
                Navigator.of(context).pop();
                deleteCardApiCalling();
                // Close the dialog
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCardApiCalling() async {
    context.loaderOverlay.show();
    var url =
        "${Network.baseUrl}card/destroy/${widget.cardId.toString()}"; // Replace with your API endpoint

    var token = await Storage().getToken();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        FocusManager.instance.primaryFocus?.unfocus();

        context.loaderOverlay.hide();
        Fluttertoast.showToast(
            msg: "Card Delection successfully",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.white,
            backgroundColor: Colors.green);
        Navigator.push(context,
            CupertinoPageRoute(builder: (builder) => BottomNavBarExample()));
      } else {
        context.loaderOverlay.hide();
        Fluttertoast.showToast(
            msg: "Card Delection Failed",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.white,
            backgroundColor: Colors.grey);
        debugPrint('Failed to register: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (e) {
      context.loaderOverlay.hide();
      Fluttertoast.showToast(
          msg: "Card Delection Failed",
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
          backgroundColor: Colors.grey);

      debugPrint('Error: $e');
    }
  }
}

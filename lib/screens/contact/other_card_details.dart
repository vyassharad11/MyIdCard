import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/data/repository/card_repository.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/card_cubit.dart';
import '../../language/app_localizations.dart';
import '../../models/card_get_model.dart' as dataModel;
import '../../models/utility_dto.dart';
import '../../utils/url_lancher.dart';
import '../../utils/utility.dart';
import '../../utils/widgets/network.dart';
import '../add_card_module/share_card_bottom_sheet.dart';
import '../home_module/main_home_page.dart';
import 'document_preivew.dart';



class OtherCardDetails extends StatefulWidget {
  final String cardId;
  final bool isOtherCard;
  const OtherCardDetails({super.key, required this.cardId,this.isOtherCard = false});

  @override
  State<OtherCardDetails> createState() => _OtherCardDetailsState();
}

class _OtherCardDetailsState extends State<OtherCardDetails> {

  CardCubit? _getCardCubit,deleteCardCubit;
  String? twitterLink, instaLink, faceBookLink, linkdinLink;


  @override
  initState() {
    _getCardCubit = CardCubit(CardRepository());
    fetchData();
    super.initState();
  }

  String token = "";
  String input = "";
  Color? extractedColor = Colors.blue;

  // Define a RegExp pattern to extract `Color(0xff2196f3)`

  dataModel.Data? getCardModel;
  Future<void> fetchData() async {
    _getCardCubit?.apiGetCard(widget.cardId);
  }

  setLink() {
    getCardModel?.cardSocials?.forEach((action) {
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
      listeners:
      [
        BlocListener<CardCubit, ResponseState>(
          bloc: _getCardCubit,
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
              var dto = state.data as dataModel.GetCardModel;
              getCardModel = dto.data;
              setLink();
            }
            setState(() {});
          },),
      ],
      child: Scaffold(
        backgroundColor:  getCardModel
            ?.cardStyle !=
            null
            ? Color(int.parse(
            '0xFF${getCardModel!.cardStyle!}'))
            : ColoursUtils.whiteLightColor.withOpacity(1.0),
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 120,
                      child: Center(
                        child: Text(
                          getCardModel?.cardName.toString() ?? "",
                          overflow: TextOverflow.ellipsis,
                          style:  TextStyle(
                            color: getTextColorFromHex(
                                '0xFF${getCardModel!.cardStyle!}'),
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
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
                              ShareCardBottomSheetOther(
                                cardData:
                                getCardModel,
                              ),
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white
                        ),
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Image.asset(
                            "assets/images/send-01.png",
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
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
                  margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
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
                                    top: 12.0, left: 8),
                                child: ClipRRect(
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(50)),
                                  child: CachedNetworkImage(
                                    height: 80,
                                    width: 80,
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
                                          height: 100,
                                          fit: BoxFit.fill,
                                          width: 100,
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
                      const SizedBox(
                        height: 0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 12),
                        child:  Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 140,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 17,
                                  ),
                                  Text(
                                    "${getCardModel?.firstName ?? ""} ${getCardModel?.lastName ?? ""}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    getCardModel
                                        ?.jobTitle ??
                                        "",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                        FontWeight.normal,
                                        color: Colors.black45),
                                  ),
                                  SizedBox(height: 3,),
                                  Text(
                                    getCardModel
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
                                "${Network.imgUrl}${getCardModel?.companyLogo ?? ""}",
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
                                      height: 90,
                                      fit: BoxFit.fill,
                                      width: 90,
                                    ),
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
                const SizedBox(
                  height: 6,
                ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(20), // Rounded corners
                    ),
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getCardModel
                                  ?.companyName ??
                                  "",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight.normal,
                                  color: Colors.black45),
                            ),
                            Text(
                              getCardModel?.companyType?.companyType ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            // Text(
                            //   getCardModel
                            //       ?.jobTitle ??
                            //       "",
                            //   style: TextStyle(
                            //       fontSize: 14,
                            //       fontWeight:
                            //       FontWeight.normal,
                            //       color: Colors.black45),
                            // ),
                            Container(
                              height: 1,
                              color: ColoursUtils.background,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 100,
                                  child: Text(
                                    getCardModel!
                                        .companyAddress
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    _showBottomSheet(context, () {
                                      _openMap(getCardModel
                                          ?.companyAddress ??
                                          "");
                                    },
                                        "Send Location",
                                        getCardModel
                                            ?.companyAddress
                                            .toString() ??
                                            "",
                                        false);
                                  },
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                )
                              ],
                            ),
                          Container(
                          height: 1,
                          color: ColoursUtils.background,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 100,
                                  child: Text(
                                    getCardModel!
                                        .companyWebsite
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    launchUrlGet(
                                      getCardModel
                                          ?.companyWebsite ??
                                          "",
                                    );
                                  },
                                  child: Image.asset(
                                    "assets/images/link_ic.png",
                                    width: 20,
                                    height: 20,
                                    color: Colors.grey,
                                  )
                                )
                              ],
                            ),
                            Container(
                              height: 1,
                              color: ColoursUtils.background,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 110,
                                  child: Text(
                                    getCardModel!
                                        .workEmail
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                InkWell(
                                    onTap: (){
                                      _showBottomSheet(context,
                                              () async {
                                            // await launch("${contactDetailsDatum
                                            //     ?.workEmail ??
                                            //     ""}?subject=&body=");
                                            await launch(
                                                "mailto:${getCardModel?.workEmail ?? ""}?subject=&body=");
                                            // openGmail(
                                            //     body: "",
                                            //     email: contactDetailsDatum
                                            //             ?.workEmail ??
                                            //         "",
                                            //     subject: "");
                                          },
                                          "Send Email",
                                          getCardModel
                                              ?.workEmail
                                              .toString() ??
                                              "",
                                          false);
                                    },
                                    child:  Icon(
                                      Icons.mail_outline_outlined,
                                      color: Colors.grey,
                                      size: 20,
                                    )
                                )
                              ],
                            ),
                            Container(
                              height: 1,
                              color: ColoursUtils.background,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getCardModel!
                                      .phoneNo
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: (){
                                          _showBottomSheet(context, () {
                                            dialNumber(getCardModel
                                                ?.phoneNo
                                                .toString() ??
                                                "");
                                          },
                                              "Phone",
                                              getCardModel?.phoneNo
                                                  .toString() ??
                                                  "",
                                              false);
                                        },
                                        child:   Icon(
                                          Icons.call,
                                          color: Colors.grey,
                                         size: 20,
                                        )
                                    ),
                                    SizedBox(width: 5,),
                                    InkWell(
                                        onTap: (){
                                          _showBottomSheet(context,
                                                  () async {
                                                // openSMS(contactDetailsDatum?.phoneNo
                                                //         .toString() ??
                                                //     "");

                                                await launch(
                                                    "sms:${getCardModel?.phoneNo.toString() ?? ""}?body=");
                                              },
                                              "Send Message",
                                              getCardModel?.phoneNo
                                                  .toString() ??
                                                  "",
                                              false);
                                        },
                                        child:   Image.asset(
                                          "assets/images/message_ic.png",
                                          color: Colors.grey,
                                          width: 18,
                                          height: 18,
                                        )
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Container(
                              height: 1,
                              color: ColoursUtils.background,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
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
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                if(linkdinLink != null && linkdinLink!.isNotEmpty)       InkWell(
                                  onTap: () {
                                    print("setLink??>>>>>>>>>>>$linkdinLink");
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (getCardModel != null &&
                    getCardModel!.cardDocuments != null && getCardModel!.cardDocuments!.isNotEmpty)
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
                                      .cardDocuments![index]
                                      .documentsName ?? "",),
                                trailing: IconButton(
                                  icon: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4,),
                                    child: Icon(Icons.open_in_new,
                                  color: Colors.grey,)),
                                  onPressed: () {
                                    if(
                                    getCardModel!.cardDocuments![index].document.toString().contains("png") ||
                                        getCardModel!.cardDocuments![index].document.toString().contains("jpg") ||
                                        getCardModel!.cardDocuments![index].document.toString().contains("jpeg")
                                    ) {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            DocumentPreview(
                                              imageUrl: getCardModel!
                                                  .cardDocuments![index]
                                                  .document ?? "",),));
                                      // Handle delete action
                                    }else{
                                      launch("${Network.imgUrl}${getCardModel!.cardDocuments![index].document ?? ""}");
                                    }
                                    // Handle delete action
                                  },
                                ),
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
              ],
            ),
          ),
        ),
      ),
    );
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

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(  AppLocalizations.of(context)
              .translate('deleteCard')),
          content: Text(  AppLocalizations.of(context)
              .translate('deleteAlert')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform delete action here
                Navigator.of(context).pop();
                deleteCardApiCalling();
                // Close the dialog
              },
              child: Text(  AppLocalizations.of(context)
                  .translate('delete')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(  AppLocalizations.of(context)
                  .translate('cancel')),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCardApiCalling() async {
    Utility.showLoader(context);
    deleteCardCubit?.apiDeleteCard(widget.cardId.toString());
  }

}

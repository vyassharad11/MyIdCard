import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_di_card/screens/add_card_module/card_details.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/card_cubit.dart';
import '../../createCard/create_card_final_preview.dart';
import '../../data/repository/card_repository.dart';
import '../../language/app_localizations.dart';
import '../../localStorage/storage.dart';
import '../../models/card_list.dart';
import '../../utils/url_lancher.dart';
import '../../utils/utility.dart';
import '../../utils/widgets/network.dart';
import 'package:http/http.dart' as http;

import 'create_card_user.dart';


class AddNewCardHome extends StatefulWidget {
  const AddNewCardHome({super.key});

  @override
  State<AddNewCardHome> createState() => _AddNewCardHomeState();

}
class _AddNewCardHomeState extends State<AddNewCardHome> {
  CardCubit? _getCardCubit;
  CardListModel? cardList;
  bool isLoad = true;

  @override
  void initState() {
    _getCardCubit = CardCubit(CardRepository());
    getMyCard();
    super.initState();
  }

  Future<void> getMyCard() async {
    isLoad = true;
    _getCardCubit?.apiGetMyCard();
  }




  @override
  Widget build(BuildContext context) {
    return BlocListener<CardCubit, ResponseState>(
      bloc: _getCardCubit,
      listener: (context, state) {
        if (state is ResponseStateLoading) {
        } else if (state is ResponseStateEmpty) {
          isLoad = false;
        } else if (state is ResponseStateNoInternet) {
          isLoad = false;
        } else if (state is ResponseStateError) {
          isLoad = false;
        } else if (state is ResponseStateSuccess) {
          var dto = state.data as CardListModel;
          cardList = dto;
          isLoad = false;
        }
        setState(() {});
      },
      child: Scaffold(
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
                          builder: (builder) => const CreateCardScreen(),
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
              isLoad == true? SizedBox(
          height: MediaQuery.of(context).size.height / 1.3,
            width: MediaQuery.of(context).size.width,child:_getShimmerView()):
              cardList != null && cardList!.data!.isNotEmpty?
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                width: MediaQuery.of(context).size.width,
                child: Swiper(
                  itemCount: cardList!.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => CardDetails(cardData: cardList?.data?[index] ,),));
                      },
                      child: Padding(
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
                                            top: 12.0, left: 8),
                                        child: cardList!.data![index].cardImage != null && cardList!.data![index].cardImage.toString().isNotEmpty? ClipRRect(
                                          borderRadius:
                                          const BorderRadius.all(
                                              Radius.circular(50)),
                                          child: CachedNetworkImage(
                                            height: 80,
                                            width: 80,
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
                                                  height: 100,
                                                  fit: BoxFit.fill,
                                                  width: 100,
                                                ),
                                          ),
                                        ): Image.asset(
                                          "assets/logo/Central icon.png",
                                          height: 100,
                                          fit: BoxFit.fill,
                                          width: 100,
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
                                              Radius.circular(100)),
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
                              // ClipRRect(
                              //   borderRadius: const BorderRadius.only(
                              //       topLeft: Radius.circular(18),
                              //       topRight: Radius.circular(18)),
                              //   child: Image.asset(
                              //     "assets/images/card_header.png",
                              //     height: 80,
                              //     fit: BoxFit.fitWidth,
                              //     width: double.infinity,
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 17,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
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
                                              cardList!.data![index]
                                                  .companyName ??
                                                  "",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                  FontWeight.normal,
                                                  color: Colors.black45),
                                            ),
                                            Text(
                                              cardList!.data![index].companyTypeId == "1"
                                                  ? "IT"
                                                  : "Finance",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
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
                                          ],
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
                                                  height: 90,
                                                  fit: BoxFit.fill,
                                                  width: 90,
                                                ),
                                          ),
                                        ): Image.asset(
                                          "assets/logo/Central icon.png",
                                          height: 100,
                                          fit: BoxFit.fill,
                                          width: 100,
                                        ),
                                      ],
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
                               SizedBox(height: 6,),
                               Center(
                                child: CachedNetworkImage(
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                  "${Network.imgUrl}${cardList!.data![index].qrCode}",
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
                                        height: 200,
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      ),
                                ),
                              ),
                              SizedBox(height: 6,),
                              Center(
                                child: SizedBox(
                                  height: 35,
                                  width: 160,
                                  child: ElevatedButton(
                                   // iconAlignment: IconAlignment.start,
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: "${Network.imgUrl}${cardList!.data![index].qrCode}",)).then((_) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Text copied to clipboard!')),
                                        );
                                      });                                    },
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
                                        "${Network.shareUrl}${cardList?.data?[index].id.toString()}",
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
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Share", // Right side text
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
                      ),
                    );
                  },
                  itemWidth: MediaQuery.sizeOf(context).width / 1.1,
                  axisDirection: AxisDirection.right,
                  layout: SwiperLayout.STACK,
                ),
              ):SizedBox(),
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
      child:showCardShimmer(),
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
                SizedBox(height: 6,),
                Divider(color: Colors.grey,height: 1,),
                SizedBox(height: 20,),
                Center(
                  child: Container(
                    height: 20,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(4)),
                      color: Color(0x72231532),
                    ),
                  ),
                ),
                SizedBox(height: 6,),
                Center(
                  child: Container(
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(4)),
                      color: Color(0x72231532),
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                Center(
                  child: Container(
                    height: 20,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(20)),
                      color: Color(0x72231532),
                    ),
                  ),
                ),
                SizedBox(height: 6,),
                Divider(color: Colors.grey,height: 1,),
                SizedBox(height: 6,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(4)),
                        color: Color(0x72231532),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(4)),
                        color: Color(0x72231532),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(4)),
                        color: Color(0x72231532),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(4)),
                        color: Color(0x72231532),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(4)),
                        color: Color(0x72231532),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

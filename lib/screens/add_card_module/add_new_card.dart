import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_di_card/screens/add_card_module/card_details.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/card_cubit.dart';
import '../../createCard/create_card_final_preview.dart';
import '../../data/repository/card_repository.dart';
import '../../language/app_localizations.dart';
import '../../localStorage/storage.dart';
import '../../models/card_list.dart';
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

  @override
  void initState() {
    _getCardCubit = CardCubit(CardRepository());
    getMyCard();
    super.initState();
  }

  Future<void> getMyCard() async {
    _getCardCubit?.apiGetMyCard();
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<CardCubit, ResponseState>(
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
          var dto = state.data as CardListModel;
          cardList = dto;
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
              if (cardList != null && cardList!.data!.isNotEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                width: MediaQuery.of(context).size.width,
                child: Swiper(
                  itemCount: cardList!.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CardDetails(cardData: cardList?.data?[index] ,),));
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
                      ),
                    );
                  },
                  itemWidth: MediaQuery.sizeOf(context).width / 1.1,
                  axisDirection: AxisDirection.right,
                  layout: SwiperLayout.STACK,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

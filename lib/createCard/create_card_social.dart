import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/bloc/cubit/card_cubit.dart';
import 'package:my_di_card/data/repository/card_repository.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:my_di_card/utils/common_utils.dart';
import 'package:my_di_card/utils/widgets/network.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/api_resp_state.dart';
import '../language/app_localizations.dart';
import '../localStorage/storage.dart';
import '../models/card_get_model.dart';
import '../models/social_data.dart';
import '../models/utility_dto.dart';
import '../utils/url_lancher.dart';
import '../utils/utility.dart';
import 'create_card_details.dart';

class CreateCardScreenSocial extends StatefulWidget {
  final String cardId;
  final bool isEdit;
   CreateCardScreenSocial(
      {super.key, required this.cardId, required this.isEdit});

  @override
  State<CreateCardScreenSocial> createState() => _CreateCardScreenSocialState();
}

class _CreateCardScreenSocialState extends State<CreateCardScreenSocial> {
  TextEditingController linkedin = TextEditingController();
  TextEditingController instagram = TextEditingController();
  TextEditingController facebook = TextEditingController();
  TextEditingController twitter = TextEditingController();
  final List<TextEditingController> _controllers = [];

  CardCubit? _getCardCubit,_cardCubit,_updateCardCubit;

  @override
  void initState() {
    _cardCubit = CardCubit(CardRepository());
    _getCardCubit = CardCubit(CardRepository());
    _updateCardCubit = CardCubit(CardRepository());
    fetchSocials();
    if (widget.isEdit) {
      fetchEditData();
    }
    super.initState();
  }

    Future<void> fetchEditData() async {
      _getCardCubit?.apiGetCard(widget.cardId);
    }


  List<SocialDatum> socials = []; // List to hold parsed social objects
  bool isLoading = true; // To manage loading state

  Future<void> fetchSocials() async {
    _cardCubit?.apiGetSocials();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
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
              var dto = state.data as GetCardModel;
              dto.data?.cardSocials?.forEach((action) {
                if (action.socialName == "Twitter") {
                  twitter.text = action.socialLink.toString();
                }
                if (action.socialName == "Instagram") {
                  instagram.text = action.socialLink.toString();
                }
                if (action.socialName == "Facebook") {
                  facebook.text = action.socialLink.toString();
                }
                if (action.socialName == "LinkedIn") {
                  linkedin.text = action.socialLink.toString();
                }
                if (action.socialId > 4) {
                  TextEditingController textEditingController =
                  TextEditingController();
                  textEditingController.text = action.socialLink.toString();
                  _controllers.add(textEditingController);
                }
              });
            }
            setState(() {});
          },
        ),
        BlocListener<CardCubit, ResponseState>(
          bloc: _cardCubit,
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
              var dto = state.data as SocialForCard;
              socials = dto.data ?? [];
            }
            setState(() {});
          },
        ),
        BlocListener<CardCubit, ResponseState>(
            bloc: _updateCardCubit,
            listener: (context, state) {
              if (state is ResponseStateLoading) {
              } else if (state is ResponseStateEmpty) {
                Utility.hideLoader(context);
                Utility().showFlushBar(context: context, message: state.message,isError: true);
              } else if (state is ResponseStateNoInternet) {
                Utility().showFlushBar(context: context, message: state.message,isError: true);
                Utility.hideLoader(context);
              } else if (state is ResponseStateError) {
                Utility.hideLoader(context);
                Utility().showFlushBar(context: context, message: state.errorMessage,isError: true);
              } else if (state is ResponseStateSuccess) {
                var dto = state.data as UtilityDto;
                Utility.hideLoader(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => CreateCardScreenDetails(
                              cardId: widget.cardId,
                              isEdit: widget.isEdit,
                            )));
                Utility().showFlushBar(context: context, message: dto.message ?? "");
                setState(() {});
              }
            })
      ],
        child: GestureDetector(
          onTap: CommonUtils.closeKeyBoard,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pop(context), // Default action: Go back
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
                       Center(
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('createCardOn'),
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                        height: 3,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: 10,
                        height: 3,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: 30,
                        height: 3,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: 10,
                        height: 3,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: 10,
                        height: 3,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                   Center(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('socialMedia'),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: ColoursUtils.background, // Light white color
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: TextField(
                                    controller: linkedin,
                                    decoration: InputDecoration(
                                      hintText: 'Linkedin',
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12.0, bottom: 12, left: 20),
                                        child: Image.asset(
                                          "assets/images/fi_1384014.png",
                                          height: 14,
                                          fit: BoxFit.contain,
                                          width: 14,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                      hintStyle: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8,),
                              InkWell(
                                onTap: (){
                                  launch(
                                   "https://www.youtube.com"
                                  );
                                },
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: ColoursUtils.background, // Light white color
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: TextField(
                                    controller: facebook,
                                    decoration: InputDecoration(
                                      hintText: 'Facebook',
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12.0, bottom: 12, left: 20),
                                        child: Image.asset(
                                          "assets/images/fi_1384005.png",
                                          height: 14,
                                          fit: BoxFit.contain,
                                          width: 14,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                      hintStyle: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8,),
                              InkWell(
                                onTap: (){
                                  launch(
                                      "https://www.youtube.com"
                                  );
                                },
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: ColoursUtils.background, // Light white color
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: TextField(
                                    controller: instagram,
                                    decoration: InputDecoration(
                                      hintText: '@Instagram',
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12.0, bottom: 12, left: 20),
                                        child: Image.asset(
                                          "assets/images/instagram.png",
                                          height: 14,
                                          fit: BoxFit.contain,
                                          width: 14,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                      hintStyle: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8,),
                              InkWell(
                                onTap: (){
                                  showMenu(
                                    position: RelativeRect.fromLTRB(300, 370, 0, 50),
                                    context: context, items: [
                                    PopupMenuItem(child: Text("Show a popup indicating: “Put your Instagram name indicated by what comes after the @ value on your account."),)
                                  ],);
                                },
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: ColoursUtils.background, // Light white color
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: TextField(
                                    controller: twitter,
                                    decoration: InputDecoration(
                                      hintText: '@Twitter',
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12.0, bottom: 12, left: 20),
                                        child: Image.asset(
                                          "assets/images/x.png",
                                          height: 14,
                                          fit: BoxFit.contain,
                                          width: 14,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                      hintStyle: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8,),
                              InkWell(
                                onTap: (){
                                  showMenu(context: context,
                                    position: RelativeRect.fromLTRB(300, 433, 0, 50),
                                    items: [
                                    PopupMenuItem(child: Text("Show a popup indicating: “Put your Twitter name indicated by what comes after the @ value on your account."),)
                                  ],);
                                },
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _controllers.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 50,
                                margin: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  color: ColoursUtils.background,
                                  // Light white color
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                                child: TextField(
                                  controller: _controllers[index],
                                  decoration: InputDecoration(
                                    hintText: 'Other',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12.0, bottom: 12, left: 20),
                                      child: Image.asset(
                                        "assets/images/browser.png",
                                        height: 14,
                                        fit: BoxFit.contain,
                                        width: 14,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    hintStyle: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: SizedBox(
                  //     height: 45,
                  //     width: MediaQuery.of(context).size.width,
                  //     child: ElevatedButton(
                  //      // iconAlignment: IconAlignment.start,
                  //       onPressed: () {
                  //         // Handle button press
                  //         setState(() {
                  //           _controllers.add(TextEditingController());
                  //         });
                  //       },
                  //       style: ElevatedButton.styleFrom(
                  //         elevation: 0,
                  //         backgroundColor: Colors.white, // Background color
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius:
                  //               BorderRadius.circular(30), // Rounded corners
                  //         ),
                  //       ),
                  //       child: const Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           Icon(
                  //             Icons.add, // Left side icon
                  //             color: Colors.black,
                  //             size: 20,
                  //           ),
                  //           SizedBox(
                  //             width: 6,
                  //           ), // Space between icon and text
                  //           Text(
                  //             "Add New", // Right side text
                  //             style: TextStyle(color: Colors.black, fontSize: 16),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 8
                  ),
                  Container(
                    // margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                       // iconAlignment: IconAlignment.start,
                        onPressed: () {
                          if(linkedin.text.isNotEmpty || twitter.text.isNotEmpty || facebook.text.isNotEmpty || instagram.text.isNotEmpty) {
                            Utility.showLoader(context);
                            submitSocialLinks();
                          }else{
                            Utility().showFlushBar(context: context, message: "Please enter atleast one social link",isError: true);
                          }
                          },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Rounded corners
                          ),
                        ),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate("continue"), // Right side text
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
  }

  List<String> listOfmap = [];
  Future<void> submitSocialLinks() async {
    int valueNew = 5;

    Map<String, dynamic> body = {
      'step_no': '3',
    };
    List<dynamic> lsitOfSocial = [];
    String apiUrl =
        "${Network.baseUrl}card/update/${widget.cardId}"; // Replace with your API endpoint
    if (linkedin.text.isNotEmpty) {
      lsitOfSocial.add({
        "social_id[]": "1",
        "social_link[]": linkedin.text.toString().trim(),
      });
    }
    if (instagram.text.isNotEmpty) {
      lsitOfSocial.add({
        "social_id[]": "2",
        "social_link[]": instagram.text.toString().trim(),
      });
    }
    if (facebook.text.isNotEmpty) {
      lsitOfSocial.add({
        "social_id[]": "3",
        "social_link[]": facebook.text.toString().trim(),
      });
    }
    if (twitter.text.isNotEmpty) {
      lsitOfSocial.add({
        "social_id[]": "4",
        "social_link[]": twitter.text.toString().trim(),
      });
    }
    if (_controllers.isNotEmpty) {
      for (var action in _controllers) {
        lsitOfSocial.add({
          "social_id[]": "$valueNew",
          "social_link[]": action.text.toString().trim(),
        });
        valueNew++;
      }
    }
    int value = 0;
    // body.addAll(lsitOfSocial);
    for (var valueData in lsitOfSocial) {
      body['step_no'] = '3';
      body["social_link[$value]"] = valueData["social_link[]"];
      body["social_id[$value]"] = valueData["social_id[]"];
      value++;
    }
    _updateCardCubit?.cardUpdateApiOld(body,widget.cardId);
  }
}

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/data/repository/card_repository.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/api_resp_state.dart';
import '../bloc/cubit/card_cubit.dart';
import '../language/app_localizations.dart';
import '../localStorage/storage.dart';
import '../models/card_get_model.dart' as dataModel;
import '../models/utility_dto.dart';
import '../screens/contact/document_preivew.dart';
import '../screens/home_module/main_home_page.dart';
import '../utils/utility.dart';
import '../utils/widgets/network.dart';
import 'create_card_user_screen.dart';

class CreateCardFinalPreview extends StatefulWidget {
  final String cardId;
  final bool isEdit;
  const CreateCardFinalPreview({super.key, required this.cardId,this.isEdit = false});

  @override
  State<CreateCardFinalPreview> createState() => _CreateCardFinalPreviewState();
}

class _CreateCardFinalPreviewState extends State<CreateCardFinalPreview> {

  CardCubit? _getCardCubit,deleteCardCubit;

  @override
  initState() {
    _getCardCubit = CardCubit(CardRepository());
    deleteCardCubit = CardCubit(CardRepository());
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
            }
            setState(() {});
          },),
        BlocListener<CardCubit, ResponseState>(
          bloc: deleteCardCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              Utility.hideLoader(context);
              Utility().showFlushBar(context: context, message: state.message,isError: true);
            } else if (state is ResponseStateNoInternet) {
              Utility.hideLoader(context);
              Utility().showFlushBar(context: context, message: state.message,isError: true);
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
              Utility().showFlushBar(context: context, message: state.errorMessage,isError: true);
            } else if (state is ResponseStateSuccess) {
              var dto = state.data as UtilityDto;
              Utility.hideLoader(context);
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (builder) => BottomNavBarExample()),
                    (route) => false,
              );
              Utility().showFlushBar(context: context, message: dto.message ?? "");
            }
            setState(() {});
          },),
      ],
      child: WillPopScope(
        onWillPop: () async{
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (builder) => BottomNavBarExample()),
                (route) => false,
          );
          return false;
        },
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
                                onTap: () =>   Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(builder: (builder) => BottomNavBarExample()),
                                      (route) => false,
                                ), // Default action: Go back
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
                                Text(
                                  getCardModel?.cardName.toString() ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.w600,color: Colors.white),
                                ),

                            if(widget.isEdit == false)    GestureDetector(
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
                                    child: Container(height: 44,
                                    width: 44,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(44)),
                                    child: const Icon(Icons.edit_outlined,color: Colors.black,size: 20,))),
                                if(widget.isEdit == true)  InkWell(
                                  onTap: (){
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(builder: (builder) => BottomNavBarExample()),
                                          (route) => false,
                                    );
                                  },
                                  child: Container(height: 44,
                                  width: 44,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(44)),
                                    child: Image.asset("assets/images/check_circle.png"),
                                  ),
                                )
                          ],
                        ),
                        const SizedBox(height: 10),
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
                                            top: 18.0, left: 8,bottom: 8),
                                        child: ClipRRect(
                                          borderRadius:
                                          const BorderRadius.all(
                                              Radius.circular(50)),
                                          child: CachedNetworkImage(
                                            height: 92,
                                            width: 92,
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
                                                  height: 90,
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
                                    Column(
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
                                      ],
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
                                        "${Network.imgUrl}${getCardModel?.company_logo ?? ""}",
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
                                              height: 80,
                                              fit: BoxFit.fill,
                                              width: double.infinity,
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
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getCardModel?.companyName ?? "",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  getCardModel?.companyTypeId == "1"
                                      ? "IT"
                                      : "Finance",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
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
                          height: 10,
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
                                    var  s = getCardModel!.cardDocuments![index].document.toString();
                                    String result = "";
                                    List<String> parts = s.split('/');
                                    if (parts.length > 2) {
                                       result = parts.sublist(2).join('/');
                                      print(result); // Output: item/12345
                                    } else {
                                      print('Not enough "/" characters in the string.');
                                    }
                                      print(
                                          "image-----${getCardModel!.cardDocuments![index].document.toString()}");
                                      print(
                                          "image-----${getCardModel!.cardDocuments![index].cardId.toString()}");
                                      return InkWell(
                                        onTap: (){
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
                                            launch(getCardModel!.cardDocuments![index].document ?? "");
                                          }
                                        },
                                        child: ListTile(
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

                                              result
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
                          height: 10,
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
                                   // iconAlignment: IconAlignment.start,
                                    onPressed: () {
                                      showDeleteDialog(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.white, // Background color
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(
                                            30), // Rounded corners
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                        AppLocalizations.of(context)
                                        .translate(widget.isEdit == false?'delete':'cancel'),
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
                                   // iconAlignment: IconAlignment.start,
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        CupertinoPageRoute(builder: (builder) => BottomNavBarExample()),
                                            (route) => false,
                                      );
                                      // Handle button press
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.white, // Background color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // Rounded corners
                                      ),
                                    ),
                                    child:  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)
                                              .translate(widget.isEdit == false?'finish':"submit"), // Right side text
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                                                    ],
                                                  ),
                        SizedBox(height: 16,)
                      ],
                    ),
            ),
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

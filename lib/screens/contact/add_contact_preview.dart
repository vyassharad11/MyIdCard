import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_di_card/bloc/cubit/card_cubit.dart';
import 'package:my_di_card/data/repository/card_repository.dart';
import '../../models/card_get_model.dart' as dataModel;

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/contact_cubit.dart';
import '../../data/repository/contact_repository.dart';
import '../../language/app_localizations.dart';
import '../../models/card_get_model.dart';
import '../../models/contact_details_dto.dart';
import '../../models/utility_dto.dart';
import '../../utils/colors/colors.dart';
import '../../utils/utility.dart';
import '../../utils/widgets/network.dart';

class AddContactPreview extends StatefulWidget {
  final String contactId;
  Function callBack;
   AddContactPreview({super.key, required this.contactId,required this.callBack});

  @override
  State<AddContactPreview> createState() => _AddContactPreviewState();
}

class _AddContactPreviewState extends State<AddContactPreview> {
  ContactCubit? _addContactCubit;
  CardCubit?_cardDetailCubit;
  bool isLoad = true;
  dataModel.Data? getCardModel;


  @override
  void initState() {
    _cardDetailCubit = CardCubit(CardRepository());
    _addContactCubit = ContactCubit(ContactRepository());
    getContactDetail();
    // TODO: implement initState
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    _cardDetailCubit?.close();
    _cardDetailCubit = null;
  }

  Future<void> apiAddContact() async {
    Map<String, dynamic> data = {
      "card_id": widget.contactId,
    };
    _addContactCubit?.apiAddContact(data);
  }

  Future<void> getContactDetail() async {
    Utility.showLoader(context);
    _cardDetailCubit?.apiGetCard(widget.contactId);
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ContactCubit, ResponseState>(
          bloc: _addContactCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              Utility.hideLoader(context);
              Utility().showFlushBar(
                  context: context, message: state.message, isError: true);
            } else if (state is ResponseStateNoInternet) {
              Utility.hideLoader(context);
              Utility().showFlushBar(
                  context: context, message: state.message, isError: true);
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
              Utility().showFlushBar(
                  context: context, message: state.errorMessage, isError: true);
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              var dto = state.data as UtilityDto;
              widget.callBack.call();
              Navigator.pop(context);
              Utility()
                  .showFlushBar(context: context, message: dto.message ?? "");
            }
            setState(() {});
          },
        ),
        BlocListener<CardCubit, ResponseState>(
          bloc: _cardDetailCubit,
          listener: (context, state) {
            if (state is ResponseStateLoading) {
            } else if (state is ResponseStateEmpty) {
              isLoad = false;
              Utility.hideLoader(context);
            } else if (state is ResponseStateNoInternet) {
              Utility.hideLoader(context);
              isLoad = false;
            } else if (state is ResponseStateError) {
              Utility.hideLoader(context);
              isLoad = false;
            } else if (state is ResponseStateSuccess) {
              Utility.hideLoader(context);
              isLoad = false;
              var dto = state.data as GetCardModel;
              getCardModel = dto.data;
              // setLink();
            }
            setState(() {});
          },
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 30),
        constraints: BoxConstraints(minHeight: 70,maxHeight: MediaQuery.of(context).size.height-100),
        decoration: BoxDecoration(
            color:  getCardModel
            ?.cardStyle !=
        null
        ? Color(int.parse(
        '0xFF${getCardModel!.cardStyle!}'))
            : ColoursUtils.whiteLightColor.withOpacity(1.0),
            borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(44),
                            color: Colors.white),
                            padding: EdgeInsets.all(8),
                            child:Image.asset("assets/images/close.png")
                          ),
                        ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 120,
                      child: Text(
                        getCardModel?.cardName ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Utility.showLoader(context);
                        apiAddContact();
                      },
                      child: Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(44),
                              color: Colors.white),
                          child:Icon(Icons.add)
                      ),
                    ),
                      ],
                    ),
                    SizedBox(height: 20,),
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
                                        top: 8.0, left: 2),
                                    child:getCardModel!.cardImage != null && getCardModel!.cardImage.toString().isNotEmpty ?ClipRRect(
                                      borderRadius:
                                      const BorderRadius.all(
                                          Radius.circular(80)),
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
                                    ):Image.asset(
                                      "assets/logo/Central icon.png",
                                      height: 105,
                                      fit: BoxFit.fill,
                                      width: 105,
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
                                          80)),
                                  child: CachedNetworkImage(
                                    height: 80,
                                    width: 80,
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
                      height: 10,
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
                              getCardModel?.companyTypeId.toString() == "1"
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
                    // Spacer(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
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
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white, // Background color
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.transparent),
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
                                    .translate('cancel'),
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
                            Utility.showLoader(context);
                            apiAddContact();
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white, // Background color
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.transparent),
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
                                    .translate('add'),
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
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}

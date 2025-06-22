import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../language/app_localizations.dart';
import '../../models/card_list.dart';
import '../../models/contact_details_dto.dart';
import '../../models/my_contact_model.dart';
import '../../notifire_class.dart';
import '../../utils/constant.dart';
import '../../utils/url_lancher.dart';
import '../../utils/utility.dart';
import '../../utils/widgets/network.dart';
import '../../models/card_get_model.dart' as dataModel;


class ShareCardBottomSheet extends StatefulWidget {
  final CardData? cardData;
  const ShareCardBottomSheet({super.key,this.cardData});

  @override
  State<ShareCardBottomSheet> createState() => _ShareCardBottomSheetState();
}

class _ShareCardBottomSheetState extends State<ShareCardBottomSheet> {
  @override
  void initState() {
    // setLink();
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
        child: Padding(
        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,top: 16,left: 16,right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${AppLocalizations.of(context).translate(
            'shareYourNew')} ",style: TextStyle( fontFamily: Constants.fontFamily,fontWeight: FontWeight.w600,fontSize: 22,color: Colors.black),),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(22)),
                    child: const Icon(
                      Icons.clear,
                      size: 18,
                    )),
              ),
            ],
          ),
          Text("${ AppLocalizations.of(context).translate(
              'digitalBusinessCard')} ",style: TextStyle(fontWeight: FontWeight.w600, fontFamily: Constants.fontFamily,fontSize: 22,color: Colors.blue),),
          Text("${ AppLocalizations.of(context).translate(
              'withPeople')} ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22,color: Colors.blue, fontFamily: Constants.fontFamily,),),
            SizedBox(height: 24,),
            Center(
              child: CachedNetworkImage(
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                imageUrl:
                "${Network.imgUrl}${widget.cardData?.qrCode}",
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
            SizedBox(height: 20,),
            Center(
              child: SizedBox(
                height: 35,
                width: Provider.of<LocalizationNotifier>(context).appLocal == Locale("en")?160:170,
                child: ElevatedButton(
                  // iconAlignment: IconAlignment.start,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: "${Network.imgUrl}${widget.cardData?.qrCode}",)).then((_) {
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
                            'CopyQrCode'), // Right side text
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
                      "${Network.shareUrl}${widget.cardData?.id.toString()}",
                      subject:  AppLocalizations.of(context).translate(
                      'shareYourCard'),
                      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                    );                  },
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
                      AppLocalizations.of(context).translate(
                      'share'), // Right side text
                        style: TextStyle(
                            color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),),
        ],),),
    );
  }
}
class ShareCardBottomSheetOther extends StatefulWidget {
  final dataModel.Data? cardData;
  const ShareCardBottomSheetOther({super.key,this.cardData});

  @override
  State<ShareCardBottomSheetOther> createState() => _ShareCardBottomSheetStateOther();
}

class _ShareCardBottomSheetStateOther extends State<ShareCardBottomSheetOther> {
  @override
  void initState() {
    // setLink();
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
        child: Padding(
        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,top: 16,left: 16,right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text( AppLocalizations.of(context).translate('shareTheCardContact') ,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22,color: Colors.blue, fontFamily: Constants.fontFamily),overflow: TextOverflow.fade,)),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(22)),
                    child: const Icon(
                      Icons.clear,
                      size: 18,
                    )),
              ),
            ],
          ),
          // Text("contact ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22,color: Colors.black,fontFamily: Constants.fontFamily),),
          // Text("with people ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22,color: Colors.blue, fontFamily: Constants.fontFamily),),
            SizedBox(height: 24,),
            Center(
              child: CachedNetworkImage(
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                imageUrl:
                "${Network.imgUrl}${widget.cardData?.qrCode}",
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
            SizedBox(height: 20,),
            Center(
              child: SizedBox(
                height: 35,
                width: Provider.of<LocalizationNotifier>(context).appLocal == Locale("en")?160:170,
                child: ElevatedButton(
                  // iconAlignment: IconAlignment.start,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: "${Network.imgUrl}${widget.cardData?.qrCode}",)).then((_) {
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
                            'CopyQrCode'), // Right side text
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
                      "${Network.shareUrl}${widget.cardData?.id.toString()}",
                      subject:  AppLocalizations.of(context).translate(
                          'shareYourCard'),
                      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                    );                  },
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
                      AppLocalizations.of(context).translate(
                      'share'), // Right side text
                        style: TextStyle(
                            color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),),
        ],),),
    );
  }
}

class ShareOtherCardBottomSheet extends StatefulWidget {
  final DataContact? cardData;
  const ShareOtherCardBottomSheet({super.key,this.cardData});

  @override
  State<ShareOtherCardBottomSheet> createState() => _ShareOtherCardBottomSheetState();
}

class _ShareOtherCardBottomSheetState extends State<ShareOtherCardBottomSheet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Padding(
        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,top: 16,left: 16,right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(AppLocalizations.of(context).translate('shareTheCardContact'),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22,color: Colors.blue, fontFamily: Constants.fontFamily),overflow: TextOverflow.fade,)),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(22)),
                      child: const Icon(
                        Icons.clear,
                        size: 18,
                      )),
                ),
              ],
            ),
            SizedBox(height: 24,),
            Center(
              child: CachedNetworkImage(
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                imageUrl:
                "${Network.imgUrl}${widget.cardData?.qrCode}",
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
            SizedBox(height: 20,),
            Center(
              child: SizedBox(
                height: 35,
                width: 160,
                child: ElevatedButton(
                  // iconAlignment: IconAlignment.start,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: "${Network.imgUrl}${widget.cardData?.qrCode}",)).then((_) {
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
                            'CopyQrCode'), // Right side text
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
                      "${Network.shareUrl}${widget.cardData?.cardId.toString()}",
                      subject:  AppLocalizations.of(context).translate(
                          'shareYourCard'),
                      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                    );                  },
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
                        AppLocalizations.of(context).translate(
                            'share'), // Right side text
                        style: TextStyle(
                            color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),),
          ],),),
    );
  }
}

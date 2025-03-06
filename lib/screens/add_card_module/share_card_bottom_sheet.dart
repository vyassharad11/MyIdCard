import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../language/app_localizations.dart';
import '../../models/card_list.dart';
import '../../utils/widgets/network.dart';

class ShareCardBottomSheet extends StatefulWidget {
  final CardData? cardData;
  const ShareCardBottomSheet({super.key,this.cardData});

  @override
  State<ShareCardBottomSheet> createState() => _ShareCardBottomSheetState();
}

class _ShareCardBottomSheetState extends State<ShareCardBottomSheet> {
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
              Text("Share your new ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22,color: Colors.black),),
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
          Text("Digital Business Card ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22,color: Colors.blue),),
          Text("with people ",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22,color: Colors.blue),),
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
        ],),),
    );
  }
}

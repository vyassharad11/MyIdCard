import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../utils/widgets/network.dart';

class DocumentPreview extends StatelessWidget {
  final String imageUrl;
  const DocumentPreview({super.key,required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
    appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                20), // Adjust the radius as needed
            child:

            CachedNetworkImage(
              height: MediaQuery.of(context).size.height-200,
              width: MediaQuery.of(context).size.width-40,
              fit: BoxFit.fitWidth,
              imageUrl:
              "${Network.imgUrl}$imageUrl",
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
        ),
      ),
    );
  }
}

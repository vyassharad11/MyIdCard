import 'dart:async';
import 'dart:io' as IO;
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Utility {
  static String getDurationStr(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours =
    duration.inHours != 0 ? "${twoDigits(duration.inHours)} HR " : "";
    String twoDigitMinutes = duration.inMinutes.remainder(60) != 0
        ? "${twoDigits(duration.inMinutes.remainder(60))} MINS "
        : "";
    String twoDigitSeconds = duration.inSeconds.remainder(60) != 0
        ? "${twoDigits(duration.inSeconds.remainder(60))} SEC "
        : "";

    return "$twoDigitHours$twoDigitMinutes$twoDigitSeconds";
  }

  static showAlertDialogUploading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 5),
              child: const Text("Uploading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future<String> deviceType() async {
    var platformName = "web";
    if (IO.Platform.isAndroid) {
      platformName = "Android";
    } else if (IO.Platform.isIOS) {
      platformName = "IOS";
    }
    return platformName;
  }

  static String convertDateToFormat(String data) {
    // data = '2021-10-06T06:39:05.000Z';
    if (data.isEmpty) return "";
    DateTime parseDate =
    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(data, true);
    var dateLocal = parseDate.toLocal();
    var inputDate = DateTime.parse(dateLocal.toString());
    var outputFormat = DateFormat('dd MMM yyyy hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String convertDateTimeToUtc(String data) {
    // data = '2021-10-06T06:39:05.000Z';
    if (data.isEmpty) return "";
    DateTime parseDate =
    new DateFormat("yyyy-MM-dd HH:mm:ss").parse(data).toUtc();
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    var outputDate = outputFormat.format(inputDate);
    return outputDate.toString();
  }

  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    if (dateString.isEmpty) return "";
    DateTime notificationDate =
    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  static void hideLoader(BuildContext context) {
    if (context.loaderOverlay
        .visible /* && context.loaderOverlay.overlayWidgetType == ReconnectingOverlay*/) {
      context.loaderOverlay.hide();
    }
  }

  static void showLoader(BuildContext context) {
    context.loaderOverlay.show();
  }

  static Flushbar? flushBar;


  void showFlushBar({
    required BuildContext context,
    required String message,
    bool isError = false,
  }) {
    //debugPrint("====isShowing()  ${flushBar?.isShowing()}");
    if (flushBar?.isShowing() == true ||
        flushBar?.isAppearing() == true ||
        flushBar?.isHiding() == true) {
      flushBar!.dismiss();
      flushBar = null;
      // return;
    }
    //debugPrint("====showFlushBar");
    var color =  isError == true
        ? Colors.redAccent
        : Color(0xFF0983E1).withOpacity(0.8);
    var icon = isError == true
        ? Icons.cancel_outlined
        : Icons.check_circle_outline_rounded;
    flushBar = Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: color.withOpacity(0.16),
      borderColor: color,
      borderRadius: BorderRadius.circular(8),
      margin: EdgeInsets.only(
          left: 15, right: 15, top: MediaQuery.of(context).padding.top),
      padding: const EdgeInsets.all(8),
      barBlur: 20,
      isDismissible: true,
      duration: const Duration(seconds: 2),
      messageText: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         if(isError == false)  Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(icon, color: Colors.black, size: 20.0),
          ),
          if(isError == false)   const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.left,
              style:  TextStyle(
                  color: isError?Colors.white:Colors.black,
                  fontSize:14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          if(isError)   InkWell(
            child: const Padding(
              padding: EdgeInsets.only(top: 3.0),
              child: Icon(
                Icons.clear,
                color: Colors.black,
                size: 20.0,
              ),
            ),
            onTap: () {
              flushBar?.dismiss();
            },
          ),
        ],
      ),
      onStatusChanged: (status) {
        // debugPrint("====status  $status");
        if (status == FlushbarStatus.DISMISSED) flushBar = null;
      },
    );
    flushBar?.show(context);
  }



  static showConfirmAlertDialog(
      {required BuildContext context, required String title, required String msg,
        String positiveText = "Yes", String negativeText = "No", Function? onPositiveClick, Function? onNegativeClick}) {
    AlertDialog alert = AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      // backgroundColor: AppColors.textGreenColor.withOpacity(0.16),
      content: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius:
          const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Text(
                  msg,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onPositiveClick?.call();
                },
                style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40)),
                child: Text(positiveText,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                onNegativeClick?.call();
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40)),
              child: Text(negativeText,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showAlertDialog({ required BuildContext? context,
    required String msg,
    String btnText = "Ok",
    Function? onPositiveClick,}) {
    AlertDialog alert = AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.white,
      content: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8 ,right: 8 ,top: 10),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Text(msg,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(alignment: Alignment.bottomRight,
                child: Padding(
                  padding:  const EdgeInsets.only(right: 20,bottom: 10),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context!);
                      onPositiveClick?.call();
                    },
                    child: Text(btnText,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context!,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}

// import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
class ScanQrCodeBottomSheet extends StatelessWidget {
  const ScanQrCodeBottomSheet({super.key});

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
      print("Scan result: $barcodeScanRes");

    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    // setState(() {
    //   _scanBarcode = barcodeScanRes;
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
     constraints: BoxConstraints(minHeight: 500,maxHeight: MediaQuery.of(context).size.height - 100),
      child: Padding(
        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,top: 16,left: 16,right: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title text
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Wrap(
                      children: [
                        const Text(
                          softWrap: true,
                          'Scan ',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          softWrap: true,
                          'QR Code',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontSize: 22,
                            color: ColoursUtils.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const Text(
                          softWrap: true,
                          'to add in your Contacts',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                ],
              ),
              const SizedBox(height: 8),
              InkWell(       onTap:() async {
                scanQR();
                // Future<void> scanBarcode() async {
                //   String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                //     '#ff6666', // Scanner color
                //     'Cancel', // Cancel button text
                //     true, // Show flash icon
                //     ScanMode.BARCODE, // Scan mode
                //    );

                  // print("Scan result: $barcodeScanRes");
                // }
                // final qrCode = QrCode(4, QrErrorCorrectLevel.L)
                //   ..addData('Hello, world in QR form!');
                //    debugPrint("Barcode list: $qrCode");
                // final qrImage = QrImage(qrCode);
                // debugPrint("Barcode list: $qrImage");

                // Navigator.of(context).push(
              //     MaterialPageRoute(
              //         builder: (context) => AiBarcodeScanner(
              //         onDispose: () {
              //     /// This is called when the barcode scanner is disposed.
              //     /// You can write your own logic here.
              //     debugPrint("Barcode scanner disposed!");
              // },
              //   hideGalleryButton: false,
              //   controller: MobileScannerController(
              //   detectionSpeed: DetectionSpeed.noDuplicates,
              //   ),
              //   onDetect: (BarcodeCapture capture) {
              //   /// The row string scanned barcode value
              //   final String? scannedValue =
              //   capture.barcodes.first.rawValue;
              //   debugPrint("Barcode scanned: $scannedValue");
              //
              //   /// The `Uint8List` image is only available if `returnImage` is set to `true`.
              //   // final Uint8List? image = capture.image;
              //   // debugPrint("Barcode image: $image");
              //
              //   /// row data of the barcode
              //   final Object? raw = capture.raw;
              //   debugPrint("Barcode raw: $raw");
              //
              //   /// List of scanned barcodes if any
              //   final List<Barcode> barcodes = capture.barcodes;
              //   debugPrint("Barcode list: $barcodes");
              //   },
              //   validator: (value) {
              //   if (value.barcodes.isEmpty) {
              //   return false;
              //   }
              //   if (!(value.barcodes.first.rawValue
              //       ?.contains('flutter.dev') ??
              //   false)) {
              //   return false;
              //   }
              //   return true;
              //   })));
                },
                child: const Center(
                  child: Icon(
                    Icons.qr_code_2, // QR Code Icon
                    size: 120,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'or',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              // Scan Physical Card
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Scan ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    ' Physical Card',
                    style: TextStyle(
                      fontSize: 18,
                      color: ColoursUtils.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // First Name Input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Last Name Input
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 20),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Top + Icon
                        CircleAvatar(
                          radius: 18,
                          child: Image.asset("assets/images/add button.png"),
                        ),
                        const SizedBox(
                            height: 20), // Space between icon and text
                        // Text below the icon
                        const Text(
                          'Upload Physical Card',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(
                            height: 4), // Space between icon and text
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              // Upload Physical Card Button
            ],
          ),
        ),
      ),
    );
  }
}

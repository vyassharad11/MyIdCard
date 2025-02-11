import 'package:flutter/material.dart';
import 'package:my_di_card/utils/colors/colors.dart';

class ScanQrCodeBottomSheet extends StatelessWidget {
  const ScanQrCodeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
              const Center(
                child: Icon(
                  Icons.qr_code_2, // QR Code Icon
                  size: 120,
                  color: Colors.black,
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

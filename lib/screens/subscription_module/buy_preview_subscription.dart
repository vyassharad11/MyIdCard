import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_di_card/utils/colors/colors.dart';

import 'buy_subscription_screen.dart';

class BuySubscriptionPreviewScreen extends StatefulWidget {
  const BuySubscriptionPreviewScreen({super.key});

  @override
  State<BuySubscriptionPreviewScreen> createState() =>
      _BuySubscriptionPreviewScreenState();
}

class _BuySubscriptionPreviewScreenState
    extends State<BuySubscriptionPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          'Buy Subscription',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12), // Spacing between text elements

            // Personal Plan Info
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      "assets/images/Frame 1707479720.png",
                      height: 160,
                      width: 160,
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Personal Plan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Trial End Info
                    Text(
                      'Your free trial will end on July 23, 2024.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Billing Information
                    Text(
                      'After that, you will be automatically billed ₹8000.',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30), // Spacing before buttons

            // Cancel Trial Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Manage plan logic goes here
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: const BorderSide(color: Colors.grey, width: 2),
                    ),
                    child: const Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Cancel trial logic goes here
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (builder) => SubscriptionBuyScreen(
                              planName: 'Personal Plan',
                              price: '₹8000/month',
                              catalogCount: 1,
                              categoriesCount: 10,
                              productCount: 200,
                              enquiries: 'Unlimited',
                              downloads: 'Unlimited',
                              features: 'All the Features',
                              nextPaymentDate: 'July 24, 2024',
                              paymentMethod: 'Credit Card',
                              totalAmount: '₹8000',
                            ),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColoursUtils
                          .primaryColor, // Red button for cancel action
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Manage Plan',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16), // Spacing between buttons

            // Manage Plan Button
          ],
        ),
      ),
    );
  }
}

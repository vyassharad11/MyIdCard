import 'package:flutter/material.dart';
import 'package:my_di_card/utils/colors/colors.dart';

class SubscriptionBuyScreen extends StatefulWidget {
  final String planName;
  final String price;
  final int catalogCount;
  final int categoriesCount;
  final int productCount;
  final String enquiries;
  final String downloads;
  final String features;
  final String nextPaymentDate;
  final String paymentMethod;
  final String totalAmount;

  const SubscriptionBuyScreen({super.key, 
    required this.planName,
    required this.price,
    required this.catalogCount,
    required this.categoriesCount,
    required this.productCount,
    required this.enquiries,
    required this.downloads,
    required this.features,
    required this.nextPaymentDate,
    required this.paymentMethod,
    required this.totalAmount,
  });

  @override
  State<SubscriptionBuyScreen> createState() => _SubscriptionBuyScreenState();
}

class _SubscriptionBuyScreenState extends State<SubscriptionBuyScreen> {
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
            // Plan Details
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: ColoursUtils.primaryColor, width: 2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.planName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.price,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 20),

                  // Subscription Features
                  _buildFeatureRow('Catalog', '${widget.catalogCount} Catalog'),
                  _buildFeatureRow(
                      'Categories', '${widget.categoriesCount} Categories'),
                  _buildFeatureRow(
                      'Products', '${widget.productCount} Products'),
                  _buildFeatureRow(
                      'Enquiries', '${widget.enquiries} Enquiries'),
                  _buildFeatureRow('Downloads',
                      '${widget.downloads} Downloads (PDF and Data)'),
                  _buildFeatureRow('Features', widget.features),
                ],
              ),
            ),

            const SizedBox(
                height: 20), // Spacing between features and payment details

            // Payment Information
            const Text(
              'Next Payment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.nextPaymentDate),
            const SizedBox(height: 8),

            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.paymentMethod),

            const SizedBox(height: 20),

            // Total Amount
            const Text(
              'Total',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.totalAmount,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),

            const Spacer(),

            // Go to Dashboard Button
            ElevatedButton(
              onPressed: () {
                // Logic to go to dashboard
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                backgroundColor: ColoursUtils.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Center(
                child: Text(
                  'Go to Dashboard',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each feature row
  Widget _buildFeatureRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.check_box,
            color: ColoursUtils.primaryColor,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

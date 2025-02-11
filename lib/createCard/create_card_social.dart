import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/utils/colors/colors.dart';
import 'package:my_di_card/utils/common_utils.dart';
import 'package:my_di_card/utils/widgets/network.dart';

import '../localStorage/storage.dart';
import '../models/card_get_model.dart';
import '../models/social_data.dart';
import 'create_card_details.dart';

class CreateCardScreenSocial extends StatefulWidget {
  final String cardId;
  final bool isEdit;
  const CreateCardScreenSocial(
      {super.key, required this.cardId, required this.isEdit});

  @override
  State<CreateCardScreenSocial> createState() => _CreateCardScreenSocialState();
}

class _CreateCardScreenSocialState extends State<CreateCardScreenSocial> {
  TextEditingController linkedin = TextEditingController();
  TextEditingController instagram = TextEditingController();
  TextEditingController facebook = TextEditingController();
  TextEditingController twitter = TextEditingController();
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    fetchSocials();
    if (widget.isEdit) {
      fetchEditData();
    }
    super.initState();
  }

  Future<void> fetchEditData() async {
    var token = await Storage().getToken();
    String apiUrl =
        "${Network.baseUrl}card/get/${widget.cardId}"; // Replace with your API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        // Successfully fetched data
        final jsonResponse = jsonDecode(response.body);

        GetCardModel getCardModel = GetCardModel.fromJson(jsonResponse);
        setState(() {
          getCardModel.data?.cardSocials?.forEach((action) {
            if (action.socialName == "Twitter") {
              twitter.text = action.socialLink.toString();
            }
            if (action.socialName == "Instagram") {
              instagram.text = action.socialLink.toString();
            }
            if (action.socialName == "Facebook") {
              facebook.text = action.socialLink.toString();
            }
            if (action.socialName == "LinkedIn") {
              linkedin.text = action.socialLink.toString();
            }
            if (action.socialId > 4) {
              TextEditingController textEditingController =
                  TextEditingController();
                  textEditingController.text = action.socialLink.toString();
              _controllers.add(textEditingController);
            }
          });
        });

        debugPrint("Data fetched successfully: $getCardModel");
        context.loaderOverlay.hide();
      } else {
        context.loaderOverlay.hide();

        // Handle error response
        debugPrint("Failed to fetch data. Status Code: ${response.statusCode}");
        debugPrint("Error: ${response.body}");
      }
    } catch (error) {
      context.loaderOverlay.hide();

      // Handle any exceptions
      debugPrint("An error occurred: $error");
    }
  }

  final String apiUrl =
      "${Network.baseUrl}api/socials"; // Replace with your API URL
  List<Social> socials = []; // List to hold parsed social objects
  bool isLoading = true; // To manage loading state

  Future<void> fetchSocials() async {
    var token = await Storage().getToken();
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $token', // Add your authorization token
      });
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse['status'] == true) {
          setState(() {
            socials = (decodedResponse['data'] as List)
                .map((item) => Social.fromJson(item))
                .toList();
            isLoading = false;
          });
        }
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: CommonUtils.closeKeyBoard,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pop(context), // Default action: Go back
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
                  const Center(
                    child: Text(
                      "Create Card",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 3,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 3,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 30,
                    height: 3,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 3,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 3,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  "Social Media",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: ColoursUtils.background, // Light white color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: linkedin,
                          decoration: InputDecoration(
                            hintText: 'Linkedin',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12, left: 20),
                              child: Image.asset(
                                "assets/images/fi_1384014.png",
                                height: 14,
                                fit: BoxFit.contain,
                                width: 14,
                              ),
                            ),
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: ColoursUtils.background, // Light white color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: instagram,
                          decoration: InputDecoration(
                            hintText: 'Instagram',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12, left: 20),
                              child: Image.asset(
                                "assets/images/instagram.png",
                                height: 14,
                                fit: BoxFit.contain,
                                width: 14,
                              ),
                            ),
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: ColoursUtils.background, // Light white color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: facebook,
                          decoration: InputDecoration(
                            hintText: 'Facebook',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12, left: 20),
                              child: Image.asset(
                                "assets/images/fi_1384005.png",
                                height: 14,
                                fit: BoxFit.contain,
                                width: 14,
                              ),
                            ),
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: ColoursUtils.background, // Light white color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: twitter,
                          decoration: InputDecoration(
                            hintText: 'Twitter',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12, left: 20),
                              child: Image.asset(
                                "assets/images/x.png",
                                height: 14,
                                fit: BoxFit.contain,
                                width: 14,
                              ),
                            ),
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _controllers.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 50,
                            margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              color: ColoursUtils.background,
                              // Light white color
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: _controllers[index],
                              decoration: InputDecoration(
                                hintText: 'Other',
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, bottom: 12, left: 20),
                                  child: Image.asset(
                                    "assets/images/browser.png",
                                    height: 14,
                                    fit: BoxFit.contain,
                                    width: 14,
                                  ),
                                ),
                                border: InputBorder.none,
                                hintStyle: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    iconAlignment: IconAlignment.start,
                    onPressed: () {
                      // Handle button press
                      setState(() {
                        _controllers.add(TextEditingController());
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add, // Left side icon
                          color: Colors.black,
                          size: 20,
                        ),
                        SizedBox(
                          width: 6,
                        ), // Space between icon and text
                        Text(
                          "Add New", // Right side text
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8
              ),
              Container(
                // margin: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    iconAlignment: IconAlignment.start,
                    onPressed: () {
                      submitSocialLinks();

                      // Handle button press
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Continue", // Right side text
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<String> listOfmap = [];
  Future<void> submitSocialLinks() async {
    var token = await Storage().getToken();
    List<String> id = [];
    List<String> prices = [];
    int valueNew = 5;

    Map<String, dynamic> body = {
      'step_no': '3',
    };
    List<dynamic> lsitOfSocial = [];
    String apiUrl =
        "${Network.baseUrl}card/update/${widget.cardId}"; // Replace with your API endpoint
    if (linkedin.text.isNotEmpty) {
      lsitOfSocial.add({
        "social_id[]": "1",
        "social_link[]": linkedin.text.toString().trim(),
      });
    }
    if (instagram.text.isNotEmpty) {
      lsitOfSocial.add({
        "social_id[]": "2",
        "social_link[]": instagram.text.toString().trim(),
      });
    }
    if (facebook.text.isNotEmpty) {
      lsitOfSocial.add({
        "social_id[]": "3",
        "social_link[]": facebook.text.toString().trim(),
      });
    }
    if (twitter.text.isNotEmpty) {
      lsitOfSocial.add({
        "social_id[]": "4",
        "social_link[]": twitter.text.toString().trim(),
      });
    }
    if (_controllers.isNotEmpty) {
      for (var action in _controllers) {
        lsitOfSocial.add({
          "social_id[]": "$valueNew",
          "social_link[]": action.text.toString().trim(),
        });
        valueNew++;
      }
    }
    int value = 0;
    // body.addAll(lsitOfSocial);
    for (var valueData in lsitOfSocial) {
      body['step_no'] = '3';
      body["social_link[$value]"] = valueData["social_link[]"];
      body["social_id[$value]"] = valueData["social_id[]"];
      value++;
    }

    try {
      debugPrint('body : $body');
      // Send the POST request
      final response = await http.post(Uri.parse(apiUrl),
          headers: {
            'Accept': 'application/json', // Set content type to JSON
            'Authorization': 'Bearer $token', // Add your authorization token
          },
          body: body);

      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => CreateCardScreenDetails(
                      cardId: widget.cardId,
                      isEdit: widget.isEdit,
                    )));
      } else {
        debugPrint(response.reasonPhrase);
        debugPrint("Response Reason Phrase: ${response.reasonPhrase}");
      }
    } catch (error) {
      debugPrint("An error occurred: $error");
    }
  }
}

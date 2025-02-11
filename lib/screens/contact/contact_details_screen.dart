import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../meetings/metting_details.dart';
import '../meetings/metting_list.dart';

class ContactDetails extends StatefulWidget {
  const ContactDetails({super.key});

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  Widget buildContactBottomSheetContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text(
              'Add to favorites',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              // Add functionality here
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: const Text(
              'Add tag',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              // Add functionality here
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: const Text(
              'Hide Contact',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              // Add functionality here
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            title: const Text(
              'Export to Contacts App',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              // Add functionality here
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: const Text(
              'Delete Contact',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              // Add delete functionality here
            },
          ),
          const Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Abhishe Joshi",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  builder: (context) {
                    return buildContactBottomSheetContent(context);
                  },
                );
              },
              icon: const Icon(Icons.more_vert))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18), // if you need this
                  side: const BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18)),
                      child: Image.asset(
                        "assets/images/card_header.png",
                        height: 80,
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 17,
                                  ),
                                  Text(
                                    "Abhishe Joshi",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "CEO",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black45),
                                  ),
                                  Text(
                                    "Deo of Fifa design",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black45),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 35,
                                width: 90,
                                child: ElevatedButton(
                                  iconAlignment: IconAlignment.start,
                                  onPressed: () {
                                    // Handle button press
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.blue, // Background color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          30), // Rounded corners
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/send-01.png",
                                        height: 16,
                                        width: 16,
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ), // Space between icon and text
                                      const Text(
                                        "Send", // Right side text
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
                                height: 55,
                                width: 45,
                              ),
                              Image.asset(
                                "assets/social/facebook.png",
                                height: 55,
                                width: 45,
                              ),
                              Image.asset(
                                "assets/social/insta.png",
                                height: 55,
                                width: 45,
                              ),
                              Image.asset(
                                "assets/social/whats.png",
                                height: 55,
                                width: 45,
                              ),
                              Image.asset(
                                "assets/social/applew.png",
                                height: 55,
                                width: 45,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: Text(
                "Notes",
                style: TextStyle(
                  color: Colors.black, // Text color
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light background color
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                child: const Center(
                  child: Text(
                    "Two driven jocks help fax my big quiz. Quick, Baz, get my woven flax jodhpurs! Now fax quiz Jack!",
                    style: TextStyle(
                      color: Colors.black, // Text color
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'Mettings',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20, top: 6),
                            child: ClipOval(
                              child: Material(
                                color: Colors.blue, // Button color
                                child: InkWell(
                                  splashColor: Colors.blue, // Splash color
                                  onTap: () {
                                    // showModalBottomSheet(
                                    //   context: context,
                                    //   shape: const RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.vertical(
                                    //       top: Radius.circular(25.0),
                                    //     ),
                                    //   ),
                                    //   builder: (context) {
                                    //     return buildContactBottomSheetContent(
                                    //         context);
                                    //   },
                                    // );
                                  },
                                  child: const SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (ctx, index) {
                            return Container(
                              color: Colors.black12,
                              height: 1,
                            );
                          },
                          itemCount: meetings.length,
                          itemBuilder: (context, index) {
                            final meeting = meetings[index];
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (builder) =>
                                        MeetingDetailsScreen(),
                                  ),
                                );
                              },
                              title: Text(
                                meeting['title'] ?? '',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                meeting['description'] ?? '',
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: Text(
                                meeting['date'] ?? '',
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 14),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (builder) => const MeetingsScreen(),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "View All meetings",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                              size: 20,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Map<String, String>> meetings = [
    {
      'title': 'Meeting with Janice',
      'date': '5 July 2024',
      'description': 'Product Design Discussion',
    },
    {
      'title': 'Meeting with Ori',
      'date': '3 July 2024',
      'description': 'Design System',
    },
    {
      'title': 'Meeting with Max',
      'date': '3 July 2024',
      'description': 'Design System',
    },
    {
      'title': 'Meeting with Max',
      'date': '2 July 2024',
      'description': 'Design System',
    },
  ];
}



// Bottom Sheet content

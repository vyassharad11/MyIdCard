import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../models/my_meetings_model.dart';
import 'create_edit_meeting.dart'; // To open the meeting link

class MeetingDetailsScreen extends StatelessWidget {
  MeetingDatum? meetingDatum;
  String?contactId;
   MeetingDetailsScreen({super.key,this.meetingDatum,this.contactId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title:  Text(
          "${meetingDatum?.firstName ?? ""} Meeting",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        meetingDatum?.notes ?? "",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateEditMeeting(
                              isEdit: true,
                              meetingDatum: meetingDatum,
                              contactId: contactId,
                              meetingId: meetingDatum?.id.toString(),

                            ),));
                            // showModalBottomSheet(
                            //   context: context,
                            //   shape: const RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.vertical(
                            //       top: Radius.circular(25.0),
                            //     ),
                            //   ),
                            //   builder: (context) {
                            //     return BottomSheetContentAddContact();
                            //   },
                            // );
                          },
                          child: Image.asset(
                            "assets/images/edit-05.png",
                            height: 16,
                            width: 16,
                            color: Colors.black,
                          )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(
                              Icons.calendar_month_outlined, 'Date & Time'),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 6),
                            child: Text(
                                DateFormat('d MMMM yyyy').format(meetingDatum?.dateTime ?? DateTime.now()),
                                style: const TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(Icons.location_city, 'Address'),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 6),
                            child: Text(meetingDatum?.address ?? "",
                                style: const TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(Icons.link, 'Link'),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 6),
                            child: InkWell(
                              onTap: () => _launchURL( meetingDatum?.link ?? "",),
                              child: Text(
                                meetingDatum?.link ?? "",
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(Icons.notes, 'Notes'),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 6),
                            child: Text(meetingDatum?.notes ?? "",
                                style: const TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create section titles
  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.black54,
          size: 20,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: const TextStyle(
              fontSize: 14,
              color: Colors.blueAccent,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // Method to open the meeting link in the browser
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class BottomSheetContentAddContact extends StatelessWidget {
  static const List<String> items = [
    'Add to private contact',
    'Export to Contacts App',
  ];

  const BottomSheetContentAddContact({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        color: Colors.white,
      ),
      child: ListView.separated(
        shrinkWrap: true, // Limits the ListView's height
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              items[index],
              style: const TextStyle(fontSize: 15),
            ),
            onTap: () {
              debugPrint('${items[index]} tapped');
              Navigator.pop(context); // Close the bottom sheet after tap
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1,
            color: Colors.grey[300],
          );
        },
      ),
    );
  }
}

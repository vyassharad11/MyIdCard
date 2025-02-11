import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_di_card/screens/meetings/metting_details.dart';

class MeetingsScreen extends StatefulWidget {
  const MeetingsScreen({super.key});

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  // List of meetings
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Meeting",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: ListView.separated(
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
                  builder: (builder) => MeetingDetailsScreen(),
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
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
          );
        },
      ),
    );
  }
}

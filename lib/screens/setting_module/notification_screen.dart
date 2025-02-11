import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Removes the default back button
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const CircleAvatar(
              backgroundColor: Colors.white60, // Notification icon background
              child: Icon(
                Icons.close, // Notification icon
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        // padding: const EdgeInsets.all(8.0),
        itemCount: 10, // Example notification count
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              leading: const CircleAvatar(
                backgroundColor: Colors.blue, // Notification icon background
                child: Icon(
                  Icons.notifications, // Notification icon
                  color: Colors.white,
                ),
              ),
              title: Text('Notification Title $index'),
              subtitle: Text('This is the description$index.'),
              trailing: GestureDetector(
                onTap: () {},
                child: Image.asset(
                  "assets/images/Frame 416.png",
                  height: 26,
                  width: 26,
                ),
              ));
        },
      ),
    );
  }
}

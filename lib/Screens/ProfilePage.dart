import 'package:firebase/Screens/VideoCall/VideoCallPage.dart';
import 'package:firebase/Screens/YourLocation.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String email;
  final String phoneNumber;

  // Constructor to accept the email and phone number parameters
  ProfilePage({super.key, required this.email, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Page')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(email), // Display email
              accountEmail: Text(phoneNumber), // Display phone number
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(email[0].toUpperCase()), // Initial of the email
              ),
            ),
            ListTile(
              leading: Icon(Icons.video_call),
              title: Text('Video Call'),
              onTap: () {
                // Add navigation or functionality for Video Call
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => VideoCallPage()));
              },
            ),
            ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Your Location'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => YourLocation()));
                }),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Add navigation or functionality for Settings
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Text('Email: $email', style: Theme.of(context).textTheme.bodyLarge),
            Text('Phone: $phoneNumber',
                style: Theme.of(context).textTheme.bodyLarge),
            // Add more UI elements as needed
          ],
        ),
      ),
    );
  }
}

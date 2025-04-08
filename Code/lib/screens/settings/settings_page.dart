import '../splash_screen.dart';
import 'about_page.dart';
import 'contact_page.dart';
import 'faq_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/settings.png', // Ensure this asset is in pubspec.yaml
                      height: 150,
                      width: 150,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Settings',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Profile Section
              const Text('Profile', style: sectionTitleStyle),
              ListTile(
                leading: const Icon(Icons.person_2_outlined),
                title: const Text('Edit Profile'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to profile editing page
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Open language selection
                },
              ),

              // Tax Settings Section
              const SizedBox(height: 16),
              const Text('Tax Settings', style: sectionTitleStyle),
              ListTile(
                leading: const Icon(Icons.public),
                title: const Text('Select Tax Region'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to tax region selection
                },
              ),
              ListTile(
                leading: const Icon(Icons.percent),
                title: const Text('Set Default Tax Rate'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Open tax rate input
                },
              ),
              SwitchListTile(
                secondary: const Icon(Icons.local_offer),
                title: const Text('Enable Tax Treaty Benefits'),
                value: true, // Should be linked to app settings state
                onChanged: (bool value) {
                  // Toggle tax treaty benefits
                },
              ),

              // Notifications Section
              const SizedBox(height: 16),
              const Text('Notifications', style: sectionTitleStyle),
              SwitchListTile(
                secondary: const Icon(Icons.notifications),
                title: const Text('Enable Notifications'),
                value: true, // Replace with actual user setting
                onChanged: (bool value) {
                  // Toggle notifications
                },
              ),
              ListTile(
                leading: const Icon(Icons.alarm),
                title: const Text('Set Expense Alerts'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Open alerts setup
                },
              ),

              // Security Section
              const SizedBox(height: 16),
              const Text('Security', style: sectionTitleStyle),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to change password page
                },
              ),
              SwitchListTile(
                secondary: const Icon(Icons.fingerprint),
                title: const Text('Enable Biometric Login'),
                value: false, // Example toggle
                onChanged: (bool value) {
                  // Toggle biometric authentication
                },
              ),

              // Theme Section
              const SizedBox(height: 16),
              const Text('Theme', style: sectionTitleStyle),
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text('Enable Dark Mode'),
                value: false, // Example toggle
                onChanged: (bool value) {
                  // Toggle biometric authentication
                },
              ),

              // Support Section
              const SizedBox(height: 16),
              const Text('Support', style: sectionTitleStyle),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('FAQs'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FAQPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.support),
                title: const Text('Contact Support'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About App'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                },
              ),

              // Support Section
              const SizedBox(height: 16),
              const Text('Log Out', style: sectionTitleStyle),
              ListTile(
                leading: const Icon(Icons.person_3),
                title: const Text('Log Out'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 3),
                      content: Text(
                        'Logged Out Successfully!',
                        style: TextStyle(color: Colors.black),
                      ),
                      backgroundColor: Colors.greenAccent,
                    ),
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const TextStyle sectionTitleStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

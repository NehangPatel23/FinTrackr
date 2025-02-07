import 'package:fintrackr/screens/ui_elements/header.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header and Introduction
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  'assets/contact_us.png',
                  height: 160,
                  width: 160,
                  fit: BoxFit.cover,
                ),
              ),
              Header(text: 'Contact Us!'),
              const Text(
                "We're here to help! Reach out to us through any of the channels below.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              // Contact Cards
              _buildContactCard(
                  "Nehang Patel",
                  "+1 (513) 726-8552",
                  "patel3ng@mail.uc.edu",
                  "https://www.linkedin.com/in/nehangpatel/",
                  "nehang.png"),
              const SizedBox(height: 20),
              _buildContactCard(
                  "Shruti Asolkar",
                  "+1 (513) 237-3457",
                  "asolkasy@mail.uc.edu",
                  "https://www.linkedin.com/in/shruti-asolkar/",
                  "shruti.png"),
              const SizedBox(height: 20),
              _buildContactCard(
                  "Tharun Ravikumar",
                  "+1 (513) 834-2011",
                  "ravikutn@mail.uc.edu",
                  "https://www.linkedin.com/in/tharun-swaminathan-ravi-kumar-81a88a20a/",
                  "tharun.png"),

              // GitHub Section
              const SizedBox(height: 50),
              const Text(
                "Check out our GitHub Repository",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildSocialIcon(FontAwesomeIcons.github,
                  "https://github.com/NehangPatel23/FinTrackr"),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(Icons.location_on),
                            iconSize: 25,
                            onPressed: () => launchUrl(Uri.parse(
                                "https://www.google.com/maps/dir/39.1331639,-84.5166698/University+of+Cincinnati,+2600+Clifton+Ave,+Cincinnati,+OH+45221/@39.1342464,-84.5183584,17z/data=!3m1!4b1!4m9!4m8!1m1!4e1!1m5!1m1!1s0x8841b38acb65ec25:0x4249b42781c0c5fc!2m2!1d-84.5149504!2d39.1329219?entry=ttu&g_ep=EgoyMDI1MDIwNC4wIKXMDSoASAFQAw%3D%3D")),
                            color: Colors.redAccent),
                        Text(
                          "University of Cincinnati, \n2600 Clifton Ave, Cincinnati, OH 45221",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(
      String name, String phone, String email, String website, String picture) {
    return Card(
      elevation: 8,
      shadowColor: Colors.blueAccent.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                    child: Image.asset(
                        height: 80,
                        width: 80,
                        'assets/$picture',
                        fit: BoxFit.cover)),
                SizedBox(
                  width: 20,
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildContactOption(Icons.phone, "Phone", phone, "tel:$phone"),
            _buildContactOption(Icons.email, "Email", email, "mailto:$email"),
            _buildContactOption(Icons.language, "LinkedIn", website, website),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(
      IconData icon, String title, String detail, String url) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.1)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.blueAccent),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    detail,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        radius: 30,
        child: Icon(icon, color: Colors.white, size: 35),
      ),
    );
  }
}

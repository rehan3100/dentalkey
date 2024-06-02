import 'dart:convert';
import 'package:dental_key/dental_portal/mainscreen/dentalportal_main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamMembersPage extends StatefulWidget {
  final String accessToken;

  TeamMembersPage({required this.accessToken});

  @override
  _TeamMembersPageState createState() => _TeamMembersPageState();
}

class _TeamMembersPageState extends State<TeamMembersPage> {
  List<dynamic> teamMembers = [];
  Map<String, dynamic>? myProfile;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final profileResponse = await http.get(Uri.parse(
          'https://dental-key-738b90a4d87a.herokuapp.com/miscellaneous/my_profile/'));
      final teamResponse = await http.get(Uri.parse(
          'https://dental-key-738b90a4d87a.herokuapp.com/miscellaneous/team-members/'));

      if (profileResponse.statusCode == 200 && teamResponse.statusCode == 200) {
        setState(() {
          myProfile =
              (json.decode(profileResponse.body) as List<dynamic>).first;
          teamMembers = json.decode(teamResponse.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              DentalPortalMain(accessToken: widget.accessToken)),
    );
    return false;
  }

  Future<void> refreshpage() async {
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Team Members'),
        ),
        body: RefreshIndicator(
          onRefresh: refreshpage,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          // Header image
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 200, // Set a fixed height for the image
                                child: Image.asset(
                                  'assets/images/team_members.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(
                                      0.5), // Adding a semi-transparent overlay
                                ),
                              ),
                              Positioned(
                                top: 20,
                                left: 20,
                                right: 20,
                                child: Column(
                                  children: [
                                    // Heading
                                    Text(
                                      'Meet Our Team',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    // Description
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        'We are proud to introduce our team of highly skilled professionals who are dedicated to providing the best services to the field of Dentistry. Our team members are passionate, experienced, and committed to excellence.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Divider(
                            color: Color.fromARGB(255, 137, 224, 250),
                            thickness: 2,
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              '"We warmly invite you to join our team of dedicated professionals. Become a part of our dynamic group and help us continue to excel. We look forward to welcoming you as a valued team member. Feel free to message us anytime, 24/7."',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blueGrey),
                              textAlign: TextAlign
                                  .center, // Set the text alignment here
                            ),
                          ),
                          SizedBox(height: 10),
                          Divider(
                            color: Color.fromARGB(255, 137, 224, 250),
                            thickness: 2,
                          ),
                          SizedBox(height: 20),

                          if (myProfile != null)
                            Card(
                              margin: EdgeInsets.all(10),
                              color: Color.fromARGB(255, 0, 61, 104),
                              child: Column(
                                children: [
                                  // Full-width Image at the top
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .white, // White-filled border
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: AspectRatio(
                                            aspectRatio: 1.0,
                                            child: Container(),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                4.0), // Adjust padding for border thickness
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    6), // Adjust radius to match border
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      myProfile!['picture'] ??
                                                          ''),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 10),
                                  // Name
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            myProfile!['full_name'] ?? '',
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Gmail address
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 5.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            myProfile!['gmail_id'] ?? '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  // Position with bullets
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: (myProfile!['positions'] ?? '')
                                          .split('\n')
                                          .map<Widget>(
                                            (position) => Row(
                                              children: [
                                                Text(
                                                  '• ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    position,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color.fromARGB(
                                                          255, 222, 222, 222),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  // Message
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Divider(
                                      color: Color.fromARGB(255, 137, 224, 250),
                                      thickness: 2,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            myProfile!['message'] ?? '',
                                            textAlign: TextAlign
                                                .justify, // Ensures text is justified
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromARGB(
                                                  255, 206, 206, 206),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Divider(
                                      color: Color.fromARGB(255, 137, 224, 250),
                                      thickness: 2,
                                    ),
                                  ),
                                  // Links
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, left: 8.0, bottom: 10.0),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          if (myProfile!['facebook_id'] !=
                                                  null &&
                                              myProfile!['facebook_id']!
                                                  .isNotEmpty)
                                            IconButton(
                                              icon: Icon(Icons.facebook,
                                                  color: Colors.blue),
                                              onPressed: () {
                                                _launchUrl(
                                                    myProfile!['facebook_id']);
                                              },
                                            ),
                                          if (myProfile!['whatsapp_id'] !=
                                                  null &&
                                              myProfile!['whatsapp_id']!
                                                  .isNotEmpty)
                                            IconButton(
                                              icon: FaIcon(
                                                  FontAwesomeIcons.whatsapp,
                                                  color: Colors.green),
                                              onPressed: () {
                                                _launchUrl(
                                                    myProfile!['whatsapp_id']);
                                              },
                                            ),
                                          if (myProfile!['instagram_id'] !=
                                                  null &&
                                              myProfile!['instagram_id']!
                                                  .isNotEmpty)
                                            IconButton(
                                              icon: FaIcon(
                                                  FontAwesomeIcons.instagram,
                                                  color: Colors.purple),
                                              onPressed: () {
                                                _launchUrl(
                                                    myProfile!['instagram_id']);
                                              },
                                            ),
                                          if (myProfile!['youtube_id'] !=
                                                  null &&
                                              myProfile!['youtube_id']!
                                                  .isNotEmpty)
                                            IconButton(
                                              icon: FaIcon(
                                                  FontAwesomeIcons.youtube,
                                                  color: Colors.red),
                                              onPressed: () {
                                                _launchUrl(
                                                    myProfile!['youtube_id']);
                                              },
                                            ),
                                          if (myProfile!['twitter_id'] !=
                                                  null &&
                                              myProfile!['twitter_id']!
                                                  .isNotEmpty)
                                            IconButton(
                                              icon: FaIcon(
                                                  FontAwesomeIcons.twitter,
                                                  color: Colors.lightBlue),
                                              onPressed: () {
                                                _launchUrl(
                                                    myProfile!['twitter_id']);
                                              },
                                            ),
                                          if (myProfile!['whatsapp_other_id'] !=
                                                  null &&
                                              myProfile!['whatsapp_other_id']!
                                                  .isNotEmpty)
                                            IconButton(
                                              icon: FaIcon(
                                                  FontAwesomeIcons.whatsapp,
                                                  color: Colors.green),
                                              onPressed: () {
                                                _launchUrl(myProfile![
                                                    'whatsapp_other_id']);
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Team members list
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: teamMembers.length,
                            itemBuilder: (context, index) {
                              final teamMember = teamMembers[index];
                              bool isEven = index % 2 == 0;

                              return Card(
                                margin: EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: isEven
                                            ? [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        teamMember[
                                                                'full_name'] ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        teamMember['status'] ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        teamMember[
                                                                'position'] ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                          'Membership valid from: ${teamMember['date_from'] ?? ''}'),
                                                      Text(
                                                          'Membership valid upTo: ${teamMember['date_to'] ?? 'Present'}'),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                CircleAvatar(
                                                  radius: 60,
                                                  backgroundImage: NetworkImage(
                                                      teamMember['picture'] ??
                                                          ''),
                                                ),
                                              ]
                                            : [
                                                CircleAvatar(
                                                  radius: 60,
                                                  backgroundImage: NetworkImage(
                                                      teamMember['picture'] ??
                                                          ''),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        teamMember[
                                                                'full_name'] ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        teamMember['status'] ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        teamMember[
                                                                'position'] ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                          'Membership valid from: ${teamMember['date_from'] ?? ''}'),
                                                      Text(
                                                          'Membership valid upto: ${teamMember['date_to'] ?? 'Present'}'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}

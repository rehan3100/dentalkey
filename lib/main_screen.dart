import 'package:flutter/material.dart';
import 'package:dental_key/dental_portal/authentication/login_dental.dart';
import 'splash_screen.dart'; // Import your SplashScreen

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double fem = 0;
  double ffem = 0;

  // Booleans to track whether each image is clicked
  bool isDentistPortalClicked = false;
  bool isDentalDoctorClicked = false;
  bool isPatientPortalClicked = false;
  bool isPatientPatientClicked = false;

  // Function to handle click events for group 1
  void handleGroup1Click() {
    setState(() {
      isDentistPortalClicked = !isDentistPortalClicked;
      if (isDentistPortalClicked) {
        isDentalDoctorClicked = true;
        // Deactivate group 2
        isPatientPortalClicked = false;
        isPatientPatientClicked = false;
      }
    });
  }

  // Function to handle click events for group 2
  void handleGroup2Click() {
    setState(() {
      isPatientPortalClicked = !isPatientPortalClicked;
      if (isPatientPortalClicked) {
        isPatientPatientClicked = true;
        // Deactivate group 1
        isDentistPortalClicked = false;
        isDentalDoctorClicked = false;
      }
    });
  }

  Future<bool> _onWillPop() async {
    // Navigate to SplashScreen on back press
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    fem = MediaQuery.of(context).size.width / 429;
    ffem = fem * 0.97;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  13.94 * fem, // left padding
                  100 * fem, // top padding
                  13.94 * fem, // right padding
                  20 * fem), // bottom padding (adjust as needed)
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 52 * fem),
                    width: 220.51 * fem,
                    height: 200 * fem,
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    'CHOOSE AN OPTION',
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontFamily: 'Inter',
                      fontSize: 16 * ffem,
                      fontWeight: FontWeight.bold,
                      height: 3.0 * ffem / fem,
                      letterSpacing: -0.24 * fem,
                    ),
                  ),
                  SizedBox(height: 30 * fem),
                  Container(
                    width: double.infinity,
                    height: 300 * fem, // Adjust height as needed
                    child: Stack(
                      children: [
                        Positioned(
                          left: 70 * fem, // Adjust left position of the first image
                          top: 0,
                          child: GestureDetector(
                            onTap: handleGroup1Click,
                            child: Image.asset(
                              'assets/images/dentists_portal_unclicked.png',
                              width: 150 * fem, // Adjust width as needed
                              height: 150 * fem, // Adjust height as needed
                            ),
                          ),
                        ),
                        Positioned(
                          left: -20 * fem, // Adjust left position of the second image
                          top: 20,
                          child: GestureDetector(
                            onTap: handleGroup1Click,
                            child: Image.asset(
                              'assets/images/dentalportaldoctor.png',
                              width: 150 * fem, // Adjust width as needed
                              height: 200 * fem, // Adjust height as needed
                            ),
                          ),
                        ),
                        Positioned(
                          left: 200 * fem, // Adjust left position of the third image
                          top: 0,
                          child: GestureDetector(
                            onTap: handleGroup2Click,
                            child: Image.asset(
                              'assets/images/patient_portal.png',
                              width: 150 * fem, // Adjust width as needed
                              height: 150 * fem, // Adjust height as needed
                            ),
                          ),
                        ),
                        Positioned(
                          left: 280 * fem, // Adjust left position of the fourth image
                          top: 20,
                          child: GestureDetector(
                            onTap: handleGroup2Click,
                            child: Image.asset(
                              'assets/images/patientportalpatient.png',
                              width: 150 * fem, // Adjust width as needed
                              height: 200 * fem, // Adjust height as needed
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0 * fem),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isDentistPortalClicked && isDentalDoctorClicked)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginDental(),
                        ),
                      );
                    },
                    child: Text('Continue to Login'),
                  ),
                if (isPatientPortalClicked && isPatientPatientClicked)
                  ElevatedButton(
                    onPressed: null, // Disable the button
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Set the button's background color to grey
                    ),
                    child: Text('Not available for now'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

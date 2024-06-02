import 'package:dental_key/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import services to use SystemNavigator.pop

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Calculate the factor for responsiveness
    final double fem = MediaQuery.of(context).size.width / 429;

    // Define colors
    final Color whiteColor = Colors.white;
    final Color blackColor = Color.fromRGBO(0, 0, 0, 1);

    return WillPopScope(
      onWillPop: () async {
        // Exit the app when back button is pressed
        SystemNavigator.pop();
        return Future.value(false); // Return false to prevent further handling
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Center(
          child: SingleChildScrollView(
            // Wrap Column with SingleChildScrollView
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Container(
                  margin: EdgeInsets.only(
                      bottom: 40 *
                          fem), // Increase bottom margin to bring texts closer
                  width: 300 * fem, // Decrease width of logo
                  height: 600 * fem, // Maintain height
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                // Text "founded by"
                Text(
                  'founded by',
                  style: TextStyle(
                    color: blackColor,
                    fontFamily: 'Inter',
                    fontSize: 18 * fem,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 10 * fem), // Add space between lines of text
                // Text "DR. MUHAMMAD REHAN" (bold)
                Text(
                  'DR. MUHAMMAD REHAN',
                  style: TextStyle(
                    color: blackColor,
                    fontFamily: 'Inter',
                    fontSize: 20 * fem,
                    fontWeight: FontWeight.bold, // Make text bold
                  ),
                ),
                // Spacer(), // Remove Spacer
                SizedBox(height: 20 * fem), // Add space before button
                // Button
                Container(
                  margin: EdgeInsets.only(
                      bottom: 40 *
                          fem), // Decrease bottom margin to align button closer to the bottom
                  width: 380 * fem, // Decrease width of button
                  height: 55 * fem,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MainScreen()), // Navigate to mainscreen widget
                      );
                    },
                    child: Center(
                      child: Text(
                        'GET STARTED',
                        style: TextStyle(
                          fontSize: 16 * fem,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

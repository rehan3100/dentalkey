import 'dart:convert';
import 'package:dental_key/dental_portal/authentication/dental_device_change.dart';
import 'package:dental_key/dental_portal/mainscreen/dentalportal_main.dart';
import 'package:dental_key/main_screen.dart';
import 'package:dental_key/passwordforgotten_dental.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dental_key/dental_portal/authentication/signup_dental.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'secure_overlay.dart';

class LoginDental extends StatefulWidget {
  @override
  _LoginDentalState createState() => _LoginDentalState();
}

class _LoginDentalState extends State<LoginDental> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _enableScreenshotRestriction(); // Add this line
  }

  Future<void> _enableScreenshotRestriction() async {
    await SecureOverlay.enableSecureScreen();
  }

  Future<void> _disableScreenshotRestriction() async {
    await SecureOverlay.disableSecureScreen();
  }


  
  Future<void> _enableScreenshotRestriction() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  @override
  void dispose() {
    _disableScreenshotRestriction(); // Add this line

    super.dispose();
  }

  Future<void> _disableScreenshotRestriction() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  static const platform =
      MethodChannel('com.dentalkeybyrehan.dentalkeynew/device_id');

  Future<Map<String, String?>> _getDeviceIdentifiers() async {
    String? androidId;
    String? advertisingId;

    try {
      if (Platform.isAndroid) {
        androidId = await platform.invokeMethod('getAndroidId');
        advertisingId = await platform.invokeMethod('getAdvertisingId');
      } else if (Platform.isIOS) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        androidId = iosInfo.identifierForVendor;
        // You can get IDFV or IDFA for iOS
        advertisingId =
            iosInfo.identifierForVendor; // Alternatively use a package for IDFA
      }
    } on PlatformException catch (e) {
      print('Failed to get device identifiers: ${e.message}');
    }

    return {
      'androidId': androidId,
      'advertisingId': advertisingId,
    };
  }

  Future<void> _handleLogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, String?> deviceIdentifiers = await _getDeviceIdentifiers();
      String? deviceIdentifier = deviceIdentifiers['androidId'];
      String? advertisingId = deviceIdentifiers['advertisingId'];

      if (deviceIdentifier == null) {
        throw Exception('Failed to get device identifier');
      }
      print('Device Identifier (Android ID): $deviceIdentifier');
      print('Advertising ID: $advertisingId');

      final response = await http.post(
        Uri.parse('https://dental-key-738b90a4d87a.herokuapp.com/users/login/'),
        body: {
          'email': email,
          'password': password,
          'device_identifier': deviceIdentifier,
          'advertising_id': advertisingId,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String accessToken = responseData['access'];
        String refreshToken = responseData['refresh'];

        // Store the tokens securely using shared_preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);

        // Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DentalPortalMain(
              accessToken: accessToken,
            ),
          ),
        );
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String errorMessage =
            responseData['error'] ?? 'An error occurred. Please try again.';

        print('Error Message: $errorMessage');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Failed'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Exception: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              ),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse(
            'https://dental-key-738b90a4d87a.herokuapp.com/api/token/refresh/'),
        body: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String newAccessToken = responseData['access'];

        // Store the new access token
        await prefs.setString('accessToken', newAccessToken);
      } else {
        // Handle token refresh error
        await prefs.remove('accessToken');
        await prefs.remove('refreshToken');
        // Redirect to login screen
      }
    } else {
      // Handle missing refresh token case
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double fem = 1.0; // Placeholder value for fem
    double ffem = 1.0; // Placeholder value for ffem
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.fromLTRB(0 * fem, 6 * fem, 0 * fem, 0 * fem),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff5a5a5a)),
                    color: Color(0xff385a92),
                    borderRadius: BorderRadius.circular(45 * fem),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: Color(0xff385a92),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 20 * fem, 0 * fem, 5),
                              width: 150 * fem,
                              height: 200 * fem,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15 * fem),
                                child: Image.asset(
                                  'assets/images/dentalportalclicked.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 0),
                        color: Color.fromARGB(255, 255, 255, 255),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 20 * fem, 0 * fem, 0 * fem),
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 30 * ffem,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2125 * ffem / fem,
                                  letterSpacing: -0.45 * fem,
                                  color: Color(0xff385a92),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  20 * fem, 0 * fem, 20 * fem, 20 * fem),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email Address',
                                      labelStyle:
                                          TextStyle(color: Color(0xff385a92)),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                          color: Color(0xff385a92),
                                          width: 2.0,
                                        ),
                                      ),
                                      prefixIcon: Icon(Icons.email,
                                          color: Color(0xff385a92)),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email address';
                                      } else if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  TextFormField(
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle:
                                          TextStyle(color: Color(0xff385a92)),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                          color: Color(0xff385a92),
                                          width: 2.0,
                                        ),
                                      ),
                                      prefixIcon: Icon(Icons.lock,
                                          color: Color(0xff385a92)),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Color(0xff385a92),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    obscureText: !_passwordVisible,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 40.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MouseRegion(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DentalSignup()),
                                            );
                                          },
                                          child: Text(
                                            'No Account? Signup Now',
                                            style: TextStyle(
                                              color: Color(0xFF385A92),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      MouseRegion(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DentalPasswordForgot()),
                                            );
                                          },
                                          child: Text(
                                            'Forgotten Password?',
                                            style: TextStyle(
                                              color: Color(0xFF385A92),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
            Padding(
              padding: EdgeInsets.all(16.0 * fem),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Text(
                            'Login Now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_isLoading)
                            const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DentalDeviceChange()),
                        );
                      },
                      child: const Text(
                        'Request Change In Device',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

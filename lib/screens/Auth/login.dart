import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trustdine_kds/backend/central_api.dart';
import 'package:trustdine_kds/components/CustomTextField.dart';
import 'package:trustdine_kds/components/LargeCustomButton.dart';
import 'package:trustdine_kds/main.dart';
import 'package:trustdine_kds/storage/cache.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoggingIn = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter both email and password.");
      return;
    }

    setState(() {
      _isLoggingIn = true;
    });

    try {
      Map<String, dynamic> userData =
          await loginUser(_emailController.text, _passwordController.text);
      String token = userData['authtoken'];
      await SecureStorageManager.saveCredentials(token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    } catch (e) {
      print(e);
      setState(() {
        _isLoggingIn = false;
      });
      Fluttertoast.showToast(
          msg: "Wrong Credentials! Contact us: trustdine.com");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double logoWidth = screenWidth / 2.6;
    if (screenWidth > screenHeight) {
      logoWidth = screenHeight / 3;
    }
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/ui/login_img.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight / 3,
                ),
                Image.asset(
                  'assets/ui/trustdine_logo_white.png',
                  width: logoWidth,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Login to Your App",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 38.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 44.0,
                ),
                CustomTextField(
                    controller: _emailController,
                    hintText: "Email Address",
                    prefixIcon: Icons.mail,
                    obscureText: false),
                const SizedBox(
                  height: 10.0,
                ),
                CustomTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    prefixIcon: Icons.security,
                    obscureText: true),
                const SizedBox(
                  height: 32.0,
                ),
                _isLoggingIn
                    ? const Center(
                        child: CircularProgressIndicator(
                          semanticsLabel: "Logging You In",
                          backgroundColor: Colors.grey,
                          color: Color.fromARGB(255, 255, 255, 255),
                          semanticsValue: AutofillHints.countryName,
                        ),
                      )
                    : Center(
                        child: LargeCustomButton(
                          yourText: "Login",
                          onPressedFunction: _handleLogin,
                          buttonColor: Color.fromARGB(255, 252, 128, 25),
                          textColor: Colors.white,
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

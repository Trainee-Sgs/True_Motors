import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:true_motors/app_drawer_module/home_screen.dart';
import 'package:true_motors/login_module/login_screen.dart';
import 'package:true_motors/login_module/onboard.dart';

class SplashScreen extends StatefulWidget {
  final bool fromLogout;
  const SplashScreen({super.key, this.fromLogout = false});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 3000), () async {
      if (!mounted) return;

      Widget nextScreen;
      if (widget.fromLogout) {
        nextScreen = const LoginScreen();
      } else {
        final prefs = await SharedPreferences.getInstance();
        // Check if 'token' exists to determine if user is persistently logged in
        if (prefs.getString('token') != null) {
          nextScreen = const HomeScreen();
        } else {
          nextScreen = const OnboardScreen();
        }
      }

      if (!mounted) return;

      Navigator.pushReplacement(context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => nextScreen,
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          }
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Image.asset('assets/login_image/true_motors_logo.png',
              width: width * 0.85,
              height: height * 0.1,
              fit: BoxFit.contain,
            ),
          ),
        ],
      )
    );
  }
}

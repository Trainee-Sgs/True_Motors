import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AndroidLargeScreen extends StatelessWidget {
  const AndroidLargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scale = screenWidth / 360.0;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor:Color(0xFFFFFCFC),
        body: Column(
          children: [

            // ── Status Bar ────────────────────────────────────────────────
            Container(
              width: double.infinity,
              height: statusBarHeight, color: Colors.transparent,
            ),

            // ── Full Page Content — centered ──────────────────────────────
            Expanded(
              child: Stack(
                children: [

                  // ── GIF / Success Animation — top area ───────────────
                  Positioned(
                    top: 135 * scale,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox(
                        width: 328 * scale,
                        height: 238 * scale,
                        child: Image.asset(
                          'assets/rental_screen/tick.gif',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) {
                            // Fallback — animated check circle
                            return Center(
                              child: Container(
                                width: 100 * scale,
                                height: 100 * scale,
                                decoration:BoxDecoration(
                                  color: Color(0xFF005F65),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 56 * scale,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // ── Payment Successful text ───────────────────────────
                  Positioned(
                    top: 380 * scale,
                    left: 0,
                    right: 0,
                    child: Column(
                      children:[
                        Text(
                          'Payment Successful!',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Color(0xFF000000),
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 25),

                        Text(
                          'You Car Successfully Booked',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xFF000000),
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // ── Back to Home Button ───────────────────────────────
                  Positioned(
                    top: 580 * scale,
                    left: 30 * scale,
                    right: 30 * scale,
                    child: SizedBox(
                      width: 300 * scale,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          // Pop all routes back to first screen
                          Navigator.of(context).popUntil(
                              (route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Color(0xFF005F65),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child:Text(
                          'Back to Home',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
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
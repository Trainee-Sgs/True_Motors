import 'package:flutter/material.dart';
import 'package:true_motors/login_module/login_screen.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final primaryColor = const Color(0xFF005F65);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // PageView (occupies full screen)
          PageView(
            controller: _controller,
            onPageChanged: (value) {
              setState(() {
                currentPage = value;
              });
            },
            children: [
              _buildFirstPage(width, height, primaryColor),
              _buildSecondPage(width, height, primaryColor),
            ],
          ),

          // Skip Button (Top Right)
          if (currentPage == 0)
            Positioned(
              top: MediaQuery.of(context).padding.top,
              right: width * 0.06,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Skip',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: primaryColor),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 14, color: primaryColor)
                  ],
                ),
              ),
            ),

          // Bottom Controls (Page Indicator + Swipe Button)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page Indicators
                  if (currentPage == 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(2, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: currentPage == index ? 30 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: currentPage == index ? primaryColor : const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(10)),
                        );
                      }),
                    ),

                  SizedBox(height: height * 0.00),

                  // Swipe >> or Swipe to start
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                    child: SizedBox(
                      width: double.infinity,
                      height: height * 0.065,
                      child: currentPage == 0
                          ? Center(
                              child: InkWell(
                                onTap: () {
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Swipe',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 20,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Icon(Icons.keyboard_double_arrow_right, color: primaryColor, size: 28),
                                  ],
                                ),
                              ),
                            )
                          : SwipeToStartButton(
                              primaryColor: primaryColor,
                              buttonHeight: height * 0.065,
                              onSwipeRight: () {
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                              },
                            ),
                    ),
                  ),
                  SizedBox(height: height * 0.03)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFirstPage(double width, double height, Color primaryColor) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + height * 0.03,
        bottom: height * 0.12,
      ),
      child: Column(
        children: [
          // Logo
          Image.asset(
            'assets/login_image/true_motors_logo.png',
            height: height * 0.08,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Text("TRUE MOTORS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF005F65))),
          ),
          SizedBox(height: height * 0.015),
          
          // Title
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins', height: 1.3),
              children: [
                const TextSpan(text: 'All Your Vehicle Needs,\n', style: TextStyle(color: Color(0xFF0A1931))),
                const TextSpan(text: 'All in One ', style: TextStyle(color: Color(0xFF1E3A8A))),
                TextSpan(text: 'Place', style: TextStyle(color: primaryColor)),
              ],
            ),
          ),
          SizedBox(height: height * 0.02),

          // Central Graphic Area
          SizedBox(
            height: width,
            width: width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Gradient Ring
                Container(
                  width: width * 0.8,
                  height: width * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        const Color(0xFF4C66C3),
                        const Color(0xFFC77B63),
                        const Color(0xFF4CAF50),
                        const Color(0xFF1E3A8A),
                        const Color(0xFF4C66C3),
                      ],
                    )
                  ),
                  child: Center(
                    child: Container(
                      width: width * 0.8 - 16,
                      height: width * 0.8 - 16,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                // Central Car Image (now perfectly centered inside the circle)
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/onboarding_image/onboard_main.png',
                    width: width * 0.75,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.directions_car, size: 100, color: primaryColor),
                  ),
                ),

                // Floating Cards perfectly placed on the ring
                Align(
                  alignment: const Alignment(0, -1.08),
                  child: _buildFloatingCard('Buy', 'assets/onboarding_image/onboard_buy.png', Colors.green, width),
                ),
                Align(
                  alignment: const Alignment(-1.05, -0.32),
                  child: _buildFloatingCard('Sell', 'assets/onboarding_image/onboard_sell.png', const Color(0xFF1E3A8A), width),
                ),
                Align(
                  alignment: const Alignment(1.05, -0.32),
                  child: _buildFloatingCard('Compare', '', const Color(0xFF1E3A8A), width),
                ),
                Align(
                  alignment: const Alignment(-0.68, 0.85),
                  child: _buildFloatingCard('Lease', 'assets/home_image/lease.png', Colors.orange, width),
                ),
                Align(
                  alignment: const Alignment(0.68, 0.85),
                  child: _buildFloatingCard('Rent','assets/home_image/rent.png', Colors.teal, width),
                ),
              ],
            ),
          ),

          SizedBox(height: height * 0.02),

          // Bottom Features
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureImage('assets/onboarding_image/verified 1.png', 'Verified Listings', '100% Trusted'),
                _buildFeatureImage('assets/onboarding_image/badge 1.png', 'Best Deals', 'Every Day'),
                _buildFeatureImage('assets/onboarding_image/online-support 1.png', '24/7 Support', "We're Here"),
              ],
            ),
          ),
          
          SizedBox(height: height * 0.02),
        ],
      ),
    );
  }



  Widget _buildFloatingCard(String title, String imagePath, Color titleColor, double width) {
    return Container(
      width: width * 0.24,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          title == 'Compare'
              ? SizedBox(
                  width: 56,
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        right: -4,
                        top: 2,
                        child: Image.asset('assets/onboarding_image/compare_2.png', width: 34, fit: BoxFit.contain, errorBuilder: (c,e,s) => const SizedBox()),
                      ),
                      Positioned(
                        left: -2,
                        bottom: 0,
                        child: Image.asset('assets/onboarding_image/compare_1.png', width: 40, fit: BoxFit.contain, errorBuilder: (c,e,s) => Icon(Icons.directions_car, color: titleColor, size: 28)),
                      ),
                    ],
                  ),
                )
              : Image.asset(imagePath, width: 48, height: 48, fit: BoxFit.contain, errorBuilder: (c,e,s) => Icon(Icons.image, color: titleColor, size: 48)),
          const SizedBox(height: 6),
          Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, fontFamily: 'Poppins', color: titleColor)),
        ],
      ),
    );
  }

  Widget _buildFeatureImage(String imagePath, String title, String subtitle) {
    return Column(
      children: [
        Image.asset(
          imagePath,
          width: 44,
          height: 44,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 40),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 12, fontFamily: 'Poppins', color: Colors.black, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(subtitle, style: const TextStyle(fontSize: 11, fontFamily: 'Poppins', color: Colors.black87)),
      ],
    );
  }

  Widget _buildSecondPage(double width, double height, Color primaryColor) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Column(
          children: [
            // Main Image (Dealership)
            Image.asset(
              'assets/onboarding_image/onboard_2.jpg',
              width: width,
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.store, size: 100, color: primaryColor),
            ),
          SizedBox(height: height * 0.02),

          // Cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: Column(
              children: [
                _buildInfoCard(
                  icon: Icons.search,
                  iconColor: const Color(0xFF0D6EFD), // Blue
                  title: 'Find Verified Dealers',
                  subtitle: 'Connect with trusted dealers\nnear you.',
                ),
                const SizedBox(height: 8),
                _buildInfoCard(
                  icon: Icons.verified_user_outlined,
                  iconColor: const Color(0xFF00BFA5), // Teal/Green
                  title: 'Verified & Reliable',
                  subtitle: 'All dealers are verified for your\nsafety and confidence.',
                ),
                const SizedBox(height: 8),
                _buildInfoCard(
                  icon: Icons.group,
                  iconColor: const Color(0xFF6610F2), // Purple
                  title: 'Better Deals, Better Choice',
                  subtitle: 'Compare offers and choose\nthe best for you.',
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.02),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required Color iconColor, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontFamily: 'Poppins',
                    height: 1.3,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SwipeToStartButton extends StatefulWidget {
  final VoidCallback onSwipeRight;
  final Color primaryColor;
  final double buttonHeight;

  const SwipeToStartButton({
    Key? key,
    required this.onSwipeRight,
    required this.primaryColor,
    required this.buttonHeight,
  }) : super(key: key);

  @override
  _SwipeToStartButtonState createState() => _SwipeToStartButtonState();
}

class _SwipeToStartButtonState extends State<SwipeToStartButton> {
  double _dragPosition = 0.0;
  bool _isSwiped = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxDrag = constraints.maxWidth - widget.buttonHeight;
        return Container(
          height: widget.buttonHeight,
          decoration: BoxDecoration(
            color: widget.primaryColor,
            borderRadius: BorderRadius.circular(widget.buttonHeight / 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Text(
                'Swipe to start',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Positioned(
                left: _dragPosition + 6,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (!_isSwiped) {
                      setState(() {
                        _dragPosition += details.delta.dx;
                        if (_dragPosition < 0) _dragPosition = 0;
                        if (_dragPosition > maxDrag) {
                          _dragPosition = maxDrag;
                          _isSwiped = true;
                          widget.onSwipeRight();
                        }
                      });
                    }
                  },
                  onHorizontalDragEnd: (details) {
                    if (!_isSwiped) {
                      setState(() {
                        _dragPosition = 0.0;
                      });
                    }
                  },
                  child: Container(
                    width: widget.buttonHeight - 12,
                    height: widget.buttonHeight - 12,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.keyboard_double_arrow_right, color: widget.primaryColor),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
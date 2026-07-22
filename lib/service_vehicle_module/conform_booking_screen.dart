import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:true_motors/service_vehicle_module/booking_summery_screen.dart';

class ConformBookingScreen extends StatefulWidget {
  final String vehicleName;
  final int? vehicleId;
  final String servicesSelected;
  final String pickupAddress;
  final String specialInstructions;

  const ConformBookingScreen({
    super.key,
    required this.vehicleName,
    this.vehicleId,
    required this.servicesSelected,
    required this.pickupAddress,
    required this.specialInstructions,
  });

  @override
  State<ConformBookingScreen> createState() => _ConformBookingScreenState();
}

class _ConformBookingScreenState extends State<ConformBookingScreen> {

  int currentVehicleIndex = 0;
  Timer? vehicleTimer;

  final List<String> vehicleSlides = [
    'assets/vehicle_service/Bike.png',
    'assets/vehicle_service/Car.png',
    'assets/vehicle_service/Commercial Vehicle.png',
    'assets/vehicle_service/Tractor.png',
  ];

  final List<String> faqList = [
    'How long does it take to service vehicle?',
    'How long does it take to service vehicle?',
    'How long does it take to service vehicle?',
    'How long does it take to service vehicle?',
  ];

  String get vehicleName => widget.vehicleName;
  String get servicesSelected => widget.servicesSelected;
  String get pickupAddress => widget.pickupAddress.isEmpty ? 'Not Provided' : widget.pickupAddress;
  String get scheduledTime => 'Aug 3, 2025 | 10:00 AM'; // Can be updated if date picker added
  String get specialInstructions => widget.specialInstructions.isEmpty ? 'None' : widget.specialInstructions;

  @override
  void initState() {
    super.initState();
    startVehicleTimer();
  }

  void startVehicleTimer() {
    vehicleTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {
        currentVehicleIndex = (currentVehicleIndex + 1) % vehicleSlides.length;
      });
    });
  }

  @override
  void dispose() {
    vehicleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width * 0.055;
    final scale = width / 360.0;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: statusBarHeight, color: Colors.transparent,
            ),

            Container(
              width: double.infinity,
              height: 60,
              color: const Color(0xFFFFFFFF),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back,
                      color: Color(0xFF01422D),
                    ),
                  ),
                  SizedBox(width: width * 0.04),
                  const Text('Conform Booking',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Color(0xFF01422D),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 173 * scale,
                      child: Image.asset(
                        'assets/confirm_booking/Booking.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFF2F2F2),
                          child: const Center(
                            child: Icon(Icons.car_repair,
                                color: Color(0xFF1B6B5A), size: 48),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.025),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Conform Service Booking',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF000000),
                              ),
                            ),

                            SizedBox(height: height * 0.001),

                            buildDetailRow(
                                '🚗', 'Vehicle', vehicleName),
                            buildDetailRow(
                                '🔧', 'Services Selected', servicesSelected),
                            buildDetailRow(
                                '📍', 'Pickup', pickupAddress),
                            buildDetailRow(
                                '📅', 'Scheduled', scheduledTime),

                            SizedBox(height: height * 0.001),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xFF000000),
                                  height: 2,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Special Instructions : ',
                                  ),
                                  TextSpan(
                                    text: 'Kindly call before arriving.',
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: height * 0.02),

                            Row(
                              children: [
                                Expanded(
                                  flex: 165,
                                  child: SizedBox(
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (_, animation, __) =>
                                                const BookingSummeryScreen(),
                                            transitionsBuilder:
                                                (_, animation, __, child) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                            transitionDuration: const Duration(
                                                milliseconds: 300),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF005F65),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Conform Booking',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: width * 0.03),

                                Expanded(
                                  flex: 120,
                                  child: SizedBox(
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF005F65),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Icons.edit_outlined,
                                              color: Colors.white,
                                              size: 14),
                                          SizedBox(width: 4),
                                          Text('Edit',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Why Choose Us',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Our certified and trained technicians ensure that your vehicle gets the care it deserves. From routine servicing to complex repairs, your car is in safe hands.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Color(0xFF000000),
                              ),
                            ),

                            SizedBox(height: height * 0.01),
                            buildWhyItem('Expert Technicians:',
                                'Certified professionals for every service.'),
                            buildWhyItem('Genuine Parts:',
                                'Guaranteed quality and reliability.'),
                            buildWhyItem('Transparent Pricing:',
                                'No hidden charges, upfront estimates.'),
                            buildWhyItem('Convenience:',
                                'Home pickup & drop for hassle-free servicing.'),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.02),
                    Padding(
                      padding: EdgeInsets.only(
                          left: horizontalPadding, bottom: 8),
                      child: const Text(
                        'Popular Service Vehicles:',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: ClipRRect(
                          key: ValueKey(currentVehicleIndex),
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            vehicleSlides[currentVehicleIndex],
                            width: double.infinity,
                            height: 150 * scale,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 150 * scale,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFBEBE),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),

                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
                              child: Text(
                                'Frequently Asked Questions',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Color(0xFF000000),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            ...List.generate(faqList.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${index + 1}. ${faqList[index]}',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xFF000000),
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/vehicle_service/Down Arrow.png',
                                      width: 24,
                                      height: 24,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 24,
                                        color: Color(0xFF555555),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                            const SizedBox(height: 2),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.04),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$emoji ',
            style: const TextStyle(
              fontSize: 14,
              height: 2.14,
            ),
          ),
          Expanded(
            child: Text(
              '$label : $value',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xFF000000),
                height: 2.14,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWhyItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              color: Color(0xFF000000),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF000000),
                    height: 1.5,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
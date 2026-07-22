import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'rental_booking_model.dart';
import 'rental_page_screen.dart';
import 'rental_page4_screen.dart';

class RentalPage3Screen extends StatefulWidget {
  final RentalBookingData bookingData;
  const RentalPage3Screen({super.key, required this.bookingData});

  @override
  State<RentalPage3Screen> createState() => _RentalPage3ScreenState();
}

class _RentalPage3ScreenState extends State<RentalPage3Screen> {
  final List<String> carImages = ['assets/rental_screen/Hyundai Creta.png', 'assets/rental_screen/Car2.png', 'assets/rental_screen/Car3.png'];
  int currentImageIndex = 0;
  Timer? imageTimer;
  final PageController imagePageController = PageController();

  final List<Map<String, String>> featureIcons = [
    {'image': 'assets/rental_screen/Petrol.png', 'label': 'Petrol'},
    {'image': 'assets/rental_screen/Manual.png', 'label': 'Manual'},
    {'image': 'assets/rental_screen/Seat.png', 'label': '5 Seats'},
  ];
  final List<String> featureChecks = ['Crusie Control', 'Android Auto', 'GPS system', 'Air Conditioning'];

  final List<Map<String, String>> priceRows = [
    {'label': 'Base Price', 'value': '₹ 2,150'},
    {'label': 'Delivery & pickup charge', 'value': '₹ 500'},
    {'label': 'Refundable security deposit', 'value': '₹ 1,000'},
    {'label': 'Total', 'value': '₹ 3,650'},
  ];

  @override
  void initState() {
    super.initState();
    startImageTimer();
  }

  void startImageTimer() {
    imageTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      final int nextIndex = (currentImageIndex + 1) % carImages.length;
      imagePageController.animateToPage(nextIndex, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      setState(() => currentImageIndex = nextIndex);
    });
  }

  @override
  void dispose() {
    imageTimer?.cancel();
    imagePageController.dispose();
    super.dispose();
  }

  void _goBackToEdit() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => RentalPageScreen(existingData: widget.bookingData),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
          (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double hp = screenWidth * 0.055;
    final double scale = screenWidth / 360.0;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: Column(
          children: [
            Container(width: double.infinity, height: statusBarHeight, color: Colors.transparent),
            Container(
              width: double.infinity, height: 56, color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: hp),
              child: Row(children: [
                GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Color(0xFF01422D))),
                const SizedBox(width: 15),
                const Text('Rental', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 18, color: Color(0xFF01422D))),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(hp, 12, hp, 8),
                        child: const Text('Rental Vehicle By Truemotors', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF000000)))),
                    SizedBox(
                      height: 147 * scale,
                      child: PageView.builder(
                        controller: imagePageController, itemCount: carImages.length,
                        onPageChanged: (index) => setState(() => currentImageIndex = index),
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: hp),
                          child: ClipRRect(borderRadius: BorderRadius.circular(10),
                              child: Image.asset(carImages[index], width: double.infinity, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE0E0E0), child: const Center(child: Icon(Icons.directions_car, size: 60, color: Colors.grey))))),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(carImages.length, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: currentImageIndex == i ? 20 : 8, height: 8,
                      decoration: BoxDecoration(color: currentImageIndex == i ? const Color(0xFF005F65) : const Color(0xFFBDBDBD), borderRadius: BorderRadius.circular(4)),
                    ))),
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          const Expanded(child: Text('Hyundai Creta', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF000000)))),
                          Image.asset('assets/rental_screen/Like.png', width: 24, height: 24, errorBuilder: (_, __, ___) => const Icon(Icons.favorite_border, size: 24, color: Color(0xFF666666))),
                          const SizedBox(width: 12),
                          Image.asset('assets/rental_screen/Share.png', width: 24, height: 24, errorBuilder: (_, __, ___) => const Icon(Icons.share_outlined, size: 24, color: Color(0xFF666666))),
                        ]),
                        const SizedBox(height: 6),
                        Row(children: [
                          Image.asset('assets/rental_screen/Location.png', width: 22, height: 22, errorBuilder: (_, __, ___) => const Icon(Icons.location_on, size: 22, color: Color(0xFF003399))),
                          const SizedBox(width: 4),
                          const Text('Coimbatore', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF003399))),
                          const Spacer(),
                          Image.asset('assets/rental_screen/Star.png', width: 24, height: 24, errorBuilder: (_, __, ___) => const Icon(Icons.star, size: 22, color: Colors.amber)),
                          const SizedBox(width: 4),
                          const Text('4.5/5', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF000000))),
                        ]),
                      ]),
                    ),
                    const SizedBox(height: 12),
                    // Features card
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      child: Container(
                        width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(14),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Features', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF000000))),
                          const SizedBox(height: 12),
                          Row(children: featureIcons.map((item) => Expanded(child: Row(children: [
                            Image.asset(item['image']!, width: 18, height: 18, errorBuilder: (_, __, ___) => const Icon(Icons.info_outline, size: 22, color: Color(0xFF555555))),
                            const SizedBox(width: 6),
                            Text(item['label']!, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF333333))),
                          ]))).toList()),
                          const SizedBox(height: 1),
                          GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), childAspectRatio: 5.5, mainAxisSpacing: 2, crossAxisSpacing: 4,
                            children: featureChecks.map((feature) => Row(children: [
                              Image.asset('assets/rental_screen/Tick.png', width: 22, height: 22, errorBuilder: (_, __, ___) => const Icon(Icons.check, size: 22, color: Color(0xFF005F65))),
                              const SizedBox(width: 6),
                              Expanded(child: Text(feature, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Color(0xFF333333)), overflow: TextOverflow.ellipsis)),
                            ])).toList(),
                          ),
                          const SizedBox(height: 14),
                          const Text('Description', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF000000))),
                          const SizedBox(height: 8),
                          const Text('Experience the perfect blend of style, space, and performance with the Hyundai Creta. Ideal for city rides and weekend getaways, this premium SUV offers a smooth drive, advanced safety features, and a commanding road presence.',
                              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xFF5B5B5B), height: 1.6), textAlign: TextAlign.justify, maxLines: 5, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 10),
                          Center(child: Container(width: 400, height: 1, color: const Color(0xFF8B8B8B))),
                          const SizedBox(height: 8),
                          const Text('Owner Info', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF000000))),
                          const SizedBox(height: 8),
                          Row(children: [
                            ClipOval(child: Image.asset('assets/rental_screen/Harish.png', width: 52, height: 52, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const CircleAvatar(radius: 26, backgroundColor: Color(0xFFE0E0E0), child: Icon(Icons.person, size: 30, color: Color(0xFF888888))))),
                            const SizedBox(width: 12),
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('Harish', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xFF000000))),
                              const SizedBox(height: 4),
                              Row(children: [
                                Image.asset('assets/rental_screen/Star.png', width: 24, height: 24, errorBuilder: (_, __, ___) => const Icon(Icons.star, size: 16, color: Colors.amber)),
                                const SizedBox(width: 4),
                                const Text('4.5/5  (180 Review)', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xFF000000))),
                              ]),
                              const SizedBox(height: 4),
                              const Text('Joined 8 Month Ago', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xFF000000))),
                            ]),
                          ]),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Booking summary with booking data + Edit
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFB5B4B4))),
                        padding: const EdgeInsets.all(14),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(child: Text('Car Name : ${widget.bookingData.carName}',
                                style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF000000)))),
                            GestureDetector(onTap: _goBackToEdit, child: Row(children: [
                              Image.asset('assets/rental_screen/Edit.png', width: 16, height: 16, errorBuilder: (_, __, ___) => const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF01422D))),
                              const SizedBox(width: 4),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                                const Text('Edit', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF01422D))),
                                Container(height: 1, width: 24, color: const Color(0xFF01422D)),
                              ]),
                            ])),
                          ]),
                          const SizedBox(height: 10),
                          Row(children: [
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('Pickup Date & Time', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF000000))),
                              const SizedBox(height: 2),
                              Text(widget.bookingData.pickupDate, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF3C3C3C))),
                            ])),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('Return Date & Time', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF000000))),
                              const SizedBox(height: 2),
                              Text(widget.bookingData.returnDate, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF3C3C3C))),
                            ])),
                          ]),
                          const SizedBox(height: 10),
                          const Text('Location', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF000000))),
                          const SizedBox(height: 2),
                          Text(widget.bookingData.location, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF3C3C3C))),
                          const SizedBox(height: 12),
                          ...priceRows.map((row) {
                            final bool isTotal = row['label'] == 'Total';
                            return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
                              Expanded(child: Text(row['label']!, style: TextStyle(fontFamily: 'Inter', fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400, fontSize: 14, color: const Color(0xFF000000)))),
                              Text(row['value']!, style: TextStyle(fontFamily: 'Inter', fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400, fontSize: 14, color: const Color(0xFF000000))),
                            ]));
                          }),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        width: 280 * scale, height: 40,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(context, PageRouteBuilder(
                            pageBuilder: (_, anim, __) => RentalPage4Screen(bookingData: widget.bookingData),
                            transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
                            transitionDuration: const Duration(milliseconds: 300),
                          )),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005F65), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0),
                          child: const Text('Proceed', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
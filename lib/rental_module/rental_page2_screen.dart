import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'rental_booking_model.dart';
import 'rental_page_screen.dart';
import 'rental_page3_screen.dart';

class RentalPage2Screen extends StatefulWidget {
  final RentalBookingData bookingData;
  const RentalPage2Screen({super.key, required this.bookingData});

  @override
  State<RentalPage2Screen> createState() => _RentalPage2ScreenState();
}

class _RentalPage2ScreenState extends State<RentalPage2Screen> {
  int currentCardIndex = 0;
  Timer? cardTimer;

  final List<Map<String, dynamic>> infoCards = [
    {'title': 'Well-Maintained Car', 'subtitle': 'Every car is inspected & maintained to perfection. Enjoy a worry-free ride.', 'image': 'assets/rental_screen/Well.png', 'color': const Color(0xFFD85656)},
    {'title': 'Secure Payments', 'subtitle': 'Pay safely with trusted gateways. Fast, encrypted & hassle-free transactions.', 'image': 'assets/rental_screen/Secure.png', 'color': const Color(0xFF005F65)},
    {'title': '24/7 Support', 'subtitle': 'Ride worry-free with our nonstop support team. We\'ve got your back, 24/7.', 'image': 'assets/rental_screen/Support.png', 'color': const Color(0xFF1A3A6B)},
  ];

  final List<String> filterChips = ['Filter', 'Body Type', 'Fuel Type', 'Transmission Types', 'Fuel Plan'];

  final List<Map<String, String>> howItWorks = [
    {'step': '1', 'text': 'Choose Vehicle: Browse available cars & bikes.'},
    {'step': '2', 'text': 'Select Duration: Pick your rental period.'},
    {'step': '3', 'text': 'Book & Pay: Confirm your booking securely.'},
    {'step': '4', 'text': 'Pickup/Delivery: Get your vehicle at your doorstep or pick it up at our hub.'},
  ];

  // Only ONE car in the list per requirement
  final List<Map<String, String>> carList = [
    {'image': 'assets/rental_screen/Hyundai Creta.png', 'name': 'Hyundai Creta', 'price': '1,400/Day', 'rating': '4.5/5', 'location': 'Coimbatore'},
  ];

  @override
  void initState() {
    super.initState();
    startCardTimer();
  }

  void startCardTimer() {
    cardTimer = Timer.periodic(const Duration(milliseconds: 3000), (_) {
      setState(() => currentCardIndex = (currentCardIndex + 1) % infoCards.length);
    });
  }

  @override
  void dispose() {
    cardTimer?.cancel();
    super.dispose();
  }

  // Go back to RentalPageScreen pre-filled with current data for editing
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
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          children: [
            Container(width: double.infinity, height: statusBarHeight, color: Colors.transparent),
            Container(
              width: double.infinity, color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      child: const Text('Rental Vehicle By Truemotors',
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF000000))),
                    ),
                    const SizedBox(height: 10),

                    // ── Booking Summary (from RentalPageScreen data) ──────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFB5B4B4)),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text('Car Name : ${widget.bookingData.carName}',
                                      style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF000000))),
                                ),
                                GestureDetector(
                                  onTap: _goBackToEdit,
                                  child: Row(children: [
                                    Image.asset('assets/rental_screen/Edit.png', width: 14, height: 14,
                                        errorBuilder: (_, __, ___) => const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF005F65))),
                                    const SizedBox(width: 4),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('Edit', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF01422D))),
                                        Container(height: 1, width: 24, color: const Color(0xFF01422D)),
                                      ],
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    const Text('Pickup Date & Time', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF000000))),
                                    const SizedBox(height: 2),
                                    Text(widget.bookingData.pickupDate, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF3C3C3C))),
                                  ]),
                                ),
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    const Text('Return Date & Time', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF000000))),
                                    const SizedBox(height: 2),
                                    Text(widget.bookingData.returnDate, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF3C3C3C))),
                                  ]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text('Location', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF000000))),
                            const SizedBox(height: 2),
                            Text(widget.bookingData.location, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF333333))),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Filter Chips (horizontal scroll) ──────────────────
                    SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.hardEdge,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: hp, vertical: 4),
                        itemCount: filterChips.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final bool isFilter = index == 0;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white, borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFE0E0E0)),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 1))],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isFilter) ...[
                                  Image.asset('assets/rental_screen/Filter.png', width: 16, height: 16,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.filter_list, size: 16, color: Color(0xFF333333))),
                                  const SizedBox(width: 6),
                                ],
                                Text(filterChips[index], style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF333333)), overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      child: const Text('03 Car Available in your Location',
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF000000))),
                    ),
                    const SizedBox(height: 10),

                    // ── ONE car card only ─────────────────────────────────
                    ...carList.map((car) => Padding(
                      padding: EdgeInsets.only(left: hp, right: hp, bottom: 12),
                      child: buildCarCard(car, scale),
                    )),

                    const SizedBox(height: 4),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                        child: buildInfoCard(
                          key: ValueKey(currentCardIndex),
                          title: infoCards[currentCardIndex]['title'],
                          subtitle: infoCards[currentCardIndex]['subtitle'],
                          imagePath: infoCards[currentCardIndex]['image'],
                          bgColor: infoCards[currentCardIndex]['color'],
                          scale: scale,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('How Its Work', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xFF14006C))),
                          const SizedBox(height: 4),
                          const Text('Step By Step to Renta vehicle on platform', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xFF000000))),
                          const SizedBox(height: 12),
                          ...howItWorks.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('${item['step']}. ', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF000000), fontWeight: FontWeight.w400)),
                              Expanded(child: Text(item['text']!, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF000000)))),
                            ]),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(child: Text('Explore Our Collection Cars', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF000000)), textAlign: TextAlign.center)),
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(16.58),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 3.32, offset: const Offset(0, 3.32))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16.58)),
                              child: Image.asset('assets/rental_screen/Hyundai.png', width: double.infinity, height: 160 * scale, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(height: 160 * scale, color: const Color(0xFFF0F0F0), child: const Center(child: Icon(Icons.directions_car, size: 60, color: Colors.grey)))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  const Text('Hyundai Grand\ni10 Nios sportz', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF000000))),
                                  const SizedBox(height: 6),
                                  Row(children: [
                                    Image.asset('assets/rental_screen/Location.png', width: 24, height: 24, errorBuilder: (_, __, ___) => const Icon(Icons.location_on, size: 24, color: Color(0xFF003399))),
                                    const SizedBox(width: 4),
                                    const Text('Coimbatore', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF003399))),
                                  ]),
                                ])),
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(children: [
                                    Image.asset('assets/rental_screen/Money.png', width: 20, height: 20, errorBuilder: (_, __, ___) => const Icon(Icons.currency_rupee, size: 14, color: Color(0xFF003399))),
                                    const SizedBox(width: 1),
                                    const Text('1400/day', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF003399))),
                                  ]),
                                  const SizedBox(height: 15),
                                  const Padding(padding: EdgeInsets.only(left: 33), child: Text('4.5/5', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF000000)))),
                                ]),
                              ]),
                            ),
                          ],
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

  Widget buildCarCard(Map<String, String> car, double scale) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFB5B4B4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(car['image']!, width: double.infinity, height: 160 * scale, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(height: 160 * scale, color: const Color(0xFFF0F0F0), child: const Center(child: Icon(Icons.directions_car, size: 60, color: Colors.grey)))),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(car['name']!, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF000000))),
                    const SizedBox(height: 4),
                    Row(children: [
                      Image.asset('assets/rental_screen/Star.png', width: 20, height: 20, errorBuilder: (_, __, ___) => const Icon(Icons.star, size: 20, color: Colors.amber)),
                      const SizedBox(width: 4),
                      Text(car['rating']!, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF333333))),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      Image.asset('assets/rental_screen/Location.png', width: 24, height: 24, errorBuilder: (_, __, ___) => const Icon(Icons.location_on, size: 24, color: Color(0xFF003399))),
                      const SizedBox(width: 4),
                      Text(car['location']!, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF003399))),
                    ]),
                  ]),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Image.asset('assets/rental_screen/Money.png', width: 24, height: 24, errorBuilder: (_, __, ___) => const Icon(Icons.currency_rupee, size: 24, color: Color(0xFF000000))),
                    const SizedBox(width: 2),
                    Text(car['price']!, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF000000))),
                  ]),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, PageRouteBuilder(
                        pageBuilder: (_, anim, __) => RentalPage3Screen(bookingData: widget.bookingData),
                        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
                        transitionDuration: const Duration(milliseconds: 300),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF01422D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4), elevation: 0, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Book Now', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13, color: Colors.white)),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard({required Key key, required String title, required String subtitle, required String imagePath, required Color bgColor, required double scale}) {
    return Container(key: key, width: double.infinity, decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.all(16),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white, height: 1.4)),
        ])),
        const SizedBox(width: 12),
        Image.asset(imagePath, width: 70 * scale, height: 70 * scale, fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.directions_car, color: Colors.white, size: 50)),
      ]),
    );
  }
}
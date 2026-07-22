import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'rental_booking_model.dart';
import 'rental_page_screen.dart';
import 'payment_options_screen.dart';

class RentalPage4Screen extends StatefulWidget {
  final RentalBookingData bookingData;
  const RentalPage4Screen({super.key, required this.bookingData});

  @override
  State<RentalPage4Screen> createState() => _RentalPage4ScreenState();
}

class _RentalPage4ScreenState extends State<RentalPage4Screen> {
  static const List<Map<String, String>> priceRows = [
    {'label': 'Base Price', 'value': '₹ 2,150'},
    {'label': 'Delivery & pickup charge', 'value': '₹ 500'},
    {'label': 'Refundable security deposit', 'value': '₹ 1,000'},
    {'label': 'Total', 'value': '₹ 3,650'},
  ];

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

  void showImportantPointsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => ImportantPointsSheet(bookingData: widget.bookingData),
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
              width: double.infinity, color: const Color(0xFFFFFFFF),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(children: [
                GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Color(0xFF01422D))),
                const SizedBox(width: 15),
                const Text('Booking Summary', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 18, color: Color(0xFF01422D))),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 12),
                  Padding(padding: EdgeInsets.symmetric(horizontal: hp),
                      child: const Text('Rental Vehicle By Truemotors', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xFF000000)))),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hp),
                    child: ClipRRect(borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/rental_screen/Hyundai Creta.png', width: double.infinity, height: 180 * scale, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(height: 180 * scale, decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(10)),
                                child: const Center(child: Icon(Icons.directions_car, size: 60, color: Colors.grey))))),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hp),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        const Expanded(child: Text('Hyundai Creta', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xFF000000)))),
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
                        Image.asset('assets/rental_screen/Star.png', width: 22, height: 22, errorBuilder: (_, __, ___) => const Icon(Icons.star, size: 22, color: Colors.amber)),
                        const SizedBox(width: 4),
                        const Text('4.5/5', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 13, color: Color(0xFF000000))),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 12),
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
                            Text(widget.bookingData.pickupDate, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF3C3C3C))),
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
                            Expanded(child: Text(row['label']!, style: TextStyle(fontFamily: 'Inter', fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400, fontSize: 13, color: const Color(0xFF000000)))),
                            Text(row['value']!, style: TextStyle(fontFamily: 'Inter', fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400, fontSize: 14, color: const Color(0xFF000000))),
                          ]));
                        }),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width: 280 * scale, height: 40,
                      child: ElevatedButton(
                        onPressed: () => showImportantPointsSheet(context),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005F65), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
                        child: const Text('Pay Now', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Important Points Sheet ────────────────────────────────────────────────────

class ImportantPointsSheet extends StatefulWidget {
  final RentalBookingData bookingData;
  const ImportantPointsSheet({super.key, required this.bookingData});

  @override
  State<ImportantPointsSheet> createState() => _ImportantPointsSheetState();
}

class _ImportantPointsSheetState extends State<ImportantPointsSheet> {
  bool isChecked = false;

  static const List<Map<String, String>> points = [
    {'title': 'Driver License', 'subtitle': 'Passport, national ID, or government-issued photo identification.'},
    {'title': 'Identity Proof', 'subtitle': 'Passport, national ID, or government-issued photo identification.'},
    {'title': '21 + Years of age', 'subtitle': 'Minimum age for driving (usually 21 or 25 depending on the country).'},
  ];

  // Save booking to SharedPreferences so My Booking screen can read it
  Future<void> _saveBooking() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing = prefs.getStringList('my_rental_bookings') ?? [];
    final Map<String, String> booking = {
      'carName': widget.bookingData.carName,
      'pickupDate': widget.bookingData.pickupDate,
      'returnDate': widget.bookingData.returnDate,
      'location': widget.bookingData.location,
      'total': '₹ 3,650',
      'status': 'Confirmed',
      'bookedAt': DateTime.now().toIso8601String(),
    };
    existing.insert(0, jsonEncode(booking));
    await prefs.setStringList('my_rental_bookings', existing);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double hp = screenWidth * 0.044;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      padding: EdgeInsets.fromLTRB(hp, 20, hp, 24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          GestureDetector(onTap: () => Navigator.pop(context),
              child: Image.asset('assets/rental_screen/Arrow.png', width: 24, height: 24, errorBuilder: (_, __, ___) => const Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF000000)))),
          const SizedBox(width: 9),
          const Text('Important points for booking', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF000000))),
        ]),
        const SizedBox(height: 16),
        const Text('You must be physically present to receive the car and provide the required documents to our delivery agent.',
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xFF000000), height: 1.5)),
        const SizedBox(height: 16),
        ...points.map((point) => Padding(padding: const EdgeInsets.only(bottom: 14), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.asset('assets/rental_screen/Group.png', width: 24, height: 24, errorBuilder: (_, __, ___) => const Icon(Icons.badge_outlined, size: 24, color: Color(0xFF555555))),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(point['title']!, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xFF000000))),
            const SizedBox(height: 2),
            Text(point['subtitle']!, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 13, color: Color(0xFF4E4E4E))),
          ])),
        ]))),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => isChecked = !isChecked),
          child: Container(
            width: double.infinity, constraints: const BoxConstraints(minHeight: 74),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: isChecked ? const Color(0xFF005F65) : const Color(0xFFBDBDBD))),
            padding: const EdgeInsets.all(12),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200), width: 20, height: 20,
                decoration: BoxDecoration(color: isChecked ? const Color(0xFF005F65) : Colors.transparent,
                    border: Border.all(color: isChecked ? const Color(0xFF005F65) : const Color(0xFFBDBDBD), width: 1.5), borderRadius: BorderRadius.circular(4)),
                child: isChecked ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
              const SizedBox(width: 10),
              const Expanded(child: Text('I understand that if the required documents are not provided at the time of delivery, the car will not be handed over, and cancellation charges may apply.',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 12, color: Color(0xFF000000), height: 1.5))),
            ]),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity, height: 48,
          child: ElevatedButton(
            onPressed: isChecked ? () async {
              await _saveBooking();
              Navigator.pop(context);
              Navigator.push(context, PageRouteBuilder(
                pageBuilder: (_, anim, __) => PaymentOptionsScreen(bookingData: widget.bookingData),
                transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
                transitionDuration: const Duration(milliseconds: 300),
              ));
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005F65), disabledBackgroundColor: const Color(0xFF005F65).withOpacity(0.8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0,
            ),
            child: const Text('Agree And continue', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
          ),
        ),
      ]),
    );
  }
}
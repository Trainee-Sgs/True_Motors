import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'rental_booking_model.dart';
import 'android_large_screen.dart';

class PaymentOptionsScreen extends StatefulWidget {
  final RentalBookingData bookingData;
  const PaymentOptionsScreen({super.key, required this.bookingData});

  @override
  State<PaymentOptionsScreen> createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  int currentImageIndex = 0;
  Timer? imageTimer;
  final PageController imagePageController = PageController();

  @override
  void dispose() {
    imageTimer?.cancel();
    imagePageController.dispose();
    super.dispose();
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
                const Text('Payment', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 18, color: Color(0xFF01422D))),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hp),
                    child: Container(
                      width: double.infinity, padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          const Text("Pay", style: TextStyle(fontSize: 24, fontFamily: 'Inter', color: Colors.black, fontWeight: FontWeight.w500)),
                          const SizedBox(width: 15),
                          const Text("₹", style: TextStyle(fontSize: 21, color: Colors.grey, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 6),
                          const Text("3,650", style: TextStyle(fontSize: 18, fontFamily: 'Inter', fontWeight: FontWeight.w500)),
                        ]),
                        const SizedBox(height: 25),
                        const Text("Pay Via UPI App", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hp),
                    child: Container(
                      width: 328 * scale, height: 178 * scale,
                      decoration: BoxDecoration(color: const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(5), border: Border.all(color: const Color(0xFF01422D))),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        // GPay — navigates to success page
                        GestureDetector(
                          onTap: () => Navigator.push(context, PageRouteBuilder(
                            pageBuilder: (_, anim, __) => const AndroidLargeScreen(),
                            transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
                            transitionDuration: const Duration(milliseconds: 300),
                          )),
                          child: Row(children: [
                            const SizedBox(height: 30),
                            Image.asset('assets/rental_screen/Gpay.png', width: 24, height: 24, fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, size: 24, color: Color(0xFF555555))),
                            const SizedBox(width: 14),
                            const Text('GPay', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF000000))),
                          ]),
                        ),
                        const SizedBox(height: 25),
                        buildPaymentRow(imagePath: 'assets/rental_screen/Phonepay.png', label: 'Phone Pe'),
                        const SizedBox(height: 25),
                        buildPaymentRow(imagePath: 'assets/rental_screen/Paytm.png', label: 'Paytm'),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(padding: EdgeInsets.symmetric(horizontal: hp), child: const Text('Cards', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 18, color: Color(0xFF000000)))),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hp),
                    child: Container(
                      width: 329 * scale, height: 47 * scale,
                      decoration: BoxDecoration(color: const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(5), border: Border.all(color: const Color(0xFF01422D))),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      child: buildPaymentRow(imagePath: 'assets/rental_screen/card.png', label: 'Credit, Debit & ATM cards'),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(padding: EdgeInsets.symmetric(horizontal: hp), child: const Text('More Payment Options', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 18, color: Color(0xFF000000)))),
                  const SizedBox(height: 13),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: hp),
                    child: Container(
                      width: 328 * scale, height: 124 * scale,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: const Color(0xFF01422D))),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const SizedBox(height: 10),
                        buildPaymentRow(imagePath: 'assets/rental_screen/Cash.png', label: 'Cash on Pick up'),
                        const SizedBox(height: 30),
                        buildPaymentRow(imagePath: 'assets/rental_screen/Net.png', label: 'Net Banking'),
                      ]),
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

  Widget buildPaymentRow({required String imagePath, required String label}) {
    return GestureDetector(
      onTap: () {},
      child: Row(children: [
        Image.asset(imagePath, width: 24, height: 24, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const SizedBox()),
        const SizedBox(width: 14),
        Text(label, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 16, color: Color(0xFF000000))),
      ]),
    );
  }
}
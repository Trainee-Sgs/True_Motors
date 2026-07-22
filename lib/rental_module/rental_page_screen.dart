import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'rental_booking_model.dart';
import 'rental_page2_screen.dart';

class RentalPageScreen extends StatefulWidget {
  // If editing, pre-fill with existing data
  final RentalBookingData? existingData;

  const RentalPageScreen({super.key, this.existingData});

  @override
  State<RentalPageScreen> createState() => _RentalPageScreenState();
}

class _RentalPageScreenState extends State<RentalPageScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController returnController = TextEditingController();

  String _selectedLocation = '';
  int currentCardIndex = 0;
  Timer? cardTimer;

  final List<Map<String, dynamic>> infoCards = [
    {
      'title': 'Well-Maintained Car',
      'subtitle': 'Every car is inspected & maintained to perfection. Enjoy a worry-free ride.',
      'image': 'assets/rental_screen/Well.png',
      'color': const Color(0xFFD85656),
    },
    {
      'title': 'Secure Payments',
      'subtitle': 'Pay safely with trusted gateways. Fast, encrypted & hassle-free transactions.',
      'image': 'assets/rental_screen/Secure.png',
      'color': const Color(0xFF006C4D),
    },
    {
      'title': '24/7 Support',
      'subtitle': 'Ride worry-free with our nonstop support team. We\'ve got your back, 24/7.',
      'image': 'assets/rental_screen/Support.png',
      'color': const Color(0xFF20529D),
    },
  ];

  final List<Map<String, String>> howItWorks = [
    {'step': '1', 'text': 'Choose Vehicle: Browse available cars & bikes.'},
    {'step': '2', 'text': 'Select Duration: Pick your rental period.'},
    {'step': '3', 'text': 'Book & Pay: Confirm your booking securely.'},
    {'step': '4', 'text': 'Pickup/Delivery: Get your vehicle at your doorstep or pick it up at our hub.'},
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill from existing data if editing
    if (widget.existingData != null) {
      searchController.text = widget.existingData!.carName;
      pickupController.text = widget.existingData!.pickupDate;
      returnController.text = widget.existingData!.returnDate;
      _selectedLocation = widget.existingData!.location;
    }
    startCardTimer();
  }

  void startCardTimer() {
    cardTimer = Timer.periodic(const Duration(milliseconds: 3000), (_) {
      setState(() {
        currentCardIndex = (currentCardIndex + 1) % infoCards.length;
      });
    });
  }

  @override
  void dispose() {
    cardTimer?.cancel();
    searchController.dispose();
    pickupController.dispose();
    returnController.dispose();
    super.dispose();
  }

  // Validate all fields before allowing search
  bool get _canSearch =>
      searchController.text.trim().isNotEmpty &&
          pickupController.text.trim().isNotEmpty &&
          returnController.text.trim().isNotEmpty &&
          _selectedLocation.trim().isNotEmpty;

  void _onSearchPressed() {
    if (!_canSearch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill car name, pickup date, return date and location.'),
          backgroundColor: Color(0xFF005F65),
        ),
      );
      return;
    }

    final bookingData = RentalBookingData(
      carName: searchController.text.trim(),
      pickupDate: pickupController.text.trim(),
      returnDate: returnController.text.trim(),
      location: _selectedLocation.trim(),
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => RentalPage2Screen(bookingData: bookingData),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showLocationPicker() {
    final List<String> locations = [
      'Coimbatore', 'Chennai', 'Bengaluru', 'Mumbai', 'Delhi',
      'Hyderabad', 'Pune', 'Kolkata', 'Ahmedabad', 'Surat',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Select Location',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          ...locations.map((loc) => ListTile(
            leading: const Icon(Icons.location_on_outlined,
                color: Color(0xFF005F65)),
            title: Text(loc),
            onTap: () {
              setState(() => _selectedLocation = loc);
              Navigator.pop(context);
            },
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double hp = screenWidth * 0.055;
    final double scale = screenWidth / 360.0;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          children: [
            Container(width: double.infinity, height: statusBarHeight, color: Colors.transparent),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Color(0xFF01442D)),
                  ),
                  const SizedBox(width: 15),
                  const Text('Rental',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Color(0xFF01422D))),
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
                      height: 159 * scale,
                      child: Image.asset('assets/rental_screen/Banner.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFF2D2D2D),
                              child: const Center(
                                  child: Icon(Icons.two_wheeler, color: Colors.white, size: 60)))),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      child: const Text('Rental Vehicle By Truemotors',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF000000))),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xffB5B4B4)),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // ── Search car name ──
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF000000)),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  const Icon(Icons.search, color: Color(0xFF01422D), size: 18),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF3C3C3C)),
                                      decoration: const InputDecoration(
                                        hintText: 'Search Car Name or Brand',
                                        hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF3C3C3C)),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            buildDateField(label: 'Pickup Date', controller: pickupController, context: context),
                            const SizedBox(height: 16),
                            buildDateField(label: 'Return Date', controller: returnController, context: context),
                            const SizedBox(height: 14),
                            // ── Location picker ──
                            GestureDetector(
                              onTap: _showLocationPicker,
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFF000000)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _selectedLocation.isEmpty ? 'Location' : _selectedLocation,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: _selectedLocation.isEmpty ? const Color(0xFF000000) : const Color(0xFF005F65),
                                        ),
                                      ),
                                    ),
                                    Image.asset('assets/rental_screen/Right Arrow.png',
                                        width: 20, height: 20,
                                        errorBuilder: (_, __, ___) => const Icon(Icons.arrow_right_sharp, size: 20, color: Color(0xFF01422D))),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: SizedBox(
                                width: 160 * scale,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: _onSearchPressed,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _canSearch ? const Color(0xFF005F65) : const Color(0xFF005F65).withOpacity(0.5),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    elevation: 0,
                                  ),
                                  child: const Text('Search',
                                      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('How Its Work',
                              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xFF14006C))),
                          const SizedBox(height: 8),
                          const Text('Step By Step to Renta vehicle on platform',
                              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xFF000000))),
                          const SizedBox(height: 12),
                          ...howItWorks.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${item['step']}. ',
                                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF000000))),
                                Expanded(
                                    child: Text(item['text']!,
                                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF000000)))),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text('Explore Our Collection Cars',
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF000000)),
                          textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.58),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 3.32, offset: const Offset(0, 3.32))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16.58)),
                              child: Image.asset('assets/rental_screen/Hyundai.png',
                                  width: double.infinity, height: 160 * scale, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(height: 160 * scale, color: const Color(0xFFF0F0F0),
                                      child: const Center(child: Icon(Icons.directions_car, size: 60, color: Colors.grey)))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Hyundai Grand\ni10 Nios sportz',
                                            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF000000))),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Image.asset('assets/rental_screen/Location.png', width: 14, height: 14,
                                                errorBuilder: (_, __, ___) => const Icon(Icons.location_on, size: 14, color: Color(0xFF003399))),
                                            const SizedBox(width: 4),
                                            const Text('Coimbatore', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF003399))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(height: 10),
                                          Image.asset('assets/rental_screen/Money.png', width: 14, height: 14,
                                              errorBuilder: (_, __, ___) => const Icon(Icons.currency_rupee, size: 14, color: Color(0xFF003399))),
                                          const SizedBox(width: 2),
                                          const Text('1400/day',
                                              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF003399))),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const Text('4.5/5', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF000000))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDateField({required String label, required TextEditingController controller, required BuildContext context}) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF005F65))),
            child: child!,
          ),
        );
        if (picked != null) {
          controller.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
        }
      },
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF3C3C3C)),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: 'dd/mm/yyyy',
        hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF9E9E9E)),
        labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xFF005F65)),
        floatingLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF005F65)),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset('assets/rental_screen/Date.png', width: 24, height: 24, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.calendar_month_outlined, size: 24, color: Color(0xFF005F65))),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF000000), width: 1)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF000000), width: 1)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF005F65), width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget buildInfoCard({required Key key, required String title, required String subtitle, required String imagePath, required Color bgColor, required double scale}) {
    return Container(
      key: key,
      width: double.infinity,
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white)),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Image.asset(imagePath, width: 70 * scale, height: 70 * scale, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.directions_car, color: Colors.white, size: 50)),
        ],
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  int _selectedTab = 0; // 0 = Rental Vehicle, 1 = Service Vehicle

  List<Map<String, String>> _rentalBookings = [];
  bool _isLoading = true;

  final List<String> _sortChips = [
    'Sort by',
    'Booking Status',
    'Vehicle Type',
    'Rental Type',
    'Date Range',
  ];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final prefs = await SharedPreferences.getInstance();

    // ── Clear bookings on every fresh app session ─────────────────────────
    // We use a session flag stored in memory (not prefs) to detect restarts.
    // On first load each session, clear the saved list so it starts empty.
    final bool sessionStarted = _sessionStarted;
    if (!sessionStarted) {
      await prefs.remove('my_rental_bookings');
      _sessionStarted = true;
    }

    final List<String> raw =
        prefs.getStringList('my_rental_bookings') ?? [];
    setState(() {
      _rentalBookings = raw.map((e) {
        final decoded = jsonDecode(e);
        return Map<String, String>.from(decoded as Map);
      }).toList();
      _isLoading = false;
    });
  }

  // Static flag lives only in memory — resets to false on every app restart
  static bool _sessionStarted = false;

  // ── Sample service bookings (static placeholder) ──────────────────────────
  final List<Map<String, String>> _serviceBookings = [
    {
      'carName': 'Tata Nexon',
      'service': 'General Service',
      'pickup': 'Yes',
      'serviceDate': 'Aug 05, 2025',
      'workshop': 'ABC Auto Care',
      'bookingId': '#TRMS12345',
      'status': 'Completed',
      'image': 'assets/rental_screen/Hyundai Creta.png',
    },
    {
      'carName': 'Tata Nexon',
      'service': 'General Service',
      'pickup': 'Yes',
      'serviceDate': 'Aug 05, 2025',
      'workshop': 'ABC Auto Care',
      'bookingId': '#TRMS12345',
      'status': 'Completed',
      'image': 'assets/rental_screen/Hyundai Creta.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: statusBarHeight,
              color: const Color(0xFF615C5C),
            ),

            // ── AppBar ────────────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Color(0xFF01422D), size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'My Booking',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Color(0xFF01422D),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(
                  child: CircularProgressIndicator(
                      color: Color(0xFF005F65)))
                  : SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Rent Now Banner ───────────────────────────
                    _buildRentBanner(),

                    const SizedBox(height: 14),

                    // ── "My Booking" heading ──────────────────────
                    const Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'My Booking',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Tabs ──────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16),
                      child: Row(
                        children: [
                          Expanded(child: _buildTab('Rental Vehicle', 0)),
                          const SizedBox(width: 20),
                          Expanded(child: _buildTab('Service Vehicle', 1)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Sort / Filter chips ───────────────────────
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              color: Color(0xFFB2A8A8)),
                          bottom: BorderSide(
                              color: Color(0xFFB2A8A8)),
                        ),
                      ),
                      child: SizedBox(
                        height: 55,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          itemCount: _sortChips.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final bool isSort = index == 0;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(6),
                                border: Border.all(
                                    color:
                                    const Color(0xFF005F65)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSort) ...[
                                    const Icon(Icons.sort,
                                        size: 14,
                                        color:
                                        Color(0xFF434343)),
                                    const SizedBox(width: 4),
                                  ],
                                  Text(
                                    _sortChips[index],
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Booking list ──────────────────────────────
                    if (_selectedTab == 0)
                      _rentalBookings.isEmpty
                          ? _buildEmptyState(
                          'No rental bookings yet.\nBook a vehicle to see it here.')
                          : Column(
                        children: _rentalBookings
                            .map((b) =>
                            _buildRentalCard(b))
                            .toList(),
                      )
                    else
                      Column(
                        children: _serviceBookings
                            .map((b) => _buildServiceCard(b))
                            .toList(),
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

  // ── Tab button ─────────────────────────────────────────────────────────────
  Widget _buildTab(String label, int index) {
    final bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF005F65)
              : const Color(0xFFE5E3E3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF005F65)
                : const Color(0xFFCECECE),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : const Color(0xFF000000),
            ),
          ),
        ),
      ),
    );
  }

  // ── Rent Now Banner ────────────────────────────────────────────────────────
  Widget _buildRentBanner() {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Image.asset(
        'assets/home_image/rent_banner.png',
        fit: BoxFit.cover,
      ),
    );
  }

  // ── Rental booking card — Figma layout ────────────────────────────────────
  Widget _buildRentalCard(Map<String, String> booking) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDED3D3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Car image — left side, fills card height ────────────────
          Image.asset(
            'assets/my_booking/hyundai_sandro.png',
            width: 140,
            height: 140,
            fit: BoxFit.contain,
          ),

          // ── Details — right side ────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 4, right: 16, top: 10, bottom: 10,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car name
                  Text(
                    booking['carName'] ?? 'Hyundai Santro MT',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Fuel | Manual row
                  Row(
                    children: [
                      _specChip(
                          'assets/my_booking/petrol.png', 'Petrol'),
                      const SizedBox(width: 10),
                      _specChip(
                          'assets/my_booking/manual.png', 'Manual'),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // 438 kms included, Without fuel
                  Text(
                    '438 kms included, Without fuel',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: Color(0xFF000000),
                    ),
                  ),

                  // Extra Kms @ ₹ 20/Km
                  Row(
                    children: const [
                      Text(
                        'Extra Kms @ ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Color(0xFF000000),
                        ),
                      ),
                      Icon(Icons.currency_rupee,
                          size: 12, color: Color(0xFF5F6368)),
                      Text(
                        ' 20/Km',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // View Details — right-aligned
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF005F65),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Service booking card ───────────────────────────────────────────────────
  Widget _buildServiceCard(Map<String, String> booking) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDED3D3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Car image — left side ───────────────────────────────────
          Image.asset('assets/my_booking/tata_nexon.png',
            width: 145,
            height: 140,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              width: 120,
              height: 130,
              color: const Color(0xFFEEEEEE),
              child: const Icon(Icons.directions_car,
                  color: Colors.grey, size: 36),
            ),
          ),

          // ── Details ─────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10, bottom: 10, left: 0, right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking['carName'] ?? '',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Service Date: ${booking['serviceDate'] ?? ''}',
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Color(0xFF000000)),
                  ),
                  Text(
                    'Workshop: ${booking['workshop'] ?? ''}',
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Color(0xFF000000)),
                  ),
                  Text(
                    'Booking ID: ${booking['bookingId'] ?? ''}',
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Color(0xFF000000)),
                  ),
                  Text(
                    'Status: Completed',
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Color(0xFF29A702)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF005F65),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
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
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _specChip(String imagePath, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          width: 14,
          height: 14,
          errorBuilder: (_, __, ___) => const Icon(
              Icons.circle,
              size: 12,
              color: Color(0xFF555555)),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: Color(0xFF000000),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.directions_car_outlined,
                size: 56, color: Color(0xFFB2A8A8)),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFFB2A8A8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
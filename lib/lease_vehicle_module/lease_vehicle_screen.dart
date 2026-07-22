import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:true_motors/provider/used_vehicle_provider.dart';
import 'lease_vehicle_detail_screen.dart';

class LeaseVehicleScreen extends StatefulWidget {
  const LeaseVehicleScreen({super.key});

  @override
  State<LeaseVehicleScreen> createState() => _LeaseVehicleScreenState();
}

class _LeaseVehicleScreenState extends State<LeaseVehicleScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _leasedCars = [
    {
      'name': 'Hyundai Creta',
      'location': 'Coimbatore',
      'price': '1,400',
      'leaseType': 'Monthly Lease',
      'image': 'assets/rental_screen/Hyundai Creta.png',
      'isFavorite': false,
    },
    {
      'name': 'Hyundai Creta',
      'location': 'Coimbatore',
      'price': '1,400',
      'leaseType': 'Monthly Lease',
      'image': 'assets/rental_screen/Hyundai Creta.png',
      'isFavorite': false,
    },
  ];

  int currentCardIndex = 0;
  Timer? cardTimer;

  final List<Map<String, dynamic>> infoCards = [
    {
      'title': 'Well-Maintained Car',
      'subtitle':
      'Every car is inspected & maintained to perfection. Enjoy a worry-free ride.',
      'image': 'assets/rental_screen/Well.png',
      'color': const Color(0xFFD85656),
    },
    {
      'title': 'Secure Payments',
      'subtitle':
      'Pay safely with trusted gateways. Fast, encrypted & hassle-free transactions.',
      'image': 'assets/rental_screen/Secure.png',
      'color': const Color(0xFF006C4D),
    },
    {
      'title': '24/7 Support',
      'subtitle':
      'Lease worry-free with our nonstop support team. We\'ve got your back 24/7.',
      'image': 'assets/rental_screen/Support.png',
      'color': const Color(0xFF20529D),
    },
  ];

  void startCardTimer() {
    cardTimer = Timer.periodic(
      const Duration(seconds: 3),
          (_) {
        setState(() {
          currentCardIndex = (currentCardIndex + 1) % infoCards.length;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsedVehicleProvider>().fetchUsedVehicleCategories();
    });
    startCardTimer();
  }

  @override
  void dispose() {
    cardTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: statusBarHeight, color: Colors.transparent,
            ),

            // ── AppBar ────────────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Color(0xFF01422D), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Lease Vehicle',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF01422D),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Top Banner ────────────────────────────────────────
                    _buildTopBanner(),
                    const SizedBox(height: 16),
                    // ── Heading ───────────────────────────────────────────
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Lease Vehicle By Truemotors',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Search Bar ────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF01422D)),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            const Icon(Icons.search,
                                color: Color(0xFF5F6368), size: 22),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                cursorColor: Color(0xFF01422D),
                                decoration: const InputDecoration(
                                  hintText: 'Look for your favorite vehicle',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Category heading ──────────────────────────────────
                    Center(
                      child: Text(
                        'Or choose a category',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    // ── Category Row ──────────────────────────────────────
                    _buildCategoryRow(),
                    const SizedBox(height: 16),
                    // ── Filter chips ──────────────────────────────────────
                    _buildFilterChips(),
                    const SizedBox(height: 16),
                    // ── Results heading ───────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Our Hyundai leased cars ',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '(2 Results)',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF1B21D6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    // ── Car Cards ─────────────────────────────────────────
                    ..._leasedCars.asMap().entries.map((entry) {
                      final index = entry.key;
                      final car = entry.value;
                      return _buildCarCard(car, index);
                    }),
                    // ── Vehicle Lease Banner ──────────────────────────────
                    Image.asset('assets/lease_image/vehicle_banner.png'),
                    const SizedBox(height: 16),
                    // ── Well-Maintained Card ──────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: buildInfoCard(
                          key: ValueKey(currentCardIndex),
                          title: infoCards[currentCardIndex]['title'],
                          subtitle: infoCards[currentCardIndex]['subtitle'],
                          imagePath: infoCards[currentCardIndex]['image'],
                          bgColor: infoCards[currentCardIndex]['color'],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // ── How It Works ──────────────────────────────────────
                    _buildHowItWorks(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBanner() {
    return Image.asset(
      'assets/lease_image/lease_banner.png',
    );
  }

  Widget _buildCategoryRow() {
    return Consumer<UsedVehicleProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(color: Color(0xFF005F65)),
          ));
        }
        if (provider.error != null) {
          return Center(child: Text('Error: ${provider.error}', style: const TextStyle(color: Colors.red)));
        }
        if (provider.categories.isEmpty) {
          return const Center(child: Text('No categories available'));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: provider.categories.map((cat) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x40000000),
                            offset: Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.network(
                          cat.image,
                          width: 55,
                          height: 55,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(Icons.directions_car, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cat.catName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildFilterChips() {
    final chips = ['Sort By'];
    final icons = [
      Icons.sort,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(chips.length, (i) {
          return Padding(
            padding: EdgeInsets.only(right: i < chips.length - 1 ? 10 : 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFBEBEBE)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icons[i], size: 16, color: const Color(0xFF9E9E9E)),
                  const SizedBox(width: 4),
                  Text(
                    chips[i],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCarCard(Map<String, dynamic> car, int index) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB5B4B4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Car image with favorite
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(
                  car['image'],
                  width: double.infinity,
                  height: 170,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 160,
                    color: const Color(0xFFEEEEEE),
                    child: const Center(
                      child: Icon(Icons.directions_car,
                          size: 60, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _leasedCars[index]['isFavorite'] =
                      !_leasedCars[index]['isFavorite'];
                    });
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Icon(
                      car['isFavorite']
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 14,
                      color: car['isFavorite']
                          ? Color(0xFFBE000C)
                          : Color(0xFF882B2B),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car['name'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Image.asset(
                            'assets/lease_image/location.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            car['location'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF003399),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEBBBB),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          car['leaseType'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF003399),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.currency_rupee,
                            size: 18, color: Colors.black),
                        Text(
                          car['price'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          '/Day',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                LeaseVehicleDetailScreen(car: car),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF01422D),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Lease Details',
                          style: TextStyle(
                            fontSize: 14,
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
        ],
      ),
    );
  }

  Widget buildInfoCard({
    required Key key,
    required String title,
    required String subtitle,
    required String imagePath,
    required Color bgColor,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Image.asset(
            imagePath,
            width: 70,
            height: 70,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.directions_car,
              color: Colors.white,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorks() {
    final steps = [
      'Choose Vehicle: Browse available Vehicle',
      'Select Duration: Pick your Lease period.',
      'Book & Pay: Confirm your booking securely.',
      'Pickup/Delivery: Get your vehicle at your doorstep or pick it up at our hub.',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How Its Work',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF14006C),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Step By Step to Lease vehicle on platform',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          const SizedBox(height: 10),
          ...steps.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 6),
            child: Text(
              '${e.key + 1}. ${e.value}',
              style: const TextStyle(
                  fontSize: 15, color: Colors.black, height: 1.6),
            ),
          )),
        ],
      ),
    );
  }
}
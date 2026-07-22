import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lease_vehicle_quote_screen.dart';

class LeaseVehicleDetailScreen extends StatefulWidget {
  final Map<String, dynamic> car;

  const LeaseVehicleDetailScreen({super.key, required this.car});

  @override
  State<LeaseVehicleDetailScreen> createState() =>
      _LeaseVehicleDetailScreenState();
}

class _LeaseVehicleDetailScreenState extends State<LeaseVehicleDetailScreen> {
  int _currentImageIndex = 0;
  bool _isFavorite = false;

  final List<String> _carImages = [
    'assets/lease_image/hyundai.png',
    'assets/lease_image/hyundai.png',
    'assets/lease_image/hyundai.png',
  ];

  final List<Map<String, dynamic>> _features = [
    {'icon': 'assets/my_booking/petrol.png', 'label': 'Petrol'},
    {'icon': 'assets/my_booking/manual.png', 'label': 'Manual'},
    {'icon': 'assets/my_booking/seats.png', 'label': '5 Seats'},
  ];

  final List<String> _checkFeatures = [
    'Crusie Control',
    'Android Auto',
    'GPS system',
    'Air Conditioning',
  ];

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.car['isFavorite'] ?? false;
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
            // AppBar
            Container(
              color: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                    const SizedBox(height: 16),

                    // Heading
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Lease Vehicle By True Motors',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Car image slider
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                        child: _buildImageSlider(),
                    ),
                    SizedBox(height: 15,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.car['name'] ?? 'Hyundai Creta',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isFavorite = !_isFavorite;
                                  });
                                },
                                child: Icon(
                                  _isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _isFavorite
                                      ? const Color(0xFFBE000C)
                                      : const Color(0xFF5F6368),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.share_outlined,
                                  color: Colors.black, size: 24),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Location and rating
                          Row(
                            children: [
                              Image.asset('assets/lease_image/location.png',
                                width: 24,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.car['location'] ?? 'Coimbatore',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF003399),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.star_border_purple500,
                                  color: Color(0xFFFFC107), size: 24),
                              const SizedBox(width: 4),
                              const Text(
                                '4.5/5',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // White card with all details
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Features',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Feature chips row
                          _buildFeatureChips(),

                          const SizedBox(height: 16),

                          // Check features grid
                          _buildCheckFeatures(),
                          const SizedBox(height: 18),

                          // Description
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Experience the perfect blend of style, space, and performance with the Hyundai Creta. Ideal for city rides and weekend getaways, this premium SUV offers a smooth drive, advanced safety features, and a commanding road presence.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF5B5B5B),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.justify,
                          ),

                          const SizedBox(height: 10),
                          const Divider(color: Color(0xFF8B8B8B)),
                          const SizedBox(height: 8),

                          // Owner Info
                          const Text(
                            'Owner Info',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 12),
                          _buildOwnerInfo(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFFB5B4B4))
                      ),
                      padding: const EdgeInsets.all(16),
                      child: _buildPaymentDetailsCard(),
                    ),

                    const SizedBox(height: 20),
                    // Request a quote button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LeaseVehicleQuoteScreen(car: widget.car),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF005F65),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'Request a quote',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PageView.builder(
              itemCount: _carImages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Image.asset(
                  _carImages[index],
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _carImages.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentImageIndex == index ? 30 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: _currentImageIndex == index
                    ? const Color(0xFF00558B)
                    : const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureChips() {
    return Wrap(
      spacing: 20.0,
      runSpacing: 10.0,
      children: _features.map((feature) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              feature['icon'],
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 6),
            Text(
              feature['label'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildCheckFeatures() {
    return Wrap(
      spacing: 24.0,
      runSpacing: 8.0,
      children: [
        _checkItem('Crusie Control'),
        _checkItem('Android Auto'),
        _checkItem('GPS system'),
        _checkItem('Air Conditioning'),
      ],
    );
  }

  Widget _checkItem(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check, color: Color(0xFF2AA644), size: 20),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage:
          const AssetImage('assets/lease_image/owner_avatar.png'),
          onBackgroundImageError: (_, __) {},
          backgroundColor: const Color(0xFFF2F2F2),
          child: const Icon(Icons.person, size: 35, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Harish',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star_border_purple500, color: Color(0xFFFFC107), size: 16),
                const SizedBox(width: 4),
                const Text(
                  '4.5/5  ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const Text(
                  '(180 Review)',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Joined 8 Month Ago',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentDetailsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Car Name: Creta',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),
        const Text(
          'Location',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '123, Parker Street, Rogers Road, Wanda, \nNowhere - XRT589',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF3C3C3C),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Payment Details',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 10),

        _paymentRow('Base Price / Day', '₹ 1,400'),
        const SizedBox(height: 6),
        _paymentRow('Delivery & pickup charge', '₹ 500'),
        const SizedBox(height: 6),
        _paymentRow('Refundable security deposit', '₹ 10,000'),

        const SizedBox(height: 10),

        _paymentRow('Total', '₹ 12,650', isBold: true),
      ],
    );
  }

  Widget _paymentRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
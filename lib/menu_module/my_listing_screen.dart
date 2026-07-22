import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:true_motors/sell_vehicle_module/sell_car_form_screen.dart';
import 'listing_manager.dart';

class MyListingScreen extends StatefulWidget {
  const MyListingScreen({super.key});

  @override
  State<MyListingScreen> createState() => _MyListingScreenState();
}

class _MyListingScreenState extends State<MyListingScreen> {
  final ListingManager _manager = ListingManager();
  int _selectedTab = 0; // 0=Active, 1=Pending, 2=Sold

  final List<String> _tabs = ['Active Listing', 'Pending', 'Sold Vehicle'];

  @override
  void initState() {
    super.initState();
    _manager.addListener(_onListingsChanged);
  }

  @override
  void dispose() {
    _manager.removeListener(_onListingsChanged);
    super.dispose();
  }

  void _onListingsChanged() {
    if (mounted) setState(() {});
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  List<VehicleListing> get _currentListings {
    switch (_selectedTab) {
      case 0:
        return _manager.activeListings;
      case 1:
        return _manager.pendingListings;
      case 2:
        return _manager.soldListings;
      default:
        return [];
    }
  }

  void _markAsSold(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Mark as Sold',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        content: const Text(
            'Are you sure you want to mark this vehicle as sold?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _manager.markAsSold(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005F65),
            ),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editListing(VehicleListing listing) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SellCarFormScreen(
          registrationNumber: listing.registrationNumber,
          vehicleType: listing.vehicleType,
          editingListingId: listing.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
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
            Expanded(
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    _buildAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 16),
                            _buildTabs(),
                            const SizedBox(height: 10),
                            Divider(color: Color(0xFFB2A8A8)),
                            const SizedBox(height: 10),
                            _buildListingContent(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back,
                size: 24, color: Color(0xFF01422D)),
          ),
          const SizedBox(width: 16),
          const Text(
            'My Listing',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF01422D)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'My Listing',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Row(
      children: List.generate(_tabs.length, (i) {
        final isSelected = _selectedTab == i;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            child: Container(
              margin: EdgeInsets.only(right: i < _tabs.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF005F65)
                    : const Color(0xFFE5E3E3),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF005F65)
                      : const Color(0xFFCECECE),
                ),
              ),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _tabs[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildListingContent() {
    final listings = _currentListings;
    if (listings.isEmpty) return _buildNoListings();
    return Column(
      children: listings.map((l) => _buildListingCard(l)).toList(),
    );
  }

  Widget _buildNoListings() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.directions_car_outlined,
              size: 60, color: Color(0xFFB2A8A8)),
          SizedBox(height: 16),
          Text(
            'No listings found',
            style: TextStyle(
                fontSize: 16,
                color: Color(0xFFB2A8A8),
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildListingCard(VehicleListing listing) {
    final String statusLabel = listing.status == 'active'
        ? 'Active'
        : listing.status == 'sold'
        ? 'Sold'
        : 'Pending';
    final Color statusColor = listing.status == 'active'
        ? const Color(0xFF059F0A)
        : listing.status == 'sold'
        ? Colors.red
        : const Color(0xFFFFA500);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF005F65)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(child: _buildVehicleImage(listing)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${listing.brand} ${listing.model}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    _specChip('assets/my_booking/petrol.png',
                        listing.fuelType, 14),
                    _specChip('assets/my_booking/manual.png',
                        listing.transmission, 14),
                    _specChip('assets/my_booking/seats.png', '5 Seats', 14),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Listing ID: #${listing.id}',
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'Inter'),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Price: ₹${_formatPrice(listing.price)}',
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            statusLabel,
                            style: TextStyle(
                              fontSize: 13,
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (listing.status != 'sold')
                  Row(
                    children: [
                      if (listing.status == 'active') ...[
                        Expanded(
                          child: _actionButton(
                            label: 'Edit Listing',
                            onTap: () => _editListing(listing),
                            isOutlined: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _actionButton(
                            label: 'Mark as Sold',
                            onTap: () => _markAsSold(listing.id),
                            isOutlined: false,
                          ),
                        ),
                      ] else if (listing.status == 'pending') ...[
                        Expanded(
                          child: _actionButton(
                            label: 'Edit Listing',
                            onTap: () => _editListing(listing),
                            isOutlined: true,
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleImage(VehicleListing listing) {
    if (listing.images.isNotEmpty) {
      return Image.file(listing.images.first,
          width: 90, height: 90, fit: BoxFit.cover);
    }
    return Image.asset(
      'assets/sell_image/red_car.png',
      height: 100,
      width: 100,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.directions_car,
        size: 40,
        color: Color(0xFFCCCCCC),
      ),
    );
  }

  Widget _specChip(String imagePath, String label, double fontSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(imagePath, width: 15, height: 15, fit: BoxFit.contain),
        const SizedBox(width: 2),
        Text(label,
            style: TextStyle(
                fontSize: fontSize,
                color: Colors.black,
                fontFamily: 'Inter')),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required VoidCallback onTap,
    required bool isOutlined,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.white : const Color(0xFF005F65),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isOutlined
                ? const Color(0xFF742B88)
                : const Color(0xFF005F65),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isOutlined ? const Color(0xFF742B88) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  String _formatPrice(String price) {
    final num = int.tryParse(price);
    if (num == null) return price;
    if (num >= 100000) return '${(num / 100000).toStringAsFixed(1)} L';
    return price;
  }
}
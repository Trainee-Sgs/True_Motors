import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:true_motors/lease_module/listed_vehicles_manager.dart';
import 'package:true_motors/lease_module/select_vehicle_type_screen.dart';

class LeaseVehicleDashboardScreen extends StatefulWidget {
  final String initialTab;

  const LeaseVehicleDashboardScreen({
    super.key,
    this.initialTab = 'dashboard',
  });

  @override
  State<LeaseVehicleDashboardScreen> createState() =>
      _LeaseVehicleDashboardScreenState();
}

class _LeaseVehicleDashboardScreenState
    extends State<LeaseVehicleDashboardScreen> {
  late String _activeTab;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
    ListedVehiclesManager().addListener(_onVehiclesUpdated);
  }

  @override
  void dispose() {
    ListedVehiclesManager().removeListener(_onVehiclesUpdated);
    super.dispose();
  }

  void _onVehiclesUpdated() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFDFDFD),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: statusBarHeight, color: Colors.transparent,
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    _buildAppBar(context),
                    Expanded(
                      child: _activeTab == 'my_vehicles'
                          ? _buildMyVehiclesTab(context)
                          : _buildDashboardTab(context),
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

  // ── App bar ────────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: Color(0xFF01422D),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Lease Vehicle Dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF01422D),
            ),
          ),
        ],
      ),
    );
  }

  // ── Dashboard tab (original content) ──────────────────────────────────────
  Widget _buildDashboardTab(BuildContext context) {
    final vehicles = ListedVehiclesManager().vehicles;
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset('assets/lease_image/lease_banner.png'),

          // Overview Section
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildOverviewCard(
                        'My Vehicles', '${vehicles.length}'),
                    const SizedBox(width: 10),
                    _buildOverviewCard('Active Leases', '02'),
                    const SizedBox(width: 10),
                    _buildOverviewCard('Total Earnings', '₹1,45,000'),
                  ],
                ),
              ],
            ),
          ),

          // Quick Actions
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                _buildQuickAction(
                  context,
                  icon: Icons.add_circle_outline,
                  title: 'Add New Vehicle',
                  subtitle: 'List your vehicle for lease',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const SelectVehicleTypeScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                _buildQuickAction(
                  context,
                  icon: Icons.directions_car_outlined,
                  title: 'My Vehicles',
                  subtitle: 'Manage your listed vehicles',
                  onTap: () => setState(() => _activeTab = 'my_vehicles'),
                ),
                const SizedBox(height: 15),
                _buildQuickAction(
                  context,
                  icon: Icons.description_outlined,
                  title: 'My Leases',
                  subtitle: 'View your lease agreements',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── My Vehicles tab ────────────────────────────────────────────────────────
  Widget _buildMyVehiclesTab(BuildContext context) {
    final vehicles = ListedVehiclesManager().vehicles;

    if (vehicles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_car_outlined,
                size: 64, color: Color(0xFFB4B4B4)),
            const SizedBox(height: 16),
            const Text(
              'No vehicles listed yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add a vehicle to start leasing',
              style: TextStyle(fontSize: 13, color: Colors.black38),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SelectVehicleTypeScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Add New Vehicle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005F65),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Tab header
        Container(
          color: Colors.white,
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Vehicles (${vehicles.length})',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectVehicleTypeScreen(),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.add,
                        size: 18, color: Color(0xFF005F65)),
                    SizedBox(width: 4),
                    Text(
                      'Add Vehicle',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF005F65),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vehicles.length,
            itemBuilder: (_, index) =>
                _buildVehicleCard(vehicles[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleCard(ListedVehicle vehicle) {
    Widget imageWidget;
    if (vehicle.imagePaths.isNotEmpty) {
      imageWidget = ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
        child: Image.file(
          File(vehicle.imagePaths.first),
          width: 110,
          height: 100,
          fit: BoxFit.cover,
        ),
      );
    } else {
      imageWidget = ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
        child: Image.asset(
          _vehicleTypeImage(vehicle.vehicleType),
          width: 110,
          height: 100,
          fit: BoxFit.contain,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageWidget,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicle.brand} ${vehicle.model}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${vehicle.kmDriven} km | ${vehicle.fuelType} | ${vehicle.transmission}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 13, color: Colors.black38),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${vehicle.city}, ${vehicle.state}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black38,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Monthly Price',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black38,
                            ),
                          ),
                          Text(
                            '₹ ${vehicle.monthlyPrice}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF005F65),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF8F0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Active',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF005F65),
                            fontWeight: FontWeight.w600,
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

  String _vehicleTypeImage(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'van':
        return 'assets/buy_image/van.png';
      case 'truck':
        return 'assets/buy_image/commercial.png';
      case 'backhoe / loader':
        return 'assets/buy_image/backhoe.png';
      case 'car':
      default:
        return 'assets/home_image/suv.png';
    }
  }

  Widget _buildOverviewCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF2FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
              Icon(icon, color: const Color(0xFF0F4C81), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
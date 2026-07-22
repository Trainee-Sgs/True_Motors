import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:true_motors/lease_module/vehicle_details_screen.dart';

class SelectVehicleTypeScreen extends StatefulWidget {
  const SelectVehicleTypeScreen({super.key});

  @override
  State<SelectVehicleTypeScreen> createState() =>
      _SelectVehicleTypeScreenState();
}

class _SelectVehicleTypeScreenState extends State<SelectVehicleTypeScreen> {
  String? _selectedType;

  final List<Map<String, dynamic>> _vehicleTypes = [
    {
      'type': 'Car',
      'subtitle': 'Four Wheeler Vehicle',
      'image': 'assets/home_image/suv.png',
    },
    {
      'type': 'Van',
      'subtitle': 'Passengers & Cargo Vans',
      'image': 'assets/buy_image/van.png',
    },
    {
      'type': 'Truck',
      'subtitle': 'Commercial Trucks',
      'image': 'assets/buy_image/commercial.png',
    },
    {
      'type': 'Backhoe / Loader',
      'subtitle': 'Construction Vehicles',
      'image': 'assets/buy_image/backhoe.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Vehicle Type',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF01422D),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Choose the type of vehicle you want to Lease',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Column(
                            children: List.generate(_vehicleTypes.length, (index) {
                              final item = _vehicleTypes[index];
                              final isSelected = _selectedType == item['type'];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedType = item['type']),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF005F65)
                                            : const Color(0xFFb4b4b4),
                                        width: isSelected ? 1.2 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          item['image'],
                                          width: 70,
                                          height: 50,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['type'] as String,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                item['subtitle'] as String,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF989898),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const Spacer(),
                          Center(
                            child: SizedBox(
                              width: 300,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_selectedType == null) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => VehicleDetailsScreen(
                                        vehicleType: _selectedType!,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF005F65),
                                  disabledBackgroundColor: Color(0xFF005F65),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Save & Next',
                                  style: TextStyle(
                                    fontSize: 16,
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
            ),
          ),
        ],
      ),
    );
  }

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
            'Add New Vehicle',
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
}


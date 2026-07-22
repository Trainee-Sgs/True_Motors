import 'dart:io';
import 'package:flutter/material.dart';
import 'package:true_motors/lease_module/dashboard_screen.dart';
import 'package:true_motors/lease_module/listed_vehicles_manager.dart';
import 'package:true_motors/lease_module/select_vehicle_type_screen.dart';

class PreviewSubmitScreen extends StatelessWidget {
  final String vehicleType;
  final String brand;
  final String model;
  final String fuelType;
  final String transmission;
  final String year;
  final String kmDriven;
  final List<String> imagePaths;
  final String additionalInfo;
  final String state;
  final String city;
  final String area;
  final String rcPath;
  final String insurancePath;
  final String pollutionPath;
  final String leaseType;
  final String leaseDuration;
  final String noticePeriod;
  final String availableFrom;
  final String monthlyPrice;
  final String securityDeposit;
  final String includedKm;
  final String extraKmCharge;
  final List<String> selectedFeatures;

  const PreviewSubmitScreen({
    super.key,
    required this.vehicleType,
    required this.brand,
    required this.model,
    required this.fuelType,
    required this.transmission,
    required this.year,
    required this.kmDriven,
    required this.imagePaths,
    required this.additionalInfo,
    required this.state,
    required this.city,
    required this.area,
    required this.rcPath,
    required this.insurancePath,
    required this.pollutionPath,
    required this.leaseType,
    required this.leaseDuration,
    required this.noticePeriod,
    required this.availableFrom,
    required this.monthlyPrice,
    required this.securityDeposit,
    required this.includedKm,
    required this.extraKmCharge,
    required this.selectedFeatures,
  });

  // ── Vehicle type image asset ───────────────────────────────────────────────
  String _vehicleTypeImage() {
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

  void _onSubmit(BuildContext context) {
    // Save to manager
    ListedVehiclesManager().addVehicle(
      ListedVehicle(
        vehicleType: vehicleType,
        brand: brand,
        model: model,
        fuelType: fuelType,
        transmission: transmission,
        year: year,
        kmDriven: kmDriven,
        imagePaths: imagePaths,
        state: state,
        city: city,
        area: area,
        leaseType: leaseType,
        leaseDuration: leaseDuration,
        availableFrom: availableFrom,
        monthlyPrice: monthlyPrice,
        securityDeposit: securityDeposit,
        includedKm: includedKm,
        extraKmCharge: extraKmCharge,
        selectedFeatures: selectedFeatures,
        additionalInfo: additionalInfo,
      ),
    );

    // Show success popup
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/lease_image/thumb.png',
                width: 160,
                height: 160,
              ),
              const SizedBox(height: 18),
              const Text(
                'Vehicle Added Successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000A74),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your vehicle has been listed for lease,\nyou will receive request from\ninterested renters soon.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF3C3C3C),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              // Go to my Vehicle button
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    // Navigate to dashboard and show My Vehicles tab
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) =>
                        const LeaseVehicleDashboardScreen(
                            initialTab: 'my_vehicles'),
                      ),
                          (route) => route.isFirst,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005F65),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Go to my Vehicle',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Add New Vehicle button
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) =>
                        const SelectVehicleTypeScreen(),
                      ),
                          (route) => route.isFirst,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF005F65)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Add New Vehicle',
                    style: TextStyle(
                      color: Color(0xFF005F65),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    // Determine displayed image
    Widget vehicleImage;
    if (imagePaths.isNotEmpty) {
      vehicleImage = Image.file(
        File(imagePaths.first),
        width: 90,
        height: 70,
        fit: BoxFit.cover,
      );
    } else {
      vehicleImage = Image.asset(
        _vehicleTypeImage(),
        width: 90,
        height: 70,
        fit: BoxFit.contain,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(width),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preview & Submit',
                      style: TextStyle(
                        color: Color(0xFF01422D),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Please review your details before submitting',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),

                    // ── Vehicle card ──────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // Vehicle Info
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: vehicleImage,
                              ),
                              const SizedBox(width: 30),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$brand $model',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$kmDriven km | $fuelType | $transmission',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF979797),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),
                          _buildDetailRow(
                            'Location',
                            '$city, $state',
                          ),
                          _buildDivider(),

                          _buildDetailRow('Lease Type', leaseType),
                          _buildDivider(),

                          _buildDetailRow(
                            'Monthly Price',
                            '₹ ${_formatAmount(monthlyPrice)}',
                          ),
                          _buildDivider(),

                          _buildDetailRow(
                            'Security Deposit',
                            '₹ ${_formatAmount(securityDeposit)}',
                          ),
                          _buildDivider(),

                          _buildDetailRow(
                            'Available From',
                            availableFrom,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 280),

                    // ── Edit & Submit buttons ─────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(
                                  color: Color(0xFF005F65)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text(
                              'Edit',
                              style: TextStyle(
                                color: Color(0xFF005F65),
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _onSubmit(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF005F65),
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  // ── App bar ────────────────────────────────────────────────────────────────
  Widget _buildAppBar(double width) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Builder(builder: (context) {
        return Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back,
                  size: width * 0.06, color: const Color(0xFF01422D)),
              onPressed: () => Navigator.pop(context),
            ),
            const Text(
              'Add New Vehicle',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF01422D),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF969696),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Color(0xFFEEEEEE));
  }

  String _formatAmount(String raw) {
    final num? val = num.tryParse(raw);
    if (val == null) return raw;
    // Simple comma formatting
    final str = val.toStringAsFixed(0);
    final result = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) result.write(',');
      result.write(str[i]);
      count++;
    }
    return result.toString().split('').reversed.join();
  }
}
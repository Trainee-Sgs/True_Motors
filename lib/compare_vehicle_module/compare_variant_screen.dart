import 'package:flutter/material.dart';
import 'package:true_motors/app_drawer_module/compare_vehicle_screen.dart';

// ── Variant data per brand+model ───────────────────────────────────────────────
class _VariantData {
  final String variant;
  final String fuelType;
  final String imagePath;

  const _VariantData({
    required this.variant,
    required this.fuelType,
    required this.imagePath,
  });
}

// ── Static variant catalogue ───────────────────────────────────────────────────
// Add more brand/model combos here as needed.
final Map<String, List<_VariantData>> _variantCatalogue = {
  'Maruti Suzuki_Baleno': [
    _VariantData(
      variant: 'Alpha AGS',
      fuelType: 'Petrol',
      imagePath: 'assets/compare_image/baleno_alpha_ags.png',
    ),
    _VariantData(
      variant: 'Alpha MT',
      fuelType: 'Petrol',
      imagePath: 'assets/compare_image/baleno_alpha_mt.png',
    ),
    _VariantData(
      variant: 'Zeta CNG MT',
      fuelType: 'CNG',
      imagePath: 'assets/compare_image/baleno_zeta_cng.png',
    ),
    _VariantData(
      variant: 'Delta MT',
      fuelType: 'Petrol',
      imagePath: 'assets/compare_image/baleno_delta_mt.png',
    ),
  ],
  'Maruti Suzuki_Swift': [
    _VariantData(
      variant: 'VXI AMT',
      fuelType: 'Petrol',
      imagePath: 'assets/compare_image/swift.png',
    ),
    _VariantData(
      variant: 'ZXI+',
      fuelType: 'Petrol',
      imagePath: 'assets/compare_image/swift.png',
    ),
  ],
  'Maruti Suzuki_Brezza': [
    _VariantData(
      variant: 'LXI',
      fuelType: 'Petrol',
      imagePath: 'assets/compare_image/swift.png',
    ),
    _VariantData(
      variant: 'ZXI+',
      fuelType: 'Petrol',
      imagePath: 'assets/compare_image/swift.png',
    ),
  ],
  'TATA_Curvv': [
    _VariantData(
      variant: 'Smart',
      fuelType: 'Petrol',
      imagePath: 'assets/compare_image/tata_curvv_smart.png',
    ),
    _VariantData(
      variant: 'Pure +',
      fuelType: 'Petrol',
      imagePath: 'assets/compare_image/tata_curvv_pure.png',
    ),
    _VariantData(
      variant: 'Creative S',
      fuelType: 'CNG',
      imagePath: 'assets/compare_image/tata_curvv_creative.png',
    ),
    _VariantData(
      variant: 'Accomplished S',
      fuelType: 'CNG',
      imagePath: 'assets/compare_image/tata_curvv_accomplished.png',
    ),
  ],
  'TATA_Nexon': [
    _VariantData(
      variant: 'Smart',
      fuelType: 'Petrol',
      imagePath: 'assets/compare_image/hyundai.png',
    ),
    _VariantData(
      variant: 'Pure',
      fuelType: 'Diesel',
      imagePath: 'assets/compare_image/hyundai.png',
    ),
  ],
};

// ── Fallback variants when specific data isn't in the catalogue ───────────────
List<_VariantData> _fallbackVariants(String brand, String model) => [
  _VariantData(
    variant: 'Base Variant',
    fuelType: 'Petrol',
    imagePath: 'assets/compare_image/swift.png',
  ),
  _VariantData(
    variant: 'Mid Variant',
    fuelType: 'Petrol',
    imagePath: 'assets/compare_image/swift.png',
  ),
  _VariantData(
    variant: 'Top Variant',
    fuelType: 'Diesel',
    imagePath: 'assets/compare_image/swift.png',
  ),
];

class CompareVariantScreen extends StatefulWidget {
  final int slot;
  final String brand;
  final String model;

  const CompareVariantScreen({
    super.key,
    required this.slot,
    required this.brand,
    required this.model,
  });

  @override
  State<CompareVariantScreen> createState() => _CompareVariantScreenState();
}

class _CompareVariantScreenState extends State<CompareVariantScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<_VariantData> get _variants {
    final key = '${widget.brand}_${widget.model}';
    return _variantCatalogue[key] ??
        _fallbackVariants(widget.brand, widget.model);
  }

  List<_VariantData> get _filtered {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return _variants;
    return _variants
        .where((v) =>
    v.variant.toLowerCase().contains(q) ||
        v.fuelType.toLowerCase().contains(q))
        .toList();
  }

  void _selectVariant(_VariantData v) {
    final car = SelectedCar(
      brand: widget.brand,
      model: widget.model,
      variant: v.variant,
      fuelType: v.fuelType,
      imagePath: v.imagePath,
    );
    Navigator.pop(context, car);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
      body: SafeArea(
        child: Column(
          children: [
            // ── App bar ──────────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        size: 24, color: Color(0xFF01422D)),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Compare Vehicle',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF01442D),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      child: ClipRRect(
                        child: Image.asset(
                          'assets/compare_image/select_car.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Text(
                                'CARS FOR ALL NEEDS',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          // ── Search bar ───────────────────────────────────────
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF01422D),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25), // #00000040 = 25% opacity
                                  offset: const Offset(0, 4),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
                                hintText: 'Search variant',
                                hintStyle: TextStyle(
                                    color: Color(0xFF5F6368), fontSize: 15),
                                prefixIcon:
                                Icon(Icons.search, color: Color(0xFF5F6368)),
                                border: InputBorder.none,
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ── Selected brand / model header ────────────────────
                          Text(
                            'Select Variants',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.brand} / ${widget.model}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1B00B5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),

                          // ── Divider + variant list ───────────────────────────
                          if (filtered.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 32),
                                child: Text(
                                  'No variants found',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            ...filtered.map((v) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () => _selectVariant(v),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            v.variant,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            v.fuelType,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF918A8A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.black),
                                ],
                              );
                            }).toList(),
                        ],
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
}
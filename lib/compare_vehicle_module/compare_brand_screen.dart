import 'package:flutter/material.dart';
import 'package:true_motors/app_drawer_module/compare_vehicle_screen.dart';
import 'compare_variant_screen.dart';

class CompareBrandScreen extends StatefulWidget {
  final int slot; // 1 or 2

  const CompareBrandScreen({super.key, required this.slot});

  @override
  State<CompareBrandScreen> createState() => _CompareBrandScreenState();
}

class _CompareBrandScreenState extends State<CompareBrandScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _openBrand; // currently expanded brand key

  // ── Brand + model data ─────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _brands = [
    {
      'name': 'Maruti Suzuki',
      'models': ['Baleno', 'Brezza', 'Ciaz', 'Swift', 'Alto'],
    },
    {
      'name': 'TATA',
      'models': ['Curvv', 'Punch', 'Altroz', 'Harrier', 'Tiago'],
    },
    {
      'name': 'KIA',
      'models': ['Seltos', 'Sonet', 'Carens', 'EV6'],
    },
    {
      'name': 'Mahindra',
      'models': ['Thar', 'Scorpio', 'XUV700', 'Bolero'],
    },
    {
      'name': 'Renault',
      'models': ['Kwid', 'Triber', 'Kiger', 'Duster'],
    },
    {
      'name': 'Hyundai',
      'models': ['i20', 'Creta', 'Venue', 'Alcazar', 'Tucson'],
    },
    {
      'name': 'Skoda',
      'models': ['Kushaq', 'Slavia', 'Octavia', 'Superb'],
    },
    {
      'name': 'Jeep',
      'models': ['Compass', 'Meridian', 'Wrangler'],
    },
    {
      'name': 'Ford',
      'models': ['Figo', 'EcoSport', 'Endeavour'],
    },
    {
      'name': 'Toyota',
      'models': ['Fortuner', 'Innova', 'Camry', 'Urban Cruiser'],
    },
    {
      'name': 'Honda',
      'models': ['City', 'Amaze', 'Jazz', 'WRV'],
    },
    {
      'name': 'MG',
      'models': ['Hector', 'Astor', 'ZS EV', 'Gloster'],
    },
  ];

  List<Map<String, dynamic>> get _filteredBrands {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _brands;
    return _brands.where((b) {
      final brandMatch =
      (b['name'] as String).toLowerCase().contains(query);
      final modelMatch = (b['models'] as List<String>)
          .any((m) => m.toLowerCase().contains(query));
      return brandMatch || modelMatch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onModelTap(String brand, String model) async {
    // Navigate to variant screen and wait for selection
    final result = await Navigator.push<SelectedCar>(
      context,
      MaterialPageRoute(
        builder: (_) => CompareVariantScreen(
          slot: widget.slot,
          brand: brand,
          model: model,
        ),
      ),
    );
    if (result != null && mounted) {
      // Return selected car all the way back to CompareVehicleScreen
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredBrands;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 150,
                      margin: EdgeInsets.symmetric(horizontal: 0),
                      child: ClipRRect(
                        child: Image.asset(
                          'assets/compare_image/select_car.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
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
                                hintText: 'Search brand or model...',
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
                          const SizedBox(height: 18),

                          const Text(
                            'Select your car brand',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 12),

                          // ── Brand list with inline expandable model dropdown ──
                          ...filtered.map((brand) {
                            final brandName = brand['name'] as String;
                            final models = brand['models'] as List<String>;
                            final isOpen = _openBrand == brandName;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Brand header
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      _openBrand =
                                      isOpen ? null : brandName;
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isOpen
                                              ? const Color(0xFF005F65)
                                              : const Color(0xFFE2E2E2),
                                          width: isOpen ? 1 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            brandName,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Icon(
                                            isOpen
                                                ? Icons.arrow_drop_up
                                                : Icons.arrow_drop_down,
                                            color: const Color(0xFF742B88),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Model items — inline below brand header
                                  if (isOpen)
                                    Column(
                                      children: List.generate(models.length,
                                              (i) {
                                            final model = models[i];
                                            return GestureDetector(
                                              onTap: () => _onModelTap(
                                                  brandName, model),
                                              child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 14,
                                                    vertical: 14),
                                                decoration: BoxDecoration(
                                                  color:
                                                  const Color(0xFFF4F4F4),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xFFE2E2E2)),
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  model,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    )
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
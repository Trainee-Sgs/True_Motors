import 'package:flutter/material.dart';
import 'package:true_motors/app_drawer_module/home_screen.dart';
import 'package:true_motors/app_drawer_module/compare_vehicle_screen.dart';

// ── Spec data ─────────────────────────────────────────────────────────────────
class _SpecSection {
  final String title;
  final List<_SpecRow> rows;
  bool isExpanded;

  _SpecSection({
    required this.title,
    required this.rows,
    this.isExpanded = false,
  });
}

class _SpecRow {
  final String label;
  final String val1;
  final String val2;

  const _SpecRow(this.label, this.val1, this.val2);
}

// ── Fake spec data — replace with real API data as needed ─────────────────────
Map<String, dynamic> _fakeSpecs(String brand, String model) {
  if (brand == 'Maruti Suzuki') {
    return {
      'price': '9.2 Lakh',
      'seating': '5',
      'mileage': '20.1',
      'engine': '1197cc',
      'fuel': 'Petrol',
      'transmission': 'Manual',
    };
  }
  if (brand == 'TATA') {
    return {
      'price': '10.2 Lakh',
      'seating': '5',
      'mileage': '18.1',
      'engine': '1199cc',
      'fuel': 'Petrol',
      'transmission': 'Automatic',
    };
  }
  return {
    'price': '8.0 Lakh',
    'seating': '5',
    'mileage': '17.0',
    'engine': '1200cc',
    'fuel': 'Petrol',
    'transmission': 'Manual',
  };
}

class CompareResultScreen extends StatefulWidget {
  final SelectedCar car1;
  final SelectedCar car2;

  const CompareResultScreen({
    super.key,
    required this.car1,
    required this.car2,
  });

  @override
  State<CompareResultScreen> createState() => _CompareResultScreenState();
}

class _CompareResultScreenState extends State<CompareResultScreen> {
  late final Map<String, dynamic> _specs1;
  late final Map<String, dynamic> _specs2;
  late final List<_SpecSection> _sections;

  bool _isFavorite = false;
  int _selectedTabIndex = 0;

  final List<String> _tabs = [
    'Basic Information',
    'Engine & Transmission',
    'Fuel & Performance',
    'Safety & Security',
    'Entertainment & Infotainment',
    'Interior',
    'Exterior',
  ];

  @override
  void initState() {
    super.initState();
    _specs1 = _fakeSpecs(widget.car1.brand, widget.car1.model);
    _specs2 = _fakeSpecs(widget.car2.brand, widget.car2.model);

    _sections = [
      _SpecSection(
        title: 'Engine & Transmission',
        rows: [
          _SpecRow('Engine Type', 'Z12E', '1.2 Revotron'),
          _SpecRow('Displacement (cc)', '1197', '1199'),
          _SpecRow('No of Cylinders', '3', '3'),
          _SpecRow('Transmission Type', 'Manual', 'Manual'),
        ],
      ),
      _SpecSection(
        title: 'Fuel & Performance',
        rows: [
          _SpecRow('Fuel Type', _specs1['fuel'], _specs2['fuel']),
          _SpecRow('Mileage (kmpl)', _specs1['mileage'], _specs2['mileage']),
          _SpecRow('Fuel Tank Capacity', '37', '37'),
          _SpecRow('Emission Norm', 'BS VI 2.0', 'BS VI 2.0'),
        ],
      ),
      _SpecSection(
        title: 'Safety & Security',
        rows: [
          _SpecRow('Airbags', '6', '6'),
          _SpecRow('ABS', 'Yes', 'Yes'),
          _SpecRow('EBD', 'Yes', 'Yes'),
        ],
      ),
      _SpecSection(
        title: 'Entertainment & Infotainment',
        rows: [
          _SpecRow('Touchscreen Size', '9 inch', '10.25 inch'),
          _SpecRow('Android Auto', 'Yes', 'Yes'),
          _SpecRow('Apple CarPlay', 'Yes', 'Yes'),
        ],
      ),
      _SpecSection(
        title: 'Interior',
        rows: [
          _SpecRow('Seating Capacity', _specs1['seating'], _specs2['seating']),
          _SpecRow('Sunroof', 'No', 'Yes'),
          _SpecRow('Gear Indicator', 'Yes', 'Yes'),
        ],
      ),
      _SpecSection(
        title: 'Exterior',
        rows: [
          _SpecRow('Alloy Wheels', 'Yes', 'Yes'),
          _SpecRow('LED DRLs', 'Yes', 'Yes'),
          _SpecRow('Fog Lamps', 'Yes', 'Yes'),
        ],
      ),
    ];
  }

  // ── Returns the rows to display in the table for the selected tab ──────────
  List<_SpecRow> _getTabRows() {
    switch (_selectedTabIndex) {
      case 0: // Basic Information
        return [
          _SpecRow('Price', _specs1['price'] as String, _specs2['price'] as String),
          _SpecRow('Seating', _specs1['seating'] as String, _specs2['seating'] as String),
          _SpecRow('Mileage', _specs1['mileage'] as String, _specs2['mileage'] as String),
          _SpecRow('Engine', _specs1['engine'] as String, _specs2['engine'] as String),
          _SpecRow('Fuel', _specs1['fuel'] as String, _specs2['fuel'] as String),
          _SpecRow('Transmission', _specs1['transmission'] as String, _specs2['transmission'] as String),
        ];
      case 1: // Engine & Transmission
        return _sections[0].rows;
      case 2: // Fuel & Performance
        return _sections[1].rows;
      case 3: // Safety & Security
        return _sections[2].rows;
      case 4: // Entertainment & Infotainment
        return _sections[3].rows;
      case 5: // Interior
        return _sections[4].rows;
      case 6: // Exterior
        return _sections[5].rows;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCarHeader(),
                    _buildTabsAndTable(),
                    _buildRentBanner(),
                    ..._sections.map((s) => _buildAccordionSection(s)),
                    _buildLatestNews(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
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
            child: const Icon(Icons.arrow_back,
                size: 24, color: Color(0xFF01422D)),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Compare Vehicle',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF01442D),
              ),
            ),
          ),
          const Icon(Icons.share_outlined,
              size: 22, color: Color(0xFF01422D)),
        ],
      ),
    );
  }

  // ── Car Header ────────────────────────────────────────────────────────────
  Widget _buildCarHeader() {
    const double bgHeight = 95;
    const double imgHeight = 145;
    const double imgWidth = 190;
    const double stackHeight = imgHeight;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: stackHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Background halves
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: bgHeight,
                child: Row(
                  children: [
                    Expanded(child: Container(color: const Color(0xFFEB4D4D))),
                    Expanded(child: Container(color: const Color(0xFF4D4C4C))),
                  ],
                ),
              ),
              // Heart toggle
              Positioned(
                top: 8,
                right: 15,
                child: GestureDetector(
                  onTap: () => setState(() => _isFavorite = !_isFavorite),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: _isFavorite ? Colors.red : Colors.white,
                  ),
                ),
              ),
              // Car images
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: imgHeight,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 5),
                        child: Image.asset(
                          'assets/compare_image/alpha_ags.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 10),
                        child: Image.asset(
                          'assets/compare_image/tata_curvv.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Car name labels
        Row(
          children: [
            Expanded(child: _buildCarNameLabel(widget.car1)),
            Expanded(child: _buildCarNameLabel(widget.car2)),
          ],
        ),
      ],
    );
  }

  Widget _buildCarNameLabel(SelectedCar car) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: '${car.brand} ',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: car.model,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tabs (outside) + Table (separate below) ───────────────────────────────
  Widget _buildTabsAndTable() {
    final rows = _getTabRows();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Horizontally scrollable gradient tab bar — standalone ──
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFFFFFFF), Color(0xFFFFEAA4)],
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  return _buildTabChip(_tabs[i], _selectedTabIndex == i, i);
                }),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // ── Table — separate container with border ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF9A9A9A), width: 1),
              ),
              child: Column(
                children: rows.asMap().entries.map((entry) {
                  final i = entry.key;
                  final row = entry.value;
                  final isLast = i == rows.length - 1;
                  final isPriceRow = row.label == 'Price';
                  return _buildTableRow(
                    label: row.label,
                    val1: row.val1,
                    val2: row.val2,
                    isLast: isLast,
                    isPriceRow: isPriceRow,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(String label, bool selected, int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? const Color(0xFF742B88) : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        child: Text(label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow({
    required String label,
    required String val1,
    required String val2,
    bool isLast = false,
    bool isPriceRow = false,
  }) {
    const valueStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFF040084),
    );
    const labelStyle = TextStyle(
      fontSize: 13,
      color: Colors.black,
      fontWeight: FontWeight.w500
    );
    const borderColor = Color(0xFF9A9A9A);

    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(
              width: 110,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 12),
                child: Text(label, style: labelStyle),
              ),
            ),
            // Vertical divider
            Container(width: 1, color: borderColor),
            // Val 1
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 12),
                child: isPriceRow
                    ? RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: '₹ ',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF040084),
                              ),
                            ),
                            TextSpan(text: val1, style: valueStyle),
                          ],
                        ),
                      )
                    : Text(val1, style: valueStyle, textAlign: TextAlign.center),
              ),
            ),
            // Vertical divider
            Container(width: 1, color: borderColor),
            // Val 2
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 12),
                child: isPriceRow
                    ? RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: '₹ ',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF040084),
                              ),
                            ),
                            TextSpan(text: val2, style: valueStyle),
                          ],
                        ),
                      )
                    : Text(val2, style: valueStyle, textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRentBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        child: SizedBox(
          height: 150,
          width: double.infinity,
          child: Image.asset('assets/home_image/rent_banner.png',
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  // ── Accordion sections ────────────────────────────────────────────────────
  Widget _buildAccordionSection(_SpecSection section) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFACA9A9)
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                setState(() => section.isExpanded = !section.isExpanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Icon(
                    section.isExpanded ? Icons.remove : Icons.add,
                    color: Colors.black,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (section.isExpanded) ...[
            Divider(height: 1, thickness: 1, color: Color(0xFFACA9A9)),
            Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCAC1C1)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: section.rows.asMap().entries.map((entry) {
                  final i = entry.key;
                  final row = entry.value;
                  final isLast = i == section.rows.length - 1;
                  return Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 130,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  row.label,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF808080),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                width: 1, color: const Color(0xFFCAC1C1)),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  row.val1,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                width: 1, color: const Color(0xFFCAC1C1)),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  row.val2,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isLast)
                        Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xFFCAC1C1)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Latest News ──────────────────────────────────────────────────────────
  Widget _buildLatestNews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text(
            'Latest News & Updates',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildNewsCard(
                'assets/compare_image/suzuki_vitara.png',
                'The Maruti Suzuki e VITARA is equipped with an armada of safety features.',
              ),
              _buildNewsCard(
                'assets/compare_image/suzuki_jeep.png',
                'The Maruti Suzuki Jimmy is equipped with an armada of safety features.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewsCard(String imagePath, String text) {
    return Container(
      width: 210,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Color(0xFFC4BEBE)),
        borderRadius: BorderRadius.circular(8),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.asset(
              imagePath,
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 90,
                color: Colors.grey.shade200,
                child: const Icon(Icons.directions_car, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(
                  text,
                  style: const TextStyle(fontSize: 11, height: 1.4, fontWeight: FontWeight.w500),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Learn More......',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF742B88),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom nav ───────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    const selectedIndex = 3;
    final items = [
      {'image': 'assets/icons/home.png', 'label': 'Home'},
      {'image': 'assets/icons/buy.png', 'label': 'Buy'},
      {'image': 'assets/icons/sell.png', 'label': 'Sell'},
      {'image': 'assets/icons/compare.png', 'label': 'Compare'},
    ];

    return Container(
      decoration: const BoxDecoration(color: Color(0xFF005F65)),
      child: SafeArea(
        child: SizedBox(
          height: 65,
          child: Row(
            children: List.generate(items.length, (i) {
              final isSelected = selectedIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (i == 3) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(initialIndex: i),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 4),
                      Image.asset(
                        items[i]['image'] as String,
                        width: isSelected ? 28 : 24,
                        height: isSelected ? 28 : 24,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        items[i]['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.white60,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 3,
                        width: isSelected ? 40 : 0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
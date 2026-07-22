import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:true_motors/menu_module/listing_manager.dart';
import 'sell_car_photo_screen.dart';

class SellCarFormScreen extends StatefulWidget {
  final String registrationNumber;
  final String vehicleType;
  final int? vehicleCategoryId;
  // When set, we are editing an existing listing instead of creating new
  final String? editingListingId;

  const SellCarFormScreen({
    super.key,
    required this.registrationNumber,
    required this.vehicleType,
    this.vehicleCategoryId,
    this.editingListingId,
  });

  @override
  State<SellCarFormScreen> createState() => _SellCarFormScreenState();
}

class _SellCarFormScreenState extends State<SellCarFormScreen> {
  // ── Selected values ────────────────────────────────────────────────────────
  String? _selectedBrand;
  String? _selectedModel;
  String? _selectedFuelType;
  String? _selectedTransmission;
  String? _selectedRegYear;
  String? _selectedLocation;
  String? _selectedRTO;
  final List<String> _selectedFeatures = [];

  // ── Which dropdown is currently open ──────────────────────────────────────
  String? _openDropdown;

  // ── Text controllers ───────────────────────────────────────────────────────
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _insuranceController = TextEditingController();

  // ── Text field errors ──────────────────────────────────────────────────────
  String? _kmError;
  String? _priceError;
  String? _insuranceError;

  // ── Lists ──────────────────────────────────────────────────────────────────
  final List<String> _brands = [
    'Maruti Suzuki',
    'Tata',
    'Kia',
    'Honda',
    'Hyundai',
  ];
  final List<String> _models = [
    'Baleno',
    'Brezza',
    'Ciaz',
    'Swift',
    'Alto',
  ];
  final List<String> _fuelTypes = [
    'Petrol',
    'Diesel',
    'Electric',
    'CNG',
    'LPG'
  ];
  final List<String> _transmissions = ['Manual', 'Automatic', 'AMT', 'DCT'];
  final List<String> _years =
  List.generate(20, (i) => (2024 - i).toString());
  final List<String> _locations = [
    'Coimbatore',
    'Chennai',
    'Bangalore',
    'Hyderabad',
    'Mumbai',
  ];
  final List<String> _rtos = [
    'TN 57',
    'TN 01',
    'TN 33',
    'TN 11',
    'TN 58',
  ];
  final List<String> _features = [
    'Air Conditioning',
    'Power Steering',
    'Airbags',
    'Bluetooth',
  ];

  // ── Field limits ───────────────────────────────────────────────────────────
  static const int _maxKmDigits = 7;
  static const int _maxPriceDigits = 8;

  @override
  void initState() {
    super.initState();
    // Pre-fill form if editing an existing listing
    if (widget.editingListingId != null) {
      final existing = ListingManager()
          .allListings
          .where((l) => l.id == widget.editingListingId)
          .firstOrNull;
      if (existing != null) {
        _selectedBrand = existing.brand;
        _selectedModel = existing.model;
        _selectedFuelType = existing.fuelType;
        _selectedTransmission = existing.transmission;
        _selectedRegYear = existing.regYear;
        _selectedLocation = existing.location;
        _selectedRTO = existing.rto;
        _selectedFeatures.addAll(existing.features);
        _kmController.text = existing.kmDriven;
        _priceController.text = existing.price;
        _insuranceController.text = existing.insuranceDate;
      }
    }
  }

  @override
  void dispose() {
    _kmController.dispose();
    _priceController.dispose();
    _insuranceController.dispose();
    super.dispose();
  }

  void _toggleDropdown(String key) {
    setState(() => _openDropdown = _openDropdown == key ? null : key);
  }

  bool _validateTextFields() {
    bool valid = true;
    setState(() {
      final km = _kmController.text.trim();
      if (km.isEmpty) {
        _kmError = 'Please enter kilometers driven';
        valid = false;
      } else {
        final val = int.tryParse(km);
        if (val == null || val <= 0) {
          _kmError = 'Enter a valid number greater than 0';
          valid = false;
        } else {
          _kmError = null;
        }
      }

      final price = _priceController.text.trim();
      if (price.isEmpty) {
        _priceError = 'Please enter a price';
        valid = false;
      } else {
        final val = int.tryParse(price);
        if (val == null || val <= 0) {
          _priceError = 'Enter a valid price greater than 0';
          valid = false;
        } else {
          _priceError = null;
        }
      }

      if (_insuranceController.text.trim().isEmpty) {
        _insuranceError = 'Please select insurance validity date';
        valid = false;
      } else {
        _insuranceError = null;
      }
    });
    return valid;
  }

  List<String> _missingDropdowns() {
    final missing = <String>[];
    if (_selectedBrand == null) missing.add('Brand');
    if (_selectedModel == null) missing.add('Model');
    if (_selectedFuelType == null) missing.add('Fuel Type');
    if (_selectedTransmission == null) missing.add('Transmission');
    if (_selectedRegYear == null) missing.add('Registration Year');
    if (_selectedLocation == null) missing.add('Location');
    if (_selectedRTO == null) missing.add('RTO');
    return missing;
  }

  void _onSaveAndNext() {
    FocusScope.of(context).unfocus();
    setState(() => _openDropdown = null);

    final missing = _missingDropdowns();
    final bool textFieldsValid = _validateTextFields();

    if (missing.isNotEmpty || !textFieldsValid || _selectedFeatures.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please fill all fields',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: const Color(0xFF323232),
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(seconds: 2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      );
      return;
    }

    if (widget.editingListingId != null) {
      // Editing mode — update the listing directly and pop back to My Listing
      final existing = ListingManager()
          .allListings
          .where((l) => l.id == widget.editingListingId)
          .firstOrNull;
      if (existing != null) {
        final updated = existing.copyWith(
          brand: _selectedBrand,
          model: _selectedModel,
          fuelType: _selectedFuelType,
          transmission: _selectedTransmission,
          regYear: _selectedRegYear,
          kmDriven: _kmController.text.trim(),
          location: _selectedLocation,
          rto: _selectedRTO,
          price: _priceController.text.trim(),
          insuranceDate: _insuranceController.text.trim(),
          features: List<String>.from(_selectedFeatures),
        );
        ListingManager().updateListing(widget.editingListingId!, updated);
      }
      // Pop back to My Listing
      Navigator.pop(context);
    } else {
      // New listing — continue to photo screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SellCarPhotoScreen(
            registrationNumber: widget.registrationNumber,
            vehicleType: widget.vehicleType,
            brand: _selectedBrand!,
            model: _selectedModel!,
            fuelType: _selectedFuelType!,
            transmission: _selectedTransmission!,
            regYear: _selectedRegYear!,
            kmDriven: _kmController.text.trim(),
            location: _selectedLocation!,
            rto: _selectedRTO!,
            price: _priceController.text.trim(),
            insuranceDate: _insuranceController.text.trim(),
            features: _selectedFeatures,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() => _openDropdown = null);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F3F3),
        resizeToAvoidBottomInset: true,
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
                      _buildPromoBanner(width, height),
                      SizedBox(height: height * 0.015),

                      Text(
                        widget.editingListingId != null
                            ? 'Edit Vehicle - ${widget.registrationNumber}'
                            : 'Sell Vehicle - ${widget.registrationNumber}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: height * 0.005),
                      const Text(
                        'Add Or Edit Vehicle',
                        style:
                        TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      SizedBox(height: height * 0.02),

                      // ── Dropdowns ─────────────────────────────────────────
                      _buildInlineDropdown(
                        key: 'brand',
                        label: 'Select Brand',
                        value: _selectedBrand,
                        items: _brands,
                        width: width,
                        onSelected: (v) => setState(() {
                          _selectedBrand = v;
                          _openDropdown = null;
                        }),
                      ),
                      _buildInlineDropdown(
                        key: 'model',
                        label: 'Select Model',
                        value: _selectedModel,
                        items: _models,
                        width: width,
                        onSelected: (v) => setState(() {
                          _selectedModel = v;
                          _openDropdown = null;
                        }),
                      ),
                      _buildInlineDropdown(
                        key: 'fuel',
                        label: 'Fuel Type',
                        value: _selectedFuelType,
                        items: _fuelTypes,
                        width: width,
                        onSelected: (v) => setState(() {
                          _selectedFuelType = v;
                          _openDropdown = null;
                        }),
                      ),
                      _buildInlineDropdown(
                        key: 'transmission',
                        label: 'Transmission',
                        value: _selectedTransmission,
                        items: _transmissions,
                        width: width,
                        onSelected: (v) => setState(() {
                          _selectedTransmission = v;
                          _openDropdown = null;
                        }),
                      ),
                      _buildInlineDropdown(
                        key: 'year',
                        label: 'Registration Year',
                        value: _selectedRegYear,
                        items: _years,
                        width: width,
                        onSelected: (v) => setState(() {
                          _selectedRegYear = v;
                          _openDropdown = null;
                        }),
                      ),

                      // ── Kilometers Driven ─────────────────────────────────
                      _buildFloatingTextField(
                        label: 'Kilometers Driven',
                        controller: _kmController,
                        error: _kmError,
                        width: width,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(_maxKmDigits),
                        ],
                        onChanged: (_) => setState(() => _kmError = null),
                      ),

                      _buildInlineDropdown(
                        key: 'location',
                        label: 'Select Location',
                        value: _selectedLocation,
                        items: _locations,
                        width: width,
                        onSelected: (v) => setState(() {
                          _selectedLocation = v;
                          _openDropdown = null;
                        }),
                      ),
                      _buildInlineDropdown(
                        key: 'rto',
                        label: 'Select RTO',
                        value: _selectedRTO,
                        items: _rtos,
                        width: width,
                        onSelected: (v) => setState(() {
                          _selectedRTO = v;
                          _openDropdown = null;
                        }),
                      ),

                      // ── Price ─────────────────────────────────────────────
                      _buildFloatingTextField(
                        label: 'Price',
                        controller: _priceController,
                        error: _priceError,
                        width: width,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(_maxPriceDigits),
                        ],
                        onChanged: (_) => setState(() => _priceError = null),
                      ),

                      // ── Insurance Validity Date ───────────────────────────
                      _buildFloatingTextField(
                        label: 'Insurance Validity Date',
                        controller: _insuranceController,
                        error: _insuranceError,
                        width: width,
                        readOnly: true,
                        suffixIcon: const Icon(Icons.calendar_month_outlined,
                            color: Color(0xFF742B88), size: 20),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate:
                            DateTime.now().add(const Duration(days: 30)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2035),
                            builder: (ctx, child) => Theme(
                              data: Theme.of(ctx).copyWith(
                                colorScheme: const ColorScheme.light(
                                    primary: Color(0xFF005F65)),
                              ),
                              child: child!,
                            ),
                          );
                          if (picked != null) {
                            _insuranceController.text =
                            '${picked.day}/${picked.month}/${picked.year}';
                            setState(() => _insuranceError = null);
                          }
                        },
                      ),

                      // ── Feature Checklist (multi-select) ──────────────────
                      _buildMultiSelectDropdown(width),

                      SizedBox(height: height * 0.04),

                      Center(
                        child: SizedBox(
                          width: 230,
                          child: ElevatedButton(
                            onPressed: _onSaveAndNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF005F65),
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.018),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            child: Text(
                              widget.editingListingId != null
                                  ? 'Save Changes'
                                  : 'Save & Next',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── App bar ────────────────────────────────────────────────────────────────
  Widget _buildAppBar(double width) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back,
                size: width * 0.06, color: const Color(0xFF01422D)),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            widget.editingListingId != null ? 'Edit Listing' : 'Sell car',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF01422D),
                fontFamily: 'Poppins'),
          ),
        ],
      ),
    );
  }

  // ── Promo banner ───────────────────────────────────────────────────────────
  Widget _buildPromoBanner(double width, double height) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFF00274B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/sell_image/red_car.png',
            width: 136,
            height: 124,
            fit: BoxFit.contain,
          ),
          SizedBox(width: width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Sell Your Car Instantly',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Calistoga',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Best price,Free inspection.\nInstant payment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Calistoga',
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.015),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Get Free Quote',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Calistoga',
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineDropdown({
    required String key,
    required String label,
    required String? value,
    required List<String> items,
    required double width,
    required ValueChanged<String> onSelected,
  }) {
    final isOpen = _openDropdown == key;
    final hasValue = value != null;

    return Container(
      margin: EdgeInsets.only(bottom: width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Floating label above — only when value is selected
          if (hasValue)
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF005F65),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // Header — shows placeholder when nothing selected, selected value otherwise
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              _toggleDropdown(key);
            },
            child: Container(
              height: width * 0.12,
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isOpen
                      ? const Color(0xFF005F65)
                      : const Color(0xFFE2E2E2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      hasValue ? value : label,
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: const Color(0xFF742B88),
                  ),
                ],
              ),
            ),
          ),

          // Items — flush below header
          if (isOpen)
            Column(
              children: List.generate(items.length, (index) {
                final item = items[index];

                return GestureDetector(
                  onTap: () => onSelected(item),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03,
                      vertical: width * 0.03,
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xFFF4F4F4),
                        border: Border.all(color: Color(0xFFE2E2E2)),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectDropdown(double width) {
    const key = 'feature';
    final isOpen = _openDropdown == key;
    final hasValue = _selectedFeatures.isNotEmpty;

    final displayText =
    hasValue ? _selectedFeatures.join(', ') : 'Feature Checklist';

    return Container(
      margin: EdgeInsets.only(bottom: width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Floating label above — only when features are selected
          if (hasValue)
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 4),
              child: Text(
                'Feature Checklist',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF005F65),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // Header
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              _toggleDropdown(key);
            },
            child: Container(
              height: width * 0.12,
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isOpen
                      ? const Color(0xFF005F65)
                      : const Color(0xFFE2E2E2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      displayText,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: const Color(0xFF742B88),
                  ),
                ],
              ),
            ),
          ),

          // Items with checkbox on right
          if (isOpen)
            Column(
              children: List.generate(_features.length, (index) {
                final item = _features[index];
                final isSelected = _selectedFeatures.contains(item);

                return GestureDetector(
                  onTap: () => setState(() {
                    if (isSelected) {
                      _selectedFeatures.remove(item);
                    } else {
                      _selectedFeatures.add(item);
                    }
                  }),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03,
                      vertical: width * 0.015,
                    ),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        border: Border.all(color: const Color(0xFFE2E2E2)),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Checkbox(
                          value: isSelected,
                          activeColor: const Color(0xFF005F65),
                          side: const BorderSide(color: Colors.black),
                          checkColor: Colors.white,
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          onChanged: (val) => setState(() {
                            if (val == true) {
                              _selectedFeatures.add(item);
                            } else {
                              _selectedFeatures.remove(item);
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  // ── Floating label text field ──────────────────────────────────────────────
  Widget _buildFloatingTextField({
    required String label,
    required TextEditingController controller,
    required double width,
    String? error,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    Widget? suffixIcon,
    ValueChanged<String>? onChanged,
    VoidCallback? onTap,
  }) {
    final bool hasText = controller.text.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasText)
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: error != null
                      ? const Color(0xFFB00020)
                      : const Color(0xFF005F65),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            readOnly: readOnly,
            onChanged: (v) {
              onChanged?.call(v);
              setState(() {});
            },
            onTap: onTap,
            enableInteractiveSelection: !readOnly,
            style: TextStyle(
              fontSize: width * 0.035,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hasText ? '' : label,
              hintStyle: TextStyle(
                fontSize: width * 0.035,
                color: const Color(0xFFB4B4B4),
              ),
              errorText: error,
              errorStyle: const TextStyle(fontSize: 12),
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                horizontal: width * 0.03,
                vertical: width * 0.03,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: error != null
                      ? const Color(0xFFB00020)
                      : const Color(0xFFE2E2E2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                const BorderSide(color: Color(0xFF005F65)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFB00020)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                const BorderSide(color: Color(0xFFB00020)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
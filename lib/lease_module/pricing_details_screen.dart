import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:true_motors/lease_module/features_description_screen.dart';

class PricingDetailsScreen extends StatefulWidget {
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

  const PricingDetailsScreen({
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
  });

  @override
  State<PricingDetailsScreen> createState() => _PricingDetailsScreenState();
}

class _PricingDetailsScreenState extends State<PricingDetailsScreen> {
  // ── Controllers ─────────────────────────────────────────────────────────
  final TextEditingController _monthlyPriceController =
  TextEditingController();
  final TextEditingController _includedKmController =
  TextEditingController();
  final TextEditingController _extraKmChargeController =
  TextEditingController();

  String? _selectedSecurityDeposit;

  // ── Errors ───────────────────────────────────────────────────────────────
  String? _monthlyPriceError;
  String? _includedKmError;
  String? _extraKmChargeError;

  // ── Which dropdown is currently open ──────────────────────────────────────
  String? _openDropdown;

  final List<String> _securityDepositOptions = const [
    '₹5,000',
    '₹10,000',
    '₹15,000',
    '₹20,000',
    '₹25,000',
    '1 Month Lease Amount',
    '2 Months Lease Amount',
  ];

  @override
  void dispose() {
    _monthlyPriceController.dispose();
    _includedKmController.dispose();
    _extraKmChargeController.dispose();
    super.dispose();
  }

  void _toggleDropdown(String key) {
    setState(() => _openDropdown = _openDropdown == key ? null : key);
  }

  bool _validate() {
    bool valid = true;
    setState(() {
      final price = _monthlyPriceController.text.trim();
      if (price.isEmpty || (int.tryParse(price) ?? 0) <= 0) {
        _monthlyPriceError = 'Enter a valid monthly lease price';
        valid = false;
      } else {
        _monthlyPriceError = null;
      }

      if (_selectedSecurityDeposit == null) valid = false;

      final km = _includedKmController.text.trim();
      if (km.isEmpty || (int.tryParse(km) ?? 0) <= 0) {
        _includedKmError = 'Enter included KM per month';
        valid = false;
      } else {
        _includedKmError = null;
      }

      final extra = _extraKmChargeController.text.trim();
      if (extra.isEmpty || (int.tryParse(extra) ?? 0) <= 0) {
        _extraKmChargeError = 'Enter extra KM charge';
        valid = false;
      } else {
        _extraKmChargeError = null;
      }
    });
    return valid;
  }

  void _onSaveAndNext() {
    FocusScope.of(context).unfocus();
    setState(() => _openDropdown = null);

    if (!_validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all fields',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Color(0xFF323232),
          behavior: SnackBarBehavior.fixed,
          duration: Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeaturesDescriptionScreen(
          vehicleType: widget.vehicleType,
          brand: widget.brand,
          model: widget.model,
          fuelType: widget.fuelType,
          transmission: widget.transmission,
          year: widget.year,
          kmDriven: widget.kmDriven,
          imagePaths: widget.imagePaths,
          additionalInfo: widget.additionalInfo,
          state: widget.state,
          city: widget.city,
          area: widget.area,
          rcPath: widget.rcPath,
          insurancePath: widget.insurancePath,
          pollutionPath: widget.pollutionPath,
          leaseType: widget.leaseType,
          leaseDuration: widget.leaseDuration,
          noticePeriod: widget.noticePeriod,
          availableFrom: widget.availableFrom,
          monthlyPrice: _monthlyPriceController.text.trim(),
          includedKm: _includedKmController.text.trim(),
          extraKmCharge: _extraKmChargeController.text.trim(),
        ),
      ),
    );
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
        backgroundColor: const Color(0xFFF2F2F2),
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
                      const Text(
                        'Pricing Details',
                        style: TextStyle(
                          color: Color(0xFF01422D),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      const Text(
                        'Set your Pricing and Deposits',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(height: height * 0.02),

                      // ── Monthly Lease Price ─────────────────────────────
                      _buildLabeledTextField(
                        label: 'Monthly Lease Price',
                        controller: _monthlyPriceController,
                        placeholder: 'Enter amount',
                        prefixText: '₹  ',
                        width: width,
                        error: _monthlyPriceError,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(7),
                        ],
                        onChanged: (_) =>
                            setState(() => _monthlyPriceError = null),
                      ),

                      // ── Security Deposit ─────────────────────────────────
                      _buildLabeledDropdown(
                        keyId: 'deposit',
                        label: 'Security Deposit',
                        placeholder: 'Enter amount',
                        prefixText: '₹  ',
                        value: _selectedSecurityDeposit,
                        items: _securityDepositOptions,
                        width: width,
                        onSelected: (v) => setState(() {
                          _selectedSecurityDeposit = v;
                          _openDropdown = null;
                        }),
                      ),

                      // ── Included KM per Month ───────────────────────────
                      _buildLabeledTextField(
                        label: 'Included KM per Month',
                        controller: _includedKmController,
                        placeholder: 'Enter KM',
                        suffixText: 'km',
                        width: width,
                        error: _includedKmError,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        onChanged: (_) =>
                            setState(() => _includedKmError = null),
                      ),

                      // ── Extra KM Charge ──────────────────────────────────
                      _buildLabeledTextField(
                        label: 'Extra KM Charge',
                        controller: _extraKmChargeController,
                        placeholder: 'Enter amount',
                        prefixText: '₹  ',
                        width: width,
                        error: _extraKmChargeError,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5),
                        ],
                        onChanged: (_) =>
                            setState(() => _extraKmChargeError = null),
                      ),

                      SizedBox(height: height * 0.25),

                      // ── Previous & Save and Next buttons ──────────────────
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                                side: const BorderSide(
                                    color: Color(0xFF005F65), width: 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10)),
                              ),
                              child: const Text(
                                'Previous',
                                style: TextStyle(
                                  color: Color(0xFF005F65),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.04),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _onSaveAndNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF005F65),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Save & Next',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
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
      ),
    );
  }

  // ── Labeled dropdown ───────────────────────────────────────────────────────
  Widget _buildLabeledDropdown({
    required String keyId,
    required String label,
    required String placeholder,
    required String? value,
    required List<String> items,
    required double width,
    required ValueChanged<String> onSelected,
    String? prefixText,
  }) {
    final isOpen = _openDropdown == keyId;
    final hasValue = value != null;

    return Container(
      margin: EdgeInsets.only(bottom: width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: width * 0.02),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              _toggleDropdown(keyId);
            },
            child: Container(
              height: width * 0.12,
              padding:
              EdgeInsets.symmetric(horizontal: width * 0.03),
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
                    child: Row(
                      children: [
                        if (prefixText != null)
                          Text(
                            prefixText,
                            style: TextStyle(
                              fontSize: width * 0.035,
                              color: hasValue
                                  ? Colors.black
                                  : const Color(0xFFB4B4B4),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            hasValue ? value : placeholder,
                            style: TextStyle(
                              fontSize: width * 0.035,
                              color: hasValue
                                  ? Colors.black
                                  : const Color(0xFFB4B4B4),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
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
          if (isOpen && items.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: width * 0.02),
              constraints: BoxConstraints(maxHeight: width * 0.6),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                border: Border.all(color: const Color(0xFFE2E2E2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  return InkWell(
                    onTap: () => onSelected(item),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03,
                        vertical: width * 0.03,
                      ),
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
            ),
        ],
      ),
    );
  }

  // ── Labeled text field ──────────────────────────────────────────────────
  Widget _buildLabeledTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required double width,
    String? error,
    bool readOnly = false,
    Widget? suffixIcon,
    String? prefixText,
    String? suffixText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: width * 0.02),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            onTap: onTap,
            style: TextStyle(
              fontSize: width * 0.035,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: placeholder,
              hintStyle: TextStyle(
                fontSize: width * 0.035,
                color: const Color(0xFFB4B4B4),
              ),
              prefixText: prefixText,
              suffixText: suffixText,
              errorText: error,
              errorStyle: const TextStyle(fontSize: 12),
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                horizontal: width * 0.03,
                vertical: width * 0.035,
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
                borderSide:
                const BorderSide(color: Color(0xFFB00020)),
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
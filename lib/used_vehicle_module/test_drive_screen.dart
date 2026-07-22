import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'buy_car.dart'; // for CarListingCard, CarListing

// ─── Test Drive Screen ────────────────────────────────────────────────────────

class TestDriveScreen extends StatefulWidget {
  const TestDriveScreen({super.key});

  @override
  State<TestDriveScreen> createState() => _TestDriveScreenState();
}

class _TestDriveScreenState extends State<TestDriveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeSlotController = TextEditingController();

  String? _selectedVehicle;
  String? _selectedLocation;
  bool _bookingSuccess = false;
  bool _isCardFav = false; // ← favorite state for the summary card
  DateTime? _selectedDate;

  // The car shown in the summary card
  static const _car = CarListing(
    name: 'Maruti Suzuki Swift VXI 2021',
    km: 25000,
    fuel: 'Petrol',
    transmission: 'Manual',
    price: 9.2,
    emi: 13470,
    location: 'Coimbatore',
    imagePath: 'assets/buy_car/suzuki.png',
  );

  final List<String> _vehicleOptions = [
    'Maruti Suzuki Swift VXI 2021',
    'Maruti Suzuki Baleno',
    'Hyundai Creta 2023',
    'Tata Nexon',
    'Honda City',
  ];

  final List<String> _locationOptions = [
    'Coimbatore',
    'Chennai',
    'Bangalore',
    'Madurai',
    'Salem',
  ];

  final List<String> _timeSlots = [
    '9:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '2:00 PM - 3:00 PM',
    '3:00 PM - 4:00 PM',
    '4:00 PM - 5:00 PM',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    _timeSlotController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1A3A5C),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF333333),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
        '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
      });
    }
  }

  void _submitTestDrive() {
    if (_formKey.currentState!.validate()) {
      setState(() => _bookingSuccess = true);
    }
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
              height: statusBarHeight, color: Colors.transparent,
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: _bookingSuccess
                    ? _buildSuccessScreen(context)
                    : Column(
                  children: [
                    _buildTopBar(context),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Car summary using shared CarListingCard ────────
                              CarListingCard(
                                car: _car,
                                isFav: _isCardFav,
                                onFavToggle: () =>
                                    setState(() => _isCardFav = !_isCardFav),
                                onViewDetails: () =>
                                    Navigator.maybePop(context),
                              ),
                              const SizedBox(height: 16),

                              // ── Form fields inside white card ──────────────────
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildTextField(
                                      controller: _nameController,
                                      label: 'Full Name',
                                      hint: 'Enter your full name',
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z ]')),
                                      ],
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Name is required';
                                        }
                                        if (!RegExp(r'^[a-zA-Z ]+$')
                                            .hasMatch(value.trim())) {
                                          return 'Only alphabets are allowed';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 14),
                                    _buildTextField(
                                      controller: _phoneController,
                                      label: 'Contact Number',
                                      hint: 'Enter your contact number',
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Contact number is required';
                                        }
                                        if (value.length != 10) {
                                          return 'Enter a valid 10-digit mobile number';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 14),
                                    _buildTextField(
                                      controller: _emailController,
                                      label: 'Email Address',
                                      hint: 'Enter your email address',
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Email is required';
                                        }
                                        if (!RegExp(
                                          r'^[a-zA-Z0-9._%+-]+@gmail\.com$',
                                        ).hasMatch(value.trim())) {
                                          return 'Enter a valid Gmail address';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 14),
                                    _buildVehicleDropdown(),
                                    const SizedBox(height: 14),
                                    _buildDateField(),
                                    const SizedBox(height: 14),
                                    _buildLocationDropdown(),
                                    const SizedBox(height: 14),
                                    _buildTimeSlotField(),
                                    const SizedBox(height: 28),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _submitTestDrive,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          const Color(0xFF005F65),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text('Book Test Drive',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
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
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(Icons.arrow_back,
                size: 24, color: Color(0xFF01422D)),
          ),
          const SizedBox(width: 12),
          const Text('Schedule free Test Drive',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF01422D))),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF000000))),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 14, color: Color(0xFF000000)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
            const TextStyle(fontSize: 12, color: Color(0xFF737373)),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF8C8C8C))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF8C8C8C))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF8C8C8C))),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE53935))),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Vehicle',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF000000))),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedVehicle,
          dropdownColor: Colors.white,
          hint: const Text('Car',
              style: TextStyle(fontSize: 12, color: Color(0xFF737373))),
          validator: (v) =>
          v == null ? 'Please select a vehicle' : null,
          items: _vehicleOptions
              .map((v) => DropdownMenuItem(
            value: v,
            child: Text(v,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF000000))),
          ))
              .toList(),
          onChanged: (v) => setState(() => _selectedVehicle = v),
          decoration: _dropdownDecoration(),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Preferred Date',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF000000))),
        const SizedBox(height: 6),
        TextFormField(
          controller: _dateController,
          readOnly: true,
          onTap: _pickDate,
          validator: (v) =>
          v!.isEmpty ? 'Please select a date' : null,
          style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
          decoration: InputDecoration(
            hintText: 'Select preferred date',
            hintStyle:
            const TextStyle(fontSize: 12, color: Color(0xFF737373)),
            suffixIcon: const Icon(Icons.calendar_month_outlined,
                size: 22, color: Color(0xFF005F65)),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF7D7D7D))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF7D7D7D))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF7D7D7D))),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE53935))),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your Location',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF000000))),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedLocation,
          dropdownColor: Colors.white,
          hint: const Text('Coimbatore',
              style: TextStyle(fontSize: 12, color: Color(0xFF737373))),
          validator: (v) =>
          v == null ? 'Please select a location' : null,
          items: _locationOptions
              .map((l) => DropdownMenuItem(
            value: l,
            child: Text(l,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF000000))),
          ))
              .toList(),
          onChanged: (v) => setState(() => _selectedLocation = v),
          decoration: _dropdownDecoration(),
        ),
      ],
    );
  }

  Widget _buildTimeSlotField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Preferred Time Slot',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF000000))),
        const SizedBox(height: 6),
        TextFormField(
          controller: _timeSlotController,
          readOnly: true,
          validator: (v) =>
          v!.isEmpty ? 'Please select a time slot' : null,
          style: const TextStyle(fontSize: 14, color: Color(0xFF000000)),
          onTap: _showTimeSlotPicker,
          decoration: InputDecoration(
            hintText: 'Select time slot',
            hintStyle:
            const TextStyle(fontSize: 12, color: Color(0xFF737373)),
            suffixIcon: const Icon(Icons.arrow_drop_down,
                size: 25, color: Color(0xFF005F65)),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF7D7D7D))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF7D7D7D))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF7D7D7D))),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE53935))),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showTimeSlotPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Select Time Slot',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000))),
          ),
          const Divider(height: 1),
          ..._timeSlots.map(
                (slot) => ListTile(
              title: Text(slot,
                  style: const TextStyle(
                      fontSize: 14, color: Color(0xFF333333))),
              trailing: _timeSlotController.text == slot
                  ? const Icon(Icons.check, color: Color(0xFF1A3A5C))
                  : null,
              onTap: () {
                setState(() => _timeSlotController.text = slot);
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF7D7D7D))),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF7D7D7D))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF7D7D7D))),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE53935))),
      filled: true,
      fillColor: Colors.white,
    );
  }

  // ─── Success Screen ─────────────────────────────────────────────────────────

  Widget _buildSuccessScreen(BuildContext context) {
    final now = DateTime.now();
    final formatted =
        '${now.day} ${_monthName(now.month)}-${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour < 12 ? 'AM' : 'PM'}';

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Color(0xFFFFFFFF),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/buy_car/tick.gif',
                    width: 192,
                    height: 192,
                  ),
                  const SizedBox(height: 30),
                  const Text('Congratulations',
                      style: TextStyle(
                        fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000))),
                  const SizedBox(height: 30),
                  const Text('Your  free test drive booking',
                      style: TextStyle(fontSize: 16, color: Color(0xFF000000), fontFamily: 'Inter'),
                      textAlign: TextAlign.center),
                  Text('Confirmed on $formatted',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 60),
                  SizedBox(
                    width: 270,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005F65),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Back',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18)),
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

  String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }
}
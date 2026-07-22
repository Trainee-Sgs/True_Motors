import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LeaseVehicleQuoteScreen extends StatefulWidget {
  final Map<String, dynamic> car;

  const LeaseVehicleQuoteScreen({super.key, required this.car});

  @override
  State<LeaseVehicleQuoteScreen> createState() =>
      _LeaseVehicleQuoteScreenState();
}

class _LeaseVehicleQuoteScreenState extends State<LeaseVehicleQuoteScreen> {
  String? _selectedVehicleType;
  String? _selectedLeaseDuration;
  String? _selectedStartDate;
  String? _selectedPurpose;

  final TextEditingController _requirementsController = TextEditingController();
  final List<String> _vehicleTypes = ['Car', 'Van & Truck', 'Backhoe Holder', 'Agri Equipment'];
  final List<String> _leaseDurations = ['1 Month', '3 Months', '6 Months', '1 Year'];
  final List<String> _purposes = ['Personal Use', 'Business Use', 'Commercial Use', 'Other'];

  @override
  void dispose() {
    _requirementsController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF01422D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedStartDate =
        '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  // Generic dropdown menu used by Vehicle Type, Lease Duration and Purpose
  // of Use rows. Anchors a real dropdown-style PopupMenu right under the
  // tapped row (instead of a bottom sheet).
  Future<void> _showDropdownMenu({
    required BuildContext context,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
  }) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, button.size.height), ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final String? selected = await showMenu<String>(
      context: context,
      position: position,
      color: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      constraints: BoxConstraints(
        minWidth: button.size.width,
        maxWidth: button.size.width,
      ),
      items: options.map((option) {
        final bool isSelected = option == selectedValue;
        return PopupMenuItem<String>(
          value: option,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                option,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? const Color(0xFF01422D) : Colors.black87,
                ),
              ),
              if (isSelected)
                const Icon(Icons.check, color: Color(0xFF01422D), size: 18),
            ],
          ),
        );
      }).toList(),
    );

    if (selected != null) {
      onSelected(selected);
    }
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildSuccessDialog(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: statusBarHeight, color: Colors.transparent,
            ),
            // AppBar
            Container(
              color: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Color(0xFF01422D), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Lease Vehicle Quote',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF01422D),
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
                    // Banner
                    _buildBanner(),

                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            _buildFormRow(
                              icon: Icons.directions_car_outlined,
                              title: 'Vehicle Type',
                              value: _selectedVehicleType ?? 'Select Vehicle Type',
                              options: _vehicleTypes,
                              selectedValue: _selectedVehicleType,
                              onSelected: (v) =>
                                  setState(() => _selectedVehicleType = v),
                            ),

                            _divider(),
                            _buildFormRow(
                              icon: Icons.calendar_month_outlined,
                              title: 'Lease Duration',
                              value: _selectedLeaseDuration ?? 'Select Duration',
                              options: _leaseDurations,
                              selectedValue: _selectedLeaseDuration,
                              onSelected: (v) =>
                                  setState(() => _selectedLeaseDuration = v),
                            ),

                            _divider(),
                            _buildFormRow(
                              icon: Icons.calendar_today_outlined,
                              title: 'Lease Start Date',
                              value: _selectedStartDate ?? 'Select Start Date',
                              onTap: _pickStartDate,
                            ),

                            _divider(),
                            _buildFormRow(
                              icon: Icons.business_center_outlined,
                              title: 'Purpose of Use',
                              value: _selectedPurpose ?? 'Select Purpose',
                              options: _purposes,
                              selectedValue: _selectedPurpose,
                              onSelected: (v) =>
                                  setState(() => _selectedPurpose = v),
                            ),
                            _buildRequirementsField(),
                            const SizedBox(height: 15),
                            _buildHowItWorksSectionInside(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Request a Lease quote button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: GestureDetector(
                        onTap: _showSuccessPopup,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                          decoration: BoxDecoration(
                            color: const Color(0xFF005F65),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'Request a Lease quote',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Image.asset('assets/lease_image/lease_quote.png');
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFE5E7EB),
      ),
    );
  }

  Widget _buildFormRow({
    required IconData icon,
    required String title,
    required String value,
    List<String>? options,
    String? selectedValue,
    ValueChanged<String>? onSelected,
    VoidCallback? onTap,
  }) {
    return Builder(
      builder: (rowContext) {
        final VoidCallback? effectiveOnTap = onTap ??
            ((options != null && onSelected != null)
                ? () => _showDropdownMenu(
              context: rowContext,
              options: options,
              selectedValue: selectedValue,
              onSelected: onSelected,
            )
                : null);

        return InkWell(
          onTap: effectiveOnTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF0F4C81),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 24,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequirementsField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFEFEFE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: Color(0xFF0F4C81),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Additional Requirements (Optional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 1),

                  TextField(
                    controller: _requirementsController,
                    maxLines: 3,
                    maxLength: 250,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter any specific requirements...',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14
                      ),
                      counterText: '',
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '${_requirementsController.text.length}/250',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
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

  Widget _buildHowItWorksSectionInside() {
    return Column(
      children: [
        // Blue box now ONLY wraps the info icon + title + description.
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F7FD),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info,
                color: Colors.blueAccent,
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'How It Works?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "We'll share your request with verified vehicle owners. You will receive lease quotes with price, terms and vehicle details.",
                      style: TextStyle(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _howItWorksIcon(
                  Icons.verified_user_outlined,
                  'Verified Owners',
                ),
              ),
              _verticalDivider(),
              Expanded(
                child: _howItWorksIcon(
                  Icons.shield_outlined,
                  'Secure\n& Safe',
                ),
              ),
              _verticalDivider(),
              Expanded(
                child: _howItWorksIcon(
                  Icons.description_outlined,
                  'Easy Agreement',
                ),
              ),
              _verticalDivider(),
              Expanded(
                child: _howItWorksIcon(
                  Icons.support_agent,
                  '24/7\nSupport',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _howItWorksIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF0F4C81), size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 70,
      color: const Color(0xFFC4C4C4),
    );
  }

  Widget _buildSuccessDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Car image with green check overlay
            Stack(
              alignment: Alignment.center,
              children: [
                // Decorative dots background
                SizedBox(
                  width: 160,
                  height: 140,
                  child: Stack(
                    children: [
                      // Colored dots
                      const Positioned(
                          top: 10, left: 20,
                          child: _Dot(color: Color(0xFF4CAF50), size: 8)),
                      const Positioned(
                          top: 5, right: 30,
                          child: _Dot(color: Color(0xFF2196F3), size: 6)),
                      const Positioned(
                          top: 20, right: 10,
                          child: _Dot(color: Color(0xFF2196F3), size: 5)),
                      const Positioned(
                          bottom: 20, left: 10,
                          child: _Dot(color: Color(0xFFFF9800), size: 7)),
                      const Positioned(
                          bottom: 10, right: 20,
                          child: _Dot(color: Color(0xFFFF5722), size: 5)),
                      const Positioned(
                          top: 40, left: 5,
                          child: _Dot(color: Color(0xFF4CAF50), size: 5)),
                      // Green circle
                      Center(
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFE8F5E9),
                            border: Border.all(
                              color: const Color(0xFF4CAF50),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Color(0xFF4CAF50),
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Car image below the circle
            Image.asset(
              'assets/rental_screen/Hyundai Creta.png',
              width: 120,
              height: 70,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.directions_car,
                size: 60,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 12),

            // Title
            const Text(
              'Quote Successfully Sent!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Thank you! Your lease quote request has been successfully submitted. Vehicle owners will review your request and get back to you soon with the best lease offers.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // What's Next section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check,
                        color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What's Next?",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'You will receive notifications and emails once you get a quote.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Great, Thanks button
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back to detail screen
                Navigator.pop(context); // go back to lease list screen
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF003399),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Great, Thanks!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double size;
  const _Dot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
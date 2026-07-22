import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:true_motors/login_module/country_data.dart';
import 'package:true_motors/login_module/otp_screen.dart';
import 'package:true_motors/login_module/signup_screen.dart';
import 'package:true_motors/login_module/dealer_registration_screen.dart';
import 'package:true_motors/login_module/dealer_category_selection_screen.dart';
import 'package:true_motors/provider/login_screen_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

// ─── Login Screen ─────────────────────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  // Default selected country: India
  Country _selectedCountry = kCountries.firstWhere((c) => c.code == 'IN');

  // Selected OTP channel
  OtpChannel _selectedOtpChannel = OtpChannel.whatsapp;

  // Track live digit count for below-field hint/error
  int _currentPhoneLength = 0;
  // Only show the live error after user has typed at least one digit
  bool _hasStartedTyping = false;
  // Show empty-field error only after Get OTP is tapped with empty field
  bool _showEmptyError = false;

  // API loading state
  bool _isLoading = false;

  // Values read from SharedPreferences
  String _latitude = '';
  String _longitude = '';
  String _deviceId = '';

  // Fixed constants
  static const String _cid = '21472147';
  static const String _appSignature = 'itufuifyfufu';

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_onPhoneChanged);
    _loadPrefs();
  }

  // ── Read or fetch lat / lon / device_id ───────────────────────────────────
  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // ── Device ID ────────────────────────────────────────────────────────────
    String deviceId = prefs.getString('device_id') ?? '';
    if (deviceId.isEmpty) {
      deviceId = await _fetchDeviceId();
      await prefs.setString('device_id', deviceId);
    }

    // ── Location ─────────────────────────────────────────────────────────────
    String latitude  = prefs.getString('latitude')  ?? '';
    String longitude = prefs.getString('longitude') ?? '';

    if (latitude.isEmpty || longitude.isEmpty) {
      final coords = await _fetchLocation();
      latitude  = coords.$1;
      longitude = coords.$2;
      await prefs.setString('latitude',  latitude);
      await prefs.setString('longitude', longitude);
    }

    setState(() {
      _deviceId  = deviceId;
      _latitude  = latitude;
      _longitude = longitude;
    });
  }

  // ── Fetch real device ID ──────────────────────────────────────────────────
  Future<String> _fetchDeviceId() async {
    try {
      final info = DeviceInfoPlugin();
      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = await info.androidInfo;
        return android.id;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final ios = await info.iosInfo;
        return ios.identifierForVendor ?? '';
      }
      return '';
    } catch (e) {
      print('[LoginScreen] device_id fetch failed: $e');
      return '';
    }
  }

  // ── Fetch real GPS coordinates ────────────────────────────────────────────
  Future<(String, String)> _fetchLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return ('', '');
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return (pos.latitude.toString(), pos.longitude.toString());
    } catch (e) {
      print('[LoginScreen] location fetch failed: $e');
      return ('', '');
    }
  }

  void _onPhoneChanged() {
    setState(() {
      _currentPhoneLength = phoneController.text.length;
      if (phoneController.text.isNotEmpty) {
        _hasStartedTyping = true;
        _showEmptyError = false;
      }
    });
  }

  @override
  void dispose() {
    phoneController.removeListener(_onPhoneChanged);
    phoneController.dispose();
    super.dispose();
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _CountryPickerSheet(
        selectedCountry: _selectedCountry,
        onCountrySelected: (country) {
          setState(() {
            _selectedCountry = country;
            phoneController.clear();
            _hasStartedTyping = false;
            _currentPhoneLength = 0;
            _showEmptyError = false;
          });
        },
      ),
    );
  }

  // ── API call ───────────────────────────────────────────────────────────────
  Future<void> _getOtp() async {
    // Validation guards (same logic as before)
    if (phoneController.text.isEmpty) {
      setState(() => _showEmptyError = true);
      return;
    }
    if (phoneController.text.length != _selectedCountry.phoneLength) {
      setState(() => _hasStartedTyping = true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = LoginRequest(
        cid: _cid,
        ln: _longitude,
        lt: _latitude,
        deviceId: _deviceId,
        mobile: phoneController.text,
        appSignature: _appSignature,
      );

      final response = await LoginApi.sendOtp(request);

      if (!mounted) return;

      if (!response.error) {
        // Success — navigate to OTP screen, passing required data forward
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              mobile: response.mobile,
              fToken: response.fToken,
              cid: _cid,
              latitude: _latitude,
              longitude: _longitude,
              deviceId: _deviceId,
              appSignature: _appSignature,
            ),
          ),
        );
      } else {
        _showError(response.errorMsg.isNotEmpty
            ? response.errorMsg
            : 'Failed to send OTP. Please try again.');
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Something went wrong. Please check your connection.');
      print('[LoginScreen] Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(fontFamily: 'Lato', color: Colors.white)),
        backgroundColor: const Color(0xFFBE000C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final bool isIncomplete =
        _hasStartedTyping && _currentPhoneLength != _selectedCountry.phoneLength;

    String? belowFieldText;
    Color belowFieldColor = const Color(0xFF817979);

    if (_showEmptyError) {
      belowFieldText = 'Please enter mobile number';
      belowFieldColor = const Color(0xFFBE000C);
    } else if (isIncomplete) {
      belowFieldText =
      'Enter exactly ${_selectedCountry.phoneLength} digits for ${_selectedCountry.name}';
      belowFieldColor = const Color(0xFFBE000C);
    } else {
      belowFieldText = '';
      belowFieldColor = const Color(0xFF817979);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                  SizedBox(height: height * 0.12),
                  Center(
                    child: Image.asset(
                      'assets/login_image/true_motors_logo.png',
                      height: height * 0.12,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: height * 0.02),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login or Register',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.015),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Enter Phone Number*',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  // ── Phone field + below-field text ──────────────────────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(
                              _selectedCountry.phoneLength),
                        ],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Lato',
                          color: Color(0xFF000000),
                        ),
                        decoration: InputDecoration(
                          prefixIcon: IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 12),
                                GestureDetector(
                                  onTap: _showCountryPicker,
                                  child: Text(
                                    _selectedCountry.dialCode,
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                SizedBox(
                                  height: 30,
                                  child: VerticalDivider(
                                    thickness: 1,
                                    color: Color(0xFF979797),
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                          hintText: 'Enter mobile number',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Lato',
                            color: Color(0xFF686363),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Color(0xFF817979)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                            const BorderSide(color: Color(0xFF817979)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF005F65),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 4),
                        child: Text(
                          belowFieldText,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                            color: belowFieldColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Send Code Via ────────────────────────────────────────────
                  SizedBox(height: height * 0.005),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Send OTP Via',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF817979),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.012),
                  Row(
                    children: [
                      // SMS option
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedOtpChannel = OtpChannel.sms;
                            });
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _selectedOtpChannel == OtpChannel.sms
                                    ? Color(0xFF005F65)
                                    : Color(0xFF817979),
                                width: _selectedOtpChannel == OtpChannel.sms ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat,
                                  color: _selectedOtpChannel == OtpChannel.sms ? Color(0xFF005F65) : Color(0xFF817979),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'SMS',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: _selectedOtpChannel == OtpChannel.sms ? Color(0xFF005F65) : Color(0xFF817979),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // WhatsApp option
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedOtpChannel = OtpChannel.whatsapp;
                            });
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _selectedOtpChannel == OtpChannel.whatsapp
                                    ? Color(0xFF005F65)
                                    : Color(0xFF817979),
                                width: _selectedOtpChannel == OtpChannel.whatsapp ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  color: _selectedOtpChannel == OtpChannel.whatsapp ? Color(0xFF005F65) : Color(0xFF817979),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'WhatsApp',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: _selectedOtpChannel == OtpChannel.whatsapp ? Color(0xFF005F65) : Color(0xFF817979),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Get OTP Button ───────────────────────────────────────────
                  SizedBox(height: height * 0.035),
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.065,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0XFF005F65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isLoading ? null : _getOtp,
                      child: _isLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : Text(
                        'Get OTP',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Color(0xFFBDBDBD), thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'or',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Color(0xFFBDBDBD), thickness: 1)),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.065,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF005F65), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DealerCategorySelectionScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register as a dealer',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Color(0xFF005F65),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.04),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF000000),
                        fontFamily: 'Lato',
                        height: 1.4,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(text: 'By Continuing you agree to our\n'),
                        TextSpan(
                          text: 'Terms and Conditions & Privacy Policy',
                          style: TextStyle(
                            color: Color(0xFF01422D),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.02),
                ],
              ),
            ),
          ),
        ),
    );
  }
}

// ─── Country Picker Bottom Sheet ─────────────────────────────────────────────

class _CountryPickerSheet extends StatefulWidget {
  final Country selectedCountry;
  final ValueChanged<Country> onCountrySelected;

  const _CountryPickerSheet({
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Country> _filtered = kCountries;

  void _onSearch(String query) {
    setState(() {
      final q = query.toLowerCase();
      _filtered = kCountries
          .where((c) =>
      c.name.toLowerCase().contains(q) || c.dialCode.contains(q))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.75,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFFCCCCCC),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Country',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                  fontFamily: 'Lato',
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              style: TextStyle(fontSize: 14, fontFamily: 'Lato'),
              decoration: InputDecoration(
                hintText: 'Search country or dial code',
                hintStyle: TextStyle(
                  color: Color(0xFF686363),
                  fontFamily: 'Lato',
                  fontSize: 14,
                ),
                prefixIcon:
                Icon(Icons.search, color: Color(0xFF817979), size: 20),
                filled: true,
                fillColor: Color(0xFFF5F5F5),
                contentPadding:
                EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: _filtered.isEmpty
                ? Center(
              child: Text(
                'No country found',
                style: TextStyle(
                  color: Color(0xFF817979),
                  fontFamily: 'Lato',
                ),
              ),
            )
                : ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final country = _filtered[index];
                final isSelected =
                    country.code == widget.selectedCountry.code;

                return ListTile(
                  dense: true,
                  onTap: () {
                    widget.onCountrySelected(country);
                    Navigator.pop(context);
                  },
                  leading: Text(
                    country.flag,
                    style: TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    '${country.dialCode}   ${country.name}',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Lato',
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: Color(0xFF000000),
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle,
                      color: Color(0xFF005F65), size: 20)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
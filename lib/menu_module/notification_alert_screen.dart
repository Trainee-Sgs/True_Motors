import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationAlertScreen extends StatefulWidget {
  const NotificationAlertScreen({super.key});

  @override
  State<NotificationAlertScreen> createState() =>
      _NotificationAlertScreenState();
}

class _NotificationAlertScreenState extends State<NotificationAlertScreen> {
  bool _bookingUpdates = false;
  bool _sellerAlerts = false;
  bool _offersPromotions = false;
  bool _accountSecurityAlerts = false;

  static const String _keyBooking = 'notif_booking_updates';
  static const String _keySeller = 'notif_seller_alerts';
  static const String _keyOffers = 'notif_offers_promotions';
  static const String _keyAccount = 'notif_account_security_alerts';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bookingUpdates = prefs.getBool(_keyBooking) ?? true;
      _sellerAlerts = prefs.getBool(_keySeller) ?? true;
      _offersPromotions = prefs.getBool(_keyOffers) ?? true;
      _accountSecurityAlerts = prefs.getBool(_keyAccount) ?? true;
    });
  }

  Future<void> _savePref(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Widget _buildAppBar() {
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
          const Text(
            'Notifications & Alerts',
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

  // Custom toggle that shows ✓ when ON and ✗ when OFF, matching Figma design
  Widget _buildCustomToggle({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 55,
        height: 32,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value
              ? const Color(0xFF6750A4)
              : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: value
                ? const Color(0xFF6750A4)
                : const Color(0xFF6E6E6E),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment:
          value ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: value
                    ? Colors.white
                    : const Color(0xFF6E6E6E),
                shape: BoxShape.circle,
              ),
              child: Icon(
                value ? Icons.check : Icons.close,
                size: 16,
                color: value
                    ? const Color(0xFF4F378A)
                    : const Color(0xFFDBDBDB),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Each toggle item in its OWN separate white card container
  Widget _buildToggleCard({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          _buildCustomToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
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
              height: statusBarHeight,
              color: const Color(0xFF615C5C),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    _buildAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Notification & Alerts',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Stay updated, stay informed.\nGet important updates about your bookings, listings, offers, and account activity — all in one place.',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Each item in its own separate container card
                            _buildToggleCard(
                              label: 'Booking Updates',
                              value: _bookingUpdates,
                              onChanged: (v) {
                                setState(() => _bookingUpdates = v);
                                _savePref(_keyBooking, v);
                              },
                            ),
                            _buildToggleCard(
                              label: 'Seller Alerts',
                              value: _sellerAlerts,
                              onChanged: (v) {
                                setState(() => _sellerAlerts = v);
                                _savePref(_keySeller, v);
                              },
                            ),
                            _buildToggleCard(
                              label: 'Offers & Promotions',
                              value: _offersPromotions,
                              onChanged: (v) {
                                setState(() => _offersPromotions = v);
                                _savePref(_keyOffers, v);
                              },
                            ),
                            _buildToggleCard(
                              label: 'Account & Security Alerts',
                              value: _accountSecurityAlerts,
                              onChanged: (v) {
                                setState(() => _accountSecurityAlerts = v);
                                _savePref(_keyAccount, v);
                              },
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
      ),
    );
  }
}
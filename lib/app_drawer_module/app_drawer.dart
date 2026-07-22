import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:true_motors/lease_module/dashboard_screen.dart';
import 'package:true_motors/login_module/login_screen.dart';
import 'package:true_motors/login_module/splash_screen.dart';
import 'package:true_motors/menu_module/my_listing_screen.dart';
import 'package:true_motors/menu_module/saved_vehicle_screen.dart';
import 'package:true_motors/menu_module/notification_alert_screen.dart';
import 'package:true_motors/menu_module/help_support_screen.dart';
import 'package:true_motors/menu_module/security_setting_screen.dart';
import 'package:true_motors/menu_module/language_screen.dart';
import 'package:true_motors/menu_module/subscription_screen.dart';
import 'package:true_motors/menu_module/profile_information_screen.dart';
import 'package:true_motors/menu_module/my_booking_screen.dart';

class AppDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const AppDrawer({super.key, this.scaffoldKey});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _name = '';
  String _phone = '';
  String? _profileImagePath; // in-memory only, never loaded from prefs
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'User';
      _phone = prefs.getString('phone') ?? '000-000';
      // profile_image_path is intentionally NOT loaded — always starts as icon
    });
  }

  String _formatPhone(String phone) {
    if (phone.isEmpty || phone == '000-000') return '000-000';
    if (phone.length == 10) {
      return '${phone.substring(0, 5)} ${phone.substring(5, 10)}';
    }
    return phone;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked =
      await _picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) {
        // Only update in-memory state, do NOT save to SharedPreferences
        setState(() => _profileImagePath = picked.path);
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Profile Photo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(Icons.camera_alt, color: Color(0xFF005F65)),
                ),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE3F2FD),
                  child: Icon(Icons.photo_library, color: Color(0xFF1565C0)),
                ),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xFFF5F5F5),
          backgroundImage:
          (_profileImagePath != null && _profileImagePath!.isNotEmpty)
              ? FileImage(File(_profileImagePath!))
              : null,
          child: (_profileImagePath == null || _profileImagePath!.isEmpty)
              ? const Icon(Icons.person, size: 42, color: Color(0xFFAAAAAA))
              : null,
        ),
        Positioned(
          bottom: 2,
          right: 0,
          child: GestureDetector(
            onTap: _showImagePickerDialog,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF005F65),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    String? imagePath,
    IconData? icon,
    required String label,
    VoidCallback? onTap,
    Color labelColor = Colors.black,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 2,
          ),
          leading: imagePath != null
              ? Image.asset(imagePath, width: 24, height: 24)
              : Icon(icon, size: 22),
          title: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.black,
            size: 20,
          ),
          onTap: onTap ?? () {},
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFF8899BD),
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Are you sure want to Logout?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side:
                        const BorderSide(color: Color(0xFF005F65)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'NO',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('profile_image_path');
                        await prefs.remove('phone');
                        await prefs.remove('name');
                        await prefs.remove('email');
                        await prefs.remove('token');
                        await prefs.remove('user_id');
                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) => const SplashScreen(fromLogout: true)),
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005F65),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding:
                        const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'YES',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pushAndReopenDrawer(Widget screen) async {
    Navigator.pop(context);
    Navigator.of(
      widget.scaffoldKey!.currentContext!,
    ).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void _openProfileInformation() {
    Navigator.pop(context);
    Navigator.of(widget.scaffoldKey!.currentContext!).push(
      MaterialPageRoute(
        builder: (_) => ProfileInformationScreen(
          scaffoldKey: widget.scaffoldKey,
          currentImagePath: _profileImagePath,
          onImageChanged: (path) {
            setState(() => _profileImagePath = path);
          },
        ),
      ),
    ).then((_) => _loadUserData());
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Drawer(
        backgroundColor: Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        width: MediaQuery.of(context).size.width * 0.77,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: statusBarHeight, color: Colors.transparent,
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    // ─── Header ───────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      color: const Color(0xFF005F65),
                      padding: const EdgeInsets.only(
                          top: 25, left: 16, right: 12, bottom: 16),
                      child: Stack(
                        children: [
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              _buildProfileAvatar(),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _name.isEmpty
                                                ? 'User'
                                                : _name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      _formatPhone(_phone),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap:
                                            _openProfileInformation,
                                            child: const Text(
                                              'View Full Profile',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight:
                                                FontWeight.w500,
                                                decoration: TextDecoration
                                                    .underline,
                                                decorationColor:
                                                Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 3),
                                          decoration: BoxDecoration(
                                            color:
                                            const Color(0xFF30AC4B),
                                            borderRadius:
                                            BorderRadius.circular(
                                                12),
                                          ),
                                          child: const Text(
                                            'Active',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.close,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ─── Menu Items ───────────────────────────────────────
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(top: 8),
                        children: [
                          _buildMenuItem(
                            imagePath:
                            'assets/drawer_image/profile.png',
                            label: 'Profile Information',
                            onTap: _openProfileInformation,
                          ),
                          _buildMenuItem(
                            imagePath:
                            'assets/drawer_image/booking.png',
                            label: 'My Booking',
                            // ── Wired to MyBookingScreen ──
                            onTap: () => _pushAndReopenDrawer(
                                const MyBookingScreen()),
                          ),
                          _buildMenuItem(
                            imagePath:
                            'assets/drawer_image/listing.png',
                            label: 'My Listing',
                            onTap: () => _pushAndReopenDrawer(
                                const MyListingScreen()),
                          ),
                          _buildMenuItem(
                            imagePath:
                            'assets/drawer_image/saved_vehicle.png',
                            label: 'Saved Vehicles',
                            onTap: () => _pushAndReopenDrawer(
                                const SavedVehiclesScreen()),
                          ),
                          _buildMenuItem(
                            imagePath:
                            'assets/sell_image/red_car.png',
                            label: 'Lease Vehicles',
                            onTap: () => _pushAndReopenDrawer(LeaseVehicleDashboardScreen()),
                          ),
                          _buildMenuItem(
                            imagePath:
                            'assets/drawer_image/notification.png',
                            label: 'Notification & Alerts',
                            onTap: () => _pushAndReopenDrawer(
                                const NotificationAlertScreen()),
                          ),
                          _buildMenuItem(
                            imagePath: 'assets/drawer_image/help.png',
                            label: 'Help & Support',
                            onTap: () => _pushAndReopenDrawer(
                                const HelpSupportScreen()),
                          ),
                          _buildMenuItem(
                            imagePath:
                            'assets/drawer_image/security.png',
                            label: 'Subscription',
                            onTap: () => _pushAndReopenDrawer(
                                const SubscriptionScreen()),
                          ),
                          _buildMenuItem(
                            imagePath:
                            'assets/drawer_image/language.png',
                            label: 'Language',
                            onTap: () => _pushAndReopenDrawer(
                                const LanguageScreen()),
                          ),
                          const SizedBox(height: 8),
                          _buildMenuItem(
                            imagePath:
                            'assets/drawer_image/logout.png',
                            label: 'Logout',
                            onTap: _showLogoutDialog,
                          ),
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
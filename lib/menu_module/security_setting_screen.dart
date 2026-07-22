import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecuritySettingScreen extends StatelessWidget {
  const SecuritySettingScreen({super.key});

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
          const Text(
            'Security & Setting',
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

  Widget _buildSettingItem({
    required BuildContext context,
    required String imagePath,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          leading: Image.asset(
            imagePath,
            width: 24,
            height: 24,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Color(0xFF3C3C3C),
            size: 22,
          ),
          onTap: onTap,
        ),
        const Divider(
            height: 1,
            color: Color(0xFF979797),
            indent: 10,
            endIndent: 10),
      ],
    );
  }

  void _showChangeMobileDialog(BuildContext context) {
    final TextEditingController mobileController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Change Mobile Number',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: TextField(
          controller: mobileController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          decoration: InputDecoration(
            hintText: 'Enter new mobile number',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF005F65)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005F65)),
            child: const Text('Update',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showTwoFactorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Two Factor Authentication',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: const Text(
            'Enable two-factor authentication to add an extra layer of security to your account.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005F65)),
            child: const Text('Enable',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Privacy Setting',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: const Text(
            'Manage your privacy settings and control how your data is used.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
            const Text('Close', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Account',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red)),
        content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
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
                    _buildAppBar(context),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5,),
                            const Text(
                              'Security & Settings – TrueMotors',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Your privacy and security come first.\nManage your account security, privacy settings, and personal preferences — all in one place.',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black, height: 1.6),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                _buildSettingItem(
                                  context: context,
                                  imagePath:
                                  'assets/icons/mobile.png',
                                  title: 'Change Mobile Number',
                                  onTap: () =>
                                      _showChangeMobileDialog(context),
                                ),
                                _buildSettingItem(
                                  context: context,
                                  imagePath: 'assets/icons/lock.png',
                                  title: 'Two Factor Authentication',
                                  onTap: () =>
                                      _showTwoFactorDialog(context),
                                ),
                                _buildSettingItem(
                                  context: context,
                                  imagePath:
                                  'assets/icons/privacy.png',
                                  title: 'Privacy Setting',
                                  onTap: () =>
                                      _showPrivacySettingDialog(context),
                                ),
                                _buildSettingItem(
                                  context: context,
                                  imagePath:
                                  'assets/icons/delete.png',
                                  title: 'Delete Account',
                                  onTap: () =>
                                      _showDeleteAccountDialog(context),
                                ),
                              ],
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
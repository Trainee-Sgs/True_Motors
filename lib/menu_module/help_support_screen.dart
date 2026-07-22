import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
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
            'Help & Support',
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

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 10,),
          const Text('• ', style: TextStyle(fontSize: 14, color: Colors.black)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black, height: 1.4),
            ),
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
                    _buildAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5,),
                            const Text(
                              'Help & Support – True Motors',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "We're here to help you every step of the way.\nGot questions, issues, or feedback?\nFind answers quickly or connect with our support team for personalized assistance.",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black, height: 1.6),
                            ),
                            const SizedBox(height: 16),

                            // Call Us Directly
                            const Text(
                              'Call Us Directly',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildBulletPoint(
                                'Speak with our customer care team for urgent help.'),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                SizedBox(width: 10,),
                                Text('• ', style: TextStyle(fontSize: 14)),
                                Icon(Icons.phone, size: 14, color: Colors.black87),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Customer Support: +91-90873-90873',
                                    style: TextStyle(fontSize: 14, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            _buildBulletPoint('Available 9 AM – 9 PM IST'),
                            const SizedBox(height: 16),

                            // Email Support
                            const Text(
                              'Email Support',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildBulletPoint(
                                'For detailed queries or document submissions.'),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                SizedBox(width: 10,),
                                Text('• ', style: TextStyle(fontSize: 14)),
                                Icon(Icons.email_outlined, size: 14, color: Colors.black87),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'support@truemotors.com',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF005F65),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Feedback & Suggestions
                            const Text(
                              'Feedback & Suggestions',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Share your feedback to help us improve your TrueMotors experience.',
                              style: TextStyle(fontSize: 15, color: Colors.black, height: 1.6),
                            ),
                            const SizedBox(height: 12),

                            // Feedback text field
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: const Color(0xFF000000)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: _feedbackController,
                                maxLines: 6,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(12),
                                  hintText: 'Write your feedback here...',
                                  hintStyle: TextStyle(
                                      fontSize: 13, color: Color(0xFFAAAAAA)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Submit button
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_feedbackController.text.trim().isNotEmpty) {
                                    _feedbackController.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Feedback submitted successfully!'),
                                        backgroundColor: Color(0xFF005F65),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF742B88),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                                child: const Text(
                                  'Submit a Feedback',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
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
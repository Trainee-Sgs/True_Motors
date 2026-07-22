import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English';

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'native': 'English', 'icon': 'A'},
    {'name': 'Tamil', 'native': 'தமிழ்', 'icon': 'த'},
    {'name': 'Hindi', 'native': 'हिंदी', 'icon': 'आ'},
  ];

  Widget _buildAppBar() {
    return Container(
      color: Color(0xFFFFF8F8),
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
            'Select Language',
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

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  Future<void> _saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);

    setState(() {
      _selectedLanguage = language;
    });
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
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFF3AB0B7),
              ],
              stops: [0.39, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              Image.asset('assets/icons/lan.png',
                                height: 100,
                                width: 100,
                              ),
                              const SizedBox(height: 20),

                              const Text(
                                'Select Language',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'True Guide supports multiple languages to enhance your experience. Please select your preferred language to continue.',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Language options
                              Column(
                                children: _languages.map((lang) {
                                  final isSelected =
                                      _selectedLanguage == lang['name'];
                                  final isLast =
                                      _languages.last == lang;
                                  return Column(
                                    children: [
                                      InkWell(
                                        onTap: () => _saveLanguage(lang['name']!),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 14),
                                          child: Row(
                                            children: [
                                              // Language character badge
                                              Container(
                                                width: 45,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFFEAECF9),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  lang['icon']!,
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 14),
                                              // Language name
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      lang['name']!,
                                                      style: const TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w700,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    if (lang['name'] !=
                                                        lang['native'])
                                                      Text(
                                                        lang['native']!,
                                                        style: const TextStyle(
                                                          fontFamily: 'Lato',
                                                          fontSize: 15,
                                                          color: Color(0xFF656666),
                                                        ),
                                                      ),
                                                    if (lang['name'] ==
                                                        lang['native'])
                                                      Text(
                                                        lang['native']!,
                                                        style: const TextStyle(
                                                          fontFamily: 'Lato',
                                                          fontSize: 15,
                                                          color: Color(0xFF656666),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              // Radio
                                              Radio<String>(
                                                value: lang['name']!,
                                                groupValue: _selectedLanguage,
                                                onChanged: (v) {
                                                  if (v != null) {
                                                    _saveLanguage(v);
                                                  }
                                                },
                                                activeColor:
                                                const Color(0xFF4134CA),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                          height: 1,
                                          color: Color(0xFFC0ADAD),
                                          indent: 1,
                                          endIndent: 1),
                                    ],
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 24),
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
      ),
    );
  }
}
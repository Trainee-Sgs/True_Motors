import 'package:flutter/material.dart';
import 'dealer_registration_screen.dart';

class DealerTypeSelectionScreen extends StatefulWidget {
  const DealerTypeSelectionScreen({super.key});

  @override
  State<DealerTypeSelectionScreen> createState() => _DealerTypeSelectionScreenState();
}

class _DealerTypeSelectionScreenState extends State<DealerTypeSelectionScreen> {
  final List<String> _selectedTypes = ['New Vehicles'];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Lato'),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF005F65)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Dealer Registration',
            style: TextStyle(
              color: Color(0xFF005F65),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF005F65),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF005F65), // 2nd step active
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'What kind of dealer are you?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Tell us whether you sell new bikes, used ones, or both.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A4A4A),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      _buildTypeOption(
                        id: 'New Vehicles',
                        title: 'New Vehicles',
                        subtitle: 'Authorized / showroom sales of brand-new vehicles',
                      ),
                      const SizedBox(height: 16),
                      _buildTypeOption(
                        id: 'Used Vehicles',
                        title: 'Used Vehicles',
                        subtitle: 'Pre-owned / second-hand vehicle sales',
                      ),
                      const SizedBox(height: 16),
                      _buildTypeOption(
                        id: 'Both',
                        title: 'Both',
                        subtitle: 'You sell new as well as pre-owned vehicles',
                      ),
                    ],
                  ),
                ),
              ),
              
              // Continue Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DealerRegistrationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005F65),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeOption({
    required String id,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedTypes.contains(id);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedTypes.contains(id)) {
            _selectedTypes.remove(id);
          } else {
            _selectedTypes.add(id);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFFFFB) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF005F65).withOpacity(0.3) : const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF6750A4) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? const Color(0xFF6750A4) : const Color(0xFFBDBDBD),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

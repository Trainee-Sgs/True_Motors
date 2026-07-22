import 'package:flutter/material.dart';
import 'dealer_type_selection_screen.dart';

class DealerCategorySelectionScreen extends StatefulWidget {
  const DealerCategorySelectionScreen({super.key});

  @override
  State<DealerCategorySelectionScreen> createState() => _DealerCategorySelectionScreenState();
}

class _DealerCategorySelectionScreenState extends State<DealerCategorySelectionScreen> {
  final List<String> _selectedCategories = ['Bike'];

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
                            color: const Color(0xFFE0E0E0),
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
                        'What do you sell?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Select the vehicle category for your business. You can add more categories later from your dealer profile.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A4A4A),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      _buildCategoryOption(
                        id: 'Bike',
                        title: 'Bike',
                        subtitle: 'Motorcycles & Scooters',
                        icon: Icons.motorcycle, // wait, maybe TwoWheeler?
                      ),
                      const SizedBox(height: 16),
                      _buildCategoryOption(
                        id: 'Cars',
                        title: 'Cars',
                        subtitle: 'Motorcycles & Scooters', // Keeping as per screenshot
                        icon: Icons.directions_car,
                      ),
                      const SizedBox(height: 16),
                      _buildCategoryOption(
                        id: 'Commercial',
                        title: 'Commercial Vehicles',
                        subtitle: 'Trucks, vans & pickups',
                        icon: Icons.local_shipping,
                      ),
                      const SizedBox(height: 16),
                      _buildCategoryOption(
                        id: 'Agriculture',
                        title: 'Agriculture Vehicle',
                        subtitle: 'Tractors & Farm equipment',
                        icon: Icons.agriculture,
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
                        builder: (context) => const DealerTypeSelectionScreen(),
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

  Widget _buildCategoryOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedCategories.contains(id);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedCategories.contains(id)) {
            _selectedCategories.remove(id);
          } else {
            _selectedCategories.add(id);
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFFEFFFFB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF005F65),
                size: 28,
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

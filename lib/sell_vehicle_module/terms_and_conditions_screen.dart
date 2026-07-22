import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════════
// SCREEN 4 — TermsAndConditionsScreen
// ════════════════════════════════════════════════════════════════════════════

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ──────────────────────────────────────────────────
            _buildAppBar(context),

            // ── Body ────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'By listing your vehicle for sale on the True Motors platform, '
                          'you agree to the following terms and conditions:',
                      style: TextStyle(fontSize: 13, height: 1.6),
                    ),
                    const SizedBox(height: 16),
                    ..._sections
                        .map((s) => _buildSection(s))
                        .toList(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Color(0xFFFBF8F8),
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
            'Terms & Conditions',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF01422D)),
          ),
        ],
      ),
    );
  }

  // ── Section builder ───────────────────────────────────────────────────
  Widget _buildSection(_TnCSection s) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            s.title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.5),
          ),
          const SizedBox(height: 4),

          // Top-level bullets
          ...s.bullets.map(
                (b) => Padding(
              padding: const EdgeInsets.only(left: 10, top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style: TextStyle(
                          fontSize: 13, color: Colors.black87)),
                  Expanded(
                    child: Text(
                      b,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          height: 1.55),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sub-sections (indented)
          ...s.subSections.map(
                (sub) => Padding(
              padding: const EdgeInsets.only(left: 18, top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sub.title.isNotEmpty)
                    Text(
                      sub.title,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.4),
                    ),
                  ...sub.bullets.map(
                        (b) => Padding(
                      padding: const EdgeInsets.only(left: 10, top: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87)),
                          Expanded(
                            child: Text(
                              b,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                  height: 1.5),
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
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ════════════════════════════════════════════════════════════════════════════

class _TnCSection {
  final String title;
  final List<String> bullets;
  final List<_TnCSubSection> subSections;
  const _TnCSection({
    required this.title,
    this.bullets = const [],
    this.subSections = const [],
  });
}

class _TnCSubSection {
  final String title;
  final List<String> bullets;
  const _TnCSubSection({
    required this.title,
    this.bullets = const [],
  });
}

// ── Content ──────────────────────────────────────────────────────────────────
const List<_TnCSection> _sections = [
  _TnCSection(
    title: '1. Eligibility',
    bullets: [
      'The seller must be the legal owner or an authorized representative of the vehicle.',
      'The vehicle must not be stolen, under legal dispute, or restricted from resale.',
    ],
  ),
  _TnCSection(
    title: '2. Vehicle Details',
    bullets: [
      'All vehicle information (make, model, year, mileage, condition, etc.) must be accurate and truthful.',
      'Misrepresentation may lead to account suspension and removal of listings.',
    ],
  ),
  _TnCSection(
    title: '3. Ownership & Documentation',
    bullets: [
      'The seller must have valid ownership documents, including:',
    ],
    subSections: [
      _TnCSubSection(
        title: '',
        bullets: [
          'RC (Registration Certificate)',
          'Pollution Certificate',
          'Insurance (active or expired copy)',
          'ID proof of seller',
        ],
      ),
    ],
  ),
  _TnCSection(
    title: '4. Pricing and Payments',
    bullets: [
      'Vehicle price is set by the seller. True Motors does not interfere with pricing.',
      'True Motors does not handle payments directly unless agreed in advance through escrow or premium plans.',
    ],
  ),
  _TnCSection(
    title: '5. Vehicle Condition & Inspection',
    bullets: [
      'The seller must allow inspection or test drive, if requested by the buyer.',
      'Vehicles must be in the stated condition at the time of handover.',
    ],
  ),
  _TnCSection(
    title: '6. Liability Disclaimer',
    bullets: [
      'True Motors acts as a digital listing platform only.',
      'We are not responsible for disputes, payment defaults, or legal issues between buyer and seller.',
    ],
  ),
  _TnCSection(
    title: '7. Listing Removal',
    bullets: [
      'True Motors reserves the right to remove any listing that violates its terms, is reported fake, or is inactive.',
    ],
  ),
  _TnCSection(
    title: '8. Privacy and Communication',
    bullets: [
      'By listing, you agree to be contacted by potential buyers and the True Motors team.',
      'Your contact details are shared with buyers only upon serious inquiry.',
    ],
  ),
];
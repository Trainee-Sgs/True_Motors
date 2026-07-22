import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Subscription Screen ──────────────────────────────────────────────────────

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isYearly = false; // false = Monthly, true = Yearly

  // ── Plan data ────────────────────────────────────────────────────────────────

  final List<_PlanData> _monthlyPlans = const [
    _PlanData(
      name: 'Free',
      tagline: 'Get Started for free',
      price: '0',
      period: '/month',
      originalPrice: null,
      isMostPopular: false,
      isCurrent: true,
      buttonLabel: 'Current Plan',
      buttonStyle: _ButtonStyle.outlined,
      imageAsset: 'assets/subscription/month.png',
      iconColor: Color(0xFF5F6368),
      backgroundColor: Color(0xFFF1ECFD),
      features: [
        '2 Active Listing',
        'Basic Visibility',
        'Standard Support',
      ],
    ),
    _PlanData(
      name: 'Premium',
      tagline: 'Sell faster with more exposure',
      price: '299',
      period: '/month',
      originalPrice: '499',
      isMostPopular: true,
      isCurrent: false,
      buttonLabel: 'Choose Premium Plan',
      buttonStyle: _ButtonStyle.purple,
      imageAsset: 'assets/subscription/premium.png',
      iconColor: Color(0xFF742B88),
      backgroundColor: Color(0xFF6939DF),
      features: [
        '20 Active Listing',
        'Featured Listing',
        'Priority Support',
      ],
    ),
    _PlanData(
      name: 'Dealer Plan',
      tagline: 'For Dealers & Businesses',
      price: '499',
      period: '/month',
      originalPrice: '1,490',
      isMostPopular: false,
      isCurrent: false,
      buttonLabel: 'Choose Dealer Plan',
      buttonStyle: _ButtonStyle.orange,
      imageAsset: 'assets/subscription/dealer.png',
      iconColor: Color(0xFFE65100),
      backgroundColor: Color(0xFFF78B01),
      features: [
        'Unlimited Listing',
        'Featured Listing',
        'Priority Support',
        'Bulk Upload',
        'Lead Priority',
        'Dealer Badge',
      ],
    ),
  ];

  final List<_PlanData> _yearlyPlans = const [
    _PlanData(
      name: 'Free',
      tagline: 'Get Started for free',
      price: '0',
      period: '/yearly',
      originalPrice: null,
      isMostPopular: false,
      isCurrent: true,
      buttonLabel: 'Current Plan',
      buttonStyle: _ButtonStyle.outlined,
      imageAsset: 'assets/subscription/month.png',
      iconColor: Color(0xFF5F6368),
      backgroundColor: Color(0xFFF1ECFD),
      features: [
        '2 Active Listing',
        'Basic Visibility',
        'Standard Support',
      ],
    ),
    _PlanData(
      name: 'Premium',
      tagline: 'Sell faster with more exposure',
      price: '1499',
      period: '/Yearly',
      originalPrice: '2990',
      isMostPopular: true,
      isCurrent: false,
      buttonLabel: 'Choose Premium Plan',
      buttonStyle: _ButtonStyle.purple,
      imageAsset: 'assets/subscription/premium.png',
      iconColor: Color(0xFF742B88),
      backgroundColor: Color(0xFF6939DF),
      features: [
        '20 Active Listing',
        'Featured Listing',
        'Priority Support',
      ],
    ),
    _PlanData(
      name: 'Dealer Plan',
      tagline: 'For Dealers & Businesses',
      price: '1999',
      period: '/yearly',
      originalPrice: '1,490',
      isMostPopular: false,
      isCurrent: false,
      buttonLabel: 'Choose Dealer Plan',
      buttonStyle: _ButtonStyle.orange,
      imageAsset: 'assets/subscription/dealer.png',
      iconColor: Color(0xFFE65100),
      backgroundColor: Color(0xFFF78B01),
      features: [
        'Unlimited Listing',
        'Featured Listing',
        'Priority Support',
        'Bulk Upload',
        'Lead Priority',
        'Dealer Badge',
      ],
    ),
  ];

  List<_PlanData> get _activePlans =>
      _isYearly ? _yearlyPlans : _monthlyPlans;

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
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
                    _buildTopBar(context),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // ── Banner ──────────────────────────────────────────────
                            _buildBanner(),
                            const SizedBox(height: 5),

                            // ── Monthly / Yearly toggle ─────────────────────────────
                            _buildToggle(),
                            const SizedBox(height: 20),

                            // ── Plan label ─────────────────────────────────────────
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Choose your Plan',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // ── Plan cards ─────────────────────────────────────────
                            ..._activePlans.map((plan) => _buildPlanCard(plan)),
                            const SizedBox(height: 10),

                            // ── All Plans Include section ───────────────────────────
                            _buildAllPlansInclude(),
                            const SizedBox(height: 10),

                            // ── Secure payment note ─────────────────────────────────
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.lock_outline,
                                      size: 14, color: Color(0xFF3C3C3C)),
                                  SizedBox(width: 6),
                                  Text(
                                    '100% Secure Payment',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF3C3C3C),
                                    ),
                                  ),
                                ],
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

  // ── Top bar ─────────────────────────────────────────────────────────────────

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: Color(0xFFFBF8F8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back,
                size: 24, color: Color(0xFF01442D)),
          ),
          const SizedBox(width: 12),
          const Text(
            'Subscription',
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

  // ── Banner ──────────────────────────────────────────────────────────────────

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/drawer_image/subscription.png',
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ── Monthly / Yearly toggle ──────────────────────────────────────────────────

  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Color(0xFF6E6E6E)
          )
        ),
        child: Row(
          children: [
            _toggleOption('Monthly', !_isYearly),
            _toggleOption('Yearly', _isYearly),
          ],
        ),
      ),
    );
  }

  Widget _toggleOption(String label, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () =>
            setState(() => _isYearly = label == 'Yearly'),
        child: Container(
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF005F65) : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isActive? FontWeight.w700 : FontWeight.w500,
              color: isActive ? Colors.white : const Color(0xFF000000),
            ),
          ),
        ),
      ),
    );
  }

  // ── Plan card ────────────────────────────────────────────────────────────────

  Widget _buildPlanCard(_PlanData plan) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFCECECE),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Plan header row ───────────────────────────────────────
                Row(
                  children: [
                    // Icon
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: plan.backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          plan.imageAsset,
                          width: 22,
                          height: 22,
                          errorBuilder: (_, __, ___) => Icon(
                            plan.name == 'Free'
                                ? Icons.flash_on
                                : plan.name == 'Premium'
                                ? Icons.workspace_premium
                                : Icons.business_center,
                            size: 20,
                            color: plan.iconColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF000000),
                            ),
                          ),
                          Text(
                            plan.tagline,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB1B1B1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Current Plan badge (only for Free)
                    if (plan.isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF3FD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Current Plan',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF003399),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // ── Price row ─────────────────────────────────────────────
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Image.asset('assets/my_booking/rupee.png',
                      height: 12,
                      color: Color(0xFF000000),
                    ),
                    SizedBox(width: 5,),
                    Text(
                      '${plan.price} ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF000000),
                      ),
                    ),
                    Text(
                      plan.period,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF000000),
                      ),
                    ),
                    if (plan.originalPrice != null) ...[
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Image.asset('assets/my_booking/rupee.png',
                            height: 10,
                          ),
                          SizedBox(width: 2,),
                          Text(
                            plan.originalPrice!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5F6368),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),

                // ── Features list ─────────────────────────────────────────
                SizedBox(
                  height: (plan.features.length > 3) ? 60 : 28,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: plan.features.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 4,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      return _featureChip(plan.features[index]);
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // ── Action button ─────────────────────────────────────────
                // ── Action button ─────────────────────────────────────────
                if (!plan.isCurrent) _buildPlanButton(plan),
              ],
            ),
          ),

          // ── MOST POPULAR badge ────────────────────────────────────────────
          if (plan.isMostPopular)
            Positioned(
              top: -12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A3BDF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'MOST POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _featureChip(String label) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 14,
          color: Color(0xFF01422D),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.4,
              color: Color(0xFF5F6368),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanButton(_PlanData plan) {
    if (plan.buttonStyle == _ButtonStyle.outlined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF005F65)),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            plan.buttonLabel,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF005F65),
            ),
          ),
        ),
      );
    }

    final Color btnColor = plan.buttonStyle == _ButtonStyle.purple
        ? const Color(0xFF6939DF)
        : const Color(0xFFF68E01);

    return Center(
      child: SizedBox(
        width: 280,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: btnColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: Text(
            plan.buttonLabel,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ── All Plans Include ────────────────────────────────────────────────────────

  Widget _buildAllPlansInclude() {
    final benefits = [
      'Secure\nPayments',
      'Verified\nusers',
      'Data\nProtection',
      '24/7\nSupport',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Text(
            'All Plans Include',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: benefits
                .map((title) => _benefitCard(title))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _benefitCard(String title) {
    return Container(
      width: 75,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0x40000000),
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF000000),
          ),
        ),
      ),
    );
  }
}

// ─── Data Models ──────────────────────────────────────────────────────────────

enum _ButtonStyle { outlined, purple, orange }

class _PlanData {
  final String name;
  final String tagline;
  final String price;
  final String period;
  final String? originalPrice;
  final bool isMostPopular;
  final bool isCurrent;
  final String buttonLabel;
  final _ButtonStyle buttonStyle;
  final String imageAsset;
  final Color iconColor;
  final Color backgroundColor;
  final List<String> features;

  const _PlanData({
    required this.name,
    required this.tagline,
    required this.price,
    required this.period,
    this.originalPrice,
    required this.isMostPopular,
    required this.isCurrent,
    required this.buttonLabel,
    required this.buttonStyle,
    required this.imageAsset,
    required this.iconColor,
    required this.backgroundColor,
    required this.features,
  });
}

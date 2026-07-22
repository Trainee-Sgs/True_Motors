import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;

class DealerDetailsScreen extends StatelessWidget {
  const DealerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF01422D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'RS Hyundai Showroom',
          style: TextStyle(
            color: Color(0xFF01422D),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMapCard(),
              const SizedBox(height: 16),
              _buildDetailsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapCard() {
    // A simple static map representing the dealer's location
    final center = const LatLng(11.0168, 76.9558); // Coimbatore rough coords

    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: 13.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
              userAgentPackageName: 'com.truemotors.app',
            ),
            CircleLayer(
              circles: [
                CircleMarker(
                  point: center,
                  color: Colors.blue.withOpacity(0.15),
                  borderStrokeWidth: 1,
                  borderColor: Colors.blue.withOpacity(0.3),
                  useRadiusInMeter: true,
                  radius: 1200,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: center,
                  width: 24,
                  height: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 4)
                      ],
                    ),
                  ),
                ),
                Marker(
                  point: LatLng(center.latitude + 0.005, center.longitude + 0.005),
                  width: 130,
                  height: 50,
                  alignment: Alignment.topCenter,
                  child: const _SimpleMarker(
                    name: "Speed Motors",
                    distance: "1.2 km",
                    iconColor: Colors.deepPurple,
                    icon: Icons.location_on,
                  ),
                ),
                Marker(
                  point: LatLng(center.latitude - 0.003, center.longitude + 0.008),
                  width: 130,
                  height: 50,
                  alignment: Alignment.topCenter,
                  child: const _SimpleMarker(
                    name: "Prime Wheels",
                    distance: "0.6 km",
                    iconColor: Colors.red,
                    icon: Icons.store,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RS Hyundai Showroom',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'No.12, Avinashi Road, Coimbatore',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Distance', '2.1 kms'),
          _buildDetailRow('Hours', '9:30 AM – 8:00 PM'),
          _buildDetailRow('This car in stock', '3 units'),
          _buildDetailRowWithIcon(
            'Authorized Dealer',
            'Verified',
            Icons.check,
          ),
          _buildDetailRow('Rating', '4.3 ★ (210 reviews)'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF01422D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Call Dealer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF01422D)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Get Direction',
                style: TextStyle(
                  color: Color(0xFF01422D),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Book Test Drive',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Colors.black12),
      ],
    );
  }

  Widget _buildDetailRowWithIcon(String label, String value, IconData icon) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  Icon(icon, size: 18, color: Colors.black),
                  const SizedBox(width: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Colors.black12),
      ],
    );
  }
}

class _SimpleMarker extends StatelessWidget {
  final String name;
  final String distance;
  final Color iconColor;
  final IconData icon;

  const _SimpleMarker({
    required this.name,
    required this.distance,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 10, color: Colors.white),
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(name, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(distance, style: const TextStyle(fontSize: 8, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
        // Small triangle for the pointer
        CustomPaint(
          size: const Size(10, 6),
          painter: _TrianglePainter2(),
        ),
      ],
    );
  }
}

class _TrianglePainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawShadow(path, Colors.black, 1.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

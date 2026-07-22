import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'seller_information_screen.dart';
import 'terms_and_conditions_screen.dart';

class SellCarPhotoScreen extends StatefulWidget {
  final String registrationNumber;
  final String vehicleType;
  final String brand;
  final String model;
  final String fuelType;
  final String transmission;
  final String regYear;
  final String kmDriven;
  final String location;
  final String rto;
  final String price;
  final String insuranceDate;
  final List<String> features;

  const SellCarPhotoScreen({
    super.key,
    required this.registrationNumber,
    required this.vehicleType,
    required this.brand,
    required this.model,
    required this.fuelType,
    required this.transmission,
    required this.regYear,
    required this.kmDriven,
    required this.location,
    required this.rto,
    required this.price,
    required this.insuranceDate,
    required this.features,
  });

  @override
  State<SellCarPhotoScreen> createState() => _SellCarPhotoScreenState();
}

class _SellCarPhotoScreenState extends State<SellCarPhotoScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];
  final TextEditingController _additionalInfoController =
  TextEditingController();
  bool _allowTestDrive = false;

  // Validation
  String? _photoError;

  static const int _maxWordCount = 200;

  int get _wordCount {
    final text = _additionalInfoController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  }

  // ── Image picking ─────────────────────────────────────────────────────────

  Future<void> _openCamera() async {
    try {
      final XFile? photo =
      await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (photo != null) {
        setState(() {
          _selectedImages.add(File(photo.path));
          _photoError = null;
        });
      }
    } catch (e) {
      _showError('Camera not available. Please check permissions.');
    }
  }

  Future<void> _openGallery() async {
    try {
      final List<XFile> photos =
      await _picker.pickMultiImage(imageQuality: 85);
      if (photos.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(photos.map((p) => File(p.path)));
          _photoError = null;
        });
      }
    } catch (e) {
      _showError('Gallery not available. Please check permissions.');
    }
  }

  Future<void> _openFilePicker() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result != null) {
        setState(() {
          _selectedImages.addAll(result.files.map((f) => File(f.path!)));
          _photoError = null;
        });
      }
    } catch (e) {
      _showError('File picker not available.');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  // ── Validation & navigation ───────────────────────────────────────────────

  bool _validate() {
    setState(() {
      _photoError =
      _selectedImages.isEmpty ? 'Please add at least one photo' : null;
    });
    return _photoError == null;
  }

  void _onSaveAndNext() {
    if (_validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SellerInformationScreen(
            registrationNumber: widget.registrationNumber,
            vehicleType: widget.vehicleType,
            brand: widget.brand,
            model: widget.model,
            fuelType: widget.fuelType,
            transmission: widget.transmission,
            regYear: widget.regYear,
            kmDriven: widget.kmDriven,
            location: widget.location,
            rto: widget.rto,
            price: widget.price,
            insuranceDate: widget.insuranceDate,
            features: widget.features,
            images: _selectedImages,
            allowTestDrive: _allowTestDrive,
            additionalInfo: _additionalInfoController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPromoBanner(),
                    const SizedBox(height: 10),

                    // Title
                    Text(
                      'Sell Vehicle - ${widget.registrationNumber}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),

                    // ── Dashed upload box (always visible) ────────────────
                    _buildDashedUploadBox(),

                    if (_photoError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          _photoError!,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 12),
                        ),
                      ),

                    const SizedBox(height: 14),

                    // ── Selected images (shown below the box) ─────────────
                    if (_selectedImages.isNotEmpty) _buildImageGrid(),

                    const SizedBox(height: 12),

                    // ── Add more images ───────────────────────────────────
                    GestureDetector(
                      onTap: _openGallery,
                      child: Row(
                        children: const [
                          Icon(Icons.add, color: Color(0xFF742B88), size: 20),
                          SizedBox(width: 6),
                          Text(
                            'Add more images',
                            style: TextStyle(
                              fontFamily: 'Lato',
                                color: Color(0xFF742B88),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Terms & Conditions button ─────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TermsAndConditionsScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFD59090), // #D59090
                                Color(0xFFDF7B7B), // #DF7B7B
                              ],
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            child: const Text(
                              'Terms & Conditions For Sell Vehicle',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                fontFamily: 'Lato'
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Allow Test Drive ──────────────────────────────────
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _allowTestDrive,
                            activeColor: const Color(0xFF005F65),
                            side: BorderSide(
                              width: 1.2,
                              color: Color(0xFF742B88)
                            ),
                            onChanged: (v) =>
                                setState(() => _allowTestDrive = v ?? false),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Allow Test drive',
                          style: TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Additional Info ───────────────────────────────────
                    const Text(
                      'Additional Info (Optional)',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _additionalInfoController,
                      maxLines: 5,
                      onChanged: (text) {
                        final words = text
                            .trim()
                            .split(RegExp(r'\s+'))
                            .where((w) => w.isNotEmpty)
                            .toList();
                        if (words.length > _maxWordCount) {
                          final trimmed =
                          words.take(_maxWordCount).join(' ');
                          _additionalInfoController.value =
                              TextEditingValue(
                                text: trimmed,
                                selection: TextSelection.collapsed(
                                    offset: trimmed.length),
                              );
                        }
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText:
                        'Describe your vehicle',
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          BorderSide(color: Color(0xFFD4D4D4)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          BorderSide(color: Color(0xFFD4D4D4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Color(0xFF005F65)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    // Word counter
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '$_wordCount / $_maxWordCount words',
                          style: TextStyle(
                            fontSize: 12,
                            color: _wordCount >= _maxWordCount
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Navigation buttons ────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              side: const BorderSide(
                                  color: Color(0xFF005F65)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text(
                              'Previous',
                              style: TextStyle(
                                  color: Color(0xFF005F65),
                                  fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _onSaveAndNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF005F65),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text(
                              'Save & Next',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  // ── App bar ───────────────────────────────────────────────────────────────
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
          const Text('Sell car',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF01422D))),
        ],
      ),
    );
  }

  // ── Promo banner ──────────────────────────────────────────────────────────
  Widget _buildPromoBanner() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00274B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 5, top: 5),
            child: Image.asset(
              'assets/sell_image/red_car.png',
              width: 145,
              height: 140,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Sell Your Car Instantly',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Calistoga',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 1),
                  const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Best price,Free inspection.\nInstant payment',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Calistoga',
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Get Free Quote',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Calistoga',
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
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

  // ── Dashed upload box — always visible, matches Figma exactly ────────────
  Widget _buildDashedUploadBox() {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: Color(0xFF005F65),
        borderRadius: 12,
        dashWidth: 10,
        dashSpace: 8,
        strokeWidth: 3,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text first (matches Figma order)
            const Text(
              'Tap to upload your photo',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),

            // Cloud icon — tapping opens file picker
            GestureDetector(
              onTap: _openFilePicker,
              child: Image.asset('assets/sell_image/cloud.png',
                height: 48,
                width: 48,
              )
            ),
            const SizedBox(height: 10),

            // Max size label
            const Text(
              'Maximum 5 MB file size',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 16),

            // Divider with "or"
            Row(
              children: [
                Expanded(
                  child: Divider(
                      color: Color(0xFFBABABA), thickness: 1),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Divider(
                      color: Color(0xFFBABABA), thickness: 1),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Open Camera button
            SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: _openCamera,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005F65),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Open Camera',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Selected images shown below the dashed box ────────────────────────────
  Widget _buildImageGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Horizontal scrollable thumbnails
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _selectedImages.length,
            itemBuilder: (_, i) {
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImages[i],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 14,
                    child: GestureDetector(
                      onTap: () => _removeImage(i),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(3),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Custom painter for dashed border ─────────────────────────────────────────
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  _DashedBorderPainter({
    required this.color,
    required this.borderRadius,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final dashPath = _createDashedPath(path);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source) {
    final Path dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final len = draw ? dashWidth : dashSpace;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color ||
          old.dashWidth != dashWidth ||
          old.dashSpace != dashSpace;
}
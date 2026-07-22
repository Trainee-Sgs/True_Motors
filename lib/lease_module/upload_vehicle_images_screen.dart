import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:true_motors/lease_module/location_documents_screen.dart';

class UploadVehicleImagesScreen extends StatefulWidget {
  final String vehicleType;
  final String brand;
  final String model;
  final String fuelType;
  final String transmission;
  final String year;
  final String kmDriven;

  const UploadVehicleImagesScreen({
    super.key,
    required this.vehicleType,
    required this.brand,
    required this.model,
    required this.fuelType,
    required this.transmission,
    required this.year,
    required this.kmDriven,
  });

  @override
  State<UploadVehicleImagesScreen> createState() =>
      _UploadVehicleImagesScreenState();
}

class _UploadVehicleImagesScreenState
    extends State<UploadVehicleImagesScreen> {
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
      final XFile? photo = await _picker.pickImage(
          source: ImageSource.camera, imageQuality: 80);
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
      await _picker.pickMultiImage(imageQuality: 80);
      if (photos.isNotEmpty) {
        setState(() {
          for (final f in photos) {
            if (_selectedImages.length < 10) {
              _selectedImages.add(File(f.path));
            }
          }
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
          builder: (_) => LocationDocumentsScreen(
            vehicleType: widget.vehicleType,
            brand: widget.brand,
            model: widget.model,
            fuelType: widget.fuelType,
            transmission: widget.transmission,
            year: widget.year,
            kmDriven: widget.kmDriven,
            imagePaths: _selectedImages.map((f) => f.path).toList(),
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
      backgroundColor: const Color(0xFFF2F2F2),
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
                    Text(
                      'Upload Vehicle Images',
                      style: const TextStyle(
                        color: Color(0xFF01422D),
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),

                    // ── Dashed upload box ──────────────────────────────────
                    _buildDashedUploadBox(),

                    if (_photoError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _photoError!,
                          style: const TextStyle(
                              color: Color(0xFFBE000C), fontSize: 12),
                        ),
                      ),

                    const SizedBox(height: 14),

                    // ── Selected images ────────────────────────────────────
                    if (_selectedImages.isNotEmpty) _buildImageGrid(),

                    const SizedBox(height: 12),

                    // ── Add more images ────────────────────────────────────
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
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Additional Info ────────────────────────────────────
                    const Text(
                      'Additional Info (Optional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _additionalInfoController,
                      maxLines: 3,
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
                        hintText: 'Describe your vehicle',
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          const BorderSide(color: Color(0xFFD4D4D4)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          const BorderSide(color: Color(0xFFD4D4D4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                          const BorderSide(color: Color(0xFF005F65)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ── Navigation buttons ─────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(
                                  color: Color(0xFF005F65)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text(
                              'Previous',
                              style: TextStyle(
                                color: Color(0xFF005F65),
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _onSaveAndNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF005F65),
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text(
                              'Save & Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back,
                size: 24, color: Color(0xFF01422D)),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Add New Vehicle',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF01422D),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // ── Dashed upload box ─────────────────────────────────────────────────────
  Widget _buildDashedUploadBox() {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: const Color(0xFF005F65),
        borderRadius: 12,
        dashWidth: 10,
        dashSpace: 8,
        strokeWidth: 3,
      ),
      child: Container(
        width: double.infinity,
        padding:
        const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Tap to upload your photo',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _openFilePicker,
              child: Image.asset(
                'assets/sell_image/cloud.png',
                height: 48,
                width: 48,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Maximum 5 MB file size',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: Divider(color: Color(0xFFBABABA), thickness: 1),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Divider(color: Color(0xFFBABABA), thickness: 1),
                ),
              ],
            ),
            const SizedBox(height: 16),
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

  // ── Selected images grid ──────────────────────────────────────────────────
  Widget _buildImageGrid() {
    return SizedBox(
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
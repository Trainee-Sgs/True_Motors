import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:true_motors/login_module/login_screen.dart';
import 'package:true_motors/login_module/signup_screen.dart';
import 'package:true_motors/provider/otp_screen_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  // ── Data passed in from LoginScreen
  final String mobile;
  final String fToken;
  final String cid;
  final String latitude;
  final String longitude;
  final String deviceId;
  final String appSignature;

  const OtpScreen({
    super.key,
    required this.mobile,
    required this.fToken,
    required this.cid,
    required this.latitude,
    required this.longitude,
    required this.deviceId,
    required this.appSignature,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int secondsRemaining = 30;
  Timer? timer;
  final TextEditingController otpController = TextEditingController();

  // API loading states
  bool _isVerifying = false;
  bool _isResending = false;

  // f_token can be refreshed on resend; start with what login gave us
  late String _currentToken;

  @override
  void initState() {
    super.initState();
    _currentToken = widget.fToken;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    timer?.cancel();
    super.dispose();
  }

  // ── Verify OTP API call ───────────────────────────────────────────────────
  Future<void> _verifyOtp() async {
    final enteredOtp = otpController.text.trim();
    if (enteredOtp.length < 6) {
      _showError('Please enter the complete 6-digit OTP.');
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final request = OtpRequest(
        cid: widget.cid,
        mobile: widget.mobile,
        otp: enteredOtp,
        token: _currentToken,
      );

      final response = await OtpApi.verifyOtp(request);

      if (!mounted) return;

      if (!response.error) {
        // Save persistent login data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', response.userId);
        await prefs.setString('token', response.token);
        await prefs.setString('phone', response.mobile);
        
        // Success — navigate to SignupScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignupScreen(),
          ),
        );
      } else {
        _showError(response.message.isNotEmpty
            ? response.message
            : 'OTP verification failed. Please try again.');
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Something went wrong. Please check your connection.');
      print('[OtpScreen] Verify error: $e');
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  // ── Resend OTP API call ───────────────────────────────────────────────────
  Future<void> _resendOtp() async {
    setState(() => _isResending = true);

    try {
      final json = await OtpApi.resendOtp(
        cid: widget.cid,
        mobile: widget.mobile,
        appSignature: widget.appSignature,
      );

      if (!mounted) return;

      final bool hasError = json['error'] ?? true;

      if (!hasError) {
        // Update token with the freshly issued one
        final newToken = json['f_token']?.toString() ?? _currentToken;
        setState(() {
          _currentToken = newToken;
          secondsRemaining = 30;
        });
        otpController.clear();
        startTimer();
        _showSuccess('OTP resent successfully.');
      } else {
        final msg = json['error_msg']?.toString() ?? '';
        _showError(msg.isNotEmpty ? msg : 'Failed to resend OTP. Try again.');
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Something went wrong. Please check your connection.');
      print('[OtpScreen] Resend error: $e');
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(fontFamily: 'Lato', color: Colors.white)),
        backgroundColor: const Color(0xFFBE000C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(fontFamily: 'Lato', color: Colors.white)),
        backgroundColor: const Color(0xFF005F65),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Lato'),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Color(0xFFFBF8F8),
          titleSpacing: 0,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: Icon(
              Icons.arrow_back,
              color: Color(0XFF005f65),
            ),
          ),

          title: Text(
            'OTP Verification',
            style: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Color(0xFF005F65),
            ),
          ),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.08),
            child: Column(
              children: [
                SizedBox(height: height * 0.05),
                Image.asset(
                  'assets/login_image/otp.png',
                  height: 250,
                  width: 250,
                ),

                SizedBox(height: height * 0.04),
                Text(
                  'Your One Time Password (OTP) has been\nSend via SMS to Registered Mobile Number',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF000000),
                  ),
                ),

                SizedBox(height: height * 0.04),

                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: otpController,
                  autoDisposeControllers: false,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  autoFocus: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 44,
                    fieldWidth: 44,
                    borderWidth: 0.02,
                    activeColor: const Color(0xFF005F65),
                    selectedColor: const Color(0xFF005F65),
                    inactiveColor: const Color(0xFF005F65),
                  ),
                  onChanged: (value) {},
                  onCompleted: (value) {},
                ),

                SizedBox(height: height * 0.03),
                Align(
                  alignment: Alignment.centerLeft,
                  child: secondsRemaining == 0
                      ? GestureDetector(
                    onTap: _isResending ? null : _resendOtp,
                    child: _isResending
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Color(0xFF005F65),
                        strokeWidth: 2,
                      ),
                    )
                        : Container(
                      padding: EdgeInsets.only(bottom: 2),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0XFF005F65),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: Color(0XFF005F65),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                      : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 2),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0XFF005F65),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          'Resend OTP in',
                          style: TextStyle(
                            color: Color(0XFF005F65),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '$secondsRemaining Sec',
                        style: TextStyle(
                          color: Color(0XFF005F65),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.04),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF005F65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isVerifying ? null : _verifyOtp,
                    child: _isVerifying
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                        : Text(
                      'VERIFY',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'admin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;

  AnimationController? _glowController;
  AnimationController? _particleController;
  Animation<double>? _glowAnimation;

  final String _userOtp = '123456';
  final String _adminOtp = '654321';

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController!, curve: Curves.easeInOut),
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _glowController?.dispose();
    _particleController?.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_phoneController.text.length == 10) {
      setState(() {
        _isOtpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('OTP Sent! (Use 123456 for User, 654321 for Admin)'),
          backgroundColor: const Color(0xFF4A148C),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid 10-digit phone number'),
          backgroundColor: Colors.red[900],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _verifyOtp() {
    String inputOtp = _otpController.text;

    if (inputOtp == _userOtp) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (inputOtp == _adminOtp) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid OTP. Please try again.'),
          backgroundColor: Colors.red[900],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a0933),
              Color(0xFF0d0221),
              Color(0xFF000000),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated particles
            ...List.generate(30, (index) {
              return AnimatedParticle(
                delay: index * 0.2,
                duration: 4 + (index % 3),
              );
            }),

            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Glowing logo with animated border - Horizontal Oval with Curved Edges
                        AnimatedBuilder(
                          animation: _glowController ?? const AlwaysStoppedAnimation(0.0),
                          builder: (context, child) {
                            final glowValue = _glowAnimation?.value ?? 1.0;

                            return Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Animated pulsing purple border
                                  Container(
                                    height: 250,
                                    width: 390,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(135),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF4A148C).withOpacity(0.8 * glowValue),
                                          Color(0xFF6A1B9A).withOpacity(1.0 * glowValue),
                                          Color(0xFF4A148C).withOpacity(0.8 * glowValue),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF4A148C).withOpacity(0.6 * glowValue),
                                          blurRadius: 30,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Inner black oval to create border effect
                                  Container(
                                    height: 254,
                                    width: 334,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(127),
                                      color: const Color(0xFF0d0221),
                                    ),
                                  ),
                                  // Glowing image
                                  Container(
                                    height: 238,
                                    width: 318,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(119),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFFFF6F00).withOpacity(0.6 * glowValue),
                                          blurRadius: 50,
                                          spreadRadius: 15,
                                        ),
                                        BoxShadow(
                                          color: Color(0xFF00BCD4).withOpacity(0.4 * glowValue),
                                          blurRadius: 70,
                                          spreadRadius: 25,
                                        ),
                                        BoxShadow(
                                          color: Color(0xFF4A148C).withOpacity(0.5 * glowValue),
                                          blurRadius: 90,
                                          spreadRadius: 35,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(119),
                                      child: Image.asset(
                                        'assets/app_icon.jpg',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(119),
                                              color: const Color(0xFF1A1F3A),
                                            ),
                                            child: const Icon(
                                              Icons.phone_android,
                                              size: 90,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 40),

                        // Title - Expanded to prevent overflow
                        const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'ಓಂ ನಮಃ ಶಿವಾಯ',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  color: Color(0xFFFF6F00),
                                  blurRadius: 25,
                                ),
                                Shadow(
                                  color: Color(0xFF4A148C),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 50),

                        // Phone Input Field
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4A148C).withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                              prefixIcon: const Icon(Icons.phone, color: Color(0xFFFF6F00)),
                              filled: true,
                              fillColor: const Color(0xFF1a0933).withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Color(0xFF4A148C), width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: const Color(0xFF4A148C).withOpacity(0.5), width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Color(0xFFFF6F00), width: 2),
                              ),
                              counterText: '',
                            ),
                            enabled: !_isOtpSent,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // OTP Section or Send Button
                        if (_isOtpSent) ...[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00BCD4).withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                letterSpacing: 8,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                labelText: 'Enter OTP',
                                labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                                prefixIcon: const Icon(Icons.lock, color: Color(0xFF00BCD4)),
                                filled: true,
                                fillColor: const Color(0xFF1a0933).withOpacity(0.8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFF00BCD4), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: const Color(0xFF00BCD4).withOpacity(0.5), width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFF00BCD4), width: 2),
                                ),
                                counterText: '',
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF6F00),
                                  Color(0xFFFF8F00),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF6F00).withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _verifyOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Verify OTP',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _isOtpSent = false;
                                  _otpController.clear();
                                });
                              },
                              child: const Text(
                                'Change Phone Number',
                                style: TextStyle(
                                  color: Color(0xFF00BCD4),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF4A148C),
                                  Color(0xFF6A1B9A),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4A148C).withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _sendOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Send OTP',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animated particle widget for background
class AnimatedParticle extends StatefulWidget {
  final double delay;
  final int duration;

  const AnimatedParticle({
    super.key,
    required this.delay,
    required this.duration,
  });

  @override
  State<AnimatedParticle> createState() => _AnimatedParticleState();
}

class _AnimatedParticleState extends State<AnimatedParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _left;
  late double _top;
  late double _size;
  late Color _color;

  @override
  void initState() {
    super.initState();
    _left = (widget.delay * 60) % 100;
    _top = (widget.delay * 80) % 100;
    _size = 1.5 + (widget.delay % 2.5);

    final colors = [
      const Color(0xFFFF6F00),
      const Color(0xFF00BCD4),
      Colors.white,
      const Color(0xFF4A148C),
    ];
    _color = colors[(widget.delay * 10).toInt() % colors.length];

    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: (widget.delay * 100).toInt()), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _left,
      top: _top,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value * 0.6,
            child: Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _color,
                boxShadow: [
                  BoxShadow(
                    color: _color.withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
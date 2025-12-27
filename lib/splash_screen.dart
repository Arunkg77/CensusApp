import 'dart:async';
import 'package:flutter/material.dart';
import 'admin_main_screen.dart';
import 'admin_screen.dart';
import 'auth_helper.dart';
import 'home_Screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Pulsing animation for the glow
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Rotation animation for outer ring
    _rotateController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    _rotateAnimation = Tween<double>(begin: 0, end: 1).animate(_rotateController);

    // Fade in animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _fadeController.forward();

// inside splash_screen.dart initState
    Timer(const Duration(seconds: 3), () async {
      // Check login status
      final status = await AuthHelper.getLoginStatus();

      if (!mounted) return;

      if (status['isLoggedIn'] == true) {
        // Route based on user type
        Widget nextScreen = status['userType'] == AuthHelper.userTypeAdmin
            ? const AdminMainScreen()
            : const HomeScreen();

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => nextScreen));
      } else {
        // Not logged in, go to Login
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF1a0933), // Deep purple center
              Color(0xFF0d0221), // Almost black
              Color(0xFF000000), // Pure black edges
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated particles/stars
            ...List.generate(50, (index) {
              return AnimatedStar(
                delay: index * 0.1,
                duration: 3 + (index % 5),
              );
            }),

            // Rotating outer glow ring


            // Pulsing glow effect

            // Main image with fade in
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                  child: Hero(
                    tag: 'splash_image',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFF6F00).withOpacity(0.6),
                            blurRadius: 50,
                            spreadRadius: 10,
                          ),
                          BoxShadow(
                            color: Color(0xFF00BCD4).withOpacity(0.4),
                            blurRadius: 80,
                            spreadRadius: 20,
                          ),
                          BoxShadow(
                            color: Color(0xFF4A148C).withOpacity(0.5),
                            blurRadius: 100,
                            spreadRadius: 30,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          'assets/splash.jpg',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Color(0xFF1A1F3A),
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 100,
                                color: Colors.white24,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom loading with sacred geometry effect
          ],
        ),
      ),
    );
  }
}

// Animated star/particle widget
class AnimatedStar extends StatefulWidget {
  final double delay;
  final int duration;

  const AnimatedStar({
    super.key,
    required this.delay,
    required this.duration,
  });

  @override
  State<AnimatedStar> createState() => _AnimatedStarState();
}

class _AnimatedStarState extends State<AnimatedStar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _left;
  late double _top;
  late double _size;

  @override
  void initState() {
    super.initState();
    _left = (widget.delay * 50) % 100;
    _top = (widget.delay * 70) % 100;
    _size = 1 + (widget.delay % 3);

    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(
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
            opacity: _animation.value,
            child: Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
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
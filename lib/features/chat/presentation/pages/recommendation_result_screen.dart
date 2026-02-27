import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../home/domain/models/doctor.dart';
import '../../../home/presentation/widgets/doctor_card.dart';
import '../../../home/presentation/pages/main_wrapper.dart';
import '../../../home/presentation/pages/doctor_details_screen.dart';

class RecommendationResultScreen extends StatefulWidget {
  final Doctor doctor;
  const RecommendationResultScreen({super.key, required this.doctor});

  @override
  State<RecommendationResultScreen> createState() =>
      _RecommendationResultScreenState();
}

class _RecommendationResultScreenState extends State<RecommendationResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // Ensure keyboard is dismissed when showing results
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  "We found the perfect match!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  "Based on your symptoms, we recommend consulting with this specialist.",
                  style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),
    
              RepaintBoundary(
                child: Focus(
                  focusNode: FocusNode(),
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: DoctorCard(doctor: widget.doctor),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              FadeTransition(
                opacity: _fadeAnimation,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainWrapper(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Skip to Home",
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

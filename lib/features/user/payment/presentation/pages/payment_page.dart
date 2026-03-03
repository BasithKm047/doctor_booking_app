import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/user/appointment/domain/entities/user_appointment_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_booking_app/core/di/injection.dart';
import 'package:doctor_booking_app/features/user/appointment/presantation/bloc/booking_bloc.dart';
import 'package:doctor_booking_app/features/user/appointment/presantation/bloc/booking_event.dart';
import 'package:doctor_booking_app/features/user/appointment/presantation/bloc/booking_state.dart';
import 'package:doctor_booking_app/core/widgets/custom_snack_bar.dart';
import 'package:doctor_booking_app/features/user/home/presentation/pages/main_wrapper.dart';

import '../../../home/domain/entities/user_doctor_entity.dart';
import '../widgets/payment_doctor_card.dart';
import '../widgets/payment_info_card.dart';
import '../widgets/payment_method_option.dart';

class PaymentPage extends StatefulWidget {
  final UserDoctorEntity doctor;
  final UserAppointmentEntity appointment;

  const PaymentPage({
    super.key,
    required this.doctor,
    required this.appointment,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectedMethodIndex = 0;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'icon': Icons.credit_card,
      'title': 'Credit / Debit Card',
      'subtitle': '•••• •••• •••• 4242',
    },
    {
      'icon': Icons.account_balance_wallet_outlined,
      'title': 'PayPal',
      'subtitle': 'pay***@email.com',
    },
    {'icon': Icons.apple, 'title': 'Apple Pay', 'subtitle': 'Fast and secure'},
  ];

  @override
  Widget build(BuildContext context) {
    final displayTime = _formatTimeForDisplay(widget.appointment.appointmentTime);
    return BlocProvider(
      create: (context) => sl<BookingBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Payment',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildSectionHeader(
                'Booking Summary',
                'Please review your appointment details',
              ),
              const SizedBox(height: 16),
              PaymentDoctorCard(doctor: widget.doctor),
              const SizedBox(height: 16),
              PaymentInfoCard(
                date: DateFormat(
                  'MMM dd, yyyy',
                ).format(widget.appointment.appointmentDate),
                time: displayTime,
                fee: widget.doctor.consultationFee,
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(
                'Payment Method',
                'Select how you\'d like to pay',
              ),
              const SizedBox(height: 16),
              ...List.generate(paymentMethods.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PaymentMethodOption(
                    icon: paymentMethods[index]['icon'],
                    title: paymentMethods[index]['title'],
                    subtitle: paymentMethods[index]['subtitle'],
                    isSelected: selectedMethodIndex == index,
                    onTap: () => setState(() => selectedMethodIndex = index),
                  ),
                );
              }),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Secure SSL encrypted payment',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              BlocConsumer<BookingBloc, BookingState>(
                listener: (context, state) {
                  if (state is BookingSuccess) {
                    CustomSnackBar.show(
                      context,
                      'Appointment Booked Successfully!',
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainWrapper(),
                      ),
                      (route) => false,
                    );
                  } else if (state is BookingSubmitError) {
                    CustomSnackBar.show(
                      context,
                      'Booking failed: ${state.message}',
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is BookingSubmitting;
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<BookingBloc>().add(
                              SubmitBookingEvent(widget.appointment),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.medConnectPrimary,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFF1E5BB1).withOpacity(0.4),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Pay \$${widget.doctor.consultationFee.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'By clicking "Pay Now", you agree to our terms of service and cancellation policy. Your card information is handled securely.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeForDisplay(String raw) {
    // Stored format is expected to be HH:mm:ss (from availability picker / booking)
    try {
      final dt = DateFormat('HH:mm:ss').parse(raw);
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return raw;
    }
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}

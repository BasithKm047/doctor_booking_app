import 'package:doctor_booking_app/features/user/home/presentation/widgets/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_home_bloc.dart';
import '../bloc/user_home_state.dart';
import '../widgets/all_doctors_app_bar.dart';
import '../widgets/all_doctors_search_bar.dart';
import '../widgets/specialty_chip_list.dart';

class AllDoctorsScreen extends StatelessWidget {
  const AllDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AllDoctorsAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const AllDoctorsSearchBar(),
            const SizedBox(height: 20),
            const SpecialtyChipList(),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<UserHomeBloc, UserHomeState>(
                builder: (context, state) {
                  if (state is UserHomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UserHomeLoaded) {
                    if (state.doctors.isEmpty) {
                      return const Center(child: Text('No doctors found'));
                    }
                    return ListView.builder(
                      itemCount: state.doctors.length,
                      padding: const EdgeInsets.only(bottom: 24),
                      itemBuilder: (context, index) {
                        final doctor = state.doctors[index];
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 500 + (index * 100)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 50 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: DoctorCard(
                            doctor: doctor,
                            isDark: index % 2 != 0,
                          ),
                        );
                      },
                    );
                  } else if (state is UserHomeError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

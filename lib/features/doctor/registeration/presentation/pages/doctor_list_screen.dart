import 'package:doctor_booking_app/core/widgets/custom_snack_bar.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/pages/doctor_registration_page.dart';
import 'package:doctor_booking_app/core/theme/app_colors.dart';
import 'package:doctor_booking_app/features/doctor/registeration/domain/entities/doctor_registration_entity.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/bloc/doctor_bloc.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/bloc/doctor_event.dart';
import 'package:doctor_booking_app/features/doctor/registeration/presentation/bloc/doctor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorBloc>().add(GetDoctorsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Registered Doctors',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<DoctorBloc, DoctorState>(
        listener: (context, state) {
          if (state is DoctorSuccess) {
            CustomSnackBar.show(context, 'Operation Successful!');
            context.read<DoctorBloc>().add(GetDoctorsEvent());
          } else if (state is DoctorError) {
            CustomSnackBar.show(
              context,
              'Error: ${state.message}',
              isError: true,
            );
          }
        },
        builder: (context, state) {
          if (state is DoctorLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.medConnectPrimary,
              ),
            );
          } else if (state is DoctorLoaded) {
            if (state.doctors.isEmpty) {
              return const Center(child: Text('No doctors registered yet.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: state.doctors.length,
              itemBuilder: (context, index) {
                final doctor = state.doctors[index];
                return _buildDoctorCard(context, doctor);
              },
            );
          } else if (state is DoctorError) {
            return Center(
              child: Text('Failed to load doctors: ${state.message}'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDoctorCard(
    BuildContext context,
    DoctorRegistrationEntity doctor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: doctor.profileImage != null
                  ? (doctor.profileImage!.startsWith('http')
                            ? NetworkImage(doctor.profileImage!)
                            : FileImage(File(doctor.profileImage!)))
                        as ImageProvider
                  : null,
              child: doctor.profileImage == null
                  ? const Icon(Icons.person, size: 35, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    doctor.specialization,
                    style: const TextStyle(
                      color: AppColors.medConnectPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${doctor.experience} years experience',
                    style: const TextStyle(
                      color: AppColors.medConnectSubtitle,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DoctorRegistrationPage(doctor: doctor),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmation(context, doctor.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Doctor'),
        content: const Text(
          'Are you sure you want to delete this doctor registration?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<DoctorBloc>().add(DeleteDoctorEvent(id));
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// lib/screens/quiz/location_list_for_quiz.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/location.dart';
import '../../view_models/location_view_model.dart';
import '../../constants/app_colors.dart';
import 'quiz_screen.dart';

class LocationListForQuiz extends StatelessWidget {
  const LocationListForQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    final locationVM = Provider.of<LocationViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Chọn địa điểm để Quiz',
          style: TextStyle(
            color: AppColors.textColor,
            fontFamily: 'JacquesFrancois',
          ),
        ),
        elevation: 0,
      ),
      body: locationVM.locations.isEmpty
          ? const Center(child: Text('Chưa có địa điểm nào.', style: TextStyle(fontSize: 16)))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: locationVM.locations.length,
        itemBuilder: (context, index) {
          final location = locationVM.locations[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(location.name),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(location: location),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../global_widgets/app_backgroun.dart';
import '../global_widgets/app_bars/simple_app_bar.dart';
import '../global_widgets/app_card.dart';
import 'question_number_selection_page.dart';

class DifficultySelectionPage extends StatelessWidget {
  final String selectedCategory;

  const DifficultySelectionPage({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    final List<String> difficulties = ["Easy", "Medium", "Hard"];

    return SafeArea(
      child: Scaffold(
        body: AppBackground(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SimpleAppBar(title: selectedCategory),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Choose a difficulty",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(
                      difficulties.length,
                      (index) => AppCard(
                        title: difficulties[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => QuestionNumberSelectionPage(
                                selectedCategory: selectedCategory,
                                selectedDifficulty: difficulties[index],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

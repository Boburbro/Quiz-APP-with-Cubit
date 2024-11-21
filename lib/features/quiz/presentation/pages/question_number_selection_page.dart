import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/quiz_cubit.dart';
import '../global_widgets/app_backgroun.dart';
import '../global_widgets/app_bars/simple_app_bar.dart';
import '../screens/questions_screen.dart';

class QuestionNumberSelectionPage extends StatefulWidget {
  final String selectedCategory;
  final String selectedDifficulty;

  const QuestionNumberSelectionPage({
    super.key,
    required this.selectedCategory,
    required this.selectedDifficulty,
  });

  @override
  State<QuestionNumberSelectionPage> createState() =>
      _QuestionNumberSelectionPageState();
}

class _QuestionNumberSelectionPageState
    extends State<QuestionNumberSelectionPage> {
  final int _counterInit = 1;
  int _counter = 1;

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizCubit, QuizState>(
      listener: (context, state) {
        if (state is QuizLoadingSuccessState) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => QuestionsScreen(questions: state.quizes),
            ),
          );
        } else if (state is QuizLoadingFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to fetch quizzes. Please try again."),
            ),
          );
        } else if (state is QuizLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16), // Spacing between spinner and text
                      Text(
                        "Loading...",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87, // Text color
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: AppBackground(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SimpleAppBar(title: "Count of Questions"),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Category: ${widget.selectedCategory}",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        "Difficulty: ${widget.selectedDifficulty}",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(height: 50),
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "Choose number of questions",
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            ),
                            CartStepperInt(
                              stepper: _counterInit,
                              size: 45,
                              axis: Axis.horizontal,
                              elevation: 7,
                              value: _counter,
                              didChangeCount: (count) {
                                setState(() {
                                  if (count <= 10) {
                                    _counter = count;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<QuizCubit>().fetchQuizzes(
                            widget.selectedCategory,
                            widget.selectedDifficulty.toLowerCase(),
                            _counter,
                          );
                    },
                    child: const Text(
                      'Start Quiz',
                      style: TextStyle(fontSize: 20),
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

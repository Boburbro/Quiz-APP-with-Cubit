import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_with_cubit/features/quiz/presentation/global_widgets/app_backgroun.dart';

import '../../data/models/quiz_model.dart';
import '../cubit/quiz_cubit.dart';
import 'result_screen.dart';

class QuestionsScreen extends StatefulWidget {
  final List<QuizModel> questions;

  const QuestionsScreen({super.key, required this.questions});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  bool isAnswered = false;
  final List<Map<String, dynamic>> summaries = [];

  void checkAnswer(String selected, String correctAnswer) {
    setState(() {
      selectedAnswer = selected;
      isAnswered = true;
    });
  }

  void moveToNextQuestion(int totalQuestions) {
    final currentQuestion = widget.questions[currentQuestionIndex];

    summaries.add({
      "question": currentQuestion.question,
      "correctAnswer": currentQuestion.correctAnswer,
      "selectedAnswer": selectedAnswer ?? "No Answer",
      "isCorrect": selectedAnswer == currentQuestion.correctAnswer,
    });

    if (currentQuestionIndex < totalQuestions - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        isAnswered = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            summaries: summaries,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizCubit, QuizState>(
      listener: (context, state) {
        if (state is QuizLoadingState) {
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
      builder: (context, state) {
        if (state is QuizLoadingFailureState) {
          return const Center(
            child: Text(
              "Can't fetch Quiz, Try again later",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          );
        } else if (state is QuizLoadingSuccessState) {
          final List<QuizModel> questionsList = state.quizes;
          final currentQuestion = questionsList[currentQuestionIndex];

          return SafeArea(
            child: AppBackground(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 24,
                  left: 24,
                  top: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LinearProgressIndicator(
                      value: (currentQuestionIndex + 1) / questionsList.length,
                      backgroundColor: Colors.blue,
                      color: Colors.white,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'Question ${currentQuestionIndex + 1}/${questionsList.length}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Colors.white.withOpacity(0.9),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                currentQuestion.question,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          ...currentQuestion.shuffledAnswers.map((option) {
                            bool isCorrect =
                                option == currentQuestion.correctAnswer;
                            bool isSelected = selectedAnswer == option;

                            return GestureDetector(
                              onTap: !isAnswered
                                  ? () => checkAnswer(
                                      option, currentQuestion.correctAnswer)
                                  : null,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: isSelected
                                        ? (isCorrect
                                            ? Colors.green
                                            : Colors.red)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            decoration: TextDecoration.none),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    if (isAnswered && isCorrect)
                                      const Icon(Icons.check_circle,
                                          color: Colors.green),
                                    if (isAnswered && isSelected && !isCorrect)
                                      const Icon(Icons.cancel,
                                          color: Colors.red),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: isAnswered
                            ? () => moveToNextQuestion(questionsList.length)
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          currentQuestionIndex == questionsList.length - 1
                              ? "Finish"
                              : "Next",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
/*

 Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                  
                  
                 

                  
                ],
              ),
*/

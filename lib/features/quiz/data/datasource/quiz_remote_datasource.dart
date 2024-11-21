import '../models/quiz_model.dart';

abstract class QuizRemoteDatasource {
  Future<List<QuizModel>> fetchQuiz(
      String category, String difficulty, int numberOfQusetions);
}

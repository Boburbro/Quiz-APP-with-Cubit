import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/error/failure.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class GetQuizUsecase {
  final QuizRepository quizRepository;

  GetQuizUsecase(this.quizRepository);
  Future<dartz.Either<Failure, List<QuizEntity>>> call(
      String category, String difficulty, int numberOfQusetions) {
    return quizRepository.getQuiz(category, difficulty, numberOfQusetions);
  }
}

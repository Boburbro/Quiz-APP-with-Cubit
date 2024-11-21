import 'package:dartz/dartz.dart' as dartz;
import '../../../../core/error/failure.dart';
import '../entities/quiz_entity.dart';

abstract class QuizRepository {
  Future<dartz.Either<Failure, List<QuizEntity>>> getQuiz(
      String category, String difficulty, int numberOfQusetions);
}

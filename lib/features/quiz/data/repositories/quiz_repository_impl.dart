import 'package:dartz/dartz.dart' as dartz;

import '../../../../core/error/failure.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasource/quiz_remote_datasource.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDatasource quizRemoteDatasource;

  QuizRepositoryImpl({required this.quizRemoteDatasource});

  @override
  Future<dartz.Either<Failure, List<QuizEntity>>> getQuiz(
      String category, String difficulty, int numberOfQusetions) async {
    try {
      final quizModels = await quizRemoteDatasource.fetchQuiz(
          category, difficulty, numberOfQusetions);
      final quizEntities =
          quizModels.map((model) => model.toQuizEntity()).toList();

      return dartz.right(quizEntities);
    } catch (e) {
      return dartz.left(ServerFailure());
    }
  }
}

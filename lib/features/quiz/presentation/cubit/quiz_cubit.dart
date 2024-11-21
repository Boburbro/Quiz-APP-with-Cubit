import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/quiz_model.dart';
import '../../domain/usecases/get_quiz_usecase.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final GetQuizUsecase getQuizUsecase;
  QuizCubit(this.getQuizUsecase) : super(QuizInitial());

  Future<void> fetchQuizzes(
      String category, String difficulty, int numberOfQuestions) async {
    emit(QuizLoadingState());
    final result =
        await getQuizUsecase(category, difficulty, numberOfQuestions);
    result.fold(
      (failure) =>
          emit(QuizLoadingFailureState((_mapFailureToMessage(failure)))),
      (quizEntities) {
        final quizModels =
            quizEntities.map((entity) => QuizModel.fromEntity(entity)).toList();
        emit(QuizLoadingSuccessState(quizModels));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure is ServerFailure
        ? 'Unable to fetch quizzes. Please try again later.'
        : 'Unexpected error occurred.';
  }
}

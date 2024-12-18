import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/quiz/data/datasource/quiz_remote_data_source_impl.dart';
import 'features/quiz/data/repositories/quiz_repository_impl.dart';
import 'features/quiz/domain/usecases/get_quiz_usecase.dart';
import 'features/quiz/presentation/cubit/quiz_cubit.dart';
import 'features/quiz/presentation/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final quizRemoteDataSource = QuizRemoteDataSourceImpl();
    final quizRepository =
        QuizRepositoryImpl(quizRemoteDatasource: quizRemoteDataSource);
    final getQuizUsecase = GetQuizUsecase(quizRepository);
    return BlocProvider(
      create: (context) => QuizCubit(getQuizUsecase),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}

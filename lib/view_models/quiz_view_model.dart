import 'package:flutter/material.dart';
import 'package:learnvocabulary/models/quiz_result.dart';
import '../services/quiz_service.dart';

class QuizViewModel extends ChangeNotifier {
  final QuizService _quizService = QuizService();
  List<Quiz> _quizzes = [];

  List<Quiz> get quizzes => _quizzes;

  // Lấy toàn bộ kết quả quiz
  void fetchQuizzes() {
    _quizService.getAllQuizzes().listen((data) {
      _quizzes = data;
      notifyListeners();
    });
  }

  // Lấy quiz theo locationId (ví dụ để thống kê theo địa điểm)
  void fetchQuizzesByLocation(String locationId) {
    _quizService.getQuizzesByLocation(locationId).listen((data) {
      _quizzes = data;
      notifyListeners();
    });
  }

  // Thêm kết quả quiz mới
  Future<void> addQuiz(Quiz quiz) async {
    await _quizService.addQuiz(quiz);
    // Không cần fetch lại vì đã dùng Stream
  }
}

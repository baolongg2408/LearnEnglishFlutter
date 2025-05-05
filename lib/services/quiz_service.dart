import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnvocabulary/models/quiz_result.dart';

class QuizService {
  final CollectionReference _quizzes =
  FirebaseFirestore.instance.collection('quizzes');

  // Thêm kết quả làm bài
  Future<void> addQuiz(Quiz quiz) async {
    await _quizzes.doc(quiz.id).set(quiz.toJson());
  }

  // Lấy toàn bộ kết quả (hoặc bạn có thể lọc theo locationId nếu cần)
  Stream<List<Quiz>> getAllQuizzes() {
    return _quizzes.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Quiz.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Tùy chọn: Lọc theo locationId
  Stream<List<Quiz>> getQuizzesByLocation(String locationId) {
    return _quizzes
        .where('locationId', isEqualTo: locationId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Quiz.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}

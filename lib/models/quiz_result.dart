class Quiz {
  final String id; // ID duy nhất cho lần làm bài
  final String locationId; // Địa điểm gắn với quiz
  final DateTime date; // Ngày giờ làm bài
  final int totalQuestions; // Tổng số câu hỏi
  final int correctAnswers; // Số câu đúng
  final int wrongAnswers; // Số câu sai

  Quiz({
    required this.id,
    required this.locationId,
    required this.date,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locationId': locationId,
      'date': date.toIso8601String(),
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      locationId: json['locationId'],
      date: DateTime.parse(json['date']),
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      wrongAnswers: json['wrongAnswers'],
    );
  }
}

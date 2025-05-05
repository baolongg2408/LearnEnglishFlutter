import 'package:flutter/material.dart';
import 'package:learnvocabulary/models/quiz_result.dart';
import 'package:provider/provider.dart';
import '../../models/location.dart';
import '../../models/vocabulary.dart';
import '../../view_models/vocabulary_view_model.dart';
import '../../view_models/quiz_view_model.dart';

class QuizScreen extends StatefulWidget {
  final Location location;

  const QuizScreen({super.key, required this.location});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int correct = 0;
  int wrong = 0;
  List<Vocabulary> vocabularies = [];
  TextEditingController answerController = TextEditingController();
  List<bool> answeredCorrectly = [];

  bool showResult = false;
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vocabVM = Provider.of<VocabularyViewModel>(context, listen: false);
      vocabVM.fetchVocabularies(widget.location.id);
    });
  }

  void checkAnswer(String userAnswer, String correctAnswer) {
    final normalizedUser = userAnswer.trim().toLowerCase();
    final normalizedCorrect = correctAnswer.trim().toLowerCase();
    final isAnswerCorrect = normalizedUser == normalizedCorrect;

    setState(() {
      isCorrect = isAnswerCorrect;
      if (isAnswerCorrect) {
        correct++;
      } else {
        wrong++;
      }
      answeredCorrectly.add(isAnswerCorrect);
    });

    // Chờ 1.5 giây rồi chuyển câu tiếp theo
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isCorrect = null;
        answerController.clear();
        if (currentQuestionIndex < vocabularies.length - 1) {
          currentQuestionIndex++;
        } else {
          showResult = true;
          saveResult();
        }
      });
    });
  }

  void saveResult() {
    final quiz = Quiz(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      locationId: widget.location.id,
      date: DateTime.now(),
      totalQuestions: vocabularies.length,
      correctAnswers: correct,
      wrongAnswers: wrong,
    );
    Provider.of<QuizViewModel>(context, listen: false).addQuiz(quiz);
  }

  @override
  Widget build(BuildContext context) {
    final vocabVM = Provider.of<VocabularyViewModel>(context);
    vocabularies = vocabVM.vocabularies;

    if (vocabularies.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz: ${widget.location.name}')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (showResult) {
      return Scaffold(
        appBar: AppBar(title: Text('Kết quả: ${widget.location.name}')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🎯 Tổng số câu: ${vocabularies.length}'),
              Text('✅ Đúng: $correct'),
              Text('❌ Sai: $wrong'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Quay lại'),
              ),
            ],
          ),
        ),
      );
    }

    final currentVocab = vocabularies[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Quiz: ${widget.location.name}')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Từ vựng ${currentQuestionIndex + 1}/${vocabularies.length}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              currentVocab.word,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: answerController,
              decoration: InputDecoration(
                hintText: 'Nhập nghĩa của từ...',
                filled: true,
                fillColor: isCorrect == null
                    ? Colors.white
                    : (isCorrect! ? Colors.green[100] : Colors.red[100]),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isCorrect == null
                  ? () => checkAnswer(answerController.text, currentVocab.meaning)
                  : null,
              child: const Text('Kiểm tra'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/vocabulary.dart';
import '../services/vocabulary_service.dart';

class VocabularyViewModel extends ChangeNotifier {
  final VocabularyService _vocabularyService = VocabularyService();
  List<Vocabulary> vocabularies = [];

  void fetchVocabularies(String locationId) {
    _vocabularyService.getVocabulariesByLocation(locationId).listen((data) {
      vocabularies = data;
      notifyListeners();
    });
  }

  Future<void> addVocabulary(Vocabulary vocabulary) async {
    await _vocabularyService.addVocabulary(vocabulary);
  }

  Future<void> updateVocabulary(Vocabulary vocabulary) async {
    await _vocabularyService.updateVocabulary(vocabulary);
  }

  Future<void> deleteVocabulary(String id) async {
    await _vocabularyService.deleteVocabulary(id);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vocabulary.dart';

class VocabularyService {
  final CollectionReference _vocabularies =
      FirebaseFirestore.instance.collection('vocabularies');

  Future<void> addVocabulary(Vocabulary vocabulary) async {
    await _vocabularies.doc(vocabulary.id).set(vocabulary.toJson());
  }

  Future<void> updateVocabulary(Vocabulary vocabulary) async {
    await _vocabularies.doc(vocabulary.id).update(vocabulary.toJson());
  }

  Future<void> deleteVocabulary(String id) async {
    await _vocabularies.doc(id).delete();
  }

  Stream<List<Vocabulary>> getVocabulariesByLocation(String locationId) {
    return _vocabularies
        .where('idLocation', isEqualTo: locationId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Vocabulary.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<List<Vocabulary>> getVocabulariesByLocationOnce(
      String locationId) async {
    final snapshot = await _vocabularies
        .where('idLocation', isEqualTo: locationId)
        .get();

    return snapshot.docs
        .map((doc) => Vocabulary.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}

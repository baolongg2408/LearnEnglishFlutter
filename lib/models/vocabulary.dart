class Vocabulary{
  final String _id;
  final String _idLocation;
  final String _word;
  final String _meaning;

  Vocabulary({required String id,required String idLocation, required String word,required String meaning}):
        _id= id, _idLocation = idLocation, _word = word,_meaning = meaning;

  String get meaning => _meaning;

  String get word => _word;

  String get idLocation => _idLocation;

  String get id => _id;

  @override
  String toString() {
    return '$_word : $_meaning';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'idLocation': idLocation,
    'word': word,
    'meaning': meaning,
  };

  factory Vocabulary.fromJson(Map<String, dynamic> json) => Vocabulary(
    id: json['id'],
    idLocation: json['idLocation'],
    word: json['word'],
    meaning: json['meaning'],
  );
}
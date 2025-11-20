class Word {
  final String id;
  final String word;
  final String meaning;
  final String example;
  final List<String> synonyms;
  final List<String> antonyms;
  bool learned;

  Word({
    required this.id,
    required this.word,
    required this.meaning,
    required this.example,
    this.synonyms = const [],
    this.antonyms = const [],
    this.learned = false,
  });

  factory Word.fromFirestore(String id, Map<String, dynamic> data) {
    return Word(
      id: id,
      word: data['word'] ?? '',
      meaning: data['meaning'] ?? '',
      example: data['example'] ?? '',
      synonyms: List<String>.from(data['synonyms'] ?? []),
      antonyms: List<String>.from(data['antonyms'] ?? []),
      learned: data['learned'] ?? false,
    );
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'] ?? '',
      word: map['word'] ?? '',
      meaning: map['meaning'] ?? '',
      example: map['example'] ?? '',
      synonyms: List<String>.from(map['synonyms'] ?? []),
      antonyms: List<String>.from(map['antonyms'] ?? []),
      learned: map['learned'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'example': example,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'learned': learned,
    };
  }

  Word copyWith({String? example, bool? learned}) {
    return Word(
      id: id,
      word: word,
      meaning: meaning,
      example: example ?? this.example,
      synonyms: synonyms,
      antonyms: antonyms,
      learned: learned ?? this.learned,
    );
  }
}

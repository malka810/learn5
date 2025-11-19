class Word {
  final String word;
  final String meaning;
  final String example;
  final List<String> synonyms;
  final List<String> antonyms;
  late final bool learned;

  Word({
    required this.word,
    required this.meaning,
    required this.example,
    this.synonyms = const [],
    this.antonyms = const [],
    this.learned = false,
  });

  Word copyWith({
    String? word,
    String? meaning,
    String? example,
    List<String>? synonyms,
    List<String>? antonyms,
    bool? learned,
  }) {
    return Word(
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      example: example ?? this.example,
      synonyms: synonyms ?? this.synonyms,
      antonyms: antonyms ?? this.antonyms,
      learned: learned ?? this.learned,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'meaning': meaning,
      'example': example,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'learned': learned,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      word: map['word'] ?? '',
      meaning: map['meaning'] ?? '',
      example: map['example'] ?? '',
      synonyms: List<String>.from(map['synonyms'] ?? []),
      antonyms: List<String>.from(map['antonyms'] ?? []),
      learned: map['learned'] ?? false,
    );
  }
}

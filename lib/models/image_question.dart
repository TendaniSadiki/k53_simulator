class ImageQuestion {
  final String id;
  final String text;
  final String imageUrl;
  final List<String> options;
  final int correctIndex;
  final List<String>? seenBy; // Track users who've seen this question

  ImageQuestion({
    required this.id,
    required this.text,
    required this.imageUrl,
    required this.options,
    required this.correctIndex,
    this.seenBy,
  });

  factory ImageQuestion.fromMap(Map<String, dynamic> data) {
    return ImageQuestion(
      id: data['id'],
      text: data['text'],
      imageUrl: data['imageUrl'],
      options: List<String>.from(data['options']),
      correctIndex: data['correctIndex'],
      seenBy: data['seenBy'] != null ? List<String>.from(data['seenBy']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'options': options,
      'correctIndex': correctIndex,
      'seenBy': seenBy,
    };
  }
}
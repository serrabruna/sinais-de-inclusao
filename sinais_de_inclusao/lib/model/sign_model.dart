class SignModel {
  final int id;
  final int categoryId;
  final String name;
  final String statement;
  final String imagePath;
  final String correctAnswer;
  final List<String> options;

  SignModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.statement,
    required this.imagePath,
    required this.correctAnswer,
    required this.options,
  });

  factory SignModel.fromJson(Map<String, dynamic> json) {
    return SignModel(
      id: json['id'] ?? 0, 
      categoryId: json['categoryId'] ?? 0,
      name: json['name'] ?? 'Sem nome',
      statement: json['statement'] ?? '',
      imagePath: json['imagePath'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      options: json['options'] != null ? List<String>.from(json['options']) : [],
    );
  }
}
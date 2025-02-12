class Exercise {
  final String id;
  final String name;
  final String category;
  final String equipment;
  final String muscleGroup;
  final String image;  // Can be asset path or file path

  Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.equipment,
    required this.muscleGroup,
    required this.image,
  });

  bool get isAssetImage => image.startsWith('assets/');

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      equipment: json['equipment'],
      muscleGroup: json['muscleGroup'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'equipment': equipment,
      'muscleGroup': muscleGroup,
      'image': image,
    };
  }
}

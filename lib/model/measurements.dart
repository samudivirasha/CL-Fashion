class Measurements {
  final double bodyLength;
  final double shoulder;
  final double sleeveLength;
  final double chest;
  final double waist;
  final double bottomWidth;

  Measurements({
    required this.bodyLength,
    required this.shoulder,
    required this.sleeveLength,
    required this.chest,
    required this.waist,
    required this.bottomWidth,
  });

  // Create from JSON data (used when parsing from Firestore)
  factory Measurements.fromJson(Map<String, dynamic> json) {
    return Measurements(
      bodyLength: (json['bodyLength'] ?? 0).toDouble(),
      shoulder: (json['shoulder'] ?? 0).toDouble(),
      sleeveLength: (json['sleeveLength'] ?? 0).toDouble(),
      chest: (json['chest'] ?? 0).toDouble(),
      waist: (json['waist'] ?? 0).toDouble(),
      bottomWidth: (json['bottomWidth'] ?? 0).toDouble(),
    );
  }

  // Convert to JSON (used when saving to Firestore)
  Map<String, dynamic> toJson() {
    return {
      'bodyLength': bodyLength,
      'shoulder': shoulder,
      'sleeveLength': sleeveLength,
      'chest': chest,
      'waist': waist,
      'bottomWidth': bottomWidth,
    };
  }

  // Helper method to create a copy with updated values
  Measurements copyWith({
    double? bodyLength,
    double? shoulder,
    double? sleeveLength,
    double? chest,
    double? waist,
    double? bottomWidth,
  }) {
    return Measurements(
      bodyLength: bodyLength ?? this.bodyLength,
      shoulder: shoulder ?? this.shoulder,
      sleeveLength: sleeveLength ?? this.sleeveLength,
      chest: chest ?? this.chest,
      waist: waist ?? this.waist,
      bottomWidth: bottomWidth ?? this.bottomWidth,
    );
  }
}

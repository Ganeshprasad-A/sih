class Plant {
  final String name;
  final String type;
  final String description;
  final String botanicalName;
  final String imageKey;
  final String audioKey;
  final String videoKey;
  final String modelKey;
  final String imageUrl;
  final String audioUrl;
  final String videoUrl;
  final String modelUrl;

  Plant({
    required this.name,
    required this.type,
    required this.description,
    required this.botanicalName,
    required this.imageKey,
    required this.audioKey,
    required this.videoKey,
    required this.modelKey,
    required this.imageUrl,
    required this.audioUrl,
    required this.videoUrl,
    required this.modelUrl,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      name: json['name'] ?? "Unknown Name",
      type: json['type'] ?? "Unknown Type",
      description: json['description'] ?? "No description available.",
      botanicalName: json['botanicalName'] ?? "Unknown Botanical Name",
      imageKey: json['imageKey'] ?? "",
      audioKey: json['audioKey'] ?? "",
      videoKey: json['videoKey'] ?? "",
      modelKey: json['modelKey'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
      audioUrl: json['audioUrl'] ?? "",
      videoUrl: json['videoUrl'] ?? "",
      modelUrl: json['modelUrl'] ?? "",
    );
  }
}

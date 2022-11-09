class PlaseSuggestion {
  late String placeId;
  late String description;
  PlaseSuggestion({
    required this.placeId,
    required this.description,
  });
  factory PlaseSuggestion.fromJson(Map<String, dynamic> json) {
    return PlaseSuggestion(
      placeId: json["place_id"],
      description: json["description"],
    );
  }
}

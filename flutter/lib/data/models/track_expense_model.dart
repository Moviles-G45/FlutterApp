class TrackExpense {
  final DateTime date;
  final int amount;
  final String description;
  final int categoryId;

  TrackExpense({
    required this.date,
    required this.amount,
    required this.description,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      "date": date.toIso8601String().split('T')[0],
      "amount": amount,
      "description": description,
      "category_id": categoryId,
    };
  }
}

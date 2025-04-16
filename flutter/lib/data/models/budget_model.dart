class BudgetModel {
  final String categoryType;
  final double percentage;

  BudgetModel({
    required this.categoryType,
    required this.percentage,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      categoryType: json['category_type'],
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

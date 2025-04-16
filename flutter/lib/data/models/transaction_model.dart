class TransactionModel {
  final String title;
  final String category;
  final String categoryType;
  final bool isExpense;
  final double amount;
  final String time;
  final String iconName;

  TransactionModel({
    required this.title,
    required this.category,
    required this.categoryType,
    required this.isExpense,
    required this.amount,
    required this.time,
    required this.iconName,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    final categoryType = category['category_type'];

    final String type = categoryType['name'];
    final bool isExpense = (type == 'needs' || type == 'wants' || type == 'savings');

    return TransactionModel(
      title: json['description'],
      category: category['name'],
      categoryType: type,
      isExpense: isExpense,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      time: json['date'],
      iconName: _guessIcon(category['name']),
    );
  }

  static String _guessIcon(String categoryName) {
    final map = {
      'Salary': 'salary',
      'Freelancing': 'salary',
      'Groceries': 'food',
      'Rent': 'home',
      'Entertainment': 'entertainment',
      'Shopping': 'shopping_cart',
      'Emergency Fund': 'savings',
    };
    return map[categoryName] ?? 'receipt';
  }
}

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

  /// Convertir el objeto a un mapa para almacenamiento en caché
  Map<String, dynamic> toJson() => {
        'title': title,
        'category': category,
        'categoryType': categoryType,
        'isExpense': isExpense,
        'amount': amount,
        'time': time,
        'iconName': iconName,
      };

  /// Crear el objeto a partir de un mapa JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] ?? {};
    final categoryType = category['category_type'] ?? {};

    final String type = categoryType['name'] ?? 'unknown';
    final bool isExpense = (type == 'needs' || type == 'wants' || type == 'savings');

    return TransactionModel(
      title: json['title'] ?? json['description'] ?? 'Unknown',
      category: category['name'] ?? 'Unknown',
      categoryType: type,
      isExpense: isExpense,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      time: json['time'] ?? json['date'] ?? '',
      iconName: _guessIcon(category['name'] ?? 'Unknown'),
    );
  }

  /// Adivinar el ícono según el nombre de la categoría
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

  /// Conversión a String para depuración
  @override
  String toString() {
    return 'TransactionModel(title: $title, category: $category, type: $categoryType, '
        'isExpense: $isExpense, amount: $amount, time: $time, icon: $iconName)';
  }
}

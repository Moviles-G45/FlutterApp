
class BalanceData {
  final double balance;
  final double expenses;

  BalanceData({
    required this.balance,
    required this.expenses,
  });

  factory BalanceData.fromJson(Map<String, dynamic> json) {
    return BalanceData(
      balance: json['balance'] ?? 0.0,
      expenses: json['total_expenses'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'balance': balance,
        'total_expenses': expenses,
      };
}

class BalanceModel {
  final double balance;
  final double totalExpenses;
  final double totalEarnings;
  final double needsSpent;
  final double wantsSpent;
  final double savingsSpent;

  BalanceModel({
    required this.balance,
    required this.totalExpenses,
    required this.totalEarnings,
    required this.needsSpent,
    required this.wantsSpent,
    required this.savingsSpent,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(
      balance: (json['balance'] as num).toDouble(),
      totalExpenses: (json['total_expenses'] as num).toDouble(),
      totalEarnings: (json['total_earnings'] as num).toDouble(),
      needsSpent: (json['needs_spent'] as num).toDouble(),
      wantsSpent: (json['wants_spent'] as num).toDouble(),
      savingsSpent: (json['savings_spent'] as num).toDouble(),
    );
  }
}

class WalletTransaction {
  final double amount;
  final String description;
  final DateTime createdAt;

  WalletTransaction({
    required this.amount,
    required this.description,
    required this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      amount: (json['amount'] as num).toDouble(),
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

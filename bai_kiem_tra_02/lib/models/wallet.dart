class Wallet {
  final double balance;
  final List<WalletTransaction> transactions;

  Wallet({
    required this.balance,
    required this.transactions,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance: (json['balance'] as num).toDouble(),
      transactions: (json['transactions'] as List)
          .map((e) => WalletTransaction.fromJson(e))
          .toList(),
    );
  }
}

class WalletTransaction {
  final String description;
  final DateTime createdAt;
  final double amount;

  WalletTransaction({
    required this.description,
    required this.createdAt,
    required this.amount,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

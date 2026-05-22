class TransactionModel {
  final String imageUrl;
  final String userName;
  final String description;
  final double amount;
  final DateTime date;

  TransactionModel({
    required this.imageUrl,
    required this.userName,
    required this.description,
    required this.amount,
    required this.date,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      imageUrl: map['imageUrl'] as String? ?? '',
      userName: map['userName'] as String? ?? '',
      description: map['description'] as String? ?? '',

      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,

      date: map['date'] is DateTime
          ? map['date'] as DateTime
          : DateTime.tryParse(map['date']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

class CardModel {
  final String cardNumber;
  final double amount;
  final String cvc;
  final String expiryDate;
  final List<TransactionModel> transactions;

  CardModel({
    required this.cardNumber,
    required this.amount,
    required this.cvc,
    required this.expiryDate,
    required this.transactions,
  });

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      cardNumber: map['cardNumber'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      cvc: map['cvc'] as String? ?? '',
      expiryDate: map['expiryDate'] as String? ?? '',

      transactions: (map['transactions'] as List? ?? [])
          .map((x) => TransactionModel.fromMap(x as Map<String, dynamic>))
          .toList(),
    );
  }
}

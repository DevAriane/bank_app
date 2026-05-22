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
}

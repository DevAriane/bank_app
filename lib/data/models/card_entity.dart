import 'package:objectbox/objectbox.dart';
import 'wallet_entity.dart';
import 'transaction_entity.dart';

enum CardVisualType { blanc, degrade, sombre }

@Entity()
class CardEntity {
  @Id()
  int id = 0;

  late String cardNumber;
  late String expiryDate;
  late String cvc;
  late String type;
  late String themeColor;
  late int amount;

  final wallet = ToOne<WalletEntity>();

  // final CardVisualType visualType;

  @Backlink('card')
  final transactions = ToMany<TransactionEntity>();

  CardEntity({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvc,
    required this.type,
    required this.themeColor,
    required this.amount,
    // required this.visualType,
  });
}

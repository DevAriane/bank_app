import 'package:objectbox/objectbox.dart';
import 'card_entity.dart';
import 'transaction_entity.dart';

@Entity()
class WalletEntity {
  @Id()
  int id = 0;

  @Unique()
  late String currency; 
  late double balance;

  @Backlink('wallet')
  final cards = ToMany<CardEntity>();

  @Backlink('wallet')
  final transactions = ToMany<TransactionEntity>();

  WalletEntity({required this.currency, required this.balance});
}

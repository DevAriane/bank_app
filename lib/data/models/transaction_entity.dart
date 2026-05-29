import 'package:objectbox/objectbox.dart';
import 'wallet_entity.dart';
import 'card_entity.dart';

@Entity()
class TransactionEntity {
  @Id()
  int id = 0;

  late String title;
  late String category;
  late int amount;
  late String image;
  

  @Property(type: PropertyType.date)
  late DateTime date;

  final wallet = ToOne<WalletEntity>();

  final card = ToOne<CardEntity>();

  TransactionEntity({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.image,
  });
}

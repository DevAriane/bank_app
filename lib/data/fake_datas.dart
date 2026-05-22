import 'package:bank_app/models/card_model.dart';
import '../common/images_resources.dart';

final List<CardModel> fakeCardsList = [
  CardModel(
    cardNumber: '**** **** **** 4582',
    amount: 1250.75,
    cvc: '321',
    expiryDate: '08/29',
    transactions: [
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'Yannick Noah',
        description: 'Course Uber Taxi',
        amount: -15.00,
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'Supermarché Casino',
        description: 'Courses alimentaires',
        amount: -84.50,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'Marie Claire',
        description: 'Remboursement dîner',
        amount: 45.00,
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'Netflix',
        description: 'Abonnement Premium',
        amount: -19.99,
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'Station Total',
        description: 'Plein d\'essence',
        amount: -65.00,
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'Airbnb',
        description: 'Réservation Weekend',
        amount: -240.00,
        date: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ],
  ),
  CardModel(
    cardNumber: '**** **** **** 8910',
    amount: 5420.00,
    cvc: '745',
    expiryDate: '12/27',
    transactions: [
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'Société Générale',
        description: 'Virement Salaire',
        amount: 2500.00,
        date: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'Apple Store',
        description: 'Abonnement iCloud',
        amount: -9.99,
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'Amazon France',
        description: 'Achat Électronique',
        amount: -129.50,
        date: DateTime.now().subtract(const Duration(days: 4)),
      ),
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'Fiverr',
        description: 'Prestation Logo Freelance',
        amount: -50.00,
        date: DateTime.now().subtract(const Duration(days: 6)),
      ),
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'Nike Store',
        description: 'Chaussures de Sport',
        amount: -120.00,
        date: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ],
  ),
  CardModel(
    cardNumber: '**** **** **** 2364',
    amount: 85.20,
    cvc: '159',
    expiryDate: '03/26',
    transactions: [
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'Starbucks',
        description: 'Café et Pâtisserie',
        amount: -6.80,
        date: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'McDonald\'s',
        description: 'Menu Menu Best Of',
        amount: -11.50,
        date: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'Boulangerie Paul',
        description: 'Formule Déjeuner',
        amount: -8.90,
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'Spotify',
        description: 'Abonnement Musique',
        amount: -10.99,
        date: DateTime.now().subtract(const Duration(days: 3)),
      ),
      TransactionModel(
        imageUrl: 'https://pravatar.cc',
        userName: 'SNCF Train',
        description: 'Billet Aller-Retour',
        amount: -45.00,
        date: DateTime.now().subtract(const Duration(days: 6)),
      ),
    ],
  ),
];

class CardAction {
  final String title;
  final String image;

  CardAction({required this.title, required this.image});
}

List<CardAction> get actionCard => [
  CardAction(title: "ADD", image: ImagesResources.add),
  CardAction(title: "SEND", image: ImagesResources.send),
  CardAction(title: "CONVERT", image: ImagesResources.convert),
  CardAction(title: "MORE", image: ImagesResources.more),
];

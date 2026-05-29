import 'package:bank_app/common/images_resources.dart';
import 'package:bank_app/data/services/objectbox_service.dart';
import 'package:get/get.dart';
import '../../../data/models/wallet_entity.dart';
import '../../../data/models/card_entity.dart';
import '../../../data/models/transaction_entity.dart';
import 'package:bank_app/objectbox.g.dart';
import 'package:bank_app/currency.dart';

class DashboardController extends GetxController {
  late final Box<WalletEntity> _walletBox;
  late final Box<CardEntity> _cardBox;
  late final Box<TransactionEntity> _transactionBox;

  final wallets = <WalletEntity>[].obs;
  final cards = <CardEntity>[].obs;
  final filteredTransactions = <TransactionEntity>[].obs;
  final filteredCards = <CardEntity>[].obs;

  final selectedCard = Rxn<CardEntity>();
  final selectedWallet = Rxn<WalletEntity>();

  @override
  void onInit() {
    super.onInit();
    _walletBox = ObjectBoxService.to.store.box<WalletEntity>();
    _cardBox = ObjectBoxService.to.store.box<CardEntity>();
    _transactionBox = ObjectBoxService.to.store.box<TransactionEntity>();

    _initDatabaseStreams();
    _initWorkers();
  }

  void _initDatabaseStreams() {
    final store = ObjectBoxService.to.store;

    _cardBox.removeAll();
    _walletBox.removeAll();
    _transactionBox.removeAll();

    _walletBox.putMany([
      WalletEntity(currency: 'USD', balance: 2500.0),
      WalletEntity(currency: 'EUR', balance: 1200.0),
      WalletEntity(currency: 'CNY', balance: 8000.0),
    ]);

    wallets.assignAll(_walletBox.getAll());
    final initialCards = _cardBox.getAll();
    cards.assignAll(initialCards);

    if (wallets.isNotEmpty) {
      selectedWallet.value = wallets.first;
      _updateCardsAndSelection();
    }

    store.watch<WalletEntity>().listen((_) {
      wallets.assignAll(_walletBox.getAll());
    });

    store.watch<CardEntity>().listen((_) {
      final updatedCards = _cardBox.getAll();
      cards.assignAll(updatedCards);
      _updateCardsAndSelection();
    });

    store.watch<TransactionEntity>().listen((_) {
      _updateTransactionsList();
    });
  }

  void _initWorkers() {
    ever(selectedWallet, (_) {
      _updateCardsAndSelection();
    });

    ever(selectedCard, (_) {
      _updateTransactionsList();
    });
  }

  void _updateCardsAndSelection() {
    if (selectedWallet.value != null) {
      final currentWalletId = selectedWallet.value!.id;

      final walletCards = cards
          .where((c) => c.wallet.target?.id == currentWalletId)
          .toList();

      filteredCards.assignAll(walletCards);

      if (walletCards.isNotEmpty) {
        if (selectedCard.value == null ||
            selectedCard.value!.wallet.target?.id != currentWalletId) {
          selectedCard.value = walletCards.first;
        }
      } else {
        selectedCard.value = null;
      }
    } else {
      filteredCards.clear();
      selectedCard.value = null;
    }
    _updateTransactionsList();
  }

  void updateSelectedCard(CardEntity card) {
    selectedCard.value = card;
  }

  void selectWalletDirectly(WalletEntity wallet) {
    selectedWallet.value = wallet;
    _updateCardsAndSelection();
  }

  void _updateTransactionsList() {
    if (selectedCard.value != null) {
      final query = _transactionBox
          .query(TransactionEntity_.card.equals(selectedCard.value!.id))
          .order(TransactionEntity_.date, flags: Order.descending)
          .build();
      filteredTransactions.assignAll(query.find());
      query.close();
    } else {
      filteredTransactions.clear();
    }
  }

  void createNewCard({
    required String name,
    required String currency,
    required String colorLeft,
    required String colorRight,
    required int amount,
  }) {
    var wallet = _walletBox
        .query(WalletEntity_.currency.equals(currency))
        .build()
        .findFirst();

    if (wallet == null) {
      Get.snackbar("error", "portefeuille introuvable");
      return;
    }

    if (wallet.balance < amount) {
      Get.snackbar("Error", "votre portefeuille est insuffisant");
      return;
    }

    wallet.balance -= amount;
    _walletBox.put(wallet);

    final newCard = CardEntity(
      name: name,
      cardNumber: "5231 7252 1769 ${1000 + cards.length}",
      expiryDate: "12/30",
      cvc: "123",
      type: "Debit",
      themeColorLeft: colorLeft,
      themeColorRight: colorRight,
      amount: amount.toInt(),
    );

    newCard.wallet.target = wallet;
    _cardBox.put(newCard);

    if (selectedCard.value == null) {
      selectedCard.value = newCard;
    }
  }

  void makeCardPayment({
    required String title,
    required String category,
    required double amount,
  }) {
    final currentCard = selectedCard.value;
    final currentWallet = selectedWallet.value;

    if (currentCard == null || currentWallet == null) return;
    if (currentCard.amount < amount.abs() && amount < 0) {
      Get.snackbar("Erreur", "Solde de la carte insuffisant");
      return;
    }

    currentCard.amount += amount.toInt();

    final tx = TransactionEntity(
      title: title,
      category: category,
      amount: amount.toInt(),
      date: DateTime.now(),
      image: ImagesResources.card,
    );
    tx.wallet.target = currentWallet;
    tx.card.target = currentCard;

    ObjectBoxService.to.store.runInTransaction(TxMode.write, () {
      _cardBox.put(currentCard);
      _transactionBox.put(tx);
    });
  }

  void makeDepot({
    required CardEntity card1,
    required CardEntity card2,
    required String title,
    required double amount,
  }) {
    if (card1.amount < amount) {
      Get.snackbar(
        "ERROR",
        "Argent insuffisant dans votre carte \${card1.name}",
      );
      return;
    }

    card1.amount -= amount.toInt();
    card2.amount += amount.toInt();

    final tx = TransactionEntity(
      title: "$title ${card1.name} vers ${card2.name}",
      category: "depot",
      amount: -amount.toInt(),
      date: DateTime.now(),
      image: ImagesResources.send,
    );

    tx.card.target = card1;
    if (card1.wallet.target != null) {
      tx.wallet.target = card1.wallet.target;
    }

    ObjectBoxService.to.store.runInTransaction(TxMode.write, () {
      _cardBox.put(card1);
      _cardBox.put(card2);
      _transactionBox.put(tx);
    });
  }

  void addmoneytocardfromwallet({
    required CardEntity card,
    required String title,
    required double amount,
    required String currency,
  }) {
    var wallet = _walletBox
        .query(WalletEntity_.currency.equals(currency))
        .build()
        .findFirst();

    if (wallet == null || wallet.balance < amount) {
      Get.snackbar("Error", "Solde du portefeuille insuffisant");
      return;
    }

    wallet.balance -= amount;
    card.amount += amount.toInt();

    final tx = TransactionEntity(
      title: "$title de ${amount.toInt()} vers ${card.name}",
      category: "ajout",
      amount: amount.toInt(),
      date: DateTime.now(),
      image: ImagesResources.add,
    );

    tx.card.target = card;
    tx.wallet.target = wallet;

    ObjectBoxService.to.store.runInTransaction(TxMode.write, () {
      _walletBox.put(wallet);
      _cardBox.put(card);
      _transactionBox.put(tx);
    });
  }

  void convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amountToConvert,
    required WalletEntity sourceWallet,
    required WalletEntity targetWallet,
    required CardEntity sourceCard,
    required CardEntity targetCard,
  }) {
    if (sourceCard.amount < amountToConvert) {
      Get.snackbar(
        "Erreur",
        "Le solde de votre carte initiale est insuffisant",
      );
      return;
    }

    double convertedAmount = executeConversion(
      amount: amountToConvert,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );

    sourceWallet.balance -= amountToConvert;
    sourceCard.amount -= amountToConvert.toInt();
    targetCard.amount += convertedAmount.toInt();
    targetWallet.balance += convertedAmount.toInt();

    final txSource = TransactionEntity(
      title:
          "Conversion ${sourceCard.name} ($fromCurrency) ➔ ${targetCard.name} ($toCurrency)",
      category: "Exchange",
      amount: -amountToConvert.toInt(),
      image: ImagesResources.convert,
      date: DateTime.now(),
    );
    txSource.wallet.target = sourceWallet;
    txSource.card.target = sourceCard;

    ObjectBoxService.to.store.runInTransaction(TxMode.write, () {
      _cardBox.put(sourceCard);
      _cardBox.put(targetCard);
      _walletBox.put(sourceWallet);
      _walletBox.put(targetWallet);
      _transactionBox.put(txSource);
    });

    Get.back();
    Get.snackbar("Succès", "Conversion effectuée avec succès !");
  }
}

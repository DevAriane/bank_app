import 'package:bank_app/data/services/objectbox_service.dart';
import 'package:get/get.dart';
import '../../../data/models/wallet_entity.dart';
import '../../../data/models/card_entity.dart';
import '../../../data/models/transaction_entity.dart';
import 'package:bank_app/objectbox.g.dart';

class DashboardController extends GetxController {
  late final Box<WalletEntity> _walletBox;
  late final Box<CardEntity> _cardBox;
  late final Box<TransactionEntity> _transactionBox;

  final wallets = <WalletEntity>[].obs;
  final cards = <CardEntity>[].obs;
  final filteredTransactions = <TransactionEntity>[].obs;

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

      if (wallets.first.cards.isNotEmpty) {
        selectedCard.value = wallets.first.cards.first;
      } else {
        selectedCard.value = null;
      }
    }

    _updateTransactionsList();

    store.watch<WalletEntity>().listen((_) {
      wallets.assignAll(_walletBox.getAll());
    });

    store.watch<CardEntity>().listen((_) {
      final updatedCards = _cardBox.getAll();
      cards.assignAll(updatedCards);
    });

    store.watch<TransactionEntity>().listen((_) {
      _updateTransactionsList();
    });
  }

  void _initWorkers() {
    ever(cards, (List<CardEntity> updatedCards) {
      if (updatedCards.isNotEmpty &&
          selectedCard.value == null &&
          selectedWallet.value == null) {
        updateSelectedCard(updatedCards.first);
      }
    });

    ever(selectedCard, (CardEntity? card) {
      if (card != null) {
        selectedWallet.value = card.wallet.target;
        _updateTransactionsList();
      }
    });
  }

  void updateSelectedCard(CardEntity card) {
    selectedCard.value = card;
  }

  void selectWalletDirectly(WalletEntity wallet) {
    selectedWallet.value = wallet;

    if (wallet.cards.isNotEmpty) {
      selectedCard.value = wallet.cards.first;
    } else {
      selectedCard.value = null;
    }
    _updateTransactionsList();
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
      Get.snackbar("error", "porte feuille introuvable");
      return;
    }

    if (wallet.balance < amount) {
      Get.snackbar("Error", "votre portefeuille est insuffisant ");
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
      amount: amount,
    );

    newCard.wallet.target = wallet;
    _cardBox.put(newCard);
  }

  void makeCardPayment({
    required String title,
    required String category,
    required double amount,
  }) {
    final currentCard = selectedCard.value;
    final currentWallet = selectedWallet.value;

    if (currentCard == null || currentWallet == null) return;
    if (currentWallet.balance < amount.abs() && amount < 0) {
      Get.snackbar("Erreur", "Solde insuffisant en ${currentWallet.currency}");
      return;
    }

    currentWallet.balance += amount;

    final tx = TransactionEntity(
      title: title,
      category: category,
      amount: amount,
      date: DateTime.now(),
    );
    tx.wallet.target = currentWallet;
    tx.card.target = currentCard;

    ObjectBoxService.to.store.runInTransaction(TxMode.write, () {
      _walletBox.put(currentWallet);
      _transactionBox.put(tx);
    });
  }

  void convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amountToConvert,
    required double rate,
  }) {
    final sourceWallet = _walletBox
        .query(WalletEntity_.currency.equals(fromCurrency))
        .build()
        .findFirst();
    final targetWallet = _walletBox
        .query(WalletEntity_.currency.equals(toCurrency))
        .build()
        .findFirst();

    if (sourceWallet == null ||
        targetWallet == null ||
        sourceWallet.balance < amountToConvert) {
      return;
    }

    sourceWallet.balance -= amountToConvert;
    targetWallet.balance += (amountToConvert * rate);

    final txSource = TransactionEntity(
      title: "Conversion $fromCurrency -> $toCurrency",
      category: "Exchange",
      amount: -amountToConvert,
      date: DateTime.now(),
    );
    txSource.wallet.target = sourceWallet;

    ObjectBoxService.to.store.runInTransaction(TxMode.write, () {
      _walletBox.putMany([sourceWallet, targetWallet]);
      _transactionBox.put(txSource);
    });
  }
}

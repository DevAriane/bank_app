import 'package:flutter/material.dart';
import 'package:get_x/get.dart';
import '../../../data/models/wallet_entity.dart';
import '../../../data/models/card_entity.dart';
import '../../../data/models/transaction_entity.dart';
import 'package:objectbox/objectbox.dart';

class DashboardController extends GetxController {
  late final Box<WalletEntity> _walletBox;
  late final Box<CardEntity> _cardBox;
  late final Box<TransactionEntity> _transactionBox;

  final wallets = <WalletEntity>[].obs;
  final cards = <CardEntity>[].obs;

  final selectedCards = Rxn<CardEntity>;
  final selectWallet = Rxn<WalletEntity>;

  final filteredTransaction = <TransactionEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
  }
}

import 'package:flutter/material.dart';
import '../data/models/card_entity.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';
import '../common/app_color.dart';
import 'package:get/get.dart';
import '../common/button.dart';
import '../data/models/wallet_entity.dart';

class ConvertCurrency extends StatefulWidget {
  const ConvertCurrency({super.key});

  @override
  State<ConvertCurrency> createState() => _ConvertCurrencyState();
}

class _ConvertCurrencyState extends State<ConvertCurrency> {
  final DashboardController controller = Get.find<DashboardController>();
  final TextEditingController _amountController = TextEditingController();

  int? _sourceCardId;
  WalletEntity? _targetWallet;
  int? _targetCardId;

  void _executerConvertion(List<CardEntity> availableTargetCards) {
    final double? amount = double.tryParse(_amountController.text);

    if (amount == null || amount <= 0) {
      Get.snackbar(
        "Champ invalide",
        "Veuillez entrer un montant valide supérieur à 0",
      );
      return;
    }

    final sourceCard = controller.filteredCards.firstWhereOrNull(
      (c) => c.id == _sourceCardId,
    );

    final sourceWallet = sourceCard?.wallet.target;

    final targetCard = availableTargetCards.firstWhereOrNull(
      (c) => c.id == _targetCardId,
    );
    final targetWallet = _targetWallet;

    if (sourceCard == null ||
        sourceWallet == null ||
        targetCard == null ||
        targetWallet == null) {
      Get.snackbar(
        "Erreur",
        "Sélection incomplète. Veuillez vérifier vos choix.",
      );
      return;
    }

    if (sourceCard.id == targetCard.id) {
      Get.snackbar(
        "Opération impossible",
        "Impossible de convertir vers la même carte",
      );
      return;
    }

    controller.convertCurrency(
      fromCurrency: sourceWallet.currency,
      toCurrency: targetWallet.currency,
      amountToConvert: amount,
      sourceWallet: sourceWallet,
      targetWallet: targetWallet,
      sourceCard: sourceCard,
      targetCard: targetCard,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      showDragHandle: true,
      onClosing: () {},
      shadowColor: AppColor.grisMoyen,
      backgroundColor: const Color.fromARGB(255, 239, 238, 238),
      builder: (context) {
        return Obx(() {
          if (controller.filteredCards.isEmpty || controller.wallets.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text("aucune carte disponible")),
            );
          }

          if (!controller.filteredCards.any((c) => c.id == _sourceCardId)) {
            _sourceCardId = controller.filteredCards.first.id;
          }
          _sourceCardId ??= controller.filteredCards.first.id;

          _targetWallet ??= controller.wallets.first;
          _targetWallet =
              controller.wallets.firstWhereOrNull(
                (w) => w.id == _targetWallet!.id,
              ) ??
              controller.wallets.first;

          List<CardEntity> availableTargetCards = controller.cards
              .where((card) => card.wallet.target?.id == _targetWallet!.id)
              .toList();

          if (availableTargetCards.isNotEmpty) {
            if (_targetCardId == null ||
                !availableTargetCards.any((c) => c.id == _targetCardId)) {
              _targetCardId = availableTargetCards.first.id;
            }
          } else {
            _targetCardId = null;
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: 8,
                left: 25,
                right: 25,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Carte initiale",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.bleuSombre,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.grisMoyen),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _sourceCardId,
                        isExpanded: true,
                        items: controller.filteredCards.map((CardEntity card) {
                          return DropdownMenuItem<int>(
                            value: card.id,
                            child: Text(
                              "${card.name} (${card.amount} ${card.wallet.target?.currency ?? ''})",
                            ),
                          );
                        }).toList(),
                        onChanged: (int? newvalue) {
                          setState(() {
                            _sourceCardId = newvalue;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Entrer le montant a envoyer ",
                      labelStyle: const TextStyle(color: AppColor.grisArdoise),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: AppColor.grisMoyen),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: AppColor.bleuSombre,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Choisir le portemonnaie cible",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.bleuSombre,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.grisMoyen),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<WalletEntity>(
                        value: _targetWallet,
                        isExpanded: true,
                        items: controller.wallets.map((WalletEntity wallet) {
                          return DropdownMenuItem<WalletEntity>(
                            value: wallet,
                            child: Text(wallet.currency),
                          );
                        }).toList(),
                        onChanged: (WalletEntity? newvalue) {
                          setState(() {
                            _targetWallet = newvalue;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Carte finale",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.bleuSombre,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColor.grisMoyen),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _targetCardId,
                        isExpanded: true,
                        hint: const Text("Aucune carte disponible"),
                        items: availableTargetCards.map((CardEntity card) {
                          return DropdownMenuItem<int>(
                            value: card.id,
                            child: Text(card.name),
                          );
                        }).toList(),
                        onChanged: (int? newvalue) {
                          setState(() {
                            _targetCardId = newvalue;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      title: "valider",
                      fondColor: AppColor.bleuSombre,
                      textColor: AppColor.blanc,
                      onpress: () => _executerConvertion(availableTargetCards),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

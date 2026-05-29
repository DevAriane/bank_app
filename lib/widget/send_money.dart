import 'package:flutter/material.dart';
import '../data/models/card_entity.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';
import '../common/app_color.dart';
import 'package:get/get.dart';
import '../common/button.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({super.key});

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  final DashboardController controller = Get.find<DashboardController>();
  final TextEditingController _amountController = TextEditingController();

  int? _sourceCardId;
  int? _targetCardId;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _validerEtTransferer() {
    final String texteMontant = _amountController.text.trim();

    final double? montantSaisi = double.tryParse(texteMontant);

    if (montantSaisi == null || montantSaisi <= 0) {
      Get.snackbar("Erreur", "Veuillez entrer un montant valide");
      return;
    }

    if (_sourceCardId == null || _targetCardId == null) {
      Get.snackbar("Erreur", "Veuillez sélectionner les deux cartes");
      return;
    }

    if (_sourceCardId == _targetCardId) {
      Get.snackbar("Erreur", "Impossible de transférer vers la même carte");
      return;
    }

    final card1 = controller.filteredCards.firstWhere(
      (c) => c.id == _sourceCardId,
    );
    final card2 = controller.filteredCards.firstWhere(
      (c) => c.id == _targetCardId,
    );

    if (card1.amount < montantSaisi) {
      Get.snackbar("Erreur", "Solde insuffisant sur la carte initiale");
      return;
    }

    controller.makeDepot(
      amount: montantSaisi,
      card1: card1,
      card2: card2,
      title: "Retrait",
    );

    _amountController.clear();
    Navigator.pop(context);
    Get.snackbar("Succès", "Le transfert d'argent a été effectué");
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
          if (controller.filteredCards.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text("aucune carte disponible")),
            );
          }

          _sourceCardId ??= controller.filteredCards.first.id;
          _targetCardId ??= controller.filteredCards.length > 1
              ? controller.filteredCards[1].id
              : controller.filteredCards.first.id;

          if (!controller.filteredCards.any((c) => c.id == _sourceCardId)) {
            _sourceCardId = controller.filteredCards.first.id;
          }
          if (!controller.filteredCards.any((c) => c.id == _targetCardId)) {
            _targetCardId = controller.filteredCards.length > 1
                ? controller.filteredCards[1].id
                : controller.filteredCards.first.id;
          }

          return Padding(
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
                          child: Text(card.name),
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
                const SizedBox(height: 5),

                const Text(
                  "Carte Finale",
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
                      items: controller.filteredCards.map((CardEntity card) {
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
                const SizedBox(height: 5),

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
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: Button(
                    title: "valider",
                    fondColor: AppColor.bleuSombre,
                    textColor: AppColor.blanc,
                    onpress: () => _validerEtTransferer(),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

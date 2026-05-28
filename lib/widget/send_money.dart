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

  CardEntity? _sourceCard;
  CardEntity? _targetCard;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // void _executerTransfert() {
  //   final String texteMontant = _amountController.text.trim();
  //   final double? montant = double.tryParse(texteMontant);

  //   if (montant == null || montant <= 0) {
  //     Get.snackbar("Erreur", "Veuillez entrer un montant valide");
  //     return;
  //   }

  //   if (_sourceCard == null || _targetCard == null) {
  //     Get.snackbar("Erreur", "Veuillez sélectionner les deux cartes");
  //     return;
  //   }

  //   if (_sourceCard!.id == _targetCard!.id) {
  //     Get.snackbar("Erreur", "Impossible de transférer sur la même carte");
  //     return;
  //   }

  //   if (_sourceCard!.amount < montant) {
  //     Get.snackbar("Erreur", "Solde insuffisant sur la carte de départ");
  //     return;
  //   }

  //   controller.makeCardPayment(
  //     title: "Transfert vers ${_targetCard!.cardNumber.substring(_targetCard!.cardNumber.length - 4)}",
  //     category: "Transfert",
  //     amount: -montant,
  //   );

  //   Get.snackbar("Succès", "Transfert effectué avec succès");
  //   Navigator.pop(context);
  // }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      showDragHandle: false,
      onClosing: () {},
      shadowColor: AppColor.grisMoyen,
      backgroundColor: const Color.fromARGB(255, 239, 238, 238),
      builder: (context) {
        return Obx(() {
          if (controller.cards.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text("aucune carte disponible")),
            );
          }

          _sourceCard ??= controller.cards.first;
          _targetCard ??= controller.cards.length > 1
              ? controller.cards[1]
              : controller.cards.first;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "carte initiale",
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
                    child: DropdownButton<CardEntity>(
                      value: _sourceCard,
                      isExpanded: true,
                      items: controller.cards.map((CardEntity card) {
                        return DropdownMenuItem<CardEntity>(
                          value: card,
                          child: Text("${card.name}"),
                        );
                      }).toList(),
                      onChanged: (CardEntity? newvalue) {
                        setState(() {
                          _sourceCard = newvalue;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                const Text(
                  "carte finale",
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
                    child: DropdownButton<CardEntity>(
                      value: _targetCard,
                      isExpanded: true,
                      items: controller.cards.map((CardEntity card) {
                        return DropdownMenuItem<CardEntity>(
                          value: card,
                          child: Text("${card.name}"),
                        );
                      }).toList(),
                      onChanged: (CardEntity? newvalue) {
                        setState(() {
                          _targetCard = newvalue;
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
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: Button(
                    title: "valider",
                    fondColor: AppColor.bleuSombre,
                    textColor: AppColor.blanc,
                    onpress: () {},
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

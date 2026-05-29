import 'package:bank_app/common/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/wallet_entity.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';
import '../common/button.dart';
import '../common/card_bottom_sheet.dart';

class BottomShowBar extends StatefulWidget {
  final WalletEntity? wallet;
  const BottomShowBar({super.key, required this.wallet});

  @override
  State<BottomShowBar> createState() => _BottomShowBarState();
}

class _BottomShowBarState extends State<BottomShowBar>
    with SingleTickerProviderStateMixin {
  final DashboardController controller = Get.find<DashboardController>();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _couleurGaucheChoisie = "0xffffffff";
  String _couleurDroiteChoisie = "0xff0a192f";

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double currentBalance = widget.wallet?.balance ?? 0.0;
    final String currentCurrency = widget.wallet?.currency ?? "";

    return BottomSheet(
      enableDrag: false,
      showDragHandle: true,
      dragHandleColor: AppColor.grisMoyen,
      animationController: _animationController,
      onClosing: () {},
      shadowColor: AppColor.grisMoyen,
      
      backgroundColor: const Color.fromARGB(255, 239, 238, 238),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: 3,
              left: 25,
              right: 25,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CardBottomSheet(
                  couleurGauche: Color(int.parse(_couleurGaucheChoisie)),
                  couleurDroite: Color(int.parse(_couleurDroiteChoisie)),
                  onColorsUpdated: (nouveauHexGauche, nouveauHexDroite) {
                    setState(() {
                      _couleurGaucheChoisie = nouveauHexGauche;
                      _couleurDroiteChoisie = nouveauHexDroite;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Entrer le nom de la carte ",
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
                const SizedBox(height: 10),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Entrer le montant a alouer ",
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

                SizedBox(
                  width: double.infinity,
                  child: Button(
                    title: "creer",
                    fondColor: AppColor.bleuSombre,
                    textColor: AppColor.blanc,
                    onpress: () {
                      final String nom = _nameController.text.trim();
                      final String texteMontant = _amountController.text.trim();
                      final int? montantSaisi =int.tryParse(texteMontant);

                      if (montantSaisi == null || montantSaisi <= 0) {
                        Get.snackbar(
                          "Erreur",
                          "Veuillez entrer un montant valide",
                        );
                        return;
                      }

                      controller.createNewCard(
                        name: nom,
                        currency: currentCurrency,
                        colorLeft: _couleurGaucheChoisie,
                        colorRight: _couleurDroiteChoisie,
                        amount: montantSaisi,
                      );

                      _amountController.clear();
                      _nameController.clear();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:bank_app/common/app_color.dart';
import 'package:bank_app/common/images_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../data/models/wallet_entity.dart';
import 'custom_card.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';

class BottomShowBar extends StatefulWidget {
  final WalletEntity? wallet;
  const BottomShowBar({super.key, required this.wallet});

  @override
  State<BottomShowBar> createState() => _BottomShowBarState();
}

class _BottomShowBarState extends State<BottomShowBar> {
  final DashboardController controller = Get.find<DashboardController>();

  final TextEditingController _amountController = TextEditingController();

  String _couleurGaucheChoisie = "0xff9e9e9e";
  String _couleurDroiteChoisie = "0xff9e9e9e";

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double currentBalance = widget.wallet?.balance ?? 0.0;
    final String currentCurrency = widget.wallet?.currency ?? "";

    return BottomSheet(
      enableDrag: false,
      showDragHandle: false,
      onClosing: () {},
      shadowColor: AppColor.grisMoyen,
      backgroundColor: const Color.fromARGB(255, 239, 238, 238),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Color(int.parse(_couleurGaucheChoisie)),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: SvgPicture.asset(
                              ImagesResources.logo,
                              height: 12,
                              colorFilter: const ColorFilter.mode(
                                AppColor.bleuSombre,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Image.asset(
                              ImagesResources.card,
                              height: 18,
                              color: AppColor.grisClair,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Color(int.parse(_couleurDroiteChoisie)),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: SvgPicture.asset(
                              ImagesResources.logo,
                              height: 12,
                              colorFilter: const ColorFilter.mode(
                                AppColor.blanc,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Image.asset(
                              ImagesResources.card,
                              height: 18,
                              color: AppColor.grisClair,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: CustomCard(
                      onColorsSelected: (hexGauche, hexDroite) {
                        setState(() {
                          _couleurGaucheChoisie = hexGauche;
                          _couleurDroiteChoisie = hexDroite;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              InputDecorator(
                decoration: InputDecoration(
                  labelText: "Solde actuel",
                  labelStyle: const TextStyle(color: AppColor.bleuSombre),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: AppColor.grisMoyen),
                  ),
                ),
                child: Text(
                  "$currentBalance  $currentCurrency",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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

              Align(
                alignment: Alignment.bottomLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.bleuSombre,
                  ),
                  onPressed: () {
                    final String texteMontant = _amountController.text.trim();
                    final int? montantSaisi = int.tryParse(texteMontant);

                    if (montantSaisi == null || montantSaisi <= 0) {
                      Get.snackbar(
                        "Erreur",
                        "Veuillez entrer un montant valide",
                      );
                      return;
                    }

                    controller.createNewCard(
                      currency: currentCurrency,
                      colorLeft: _couleurGaucheChoisie,
                      colorRight: _couleurDroiteChoisie,
                      amount: montantSaisi,
                    );

                    _amountController.clear();
                  },
                  child: const Text(
                    "Creer",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

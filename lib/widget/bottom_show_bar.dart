import 'package:bank_app/common/app_color.dart';
import 'package:bank_app/common/images_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../data/models/wallet_entity.dart';
import 'custom_card.dart';

class BottomShowBar extends StatelessWidget {
  final WalletEntity? wallet;
  const BottomShowBar({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    final double currentBalance = wallet?.balance ?? 0.0;
    final String currentCurrency = wallet?.currency ?? "";
    return BottomSheet(
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
                        color: AppColor.blanc,
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
                        color: AppColor.bleuSombre,
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
                  Expanded(child: const CustomCard()),
                ],
              ),

              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText:
                      "Solde actuel: ${currentBalance}  ${currentCurrency}",
                  labelStyle: const TextStyle(color: AppColor.bleuSombre),
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
            ],
          ),
        );
      },
    );
  }
}

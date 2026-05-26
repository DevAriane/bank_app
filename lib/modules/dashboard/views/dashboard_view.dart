import 'package:bank_app/modules/history_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:bank_app/common/app_color.dart';
import '../controllers/dashboard_controller.dart';
import '../../../common/cart_widget.dart';
import '../../../common/images_resources.dart';
import '../../../utils/number_format.dart';
import '../../../common/card_action.dart';
import '../../../common/transaction_list.dart';
import '../../.././widget/bottom_show_bar.dart';
import '../../card_detail.dart';


class Dashboard extends GetView<DashboardController> {
  const Dashboard({super.key});

  String _getCurrencySymbol(String devise) {
    switch (devise) {
      case 'EUR':
        return '€';
      case 'CNY':
        return '¥';
      // case 'CMR':
      // return 'FCFA';
      default:
        return '\$';
    }
  }

  String _getCurrencyFlag(String devise) {
    switch (devise) {
      case 'EUR':
        return ImagesResources.eur;
      case 'CNY':
        // return ImagesResources.china;
        // case 'CMR':
        return ImagesResources.china;
      default:
        return ImagesResources.usa;
    }
  }

  DashboardController get controller => Get.put(DashboardController());

  List<dynamic> get localActionCard => [
    _ActionModel(title: 'Transfer', image: ImagesResources.logo),
    _ActionModel(title: 'Top Up', image: ImagesResources.logo),
    _ActionModel(title: 'Bill', image: ImagesResources.logo),
  ];

  void _showCreateCardDialog(BuildContext context, dynamic currentWallet) {
    final TextEditingController amountController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final List<String> availableColors = [
      "0xFF070128",
      "0xFF1B4332",
      "0xFF5C0632",
      "0xFF2B2D42",
    ];

    String selectedColor = availableColors.first;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF151522),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              title: const Text(
                "Nouvelle Carte Bancaire",
                style: TextStyle(
                  color: AppColor.blanc,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Solde dispo : ${formatDouble(currentWallet.balance)} ${currentWallet.currency}",
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(color: AppColor.blanc),

                      decoration: InputDecoration(
                        labelText:
                            "Montant à allouer (${currentWallet.currency})",
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white24),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blueAccent,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Veuillez entrer un montant";
                        }
                        final parsedAmount = double.tryParse(value);
                        if (parsedAmount == null || parsedAmount <= 0) {
                          return "Veuillez entrer un montant valide";
                        }
                        if (parsedAmount > currentWallet.balance) {
                          return "Solde insuffisant dans votre portefeuille";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Choisir la couleur de la carte :",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 45,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: availableColors.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, colorIndex) {
                          final colorHex = availableColors[colorIndex];
                          final isSelected = selectedColor == colorHex;
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                selectedColor = colorHex;
                              });
                            },
                            child: Container(
                              width: 45,
                              decoration: BoxDecoration(
                                color: Color(int.parse(colorHex)),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColor.blanc
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 6,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: AppColor.blanc,
                                      size: 18,
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Annuler",
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final finalAmount = int.parse(
                        amountController.text.trim(),
                      );
                      controller.createNewCard(
                        currency: currentWallet.currency,
                        color: selectedColor,
                        amount: finalAmount,
                      );
                    }
                  },
                  child: const Text(
                    "Créer",
                    style: TextStyle(color: AppColor.blanc),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentWallet = controller.selectedWallet.value;
      final initialIndex = currentWallet != null
          ? controller.wallets.indexOf(currentWallet)
          : 0;
      final safeIndex = initialIndex != -1 ? initialIndex : 0;

      return DefaultTabController(
        key: ValueKey(controller.wallets.length + safeIndex),
        initialIndex: safeIndex,
        length: controller.wallets.isEmpty ? 1 : controller.wallets.length,
        child: Scaffold(
          appBar: AppBar(
            bottom: _buildTabBar(),

            backgroundColor: AppColor.noir,

            title: SearchBar(
              constraints: const BoxConstraints(
                minHeight: 33.0,
                maxHeight: 33.0,
              ),
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 8.0),
              ),
              backgroundColor: const WidgetStatePropertyAll(Colors.white12),
              hintText: 'Search',
              hintStyle: const WidgetStatePropertyAll(
                TextStyle(fontSize: 14, color: Colors.white60),
              ),
              textStyle: const WidgetStatePropertyAll(
                TextStyle(fontSize: 14, color: Colors.white),
              ),
              leading: SvgPicture.asset(
                ImagesResources.search,
                height: 20,
                colorFilter: ColorFilter.mode(
                  AppColor.blanc.withAlpha(50),
                  BlendMode.srcIn,
                ),
              ),
            ),

            actions: [
              IconButton(
                onPressed: null,
                icon: SvgPicture.asset(
                  ImagesResources.chat,
                  colorFilter: const ColorFilter.mode(
                    AppColor.blanc,
                    BlendMode.srcIn,
                  ),
                  height: 18,
                ),
              ),
              IconButton(
                onPressed: null,
                icon: SvgPicture.asset(
                  ImagesResources.bell,
                  colorFilter: const ColorFilter.mode(
                    AppColor.blanc,
                    BlendMode.srcIn,
                  ),
                  height: 18,
                ),
              ),
            ],
          ),

          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: AlignmentGeometry.topCenter,
                        end: AlignmentGeometry.bottomCenter,
                        colors: [
                          AppColor.noir,
                          AppColor.bleuSombre,
                          const Color.fromARGB(
                            255,
                            7,
                            5,
                            79,
                          ).withValues(alpha: 0.65),
                          const Color(0xFFA6F2F4).withValues(alpha: 0.40),
                        ],
                        stops: const [0.2, 0.5, 0.8, 1.0],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentWallet != null
                                ? "${_getCurrencySymbol(currentWallet.currency)}${formatDouble(currentWallet.balance)}"
                                : "0.00",
                            style: const TextStyle(
                              fontSize: 42,
                              color: AppColor.blanc,
                            ),
                          ),
                          const SizedBox(height: 10),

                          SizedBox(
                            height: 30,
                            child: ListView.separated(
                              itemCount: controller.cards.length + 1,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 10),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                if (index == controller.cards.length) {
                                  return SizedBox(
                                    height: double.infinity,
                                    width: 30,
                                    child: FilledButton.icon(
                                      onPressed: () {
                                        showBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return currentWallet != null
                                                ? BottomShowBar(
                                                    wallet: currentWallet,
                                                  )
                                                : const BottomShowBar(
                                                    wallet: null,
                                                  );
                                          },
                                        );

                                        // if (currentWallet != null) {
                                        //   _showCreateCardDialog(
                                        //     context,
                                        //     currentWallet,
                                        //   );
                                        // } else {
                                        //   Get.snackbar(
                                        //     "Attention",
                                        //     "Sélectionnez ou créez d'abord un portefeuille.",
                                        //     snackPosition: SnackPosition.BOTTOM,
                                        //   );
                                        // }
                                      },
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.white24,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                      ),
                                      label: const Icon(Icons.add_rounded),
                                    ),
                                  );
                                }

                                final cardEntity = controller.cards[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CardDetail(card: cardEntity),
                                      ),
                                    );
                                  },
                                  child: CartWidget(
                                    color:
                                        controller.selectedCard.value?.id ==
                                            cardEntity.id
                                        ? AppColor.blanc
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 7,
                            ),
                            child: SizedBox(
                              height: 80,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: localActionCard.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 15),
                                itemBuilder: (context, index) {
                                  final action = localActionCard[index];

                                  return CardActions(
                                    title: action.title,
                                    image: action.image,
                                    onTap: () {
                                      debugPrint(
                                        "Action cliquée : ${action.title}",
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.blanc,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Transactions",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF1D3557),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const HistoryTransaction(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "View all",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF8D99AE),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // ListView.separated(
                          //   shrinkWrap: true,
                          //   physics: const NeverScrollableScrollPhysics(),
                          //   itemCount: controller.cards.length,
                          //   separatorBuilder: (context, index) =>
                          //       const SizedBox(height: 20),
                          //   itemBuilder: (context, index) {
                          //     final currentCard = controller.cards[index];
                          //     return TransactionList(card: currentCard);
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  PreferredSizeWidget _buildTabBar() {
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      onTap: (index) {
        controller.selectWalletDirectly(controller.wallets[index]);
      },
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white54,
      indicatorColor: Colors.white,
      dividerColor: Colors.transparent,
      indicatorWeight: 3.0,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      tabs: controller.wallets.map((wallet) {
        return Tab(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              children: [
                Image.asset(
                  _getCurrencyFlag(wallet.currency),
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 2,
                  children: [
                    Text(
                      wallet.currency,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.2,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      formatDouble(wallet.balance),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ActionModel {
  final String title;
  final String image;
  _ActionModel({required this.title, required this.image});
}

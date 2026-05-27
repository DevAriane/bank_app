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
      default:
        return '\$';
    }
  }

  String _getCurrencyFlag(String devise) {
    switch (devise) {
      case 'EUR':
        return ImagesResources.eur;
      case 'CNY':
        return ImagesResources.china;
      default:
        return ImagesResources.usa;
    }
  }

  @override
  DashboardController get controller => Get.put(DashboardController());

  List<dynamic> get localActionCard => [
    _ActionModel(title: 'Transfer', image: ImagesResources.logo),
    _ActionModel(title: 'Top Up', image: ImagesResources.logo),
    _ActionModel(title: 'Bill', image: ImagesResources.logo),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentWallet = controller.selectedWallet.value;

      double walletBalance = 0.0;
      String walletCurrency = 'USD';

      if (currentWallet != null) {
        final activeWallet = controller.wallets.firstWhere(
          (w) => w.id == currentWallet.id,
          orElse: () => currentWallet,
        );
        walletBalance = activeWallet.balance;
        walletCurrency = activeWallet.currency;
      }

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
                            "${_getCurrencySymbol(walletCurrency)}${formatDouble(walletBalance)}",
                            style: const TextStyle(
                              fontSize: 42,
                              color: AppColor.blanc,
                              fontWeight: FontWeight.bold,
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
                                          showDragHandle: true,
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
                                  child: CartWidget(card: cardEntity),
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

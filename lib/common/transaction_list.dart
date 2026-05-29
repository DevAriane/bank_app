import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../common/images_resources.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'depot':
      case 'transfert':
        return ImagesResources.send;
      case 'exchange':
        return ImagesResources.convert;
      case 'ajout':
        return ImagesResources.add;
      default:
        return ImagesResources.logo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Obx(() {
      final transactions = controller.filteredTransactions;

      if (transactions.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Liste de transactions vide",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        );
      }

      return ListView.builder(
        itemCount: transactions.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final element = transactions[index];
          final bool isNegative = element.amount < 0;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy à HH:mm').format(element.date),
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isNegative
                                  ? const Color(
                                      0xFF131D47,
                                    ).withValues(alpha: 0.1)
                                  : const Color(
                                      0xFF3876B4,
                                    ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SvgPicture.asset(
                              _getCategoryIcon(element.category),
                              width: 18,
                              height: 18,
                              colorFilter: ColorFilter.mode(
                                isNegative
                                    ? const Color(0xFF131D47)
                                    : const Color(0xFF3876B4),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  element.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  element.category,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      "${isNegative ? '' : '+'}${element.amount} ${controller.selectedWallet.value?.currency ?? ''}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isNegative
                            ? const Color(0xFF131D47)
                            : const Color(0xFF3876B4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(height: 1, thickness: 0.5),
              ],
            ),
          );
        },
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bank_app/common/app_color.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';

class HistoryTransaction extends GetView<DashboardController> {
  const HistoryTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final RxString activeFilter = 'All'.obs;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.noir,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.blanc,
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Transaction History",
          style: TextStyle(
            color: AppColor.blanc,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  top: 4,
                ),
                decoration: const BoxDecoration(
                  color: AppColor.noir,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildFilterChip(
                        "All",
                        activeFilter.value == "All",
                        () => activeFilter.value = "All",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFilterChip(
                        "Income",
                        activeFilter.value == "Income",
                        () => activeFilter.value = "Income",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildFilterChip(
                        "Expense",
                        activeFilter.value == "Expense",
                        () => activeFilter.value = "Expense",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Obx(() {
                final allTransactions = controller.filteredCards
                    .expand((card) => card.transactions)
                    .toList();

                final filteredTransactions = allTransactions.where((tx) {
                  if (activeFilter.value == "Income") return tx.amount > 0;
                  if (activeFilter.value == "Expense") return tx.amount < 0;
                  return true;
                }).toList();

                filteredTransactions.sort((a, b) => b.id.compareTo(a.id));

                if (filteredTransactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.receipt_long_rounded,
                            size: 64,
                            color: Color(0xFFA0AABF),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "No transactions found",
                          style: TextStyle(
                            color: Color(0xFF8D99AE),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Try switching your active filter tab",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final tx = filteredTransactions[index];
                    final isIncome = tx.amount > 0;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isIncome
                                    ? const Color(
                                        0xFF3876B4,
                                      ).withValues(alpha: 0.1)
                                    : const Color(
                                        0xFF131D47,
                                      ).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isIncome
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded,
                                color: isIncome
                                    ? const Color(0xFF3876B4)
                                    : const Color(0xFF131D47),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 14),

                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tx.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF1F2937),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tx.category,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${isIncome ? '+' : '-'} ${tx.amount.abs().toStringAsFixed(2)}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: isIncome
                                          ? const Color(0xFF3876B4)
                                          : const Color(0xFF1F2937),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        size: 11,
                                        color: Color(0xFF2ECC71),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Success",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[400],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.blanc
              : Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AppColor.noir
                : AppColor.blanc.withValues(alpha: 0.6),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bank_app/common/app_color.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';

class HistoryTransaction extends GetView<DashboardController> {
  const HistoryTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final activeFilter = 'All'.obs;

    return Scaffold(
      backgroundColor: AppColor.blanc,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.noir,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.blanc,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Transaction History",
          style: TextStyle(
            color: AppColor.blanc,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 16,
                ),
                color: AppColor.noir,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFilterChip(
                      "All",
                      activeFilter.value == "All",
                      () => activeFilter.value = "All",
                    ),
                    _buildFilterChip(
                      "Income",
                      activeFilter.value == "Income",
                      () => activeFilter.value = "Income",
                    ),
                    _buildFilterChip(
                      "Expense",
                      activeFilter.value == "Expense",
                      () => activeFilter.value = "Expense",
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Obx(() {
                final allTransactions = controller.cards
                    .expand((card) => card.transactions)
                    .toList();

                final filteredTransactions = allTransactions.where((tx) {
                  if (activeFilter.value == "Income") return tx.amount > 0;
                  if (activeFilter.value == "Expense") return tx.amount < 0;
                  return true;
                }).toList();

                filteredTransactions.sort((a, b) => b.id.compareTo(a.id));

                if (filteredTransactions.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_rounded,
                          size: 60,
                          color: Color(0xFF8D99AE),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No transactions found",
                          style: TextStyle(
                            color: Color(0xFF8D99AE),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredTransactions.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 24, color: Color(0xFFE4DDD5)),
                  itemBuilder: (context, index) {
                    final tx = filteredTransactions[index];
                    final isIncome = tx.amount > 0;

                    return Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isIncome
                                ? const Color(0xFF2ECC71).withValues(alpha: 0.1)
                                : const Color(
                                    0xFFE74C3C,
                                  ).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isIncome
                                ? Icons.arrow_downward_rounded
                                : Icons.arrow_upward_rounded,
                            color: isIncome
                                ? const Color(0xFF2ECC71)
                                : const Color(0xFFE74C3C),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF1D3557),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tx.category,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF8D99AE),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${isIncome ? '+' : ''}\$${tx.amount.abs().toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 15,
                                color: isIncome
                                    ? const Color(0xFF2ECC71)
                                    : const Color(0xFF1D3557),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Successful",
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF8D99AE),
                              ),
                            ),
                          ],
                        ),
                      ],
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
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.blanc : Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AppColor.noir
                : AppColor.blanc.withValues(alpha: 0.7),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

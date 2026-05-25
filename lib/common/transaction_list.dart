import 'package:flutter/material.dart';
import '../data/models/card_entity.dart'; 

class TransactionList extends StatelessWidget {
  final CardEntity card; 

  const TransactionList({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.expiryDate,
            style: const TextStyle(color: Color(0xFF8D99AE), fontSize: 14),
          ),

          const SizedBox(height: 8),

          
          ...card.transactions.map((element) {
            final isIncome = element.amount > 0;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color.fromARGB(255, 228, 221, 221).withValues(alpha: 0.2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: const BoxDecoration(
                          color: Color(0xFF8D99AE),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 10,
                        ),
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
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1D3557),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          element.category, 
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFA2A2A2),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${isIncome ? '+' : ''}\$${element.amount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1D3557),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${element.amount.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: isIncome ? const Color(0xFF2ECC71) : const Color(0xFFE74C3C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
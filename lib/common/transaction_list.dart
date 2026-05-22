import 'package:flutter/material.dart';
import '../models/card_model.dart';

class TransactionList extends StatelessWidget {
  final CardModel card;

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

          const SizedBox(height: 16),

          ...card.transactions.map((element) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color.fromARGB(
                        255,
                        228,
                        221,
                        221,
                      ).withValues(alpha: 0.2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        element.imageUrl,
                        width: 15,
                        height: 15,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (
                              BuildContext context,
                              Object exception,
                              StackTrace? stackTrace,
                            ) {
                              return Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8D99AE).withAlpha(50),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Color(0xFF1D3557),
                                  size: 24,
                                ),
                              );
                            },
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          element.userName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1D3557),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          element.description,
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
                        "\$${element.amount}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1D3557),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${element.amount}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2ECC71),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../common/transaction_list.dart';
import '../data/fake_datas.dart';

class HistoryTransaction extends StatelessWidget {
  const HistoryTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historiques des transactions ")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fakeCardsList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 7),
                itemBuilder: (context, index) {
                  final carte = fakeCardsList[index];

                  return TransactionList(card: carte);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

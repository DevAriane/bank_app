// enum TransactionCategory { depot, retrait }

// class TransactionCategoryConverter
//     extends PropertyConverter<TransactionCategory, String> {
//   const TransactionCategoryConverter();

//   @override
//   TransactionCategory convertToEntityProperty(String databaseValue) {
//     return TransactionCategory.values.firstWhere(
//       (e) => e.name == databaseValue,
//       orElse: () => TransactionCategory.depot,
//     );
//   }

//   @override
//   String convertToDatabaseValue(TransactionCategory entityProperty) {
//     return entityProperty.name;
//   }
// }

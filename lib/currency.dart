abstract class Currency {
  String get name;
  String get symbol;

  double get toUSD;
  double get toEUR;
  double get toCNY;
  double get toFCFA;

  double convert(double amount, String targetCurrency) {
    switch (targetCurrency.toUpperCase()) {
      case 'USD':
        return amount * toUSD;
      case 'EUR':
        return amount * toEUR;
      case 'CNY':
        return amount * toCNY;
      case 'FCFA':
        return amount * toFCFA;
      default:
        throw ArgumentError('Devise cible non reconnue');
    }
  }
}

class UsdCurrency extends Currency {
  @override
  String get name => 'Dollar Américain';
  @override
  String get symbol => '\$';
  @override
  double get toUSD => 1.0;
  @override
  double get toEUR => 0.86;
  @override
  double get toCNY => 6.78;
  @override
  double get toFCFA => 563.0;
}

class EurCurrency extends Currency {
  @override
  String get name => 'Euro';
  @override
  String get symbol => '€';
  @override
  double get toUSD => 1.16;
  @override
  double get toEUR => 1.0;
  @override
  double get toCNY => 7.90;
  @override
  double get toFCFA => 655.96;
}

class CnyCurrency extends Currency {
  @override
  String get name => 'Yuan Chinois';
  @override
  String get symbol => '¥';
  @override
  double get toUSD => 0.15;
  @override
  double get toEUR => 0.13;
  @override
  double get toCNY => 1.0;
  @override
  double get toFCFA => 83.0;
}

class FcfaCurrency extends Currency {
  @override
  String get name => 'Franc CFA';
  @override
  String get symbol => 'FCFA';
  @override
  double get toUSD => 0.00178;
  @override
  double get toEUR => 0.00152;
  @override
  double get toCNY => 0.01205;
  @override
  double get toFCFA => 1.0;
}

double executeConversion({
  required double amount,
  required String fromCurrency,
  required String toCurrency,
}) {
  Currency source;

  switch (fromCurrency.toUpperCase()) {
    case 'USD':
      source = UsdCurrency();
      break;
    case 'EUR':
      source = EurCurrency();
      break;
    case 'CNY':
      source = CnyCurrency();
      break;
    case 'FCFA':
      source = FcfaCurrency();
      break;
    default:
      throw ArgumentError('Devise de départ non reconnue');
  }

  return source.convert(amount, toCurrency);
}

import 'package:bank_app/common/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common/images_resources.dart';
import '../data/models/card_entity.dart';
import 'package:get/get.dart';
import '../modules/dashboard/controllers/dashboard_controller.dart';

class CardDetail extends StatefulWidget {
  final CardEntity card;
  const CardDetail({super.key, required this.card});

  @override
  State<CardDetail> createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  final DashboardController _controller = Get.find<DashboardController>();

  int _activeCardIndex = 0;

  Color _parseColor(String? hexString, Color defaultColor) {
    if (hexString == null || hexString.trim().isEmpty) return defaultColor;
    try {
      final int? colorValue = int.tryParse(hexString.trim());
      if (colorValue != null) return Color(colorValue);
    } catch (e) {
      debugPrint("Erreur couleur : \$e");
    }
    return defaultColor;
  }

  late final PageController _pageController;
  late List<CardEntity> _walletCards;

  @override
  void initState() {
    super.initState();

    final String currentCurrency = widget.card.wallet.target?.currency ?? "";
    _walletCards = _controller.cards
        .where((c) => c.wallet.target?.currency == currentCurrency)
        .toList();

    if (_walletCards.isEmpty) {
      _walletCards = [widget.card];
    }

    final int initialPage = _walletCards.indexWhere(
      (c) => c.id == widget.card.id,
    );
    _activeCardIndex = initialPage != -1 ? initialPage : 0;

    _pageController = PageController(
      initialPage: _activeCardIndex,
      viewportFraction: 0.72,
    );
  }

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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CardEntity activeCard = _walletCards[_activeCardIndex];

    final Color couleurGauche = _parseColor(
      widget.card.themeColorLeft,
      const Color(0xFF5A9ECA),
    );
    final Color couleurDroite = _parseColor(
      widget.card.themeColorRight,
      const Color(0xFF1E105C),
    );

    final int calculatedBalance = widget.card.amount;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SvgPicture.asset(
              ImagesResources.more,
              height: 25,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: const Color(0xFF131D47),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF131D47),
                      Color(0xFF3876B4),
                      Color(0xFF88C9E8),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              Transform.translate(
                offset: const Offset(0, -150),
                child: SizedBox(
                  height: 340,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _walletCards.length,
                    onPageChanged: (int index) {
                      setState(() {
                        _activeCardIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final CardEntity currentCardItem = _walletCards[index];
                      final Color couleurGauche = _parseColor(
                        currentCardItem.themeColorLeft,
                        const Color(0xFF5A9ECA),
                      );
                      final Color couleurDroite = _parseColor(
                        currentCardItem.themeColorRight,
                        const Color(0xFF1E105C),
                      );

                      final double scale = _activeCardIndex == index
                          ? 1.0
                          : 0.88;

                      return AnimatedScale(
                        scale: scale,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          width: 220,
                          height: 330,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [couleurGauche, couleurDroite],
                              stops: const [0.4, 0.55],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "**** ",
                                          style: TextStyle(
                                            color: AppColor.blanc,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          currentCardItem.cardNumber.substring(
                                            currentCardItem.cardNumber.length -
                                                4,
                                          ),
                                          style: const TextStyle(
                                            color: AppColor.blanc,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      currentCardItem.expiryDate,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                SvgPicture.asset(
                                  ImagesResources.logo,
                                  height: 75,
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      ImagesResources.master,
                                      height: 32,
                                      colorFilter: ColorFilter.mode(
                                        const Color(
                                          0xFFFFFFFF,
                                        ).withValues(alpha: 0.5),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    Text(
                                      currentCardItem.type,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Transform.translate(
                offset: const Offset(0, -105),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _walletCards.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _activeCardIndex == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _activeCardIndex == index
                                ? const Color(0xFF000000)
                                : const Color(0xFF9E9E9E),

                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "${_getCurrencySymbol(activeCard.wallet.target?.currency ?? '')}${activeCard.amount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D3557),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      child: Container(
                        alignment: AlignmentDirectional.topStart,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Card info",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D3557),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Card number",
                                  style: TextStyle(color: Color(0xFFA2A2A2)),
                                ),
                                Text(
                                  activeCard.cardNumber,
                                  style: const TextStyle(
                                    color: Color(0xFF1D3557),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "CVC",
                                  style: TextStyle(color: Color(0xFFA2A2A2)),
                                ),
                                Text(
                                  activeCard.cvc,
                                  style: const TextStyle(
                                    color: Color(0xFF1D3557),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Expiry date ",
                                  style: TextStyle(color: Color(0xFFA2A2A2)),
                                ),
                                Text(
                                  activeCard.expiryDate,
                                  style: const TextStyle(
                                    color: Color(0xFF1D3557),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

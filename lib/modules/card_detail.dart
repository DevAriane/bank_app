import 'package:bank_app/common/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common/images_resources.dart';
import '../data/models/card_entity.dart';

class CardDetail extends StatefulWidget {
  final CardEntity card;
  const CardDetail({super.key, required this.card});

  @override
  State<CardDetail> createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
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

  @override
  Widget build(BuildContext context) {
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
                child: Container(
                  width: 220,
                  height: 330,
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
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "**** ",
                              style: TextStyle(color: AppColor.blanc),
                            ),
                            Text(
                              " ${widget.card.cardNumber.substring(widget.card.cardNumber.length - 4)}",
                              style: const TextStyle(color: AppColor.blanc),
                            ),
                          ],
                        ),
                        Center(
                          child: Transform.translate(
                            offset: const Offset(0, 100),
                            child: SvgPicture.asset(
                              ImagesResources.logo,
                              height: 80,
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, 185),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                ImagesResources.master,
                                height: 35,
                                colorFilter: ColorFilter.mode(
                                  const Color(
                                    0xFFFFFFFF,
                                  ).withValues(alpha: 0.5),
                                  BlendMode.srcIn,
                                ),
                              ),
                              const Text(
                                "Debit",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Transform.translate(
                offset: const Offset(170, -450),
                child: Container(
                  height: 285,
                  width: 20,
                  decoration: const BoxDecoration(
                    color: AppColor.blanc,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(10),
                    ),
                  ),
                ),
              ),

              Transform.translate(
                offset: const Offset(0, -385),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 24,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF000000),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF9E9E9E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE0E0E0),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Text(
                      "\$${calculatedBalance.toStringAsFixed(2)}",
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
                                  widget.card.cardNumber,
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
                                  widget.card.cvc,
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
                                  widget.card.expiryDate,
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

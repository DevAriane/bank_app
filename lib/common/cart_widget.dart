import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'app_color.dart';
import '../data/models/card_entity.dart';
import './images_resources.dart';

class CartWidget extends StatelessWidget {
  final CardEntity? card;

  const CartWidget({super.key, this.card});

  Color _parseColor(String? hexString, Color defaultColor) {
    if (hexString == null || hexString.trim().isEmpty) {
      return defaultColor;
    }
    try {
      final int? colorValue = int.tryParse(hexString.trim());
      if (colorValue != null) {
        return Color(colorValue);
      }
    } catch (e) {
      debugPrint("Erreur lors de la conversion de la couleur : $e");
    }
    return defaultColor;
  }

  @override
  Widget build(BuildContext context) {
    final Color couleurGauche = _parseColor(
      card?.themeColorLeft,
      AppColor.blanc,
    );
    final Color couleurDroite = _parseColor(
      card?.themeColorRight,
      AppColor.bleuSombre,
    );

    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(4),
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          transform: const GradientRotation(-190),
          colors: [couleurGauche, couleurDroite],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: AlignmentDirectional.topEnd,
            child: SvgPicture.asset(
              ImagesResources.logo,
              colorFilter: const ColorFilter.mode(
                AppColor.blanc,
                BlendMode.srcIn,
              ),
              width: 14,
            ),
          ),
          Container(
            alignment: AlignmentDirectional.topStart,
            child: Image.asset(ImagesResources.card, height: 6),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bank_app/common/app_color.dart';
import 'package:bank_app/common/images_resources.dart';
import '../data/models/card_entity.dart';

class BankCardWidget extends StatelessWidget {
  final CardVisualType type;

  const BankCardWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isWhite = type == CardVisualType.blanc;
    final isGradient = type == CardVisualType.degrade;

    return Container(
      height: 50,
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: isGradient
            ? null
            : (isWhite ? AppColor.blanc : AppColor.bleuSombre),
        gradient: isGradient
            ? const LinearGradient(
                colors: [AppColor.bleuSombre, AppColor.bleuVif],
                stops: [0.3, 0.6],
              )
            : null,
        borderRadius: BorderRadius.circular(2),
        border: isWhite
            ? Border.all(color: AppColor.grisMoyen, width: 0.5)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(
              ImagesResources.logo,
              height: 12,
              colorFilter: ColorFilter.mode(
                isWhite ? AppColor.bleuSombre : AppColor.blanc,
                BlendMode.srcIn,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              ImagesResources.card,
              height: 18,
              color: isWhite
                  ? AppColor.grisClair
                  : AppColor.blanc.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }
}

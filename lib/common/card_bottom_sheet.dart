import 'package:flutter/material.dart';
import './images_resources.dart';
import 'app_color.dart';
import '../widget/custom_card.dart';
import 'package:flutter_svg/svg.dart';

class CardBottomSheet extends StatefulWidget {
  final Color couleurGauche;
  final Color couleurDroite;
  final Function(String hexGauche, String hexDroite) onColorsUpdated;

  const CardBottomSheet({
    super.key,
    required this.couleurGauche,
    required this.couleurDroite,
    required this.onColorsUpdated,
  });

  @override
  State<CardBottomSheet> createState() => _CardBottomSheetState();
}

class _CardBottomSheetState extends State<CardBottomSheet> {
  late Color _couleurGaucheLocale;
  late Color _couleurDroiteLocale;

  @override
  void initState() {
    super.initState();
    _couleurGaucheLocale = widget.couleurGauche;
    _couleurDroiteLocale = widget.couleurDroite;
  }

  @override
  void didUpdateWidget(covariant CardBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.couleurGauche != widget.couleurGauche ||
        oldWidget.couleurDroite != widget.couleurDroite) {
      _couleurGaucheLocale = widget.couleurGauche;
      _couleurDroiteLocale = widget.couleurDroite;
    }
  }

  String _colorToHex(Color color) {
    final String a = (color.a * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String r = (color.r * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String g = (color.g * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String b = (color.b * 255).toInt().toRadixString(16).padLeft(2, '0');
    return '0x$a$r$g$b';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              const Color blanc = Color(0xFFFFFFFF);
              setState(() {
                _couleurGaucheLocale = blanc;
                _couleurDroiteLocale = blanc;
              });

              widget.onColorsUpdated(_colorToHex(blanc), _colorToHex(blanc));
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset(
                      ImagesResources.logo,
                      height: 12,
                      colorFilter: const ColorFilter.mode(
                        AppColor.bleuSombre,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Image.asset(
                      ImagesResources.card,
                      height: 18,
                      color: AppColor.grisClair,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: InkWell(
            onTap: () {
              const Color bleuFonce = Color(0xFF131D47);
              const Color bleuClair = Color(0xFF3876B4);
              setState(() {
                _couleurGaucheLocale = bleuFonce;
                _couleurDroiteLocale = bleuClair;
              });

              widget.onColorsUpdated(
                _colorToHex(bleuFonce),
                _colorToHex(bleuClair),
              );
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF131D47), Color(0xFF3876B4)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset(
                      ImagesResources.logo,
                      height: 12,
                      colorFilter: const ColorFilter.mode(
                        AppColor.blanc,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Image.asset(
                      ImagesResources.card,
                      height: 18,
                      color: AppColor.grisClair,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: CustomCard(
            onColorsSelected: (hexGauche, hexDroite) {
              setState(() {
                _couleurGaucheLocale = Color(int.parse(hexGauche));
                _couleurDroiteLocale = Color(int.parse(hexDroite));
              });

              widget.onColorsUpdated(hexGauche, hexDroite);
            },
          ),
        ),
      ],
    );
  }
}

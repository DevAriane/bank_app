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

  int? idWidgetSelectionne;

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
        _element(
          id: 1,
          couleurGauche: const Color(0xFFFFFFFF),
          couleurDroite: const Color(0xFFFFFFFF),
        ),

        const SizedBox(width: 10),

        _element(
          id: 2,
          couleurGauche: const Color(0xFF131D47),
          couleurDroite: const Color(0xFF3876B4),
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

  Widget _element({
    required int id,

    required Color couleurGauche,
    required Color couleurDroite,
  }) {
    bool hadBorder = (idWidgetSelectionne == id);
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            idWidgetSelectionne = (idWidgetSelectionne == id) ? null : id;
            _couleurGaucheLocale = couleurGauche;
            _couleurDroiteLocale = couleurDroite;
          });

          widget.onColorsUpdated(
            _colorToHex(couleurGauche),
            _colorToHex(couleurDroite),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hadBorder ? Colors.blue : Colors.transparent,
              width: 3,
            ),
          ),
          child: Container(
            height: 50,
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [couleurGauche, couleurDroite]),
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
    );
  }
}

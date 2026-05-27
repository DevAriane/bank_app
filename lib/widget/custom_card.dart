import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final Function(String hexGauche, String hexDroite) onColorsSelected;

  const CustomCard({super.key, required this.onColorsSelected});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  String _colorToHex(Color color) {
    final String a = (color.a * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String r = (color.r * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String g = (color.g * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String b = (color.b * 255).toInt().toRadixString(16).padLeft(2, '0');

    return '0x$a$r$g$b';
  }

  void showPop(BuildContext context) {
    double teinteGauche = 0.0;
    double teinteDroite = 180.0;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setPopupState) {
            Color couleurGauche = HSVColor.fromAHSV(
              1.0,
              teinteGauche,
              1.0,
              1.0,
            ).toColor();
            Color couleurDroite = HSVColor.fromAHSV(
              1.0,
              teinteDroite,
              1.0,
              1.0,
            ).toColor();

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 120,
                      width: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [couleurGauche, couleurDroite],
                          stops: const [0.5, 0.5],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Filtre Gauche",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    _buildColorSlider(
                      value: teinteGauche,
                      onChanged: (nouvelleValeur) {
                        setPopupState(() => teinteGauche = nouvelleValeur);
                      },
                    ),
                    const SizedBox(height: 15),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Filtre Droite",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    _buildColorSlider(
                      value: teinteDroite,
                      onChanged: (nouvelleValeur) {
                        setPopupState(() => teinteDroite = nouvelleValeur);
                      },
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Annuler"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            widget.onColorsSelected(
                              _colorToHex(couleurGauche),
                              _colorToHex(couleurDroite),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text("Valider"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildColorSlider({
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      height: 10,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: const LinearGradient(
          colors: [
            Colors.red,
            Colors.yellow,
            Colors.green,
            Colors.cyan,
            Colors.blue,
            Colors.white,
            Colors.black,
          ],
        ),
      ),
      child: SliderTheme(
        data: const SliderThemeData(
          activeTrackColor: Colors.transparent,
          inactiveTrackColor: Colors.transparent,
          thumbColor: Colors.white,
          trackHeight: 10,
        ),
        child: Slider(value: value, min: 0.0, max: 360.0, onChanged: onChanged),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
      onPressed: () => showPop(context),
      child: const Icon(Icons.dashboard_customize),
    );
  }
}

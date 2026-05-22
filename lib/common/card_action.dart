import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'app_color.dart';

class CardActions extends StatelessWidget {
  final String title;
  final String image;
  const CardActions({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color.fromARGB(255, 238, 247, 247),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFF1D3557),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: image.isNotEmpty
                  ? SvgPicture.asset(
                      image,
                      height: 12,
                      width: 12,
                      colorFilter: const ColorFilter.mode(
                        Color(0XFFFFFFFF),
                        BlendMode.srcIn,
                      ),
                    )
                  : const Icon(Icons.bolt, color: Colors.white),
            ),
          ),

          const SizedBox(height: 30),

          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1D3557),
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

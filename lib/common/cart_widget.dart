import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'app_color.dart';
import './images_resources.dart';

class CartWidget extends StatelessWidget {
  final Color? color;
  const CartWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(4),
      width: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        gradient: color != null
            ? null
            : const LinearGradient(
                begin: AlignmentGeometry.topCenter,
                end: AlignmentGeometry.bottomCenter,
                transform: GradientRotation(-190),
                colors: [AppColor.noir, Color.fromARGB(255, 7, 1, 40), Color.fromARGB(255, 50, 23, 158)],
              ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: AlignmentDirectional.topEnd,
            child: SvgPicture.asset(
              ImagesResources.logo,
              colorFilter: ColorFilter.mode(color != null ? AppColor.noir : AppColor.blanc, BlendMode.srcIn),
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
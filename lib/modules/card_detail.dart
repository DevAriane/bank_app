import 'package:bank_app/common/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common/images_resources.dart';
import '../data/models/card_model.dart';

class CardDetail extends StatefulWidget {
  final CardModel card;
  const CardDetail({super.key, required this.card});

  @override
  State<CardDetail> createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  @override
  Widget build(BuildContext context) {
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

                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF5A9ECA),
                        Color(0xFF1E105C),
                        Color(0xFF05050A),
                      ],

                      stops: [0.4, 0.55, 1.0],
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
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "**** ",
                              style: TextStyle(color: AppColor.blanc),
                            ),
                            Text(
                              " 8152",
                              style: TextStyle(color: AppColor.blanc),
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
                child: Container(
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
                        "\$${widget.card.amount}",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Card number",
                                    style: TextStyle(color: Color(0xFFA2A2A2)),
                                  ),

                                  Text(
                                    "\$${widget.card.cardNumber}",
                                    style: const TextStyle(
                                      color: Color(0xFF1D3557),
                                    ),
                                  ),
                                  // Icon(Icons.copy),
                                ],
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "CVC",
                                    style: TextStyle(color: Color(0xFFA2A2A2)),
                                  ),
                                  Text(
                                    "\$${widget.card.cvc}",
                                    style: const TextStyle(
                                      color: Color(0xFF1D3557),
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Expiry date ",
                                    style: TextStyle(color: Color(0xFFA2A2A2)),
                                  ),
                                  Text(
                                    "\$${widget.card.expiryDate}",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

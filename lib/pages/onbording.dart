import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common/app_color.dart';
import '../common/images_resources.dart';
import 'dashboard.dart';

class Onbording extends StatelessWidget {
  const Onbording({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              width: double.infinity,

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentGeometry.topCenter,
                  end: AlignmentGeometry.bottomCenter,
                  colors: [AppColor.bleuCyan, AppColor.bleuVif],

                  stops: [0.60, 0.77],
                ),
              ),

              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2,
                  ),
                  child: Column(
                    children: [
                      Transform.translate(
                        offset: const Offset(-150, -140),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.notes,
                                  color: Color(0xFF000000),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Center(
                        child: SvgPicture.asset(
                          ImagesResources.logo,
                          width: 180,
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(
                            AppColor.noir,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentGeometry.topCenter,
                  end: AlignmentGeometry.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColor.noir.withValues(alpha: 0.2),
                    AppColor.noir,
                  ],
                  stops: const [0, 0.10, 0.3],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColor.blanc,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                              ),
                          text: "TOMORROW'S \n BANKING IS HERE \n",
                          children: [
                            TextSpan(
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: AppColor.blanc,
                                    height: 1.7,
                                  ),

                              text:
                                  '\n Experience banking reimagined for the digital age secure, intuitive, and built for the way you live today.',
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColor.blanc,
                            foregroundColor: AppColor.noir,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Dashboard(),
                              ),
                            );
                          },

                          child: const Text(
                            'Become a Customer',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D3557),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'I am Already a customer',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.blanc,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

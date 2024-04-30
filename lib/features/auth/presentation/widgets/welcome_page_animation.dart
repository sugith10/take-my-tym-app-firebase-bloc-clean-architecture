import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:take_my_tym/core/utils/app_assets/app_svg.dart';


class WelcomePageAnimation extends StatelessWidget {
  const WelcomePageAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 2,
      child:     SvgPicture.asset(MyAppSVG.welcomeGraphics),
    );
  }
}

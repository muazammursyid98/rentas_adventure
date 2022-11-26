import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide ScreenType;
import 'package:google_fonts/google_fonts.dart';
import 'package:rentas_adventure/screen/display_cart.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controller/cart_controller.dart';
import '../utils/size_config.dart';

final CartController counterController = Get.put(CartController());

class BadgeCart extends StatelessWidget {
  const BadgeCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (counterController.listStoreCart.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DisplayAddToCart(),
            ),
          );
        } else {
          AwesomeDialog(
            width: checkConditionWidth(context),
            bodyHeaderDistance: 60,
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.WARNING,
            body: Center(
              child: Text(
                'Ops, your cart is empty.',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.normal, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            title: '',
            desc: '',
            btnOkOnPress: () {},
          ).show();
        }
      },
      child: Badge(
        badgeContent: Obx(
          () => Text(
            counterController.valueCart.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        child: Icon(
          FontAwesomeIcons.bagShopping,
          size: 6.h,
          color: Colors.white,
        ),
      ),
    );
  }

  checkConditionWidth(context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return getProportionateScreenWidth(200);
    } else {
      switch (Device.screenType) {
        case ScreenType.mobile:
          return double.infinity;
        default:
          return getProportionateScreenWidth(200);
      }
    }
  }
}

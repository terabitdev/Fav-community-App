import 'package:fava/core/constants/assets.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/widgets/auth/custom_app_bar.dart';
import 'package:fava/widgets/common/custom_elevated_button.dart';
import 'package:fava/widgets/profile/payment_methods_container.dart';
import 'package:fava/widgets/profile/payment_method_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(
                  topHeight: 22,
                  title: "Payment Methods",
                  backButton: true,
                  appLogo: true,
                  subtitle: "Payment Methods",
                ),
                SizedBox(height: 12.h),
                PaymentMethodsContainer(
                  title: "Linked Accounts",
                  children: [
                    PaymentMethodTile(
                      iconAsset: AppAssets.venmo,
                      title: "Venmo",
                      subtitle: "Link Your Account",
                      isLinked: true,
                    ),
                    PaymentMethodTile(
                      iconAsset: AppAssets.zelle,
                      title: "Zelle",
                      subtitle: "Link Your Account",
                      isLinked: false,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                PaymentMethodsContainer(
                  title: "Default Payment Methods",
                  children: [
                    PaymentMethodTile(
                      iconAsset: AppAssets.venmo,
                      title: "Venmo",
                      // subtitle: "Link Your Account",
                      isLinked: true,
                      trailingType: TrailingType.radio,
                      paymentMethodId: "venmo",
                    ),
                    PaymentMethodTile(
                      iconAsset: AppAssets.zelle,
                      title: "Zelle",
                      // subtitle: "Link Your Account",
                      isLinked: false,
                      trailingType: TrailingType.radio,
                      paymentMethodId: "zelle",
                    ),
                  ],
                ),
                SizedBox(height: 34.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 5.h,
                  ),
                  child: CustomElevatedButton(
                    text: "Continue to Venmo",
                    onPressed: () {},
                    bgColor: Color.fromRGBO(50, 146, 200, 1),
                    textStyle: AppTextStyles.marlinRegular400.copyWith(
                      fontSize: 16.sp,
                      // color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 5.0,
                  ),
                  child: CustomElevatedButton(
                    text: "Continue to Venmo",
                    onPressed: () {},
                    bgColor: Color.fromRGBO(109, 30, 212, 1),
                    textStyle: AppTextStyles.marlinRegular400.copyWith(
                      fontSize: 16.sp,
                      // color: Colors.white,
                    ),
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

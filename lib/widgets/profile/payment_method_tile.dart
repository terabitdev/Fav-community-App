import 'package:fava/core/constants/assets.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/providers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

enum TrailingType { radio, switchWidget, text }

class PaymentMethodTile extends StatelessWidget {
  final String iconAsset;
  final String title;
  final String? subtitle;
  final bool isLinked;
  final TrailingType trailingType;
  final String? paymentMethodId;

  const PaymentMethodTile({
    super.key,
    required this.iconAsset,
    required this.title,
    this.subtitle,
    required this.isLinked,
    this.trailingType = TrailingType.text,
    this.paymentMethodId,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      minVerticalPadding: 0,
      minLeadingWidth: 0,
      // minTileHeight: 20.h,
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 20.r,
        child: SvgPicture.asset(iconAsset),
      ),
      title: Text(
        title,
        style: AppTextStyles.futuraDemi500.copyWith(
          fontSize: 14.sp,
        ),
      ),
      subtitle: subtitle != null ? Text(
        subtitle!,
        style: AppTextStyles.futuraBook400.copyWith(
          fontSize: 12.sp,
          color: AppColors.hintxtclr,
        ),
      ) : null,
      trailing: _buildTrailing(context),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    switch (trailingType) {
      case TrailingType.radio:
        return Consumer<PaymentProvider>(
          builder: (context, paymentProvider, _) {
            final isSelected = paymentMethodId != null &&
                paymentProvider.isSelected(paymentMethodId!);
            return GestureDetector(
              onTap: () {
                if (paymentMethodId != null) {
                  paymentProvider.selectPaymentMethod(paymentMethodId!);
                }
              },
              child: SvgPicture.asset(
                isSelected
                    ? AppAssets.radioSelected
                    : AppAssets.radioUnselected,
                width: 20.w,
                height: 20.h,
              ),
            );
          },
        );
      case TrailingType.switchWidget:
        return Consumer<PaymentProvider>(
          builder: (context, paymentProvider, _) {
            final switchValue = paymentMethodId != null
                ? paymentProvider.getSwitchState(paymentMethodId!)
                : false;
            return Switch(
              value: switchValue,
              onChanged: (value) {
                if (paymentMethodId != null) {
                  paymentProvider.toggleSwitch(paymentMethodId!, value);
                }
              },
            );
          },
        );
      case TrailingType.text:
        return Text(
          isLinked ? "Linked" : "Unlinked",
          style: AppTextStyles.futuraBook400.copyWith(
            fontSize: 15.sp,
            color: isLinked ? Colors.green : AppColors.errorclr,
          ),
        );
    }
  }
}
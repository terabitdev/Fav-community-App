import 'package:fava/core/constants/assets.dart';
import 'package:fava/providers/support_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class RatingsWidget extends StatelessWidget {
  final int maxRating;

  const RatingsWidget({
    super.key,
    this.maxRating = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SupportProvider>(
      builder: (context, supportProvider, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(maxRating, (index) {
            final starIndex = index + 1;
            final isFilled = starIndex <= supportProvider.rating;
            
            return GestureDetector(
              onTap: () {
                supportProvider.setRating(starIndex);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: SvgPicture.asset(
                  isFilled ? AppAssets.ratingsFilled : AppAssets.ratingsOutlined,
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
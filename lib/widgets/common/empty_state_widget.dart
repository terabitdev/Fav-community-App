import 'package:fava/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyStateWidget extends StatelessWidget {


  const EmptyStateWidget({
    super.key,
    
  });

  @override
  Widget build(BuildContext context) {
    return Center(
     child: Text("No Requests to Show", style: AppTextStyles.futuraBook400.copyWith(
      fontSize: 18.sp
     ),),
    );
  }

}
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LocationSharingWidget extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const LocationSharingWidget({
    super.key,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.buttonclr, width: 1.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset(
            "assets/icons/location.svg",
            width: 24.w,
            height: 20.h,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enable Location Sharing",
                style: AppTextStyles.futuraBook400.copyWith(fontSize: 16.sp),
              ),
              Text(
                "Help others find you for local requests",
                style: AppTextStyles.futuraBook400.copyWith(
                  fontSize: 10.sp,
                  color: AppColors.grayMedium,
                ),
              ),
            ],
          ),
          CustomSwitchButton(value: isEnabled, onChanged: onChanged),
        ],
      ),
    );
  }
}


class CustomSwitchButton extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double? width;
  final double? height;

  const CustomSwitchButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.width,
    this.height,
  });

  @override
  State<CustomSwitchButton> createState() => _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.value) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CustomSwitchButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final switchWidth = widget.width ?? 27.w;
    final switchHeight = widget.height ?? 14.h;
    final knobSize = switchHeight - 4.h;

    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: switchWidth,
            height: switchHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(switchHeight / 2),
              color: Color.lerp(AppColors.hintxtclr, AppColors.buttonclr, _animation.value),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  left: widget.value ? switchWidth - knobSize - 2.w : 2.w,
                  top: 2.h,
                  child: Container(
                    width: knobSize,
                    height: knobSize,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:fava/core/constants/colors.dart';
import 'package:fava/providers/nav_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  final List<IconData> iconList;
  final List<String> titles;

  const CustomBottomNavBar({
    super.key,
    required this.iconList,
    required this.titles,
  }) : assert(iconList.length == titles.length, 'Icons and titles must have the same length');

  @override
  Widget build(BuildContext context) {
    return Consumer<NavProvider>(
      builder: (context, navProvider, child) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // Built-in BottomNavigationBar (hidden selected tab)
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              child: SizedBox(
                height: 77.h,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: BottomNavigationBar(
                    currentIndex: navProvider.selectedIndex,
                    onTap: (index) {
                      navProvider.animateToPage(index);
                      // Always restart animation on tab selection
                      navProvider.floatController?.reset();
                      navProvider.floatController?.forward();
                    },
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: AppColors.bgclr,
                    selectedItemColor: Colors.transparent,
                    unselectedItemColor: Colors.grey[600],
                    selectedFontSize: 0,
                    unselectedFontSize: 0,
                    iconSize: 26.r,
                    elevation: 0,
                    enableFeedback: false,
                    items: List.generate(iconList.length, (index) {
                      return BottomNavigationBarItem(
                        icon: navProvider.selectedIndex == index
                            ? SizedBox(height: 26.r, width: 26.r)
                            : Icon(iconList[index]),
                        label: '',
                      );
                    }),
                  ),
                ),
              ),
            ),
            
            // Break-out active tab with separate icon and label animations
            Positioned(
              bottom: 15.h,
              left: _getActiveTabPosition(navProvider.selectedIndex, context),
              child: AnimatedBuilder(
                animation: navProvider.floatController ?? const AlwaysStoppedAnimation(1.0),
                builder: (context, child) {
                  final floatValue = navProvider.floatController?.value ?? 1.0;
                  
                  return GestureDetector(
                    onTap: () {
                      // Always restart animation on tap
                      navProvider.floatController?.reset();
                      navProvider.floatController?.forward();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon with float-up animation (stays up when selected)
                        Transform.translate(
                          offset: Offset(0, -floatValue * 15.h), // Icon floats upward
                          child: Container(
                            width: 81.w,
                            height: 55.h,
                            decoration: BoxDecoration(
                              color: AppColors.buttonclr,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              iconList[navProvider.selectedIndex],
                              size: 26.r,
                              color: AppColors.bgclr,
                            ),
                          ),
                        ),
                        SizedBox(height: 18.h), // Increased spacing
                        // Label always visible for selected tab
                        Container(
                          key: ValueKey(navProvider.selectedIndex),
                          constraints: BoxConstraints(maxWidth: 81.w),
                          child: Text(
                            titles[navProvider.selectedIndex],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  double _getActiveTabPosition(int selectedIndex, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabWidth = screenWidth / iconList.length;
    final centerPosition = (selectedIndex * tabWidth) + (tabWidth / 2);
    return centerPosition - (81.w / 2);
  }
}
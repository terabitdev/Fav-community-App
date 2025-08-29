import 'package:fava/core/constants/assets.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:flutter/widgets.dart';

class RequestTypeData {
  final String title;
  final String icon;
  final Color backgroundColor;
  final Color color;

  const RequestTypeData({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.color,
  });
}

class Helpers {
  static List<RequestTypeData> getRequestTypes() {
    return [
      RequestTypeData(
        title: 'Ride',
        icon: AppAssets.ride,
        backgroundColor: const Color.fromRGBO(233, 246, 247, 1),
        color: AppColors.rideClr,
      ),
      RequestTypeData(
        title: 'Errand',
        icon: AppAssets.errand,
        backgroundColor: const Color.fromRGBO(255, 221, 215, 1),
        color: AppColors.errandClr,
      ),
      RequestTypeData(
        title: 'Favor',
        icon: AppAssets.favor,
        backgroundColor: const Color.fromRGBO(250, 255, 215, 1),
        color: AppColors.favorClr,
      ),
      RequestTypeData(
        title: 'Others',
        icon: AppAssets.others,
        backgroundColor: const Color.fromRGBO(229, 229, 229, 1),
        color: AppColors.othersClr,
      ),
      RequestTypeData(
        title: 'Send Directly',
        icon: AppAssets.sendDirectly,
        backgroundColor: const Color.fromRGBO(252, 230, 255, 1),
        color: AppColors.othersClr,
      ),
    ];
  }

  static getRequestBgColor(String requestType) {
    switch (requestType.toLowerCase()) {
      case "errand":
        return Color.fromRGBO(255, 221, 215, 1);
      case "favor":
        return Color.fromRGBO(250, 255, 215, 1);
      case "ride":
        return Color.fromRGBO(233, 246, 247, 1);
      case "others":
        return Color.fromRGBO(229, 229, 229, 1); 
      default:
        return Color.fromRGBO(252, 230, 255, 1);
    }
  }

  static getRequestColor(String requestType) {
    switch (requestType.toLowerCase()) {
      case "errand":
        return AppColors.errandClr;
      case "favor":
        return AppColors.favorClr;
      case "ride":
        return AppColors.rideClr;
      default:
        return AppColors.othersClr; // fallback
    }
  }
}
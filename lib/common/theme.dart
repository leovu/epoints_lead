import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const subColor = Color(0xFF334155);
  static const primaryColor = Color(0xFF3398DC);
  static const primaryColorMix = Color(0xFFE1F0FA);
  static const primaryDarkColor = Color(0xFF1F7BBF);
  static const primaryLightColor = Color(0xFF9CCFF0);
  static const secondaryColor = Color(0xFF1A6497);
  static const secondaryColorMix = Color(0xFFD3E8F7);
  static const surfaceColor = Color(0xFFF2F7FB);
  static const tertiaryColor = Color(0xFFFF9F0A);
  static const successColor = Color(0xFF34C759);
  static const warningColor = Color(0xFFFFB020);
  static const dangerColor = Color(0xFFFF3B30);
  static const textTitleColor = Color(0xFF1E293B);
  static const textStrongColor = Color(0xFF334155);
  static const textBodyColor = Color(0xFF475569);
  static const textSecondaryColor = Color(0xFF64748B);
  static const textMutedColor = Color(0xFF94A3B8);
  static const primary50Color = Color(0xFFE1F0FA);
  static const white = Color(0xFFFFFFFF);
  static const white50 = Color(0xFFFAFAFA);
  static const black = Color(0xFF000000);
  static const lightGrey = Color(0xFFF2F7FB);
  static const grey600 = Color(0xFF64748B);
  static const dark = Color(0xFF1E293B);
  static const grey200 = Color(0xFFD8D8D8);
  static const lineColor = Color(0xFFE1F0FA);
  static const greenLightColor = Color(0xFFE5FAE6);
  static const greenBorderColor = Color(0xFFC1F0C1);
  static const greenLeadColor = Color(0xFF0BC50B);
  static const paginationColor = Color(0xFFE1F0FA);
  static const tabActiveColor = Color(0xFF1E293B);
  static const tabInActiveColor = Color(0xFF64748B);
  static const promotionColor = Color(0xFFF3F4F6);
  static const iconInActiveColor = Color(0xFF64748B);
  static const black50Color = Color(0xFF1E293B);
  static const colorLine = Color(0xFFE1F0FA);
  static const colorLineImage = Color(0xFFE1F0FA);
  static const headerColorBackground = Color(0xFF3398DC);
  static const headerColorLinearTop = Color(0xFFE3F0FA);
  static const headerColorLinearBottom = Color(0xFFF2F7FB);
  static const colorSelectedService = Color(0xFFE1F0FA);
  static const colorUnSelectedService = Color(0xFFF2F7FB);
  static const colorBorderUnSelectedService = Color(0xFFE1F0FA);
  static const redColor = Color(0xFFE22119);
  static const colorRed = Color(0xFFFF0000);
  static const greenColor = Color(0xFF11B482);
  static const orangeColorGradientTop = Color(0xFF5FAEE3);
  static const orangeColorGradientBottom = Color(0xFFE1F0FA);
  static const lineCardColor = Color(0xFFE1F0FA);
  static const blueColor = Color(0xFF2F80ED);
  static const colorBlue = Color(0xFF276EDF);
  static const grey500Color = Color(0xFF94A3B8);
  static const grey700Color = Color(0xFFD3E8F7);
  static const grey600Color = Color(0xFFBEC0C7);
  static const grey300Color = Color(0xFFF9F9F9);
  static const grey200Color = Color(0xFFF4F4F4);
  static const greyF8Color = Color(0xFFF8F8F8);
  static const redAccColor = Color(0xFFFF8F8F);
  static const blueAccColor = Color(0xFF75AEFF);
  static const colorIconVersion = Color(0xFF475569);
  static const colorBgTextField = Color(0xFFF2F7FB);
  static const colorBgBank = Color(0xFFF8F9FB);
  static const shadowColor = Color(0xFFC6C6C6);
  static const colorGreen = Color(0xFF30D78B);
  static const colorGreen50 = Color(0xFFEFFFF8);
  static const colorOrange50 = Color(0xFFE1F0FA);
  static const lineBlueColor = Color(0xFFE1F0FA);
  static const lineTabInactiveColor = Color(0xFFE1F0FA);
  static const lineBoardColor = Color(0xFFE1F0FA);
  static const lineBorderColor = Color(0xFFD3E8F7);
  static const grayBackGround = Color(0xFFE5E5E5);
  static const brown = Color(0xFFC59A70);

  static const backgroundNotification = Color(0xFFECF4FF);
  static const grey34 = Color(0xFFF3F4F7);
  static const colorTabUnselected = Color(0xFF64748B);
  static const editColor = Color(0xFFADB2BD);

  static const bluePrimary = Color(0xFF2F9AF4);
  static const primaryUnselect = Color(0xFFD3E8F7);
  static const filterSelectedColor = Color(0xFFE1F0FA);
  static const backgroundRed = Color(0xFFFFF8F8);
  static const green = Color(0xFF4CD964);
  static const backgroundGrey = Color(0xFFF2F7FB);
  static const darkGrey = Color(0xFFD3E8F7);
  static const ash = Color(0xFF64748B);
  static const colorDot = Color(0xFF94A3B8);
  static const disableColor = Color(0xFFDADADA);
  static const hintColor = Color(0xFF94A3B8);
  static const borderColor = Color(0xFFE1F0FA);
  static const grey50Color = Color(0xFFF6F6F6);
    static const primaryColorButton = RadialGradient(
      center: Alignment.centerRight,
      radius: 0.75,
      colors: <Color>[
        AppColors.primaryColor,
        AppColors.primaryGradiantColor,
      ],
      tileMode: TileMode.clamp);
  static const primaryColorReport = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.1, 0.45, 0.9],
      colors: <Color>[
        AppColors.primaryColor,
        AppColors.primaryGradiantColor,
        AppColors.white,
      ],
      tileMode: TileMode.clamp);
  static const primaryGradiantColor = Color(0xFF5FAEE3);
}

class AppFonts {
  static const font = "Inter";
}

// class AppSizes {
//   static double maxWidth;
//   static double maxHeight;
//   static double ultraPadding;
//   static double maxPadding;
//   static double minPadding;
//   static double sizeOnTap;
//   static double statusBarHeight;
//   static double bottomHeight;
//   static double sizeAppBar;
//   static double screenHeight;
//   static double border2;
//   static double border5;
//   static double border4;
//   static double border8;
//   static double border10;
//   static double border15;
//   static double border16;
//   static double border18;
//   static double border24;
//   static double titleImageSize;
//   static double iconSize;
//   static double dotSize;
//   static double loadmoreHeight;
//   static int maximumNumber;
//   static double smallButton;
//   static double totalMax;
//   static double heightLoadMore = 40.0;
//   static double double22 = 22.0;
//   static double avatarSize;

//   static double tabBarHeight;

//   static init(BuildContext context) {
//     maxWidth = MediaQuery.of(context).size.width;
//     maxHeight = MediaQuery.of(context).size.height;
//     statusBarHeight = MediaQuery.of(context).padding.top;
//     bottomHeight = MediaQuery.of(context).padding.bottom;
//     if (AppSizes.isLargeScreen(context)) {
//       maxPadding = 20.0;
//       minPadding = 15.0;
//       maxWidth = AppSizeWebConfig.maxWidthWeb;
//       // maxHeight = 926;
//       avatarSize = maxWidth / 6;
//     } else {
//       maxPadding = maxWidth * 0.05;
//       minPadding = maxPadding / 2;
//       avatarSize = maxWidth / 4;
//     }
//     ultraPadding = maxWidth * 0.1;
//     sizeOnTap = 48.0;
//     sizeAppBar = statusBarHeight + kToolbarHeight;
//     screenHeight = maxHeight - statusBarHeight;
//     border2 = 2.0;
//     border5 = 5.0;
//     border4 = 4.0;
//     border8 = 8.0;
//     border10 = 10.0;
//     border15 = 15.0;
//     border16 = 16.0;
//     border18 = 18.0;
//     border24 = 24.0;
//     titleImageSize = 20.0;
//     tabBarHeight = 46.0;
//     iconSize = 24.0;
//     dotSize = 4.0;
//     loadmoreHeight = 40.0;
//     maximumNumber = 9999999;
//     smallButton = 25.0;
//     totalMax = 9999999999999.0;
//     heightLoadMore = 40.0 + maxPadding;
//   }

//   static bool isSmallScreen(BuildContext context) {
//     return MediaQuery.of(context).size.width < 800;
//   }

//   static bool isLargeScreen(BuildContext context) {
//     return MediaQuery.of(context).size.width > 800;
//   }

// static bool isMediumScreen(BuildContext context) {
//   return MediaQuery.of(context).size.width >= 800 &&
//       MediaQuery.of(context).size.width <= 1200;
// }
// }

class AppKeys {
  static const String keyHUD = "HUD";
  static const String keyLanguage = "LANGUAGE";
}

class AppTextSizes {
  // static double size7 = 7.0;
  static double size8 = 8.0;
  static double size10 = 10.0;
  static double size11 = 11.0;
  static double size12 = 12.0;
  static double size13 = 13.0;
  static double size14 = 14.0;
  static double size15 = 15.0;
  static double size16 = 16.0;
  static double size17 = 17.0;
  static double size18 = 18.0;
  static double size20 = 20.0;
  static double size22 = 22.0;
  static double size24 = 24.0;
  static double size25 = 25.0;
  static double size28 = 28.0;
  static double size30 = 30.0;
  static double size36 = 36.0;
}

class AppTextStyles {
  static TextStyle style14HintNormalItalic = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.hintColor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic);
  static TextStyle style13BlackBold = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.bold);
  static TextStyle style12PrimaryBold = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold);
   static TextStyle style20BlackBold = TextStyle(
      fontSize: AppTextSizes.size20,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.bold);
    static TextStyle style14BlackNormal = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.normal);
  static TextStyle style13WhiteNormal = TextStyle(
      fontSize: AppTextSizes.size13,
      color: Colors.white,
      fontWeight: FontWeight.normal);
  static TextStyle style14HintNormal = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.hintColor,
      fontWeight: FontWeight.normal);
   static TextStyle style14PrimaryRegular = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.normal);
  static TextStyle style14WhiteNormal = TextStyle(
      fontSize: AppTextSizes.size14,
      color: Colors.white,
      fontWeight: FontWeight.normal);
    static TextStyle style20WhiteBold = TextStyle(
      fontSize: AppTextSizes.size20,
      color: Colors.white,
      fontWeight: FontWeight.bold);
  static TextStyle style12BlackBold = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.bold);
  static TextStyle style12grey200Normal = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.grey200Color,
      fontWeight: FontWeight.normal);
   static TextStyle style14PrimaryBold = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold);
  static TextStyle style12grey500Bold = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.grey500Color,
      fontWeight: FontWeight.bold);
  static TextStyle style12grey500Normal = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.grey500Color,
      fontWeight: FontWeight.normal);
  static TextStyle style16PrimaryBold = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold);
  static TextStyle style15WhiteBold = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.white,
      fontWeight: FontWeight.bold);
  static TextStyle style12WhiteWeight700Italic = TextStyle(
    fontSize: AppTextSizes.size12,
    color: AppColors.white,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,);
  static TextStyle style10WhiteWeight700Italic = TextStyle(
    fontSize: AppTextSizes.size10,
    color: AppColors.white,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,);
  static TextStyle style18WhiteBoldItalic = TextStyle(
    fontSize: AppTextSizes.size18,
    color: AppColors.white,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,);
  static TextStyle style20WhiteWeight700= TextStyle(
    fontSize: AppTextSizes.size20,
    color: AppColors.white,
    fontWeight: FontWeight.w700);
  static TextStyle style20BlackWeight400= TextStyle(
      fontSize: AppTextSizes.size20,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w400);
  static TextStyle style36BlackNormal = TextStyle(
      fontSize: AppTextSizes.size36,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.normal);
  static TextStyle style25WhiteWeight800Italic = TextStyle(
    fontSize: AppTextSizes.size25,
    color: AppColors.white,
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.italic,);

  static TextStyle style25BlackWeight700 = TextStyle(
      fontSize: AppTextSizes.size25,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w700);
  static TextStyle style24BlackBold = TextStyle(
      fontSize: AppTextSizes.size24,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.bold);
  static TextStyle style22BlackBold = TextStyle(
      fontSize: AppTextSizes.size22,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.bold);
  static TextStyle style16BlackBold = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.bold);
  static TextStyle style18BlackBold = TextStyle(
      fontSize: AppTextSizes.size18,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.bold);
  static TextStyle style18PrimaryBold = TextStyle(
      fontSize: AppTextSizes.size18,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.bold);
  static TextStyle style17WhiteNormal = TextStyle(
      fontSize: AppTextSizes.size17,
      color: AppColors.white,
      fontWeight: FontWeight.normal);
  static TextStyle style15PrimaryNormal = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.normal);
  static TextStyle style15WhiteNormal = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.white,
      fontWeight: FontWeight.normal);
  static TextStyle style15BlackNormal = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.normal);
  static TextStyle style15BlackBold = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.bold);
  static TextStyle style15Grey600Normal = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.grey600,
      fontWeight: FontWeight.normal);
  static TextStyle style15Red600Normal = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.redColor,
      fontWeight: FontWeight.normal);
  static TextStyle style12Grey600Normal = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.grey600,
      fontWeight: FontWeight.normal);
  static TextStyle style12Green600Normal = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.green,
      fontWeight: FontWeight.normal);
  static TextStyle style12RedNormal = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.redColor,
      fontWeight: FontWeight.normal);
  static TextStyle style12BlackW400 = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w400);
  static TextStyle style11BlackW700 = TextStyle(
      fontSize: AppTextSizes.size11,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w700);
  static TextStyle style12PrimaryW400 = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w400);
  static TextStyle style12WhiteNormal = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.white,
      fontWeight: FontWeight.normal);
  static TextStyle style12PrimaryWeight600 = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w600);
  static TextStyle style14WhiteWeight700Italic = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.white,
      fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,);
  static TextStyle style14Black50Weight400 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.black50Color,
      fontWeight: FontWeight.w400);
  static TextStyle style14BlueUnderlineWeight400 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.blueColor,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w400);
  static TextStyle style14WhiteWeight600 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.white,
      fontWeight: FontWeight.w600);
  static TextStyle style14WhiteWeight400 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.white,
      fontWeight: FontWeight.w400);
  static TextStyle style14Grey500Weight400 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.grey500Color,
      fontWeight: FontWeight.w400);
      static TextStyle style18LeadGreyBold = TextStyle(
      fontSize: AppTextSizes.size18,
      color: AppColors.colorTabUnselected,
      fontWeight: FontWeight.bold);
  static TextStyle style14reyTabWeight400 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.tabInActiveColor,
      fontWeight: FontWeight.w400);
  static TextStyle style14PrimaryWeight600 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w600);
  static TextStyle style14PrimaryWeight400 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w400);
  static TextStyle style14BlueWeight500 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.bluePrimary,
      fontWeight: FontWeight.w500);
      static TextStyle style16BlueWeight500 = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.bluePrimary,
      fontWeight: FontWeight.w500);
      static TextStyle style18BlueBold = TextStyle(
      fontSize: AppTextSizes.size18,
      color: AppColors.blueColor,
      fontWeight: FontWeight.bold);
  static TextStyle style14BlackWeight600 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w600);
  static TextStyle style14BlackWeight500 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w500);
  static TextStyle style14BlackWeight400 = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w400);
  static TextStyle style14BlackBold = TextStyle(
      fontSize: AppTextSizes.size14,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.bold);
  static TextStyle style13BlackWeight400 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w400);
  static TextStyle style13BlackWeight500 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w500);
  static TextStyle style13BlackWeight600 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w600);
  static TextStyle style13BlackWeight700 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w700);
  static TextStyle style13RedWeight700 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.redColor,
      fontWeight: FontWeight.w700);
  static TextStyle style13RedWeight400 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.redColor,
      fontWeight: FontWeight.w400);
  static TextStyle style13Weight400 =
      TextStyle(fontSize: AppTextSizes.size13, fontWeight: FontWeight.w400);
  static TextStyle style13GrayWeight400 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.tabInActiveColor,
      fontWeight: FontWeight.w400);
  static TextStyle style13GreenWeight400 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.green,
      fontWeight: FontWeight.w400);
  static TextStyle style13PrimaryWeight400 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w400);
  static TextStyle style13WhiteWeight400 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.white,
      fontWeight: FontWeight.w400);
  static TextStyle style13GreenWeight500 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.greenColor,
      fontWeight: FontWeight.w500);
  static TextStyle style13BlueWeight400 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.bluePrimary,
      fontWeight: FontWeight.w400);
  static TextStyle style13BlueWeight500 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.bluePrimary,
      fontWeight: FontWeight.w500);
  static TextStyle style13BluePrimaryWeight600 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.bluePrimary,
      fontWeight: FontWeight.w600);
  static TextStyle style13BluePrimaryWeight400 = TextStyle(
      fontSize: AppTextSizes.size13,
      color: AppColors.bluePrimary,
      fontWeight: FontWeight.w400);
  static TextStyle style12DartColorWeight500 = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.dark,
      fontWeight: FontWeight.w500);
  static TextStyle style12DartColorWeight400 = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.dark,
      fontWeight: FontWeight.w400);
  static TextStyle style12Grey500ColorWeight400 = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.grey500Color,
      fontWeight: FontWeight.w400);
  static TextStyle style11Grey500ColorWeight400 = TextStyle(
      fontSize: AppTextSizes.size11,
      color: AppColors.grey500Color,
      fontWeight: FontWeight.w400);
  static TextStyle style11WhiteWeight500 = TextStyle(
      fontSize: AppTextSizes.size11,
      color: AppColors.white,
      fontWeight: FontWeight.w500);
  static TextStyle style11WhiteNormal = TextStyle(
      fontSize: AppTextSizes.size11,
      color: AppColors.white,
      fontWeight: FontWeight.normal);
  static TextStyle style16BlackWeight700 = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w700);
  static TextStyle style16BlackWeight500 = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w500);
  static TextStyle style16BlackWeight600 = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w600);
  static TextStyle style16WhiteBold = TextStyle(
      fontSize: AppTextSizes.size16,
      color: AppColors.white,
      fontWeight: FontWeight.bold);
  static TextStyle style10WhiteBold = TextStyle(
      fontSize: AppTextSizes.size10,
      color: AppColors.white,
      fontWeight: FontWeight.bold);
  static TextStyle style12BlackWeight500 = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w500);
  static TextStyle style12BlackWeight400 = TextStyle(
      fontSize: AppTextSizes.size12,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w400);
  static TextStyle style15BlackWeight700 = TextStyle(
      fontSize: AppTextSizes.size15,
      color: AppColors.textTitleColor,
      fontWeight: FontWeight.w700);
}

class AppAnimation {
  static Duration duration = Duration(milliseconds: 500);
  static Curve curve = Curves.fastOutSlowIn;
}

class AppSizes {
  static double? maxWidth;
  static late double maxHeight;
  static double? ultraPadding;
  static double maxPadding = 0.0;
  static double minPadding = 0.0;
  static double? sizeOnTap;
  static double? sizeOnTapCheckIn;
  static late double statusBarHeight;
  static double? bottomHeight;
  static double? sizeAppBar;
  static double? screenHeight;
  static double? iconSize;
  static double? lineSize;
  static double? paddingSearch;
  static const timelineHeight = 80.0;
  static const timeWidth = 30.0;
  static const totalTimeline = 48;
  static const totalMinuteOfTimeline = 30;

  static init(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).padding.top;
    bottomHeight = MediaQuery.of(context).padding.bottom;
    ultraPadding = maxWidth! * 0.1;
    sizeOnTapCheckIn = 64;
    sizeOnTap = 40.0;
    maxPadding = sizeOnTap! / 2;
    minPadding = maxPadding / 2;
    sizeAppBar = statusBarHeight + kToolbarHeight;
    screenHeight = maxHeight - statusBarHeight;
    iconSize = 24;
    lineSize = 0.5;
    paddingSearch = 57;
  }
}



class AppFormat {
  static DateFormat formatDate = DateFormat("dd/MM/yyyy");
  static DateFormat formatDateResponse = DateFormat("yyyy-MM-dd");
  static DateFormat formatDate1Response = DateFormat("dd-MM-yyyy");
  static DateFormat formatDateTimeResponse = DateFormat("yyyy-MM-dd HH:mm:ss");
  static DateFormat formatDateTime1Request = DateFormat("dd/MM/yyyy HH:mm:ss");
  static DateFormat formatDateTime = DateFormat("dd/MM/yyyy HH:mm");
  static DateFormat formatDateMonth = DateFormat("dd/MM");
  static DateFormat formatTime = DateFormat("HH:mm");
  static NumberFormat moneyFormatDot = NumberFormat("#,###", "vi-VN");
  static NumberFormat moneyFormat = NumberFormat("#,###");
  static DateFormat formatDateTimeEn = DateFormat("dd MMMM, yyyy", "en_US");
  static DateFormat formatDateTimeVn = DateFormat("dd MMMM, yyyy", "vi_VN");
  static DateFormat formatHHMMDateTimeEn =
      DateFormat("HH:mm - dd MMMM, yyyy", "en_US");
  static DateFormat formatHHMMDateTimeVn =
      DateFormat("HH:mm - dd MMMM, yyyy", "vi_VN");
  static String formatNonSale = "d2d-nonsale/{instanceVer}";
}
class AppSizeWebConfig {
  static const maxWidthWeb = 500.0;
  static const maxHeightWeb =  926.0;
}

class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double card = 16;
  static const double sheet = 26;
  static const double pill = 100;
}

class AppGlass {
  static const double radius = AppRadius.card;

  static const double sheetRadius = AppRadius.sheet;

  static const Color accentColor = AppColors.primaryGradiantColor;

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.primaryColor, AppColors.primaryGradiantColor],
  );

  static const LinearGradient activeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primaryGradiantColor, AppColors.primaryColor],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE3F0FA), AppColors.surfaceColor, Color(0xFFEDF3F8)],
    stops: [0.0, 0.45, 1.0],
  );

  static const RoundedRectangleBorder headerShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(AppRadius.card),
      bottomRight: Radius.circular(AppRadius.card),
    ),
  );

  static Color get surface => Colors.white.withValues(alpha: 0.72);

  static Color get surfaceLight => Colors.white.withValues(alpha: 0.55);

  static Color get borderColor => Colors.white.withValues(alpha: 0.9);

  static Color get dividerColor => AppColors.primaryColorMix;

  static Color get headerIconBackground => Colors.white.withValues(alpha: 0.18);

  static List<BoxShadow> get shadow => [
        BoxShadow(
          offset: Offset(0.0, 8.0),
          blurRadius: 22.0,
          spreadRadius: -4.0,
          color: AppColors.primaryDarkColor.withValues(alpha: 0.12),
        ),
        BoxShadow(
          offset: Offset(0.0, 1.0),
          blurRadius: 3.0,
          color: Color(0xFF0F172A).withValues(alpha: 0.04),
        ),
      ];

  static List<BoxShadow> get shadowPressed => [
        BoxShadow(
          offset: Offset(0.0, 3.0),
          blurRadius: 10.0,
          spreadRadius: -2.0,
          color: AppColors.primaryDarkColor.withValues(alpha: 0.16),
        ),
      ];

  static List<BoxShadow> get headerShadow => [
        BoxShadow(
          offset: Offset(0.0, 4.0),
          blurRadius: 12.0,
          color: AppColors.primaryColor.withValues(alpha: 0.2),
        ),
      ];

  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          offset: Offset(0.0, 4.0),
          blurRadius: 12.0,
          color: AppColors.primaryColor.withValues(alpha: 0.25),
        ),
      ];

  static LinearGradient get cardGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.92),
          Color.lerp(
            Colors.white,
            AppColors.primaryColor,
            0.05,
          )!
              .withValues(alpha: 0.74),
        ],
      );

  static LinearGradient get sheetGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFDFEFF),
          Color.lerp(Colors.white, AppColors.primaryColor, 0.03)!,
          AppColors.surfaceColor,
        ],
        stops: [0.0, 0.3, 1.0],
      );

  static BoxDecoration card({double radius = AppGlass.radius, Color? color}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: color != null ? null : cardGradient,
      color: color,
      border: Border.all(color: borderColor, width: 1.0),
      boxShadow: shadow,
    );
  }

  static BoxDecoration tile({double radius = AppRadius.md, Color? color}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: color ?? surfaceLight,
      border: Border.all(color: borderColor, width: 1.0),
    );
  }

  static BoxDecoration pill({Color? color, Color? border}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      color: color ?? surface,
      border: Border.all(color: border ?? borderColor, width: 1.0),
    );
  }

  static BoxDecoration input({
    double radius = AppRadius.md,
    Color? color,
    Color? border,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: color ?? surface,
      border: Border.all(color: border ?? borderColor, width: 1.0),
    );
  }

  static BoxDecoration header() {
    return BoxDecoration(
      gradient: headerGradient,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(AppRadius.card),
        bottomRight: Radius.circular(AppRadius.card),
      ),
      boxShadow: headerShadow,
    );
  }

  static BoxDecoration primaryButton({double radius = AppRadius.md}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: activeGradient,
      boxShadow: buttonShadow,
    );
  }

  static BoxDecoration secondaryButton({double radius = AppRadius.md}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: surface,
      border: Border.all(
        color: AppColors.primaryColor.withValues(alpha: 0.4),
        width: 1.0,
      ),
    );
  }

  static BoxDecoration sheet() {
    return BoxDecoration(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppGlass.sheetRadius),
      ),
      gradient: sheetGradient,
      border: Border(top: BorderSide(color: Colors.white, width: 1.5)),
      boxShadow: [
        BoxShadow(
          offset: Offset(0.0, -6.0),
          blurRadius: 28.0,
          color: AppColors.primaryDarkColor.withValues(alpha: 0.14),
        ),
      ],
    );
  }

  static BoxDecoration dialog() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.card),
      gradient: sheetGradient,
      border: Border.all(color: borderColor, width: 1.0),
      boxShadow: shadow,
    );
  }

  static InputBorder inputBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color ?? borderColor, width: 1.0),
    );
  }

  static Widget background({required Widget child}) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: backgroundGradient),
      child: child,
    );
  }

  static Widget grabber() {
    return Container(
      width: 38.0,
      height: 5.0,
      decoration: BoxDecoration(
        color: AppColors.primaryDarkColor.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    );
  }

  static bool reduceMotion(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  static bool reduceTransparency(BuildContext context) =>
      MediaQuery.maybeHighContrastOf(context) ?? false;
}


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:lead_plugin_epoint/common/assets.dart';
// import 'package:lead_plugin_epoint/common/theme.dart';
// import 'package:lead_plugin_epoint/widget/custom_container_project_item.dart';
// import 'package:lead_plugin_epoint/widget/custom_drop_down.dart';
// import 'package:lead_plugin_epoint/widget/custom_error_message.dart';
// import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';
// import 'package:lead_plugin_epoint/widget/custom_textfield.dart';

// class CustomItemInformation extends StatelessWidget {
//   final String title;
//   final String hintText;
//   final TextSelectionControls selectionControls;
//   final TextEditingController controller;
//   final FocusNode currentNode;
//   final bool onFocus;
//   final String richTextTitle;
//   final bool isRequired;
//   final bool isDropList;
//   final bool isDropListCustomer;
//   final bool isError;
//   final Function onSuffixIconTap;
//   final double suffixSize;
//   final Color suffixIconColor;
//   final Function(String) onChanged;
//   final Function(String) onSubmitted;
//   final List<TextInputFormatter> inputFormatters;
//   final TextInputType keyboardType;
//   final int maxLines;
//   final String errorMessage;
//   final bool isPhone;
//   final String errorString;
//   final String suffixIcon;
//   final bool readOnly;
//   final Function onTap;
//   final bool isDisable;
//   final TextOverflow overflow;

//   const CustomItemInformation(this.title, this.hintText,
//       {this.controller,
//       this.currentNode,
//       this.onFocus = false,
//       this.isRequired = true,
//       this.isDropList = true,
//       this.onSuffixIconTap,
//       this.onChanged,
//       this.richTextTitle,
//       this.isError = false,
//       this.maxLines = 1,
//       this.inputFormatters,
//       this.keyboardType,
//       this.errorMessage,
//       this.isPhone = false,
//       this.errorString,
//       this.suffixIcon,
//       this.readOnly = false,
//       this.onTap,
//       this.isDisable = false,
//       this.isDropListCustomer = false,
//       this.onSubmitted,
//       this.suffixSize = 12,
//       this.suffixIconColor, this.selectionControls,
//       this.overflow});
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (title != null)
//           if (richTextTitle != null)
//             Row(
//               children: [
//                 Flexible(
//                     fit: FlexFit.loose,
//                     child: RichText(
//                       text: TextSpan(
//                           text: isRequired
//                               ? ((title ?? "") + " *")
//                               : (title ?? ""),
//                           style: AppTextStyles.style13BlackWeight400.copyWith(
//                               fontWeight: (isDisable ?? false)
//                                   ? FontWeight.w400
//                                   : FontWeight.w600,
//                               color: (isDisable ?? false)
//                                   ? AppColors.grey600Color
//                                   : (isError
//                                       ? AppColors.colorRed
//                                       : AppColors.black)),
//                           children: [
//                             TextSpan(
//                               text: " " + richTextTitle,
//                               style: AppTextStyles.style13PrimaryWeight400
//                                   .copyWith(fontWeight: FontWeight.w500),
//                             ),
//                           ]),
//                     )),
//                 if (isError)
//                   Container(
//                     child: CustomImageIcon(
//                       icon: Assets.iconError,
//                       color: AppColors.colorRed,
//                       size: 15.0,
//                     ),
//                     margin: EdgeInsets.only(left: AppSizes.minPadding / 2),
//                   ),
//               ],
//             )
//           else
//             CustomTitleProjectItem(
//               title: isRequired ? ((title ?? "") + " *") : (title ?? ""),
//               childError: isError
//                   ? Container(
//                       // ignore: sort_child_properties_last
//                       child: CustomImageIcon(
//                         icon: Assets.iconError,
//                         color: AppColors.colorRed,
//                         size: 15.0,
//                       ),
//                       margin: EdgeInsets.only(left: AppSizes.minPadding / 2),
//                     )
//                   : null,
//               titleStyle: AppTextStyles.style13BlackWeight400.copyWith(
//                   fontWeight:
//                       (isDisable ?? false) ? FontWeight.w400 : FontWeight.w600,
//                   color: (isDisable ?? false)
//                       ? AppColors.grey600Color
//                       : (isError ? AppColors.colorRed : AppColors.black)),
//             ),
//         Container(
//           height: AppSizes.minPadding,
//         ),
//         if (isDropListCustomer)
//           CustomDropDown(
//             hintText: controller != null
//                 ? ((controller.text.trim().isEmpty)
//                     ? hintText
//                     : controller.text)
//                 : hintText,
//             backgroundColor: AppColors.colorBgTextField,
//             suffixIcon: Assets.iconDropDown,
//             hintStyle: (isDisable ?? false)
//                 ? AppTextStyles.style13GrayWeight400.copyWith(
//                     fontWeight: FontWeight.normal,
//                     color: AppColors.grey600Color)
//                 : null,
//             suffixSize: suffixSize ?? 12.0,
//             suffixIconColor: (isDisable ?? false)
//                 ? AppColors.grey600Color
//                 : (suffixIconColor ?? AppColors.tabInActiveColor),
//             onTap: (isDisable ?? false)
//                 ? null
//                 : (isDropList ? onSuffixIconTap : onTap),
//             overflow: overflow,
//           )
//         else
//           CustomTextField(
//             isPhone: isPhone,
//             hintText: hintText,
//             controller: controller,selectionControls: selectionControls,
//             focusNode: currentNode,
//             onTap: (isDisable ?? false)
//                 ? null
//                 : (isDropList ? onSuffixIconTap : onTap),
//             enableBorder: onFocus,
//             suffixIcon: isDropList ? Assets.iconDropDown : suffixIcon,
//             suffixIconColor: (isDisable ?? false)
//                 ? AppColors.grey600Color
//                 : (suffixIconColor ?? AppColors.tabInActiveColor),
//             hintStyle: (isDisable ?? false)
//                 ? AppTextStyles.style13GrayWeight400.copyWith(
//                     fontWeight: FontWeight.normal,
//                     color: AppColors.grey600Color)
//                 : (isDropList ? AppTextStyles.style13BlackWeight400 : null),
//             onChanged: onChanged,
//             onSubmitted: onSubmitted,
//             obscureText: false,
//             readOnly: (controller == null || isDropList || (isDisable ?? false))
//                 ? true
//                 : readOnly,
//             inputFormatters: inputFormatters,
//             onSuffixIconTap: (isDisable ?? false)
//                 ? null
//                 : (isDropList ? onSuffixIconTap : onTap),
//             keyboardType: keyboardType ?? TextInputType.text,
//             backgroundColor: AppColors.colorBgTextField,
//             radius: 5.0,
//             maxLines: maxLines,
//             suffixSize: suffixSize ?? 12.0,

//           ),
//         if ((errorMessage ?? "") != "")
//           CustomErrorMessage(
//             icon: Assets.iconError,
//             text: errorMessage,
//             isCenter: false,
//           )
//         else
//           Container(
//             height: AppSizes.minPadding,
//           ),
//       ],
//     );
//   }
// }

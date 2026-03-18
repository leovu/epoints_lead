
part of widget;

class CustomColumnWidget extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final String? subTitle;
  final TextStyle? subTitleStyle;
  final bool? isRequired;
  final Widget child;
  final bool isCustomLine;
  final String? errorMessage;

  const CustomColumnWidget(
      {super.key,
      required this.title,
      required this.child,
      this.isRequired,
      this.titleColor,
      this.subTitle, this.isCustomLine = false, this.errorMessage, this.subTitleStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(TextSpan(
            text: title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: titleColor ?? AppColors.primaryColor),
            children: [
              if (subTitle != null)
                TextSpan(
                    text: " ($subTitle)",
                    style: subTitleStyle ?? TextStyle(color: AppColors.grey300Color)),
              if (isRequired != null && isRequired!)
                TextSpan(
                    text: "*",
                    style: TextStyle(color: AppColors.colorRed)),
              if (errorMessage != null && errorMessage != "")
                TextSpan(
                    text:"  $errorMessage",
                    style: TextStyle(color: AppColors.redColor,fontWeight: FontWeight.normal))
            ])),
        child,
        isCustomLine ? CustomLine(size: 1.0,) : Container()
      ],
    );
  }
}
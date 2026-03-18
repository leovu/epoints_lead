part of widget;

class CustomColumnIconInformation extends StatelessWidget {
  final String? icon;
  final String? title;
  final String? content;
  final Widget? child;
  final TextStyle? styleContent;
  final TextStyle? styleTile;
  final GestureTapCallback? onTap;

  CustomColumnIconInformation(
      {this.icon,
      this.title,
      this.content,
      this.child,
      this.styleContent,
      this.styleTile,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    double iconSize = 15.0;

    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                CustomImageIcon(
                  icon: icon,
                  size: iconSize,
                  color: AppColors.primaryColor,
                ),
                SizedBox(
                  width: AppSizes.minPadding,
                )
              ],
              Expanded(
                  child: Text(
                title ?? "",
                style: styleTile ?? AppTextStyles.style13BlackBold,
              ))
            ],
          ),
          Container(
            height: AppSizes.minPadding,
          ),
          child ??
              Text(
                (content ?? "").isNotEmpty
                    ? content!
                    : AppLocalizations.text(LangKey.data_empty)!,
                style: (content ?? "").isNotEmpty
                    ? styleContent ??
                        AppTextStyles.style14BlackNormal.copyWith(
                            color: onTap == null
                                ? AppColors.black
                                : AppColors.primaryColor,
                            decoration:
                                onTap == null ? null : TextDecoration.underline)
                    : AppTextStyles.style14HintNormalItalic,
              )
        ],
      ),
      onTap: (content ?? "").isNotEmpty ? onTap : null,
    );
  }
}
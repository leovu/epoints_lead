part of widget;

class CustomRowInformation extends StatelessWidget {
  final String? icon;
  final String? title;
  final Widget? titleWidget;
  final TextStyle? titleStyle;
  final String? content;
  final TextStyle? contentStyle;
  final Widget? child;
  final CrossAxisAlignment? alignment;

  CustomRowInformation({
    this.icon,
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.content,
    this.contentStyle,
    this.child,
    this.alignment,
  });

  final _iconSize = 16.0;

  Widget _buildSkeleton() {
    return CustomShimmer(
      child: Row(
        children: [
          CustomSkeleton(
            width: _iconSize,
            height: _iconSize,
            radius: _iconSize,
          ),
          Container(
            width: AppSizes.minPadding,
          ),
          CustomSkeleton(
            width: AppSizes.maxWidth! / 3,
          ),
          Container(
            width: AppSizes.minPadding,
          ),
          Expanded(
            child: CustomSkeleton(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (title == null && titleWidget == null) {
      return _buildSkeleton();
    }
    return Row(
      crossAxisAlignment: alignment ?? CrossAxisAlignment.center,
      children: [
        if (icon != null)
          Container(
            padding: EdgeInsets.only(
                right: AppSizes.minPadding,
                top: alignment == CrossAxisAlignment.start ? 2.0 : 0.0),
            child: CustomImageIcon(
              icon: icon,
              size: 16.0,
            ),
          ),
        if ((title ?? "").isNotEmpty || titleWidget != null)
          Container(
            width: AppSizes.maxWidth! * 0.5,
            padding: EdgeInsets.only(right: AppSizes.minPadding),
            child: titleWidget ??
                Text(
                  title ?? "",
                  style: titleStyle ?? AppTextStyles.style14BlackBold,
                ),
          ),
        Expanded(
          child: child ??
              Text(
                content ?? "",
                style: contentStyle ?? AppTextStyles.style14BlackNormal,
                textAlign: ((title ?? "").isNotEmpty || titleWidget != null)
                    ? TextAlign.right
                    : TextAlign.left,
              ),
        )
      ],
    );
  }
}
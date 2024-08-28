part of widget;

class CustomText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const CustomText(
      {super.key,
      this.text,
      this.fontSize,
      this.fontWeight,
      this.color,
      this.fontStyle,
      this.textAlign,
      this.maxLines,
      this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: TextStyle(
        fontSize: fontSize ?? AppTextSizes.size14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? AppColors.primaryColor,
        fontStyle: fontStyle ?? FontStyle.normal,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class CustomTextInput extends StatelessWidget {
  final String? text;
  final FontStyle? fontStyle;
  final Color? color;

  const CustomTextInput({super.key, this.text, this.fontStyle, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSizes.minPadding),
          child: CustomText(
            text: text,
            color: color ?? AppColors.black,
            fontStyle: fontStyle,
          ),
        ),
        SizedBox(
          height: 1.0,
        )
      ],
    );
  }
}

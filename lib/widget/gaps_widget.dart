part of widget;
class Gaps {
  static const Widget hGap2 = const SizedBox(width: 2);
  static const Widget hGap4 = const SizedBox(width: 4);
  static const Widget hGap6 = const SizedBox(width: 6);
  static const Widget hGap8 = const SizedBox(width: 8);
  static const Widget hGap10 = const SizedBox(width: 10);
  static const Widget hGap12 = const SizedBox(width: 12);
  static const Widget hGap15 = const SizedBox(width: 15);
  static const Widget hGap16 = const SizedBox(width: 16);
  static const Widget hGap18 = const SizedBox(width: 18);
  static const Widget hGap24 = const SizedBox(width: 24);
  static const Widget hGap32 = const SizedBox(width: 32);

  static const Widget vGap0 = const SizedBox(height: 0);
  static const Widget vGap2 = const SizedBox(height: 2);
  static const Widget vGap4 = const SizedBox(height: 4);
  static const Widget vGap5 = const SizedBox(height: 5);
  static const Widget vGap6 = const SizedBox(height: 6);
  static const Widget vGap8 = const SizedBox(height: 8);
  static const Widget vGap10 = const SizedBox(height: 10);
  static const Widget vGap11 = const SizedBox(height: 11);
  static const Widget vGap12 = const SizedBox(height: 12);
  static const Widget vGap15 = const SizedBox(height: 15);
  static const Widget vGap16 = const SizedBox(height: 16);
  static const Widget vGap20 = const SizedBox(height: 20);
  static const Widget vGap24 = const SizedBox(height: 24);
  static const Widget vGap26 = const SizedBox(height: 26);
  static const Widget vGap30 = const SizedBox(height: 30);
  static const Widget vGap32 = const SizedBox(height: 32);
  static const Widget vGap46 = const SizedBox(height: 46);
  static const Widget vGap50 = const SizedBox(height: 50);
  static const Widget vGap60 = const SizedBox(height: 60);
  static const Widget vGap80 = const SizedBox(height: 80);
  static const Widget vGap100 = const SizedBox(height: 100);
  static const Widget vGap120 = const SizedBox(height: 120);



  static SizedBox statusBarSize(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    return SizedBox(
      height: data.padding.top,
    );
  }

  static Widget listLine =  Divider(
    color: Colors.grey[300],
    height: 1.4,
    thickness: 1,
  );

  static Widget line(double size) {
    return Container(
      color: Colors.grey[300],
      height: size,
    );
  }

  static Widget dashLine = LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final boxWidth = constraints.constrainWidth();
      const dashWidth = 4.0;
      final dashHeight = 1.0;
      final dashCount = (boxWidth / (2 * dashWidth)).floor();
      return Flex(
        children: List.generate(dashCount, (_) {
          return SizedBox(
            width: dashWidth,
            height: dashHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(color: AppColors.borderColor),
            ),
          );
        }),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
      );
    },
  );

  static const Widget empty = const SizedBox.shrink();
}
part of widget;
class LoadingWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const LoadingWidget({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Shimmer.fromColors(
        baseColor: Color(0xffE9E9E9),
        highlightColor: Colors.white,
        enabled: true,
        child: child,
      ),
    );
  }
}
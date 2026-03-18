part of widget;

class CustomRotateTransaction extends StatefulWidget {
  final Widget? child;
  final bool? open;

  CustomRotateTransaction({this.child, this.open = false});

  @override
  CustomRotateTransactionState createState() => CustomRotateTransactionState();
}

class CustomRotateTransactionState extends State<CustomRotateTransaction>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        duration: AppAnimation.duration, vsync: this, upperBound: 0.35);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: AppAnimation.curve,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.open!) {
        _controller.forward();
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomRotateTransaction oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.open!) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: widget.child,
    );
  }
}

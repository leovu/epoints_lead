part of widget;

class CustomContainerList extends StatefulWidget {
  final Widget? child;
  final GestureTapCallback? onTap;

  const CustomContainerList({Key? key, this.child, this.onTap})
      : super(key: key);

  @override
  State<CustomContainerList> createState() => _CustomContainerListState();
}

class _CustomContainerListState extends State<CustomContainerList> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(AppGlass.radius);
    final bool reduceMotion = AppGlass.reduceMotion(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap == null ? null : (_) => _setPressed(true),
      onTapUp: widget.onTap == null ? null : (_) => _setPressed(false),
      onTapCancel: widget.onTap == null ? null : () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: reduceMotion
            ? Duration.zero
            : Duration(milliseconds: _pressed ? 110 : 320),
        curve: _pressed ? Curves.easeOut : Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: AppGlass.card().copyWith(
            boxShadow: _pressed ? AppGlass.shadowPressed : AppGlass.shadow,
          ),
          child: CustomPaint(
            foregroundPainter: _GlassRimPainter(radius: AppGlass.radius),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: Stack(
                children: [
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    top: 0.0,
                    height: 28.0,
                    child: IgnorePointer(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 160),
                        opacity: _pressed ? 0.5 : 1.0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(alpha: 0.7),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (widget.child != null) widget.child!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassRimPainter extends CustomPainter {
  final double radius;

  _GlassRimPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(0.5), Radius.circular(radius)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.95),
            Colors.white.withValues(alpha: 0.35),
            AppColors.primaryColor.withValues(alpha: 0.25),
            Colors.white.withValues(alpha: 0.7),
          ],
          stops: [0.0, 0.4, 0.7, 1.0],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_GlassRimPainter oldDelegate) =>
      oldDelegate.radius != radius;
}

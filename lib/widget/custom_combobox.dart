part of widget;
class CustomComboBox extends StatefulWidget {
  final String? icon;
  final String title;
  final Widget? child;
  final bool isExpand;
  final Function(bool)? onChanged;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapPlus;
  final GestureTapCallback? onTapList;
  final int quantity;
  final bool? isShowPlus;

  const CustomComboBox(
      {super.key,
      this.icon,
      required this.title,
      this.child,
      this.isExpand = true,
      this.onChanged,
      this.onTap,
      this.onTapPlus,
      this.onTapList,
      this.quantity = 0,
      this.isShowPlus = true});

  @override
  CustomComboBoxState createState() => CustomComboBoxState();
}

class CustomComboBoxState extends State<CustomComboBox> {
  late bool _expand;

  @override
  void initState() {
    super.initState();

    _expand = widget.isExpand;
  }

  @override
  void didUpdateWidget(covariant CustomComboBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_expand != widget.isExpand) {
      setState(() {
        _expand = widget.isExpand;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _buildHeader() {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: AppColors.grey200)),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.minPadding),
          child: Row(
            children: [
              if (widget.icon != null)
                CustomImageIcon(
                  icon: widget.icon,
                  color: AppColors.black,
                  size: 20.0,
                ),
              SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: AppTextSizes.size14,
                        fontWeight: (widget.child != null && _expand)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (widget.quantity > 0) ...[
                      SizedBox(width: 4),
                      Text(
                        "(${widget.quantity})",
                        style: TextStyle(
                            fontSize: AppTextSizes.size14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.bluePrimary),
                      )
                    ]
                  ],
                ),
              ),
              if (widget.child != null && widget.quantity > 0) ...[
                SizedBox(width: 16),
                CustomRotateTransaction(
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: AppColors.black,
                  ),
                  open: _expand,
                ),
                SizedBox(width: 16),
                InkWell(
                  child: CustomImageIcon(
                    icon: Assets.iconListRound,
                  ),
                  onTap: widget.onTapList,
                )
              ],
              if (widget.isShowPlus!) ...[
                SizedBox(width: 16),
                InkWell(
                  child: CustomImageIcon(
                    icon: Assets.iconPlusRound,
                  ),
                  onTap: widget.onTapPlus,
                )
              ]
            ],
          ),
        ),
      ),
      onTap: widget.onTap ??
          (widget.child == null || widget.quantity == 0
              ? null
              : () {
                print("${widget.title}, ${widget.quantity}, ${widget.isExpand}");
                  if (widget.onChanged != null) {
                    widget.onChanged!(!_expand);
                  } else {
                    setState(() {
                      _expand = !_expand;
                    });
                  }
                }),
    );
  }

  Widget _buildContent() {
    if (_expand == null) {
      return Container();
    }
    return CustomSizeTransaction(
      child: widget.child,
      open: _expand,
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(4.0)),
      child: Column(
        children: [_buildHeader(), if (widget.child != null) _buildContent()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
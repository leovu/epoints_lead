part of widget;

class CustomDropdown extends StatelessWidget {
  final List<CustomDropdownModel>? menus;
  final CustomDropdownModel? value;
  final Function(CustomDropdownModel?)? onChanged;
  final String? hint;
  final String? icon;
  final bool isText;
  final bool isHint;
  final bool showIcon;
  final IconData? suffixIcon;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onRemove;

  CustomDropdown(
      {this.icon,
      this.menus,
      this.value,
      this.onChanged,
      this.hint,
      this.isText = false,
      this.isHint = false,
      this.showIcon = false,
      this.suffixIcon,
      this.onTap,
      this.onRemove});

  _showOptions(BuildContext context){
    CustomNavigator.showCustomBottomDialog(
        context,
        CustomBottomSheet(
          title: hint ?? AppLocalizations.text(LangKey.choose),
          body: CustomBottomOption(
            options: menus!
                .map((e) => CustomBottomOptionModel(
                text: e.text,
                textColor: e.color,
                isSelected: value?.text == e.text,
                onTap: () {
                  CustomNavigator.pop(context);
                  onChanged!(e);
                }))
                .toList(),
          ),
        ));
  }

  Widget _buildBody(BuildContext context, String? text, {bool isHint = false, Color? textColor}) {
    return InkWell(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: (menus ?? []).isNotEmpty
                ? Colors.transparent
                : AppColors.grey50Color,
            border: Border.all(
              color: (menus ?? []).isNotEmpty
                  ? AppColors.borderColor
                  : AppColors.grey50Color,
            )),
        padding: EdgeInsets.all(AppSizes.minPadding),
        child: Row(
          children: [
            if (icon != null)
              Padding(
                padding: EdgeInsets.only(right: AppSizes.minPadding),
                child: CustomImageIcon(
                  icon: icon,
                  size: 20.0,
                ),
              ),
            Expanded(
                child: Text(
                  (isHint ? hint : text) ?? "",
                  style: AppTextStyles.style14BlackNormal.copyWith(
                      color: isHint ? AppColors.hintColor : (textColor ?? AppColors.black)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
            if (showIcon || !isText) ...[
              Container(
                width: AppSizes.minPadding,
              ),
              if(onRemove != null && value != null)
                InkWell(
                  child: CustomImageIcon(
                    icon: Assets.iconTrash,
                    size: 20.0,
                    color: AppColors.redColor,
                  ),
                  onTap: onRemove,
                )
              else
                Icon(
                  suffixIcon ?? Icons.keyboard_arrow_down,
                  size: 20.0,
                  color: AppColors.grey500Color,
                ),
            ]
          ],
        ),
      ),
      onTap: onTap ?? (isText ? null : () => _showOptions(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isText) {
      return _buildBody(context, value?.text, isHint: isHint, textColor: value?.color);
    }
    if (menus == null) {
      return CustomShimmer(
        child: CustomSkeleton(
          height: AppSizes.maxPadding * 2,
          radius: 5.0,
        ),
      );
    }

    if(value == null){
      return _buildBody(context, hint, isHint: true);
    }

    return _buildBody(context, value!.text, textColor: value!.color);
  }
}

class CustomDropdownModel {
  final dynamic id;
  final String? text;
  final dynamic data;
  final Color? color;

  CustomDropdownModel({this.id, this.text, this.data, this.color});
}

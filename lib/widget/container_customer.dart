part of widget;

class ContainerCustomer extends StatelessWidget {
  final CustomerResponseModel? model;
  final Function? onLoadmore;
  final Function(CustomerModel)? onTap;

  const ContainerCustomer({this.model, this.onLoadmore, this.onTap, Key? key})
      : super(key: key);

  Widget _buildContainer(List<Widget> children,
      {Function? onLoadmore, bool? showLoadmore}) {
    return CustomListView(
      children: children,
      onLoadmore: onLoadmore,
      showLoadmore: showLoadmore,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return _buildContainer(List.generate(
          1,
          (index) => CustomCustomer(
                index: index,
              )).toList());
    }

    return _buildContainer(
        List.generate(
            model!.items!.length,
            (index) => CustomCustomer(
                index: index,
                model: model!.items![index],
                onTap: onTap == null
                    ? null
                    : () => onTap!(model!.items![index]))).toList(),
        onLoadmore: onLoadmore,
        showLoadmore: model!.pageInfo?.enableLoadmore);
  }
}

class CustomCustomer extends StatelessWidget {
  final int? index;
  final CustomerModel? model;
  final GestureTapCallback? onTap;

  const CustomCustomer({this.index, this.model, this.onTap, Key? key})
      : super(key: key);

  Widget _buildContainer(List<Widget> children) {
    return CustomListView(
      padding: EdgeInsets.all(AppSizes.minPadding),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  Widget _buildSkeleton() {
    return CustomContainerList(
      child: CustomShimmer(
        child: _buildContainer(
            List.generate(5, (index) => CustomRowWithoutTitleInformation())
                .toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return _buildSkeleton();
    }

    if (model!.customerId == customerGuestId) {
      return InkWell(
        child: CustomGuestCustomer(),
        onTap: onTap,
      );
    }

    return InkWell(
        child: CustomContainerList(
          child: _buildContainer([
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text.rich(TextSpan(
                        text:
                            "${model!.customerType == customerTypePersonal ? AppLocalizations.text(LangKey.personal) : AppLocalizations.text(LangKey.enterprise)} - ",
                        style: AppTextStyles.style14HintNormal,
                        children: [
                      TextSpan(
                          text: model!.fullName,
                          style: AppTextStyles.style14PrimaryBold)
                    ]))),
                if (index != null) ...[
                  SizedBox(
                    width: AppSizes.minPadding,
                  ),
                  CustomIndex(index: index!)
                ]
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                    child: CustomListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    CustomRowWithoutTitleInformation(
                        icon: Assets.iconBarcode,
                        text: model!.customerCode ?? ""),
                    CustomRowWithoutTitleInformation(
                        icon: Assets.iconUserGroup,
                        text: model!.groupName ?? ""),
                    CustomRowWithoutTitleInformation(
                        icon: Assets.iconPhone, text: hidePhone(model!.phone,true)),
                    CustomRowWithoutTitleInformation(
                        icon: Assets.iconUserSetting,
                        text: parseAndFormatDate(model!.createdAt)),
                    if((model!.tags?.length ?? 0) > 0)
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 5.0,
                          runSpacing: 5.0,
                          children: model!.tags!.map((e) => CustomTag(
                            name: e.name,
                          )).toList(),
                        ),
                      )
                  ],
                )),
              ],
            ),
          ]),
        ),
        onTap: onTap);
  }
}

class CustomGuestCustomer extends StatelessWidget {
  const CustomGuestCustomer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContainerBooking(Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: AppSizes.maxPadding, vertical: AppSizes.minPadding),
      alignment: Alignment.center,
      child: Text(
        AppLocalizations.text(LangKey.walk_in_guest)!,
        style: AppTextStyles.style14PrimaryBold,
        textAlign: TextAlign.center,
      ),
    ));
  }
}

class ContainerBooking extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final bool isSelected;

  const ContainerBooking(this.child,
      {Key? key, this.onTap, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: AppColors.white,
            border: Border.all(
                color:
                    isSelected ? AppColors.primaryColor : AppColors.white),
            boxShadow: isSelected
                ? null
                : [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.25),
                      blurRadius: 2.0,
                      offset: Offset.zero,
                    )
                  ]),
        child: child,
      ),
      onTap: onTap,
    );
  }
}


class CustomRowWithoutTitleInformation extends StatelessWidget {
  final String? icon;
  final String? text;
  final Widget? child;
  final String? subText;
  final TextStyle? textStyle;
  final bool isExpand;
  final int? maxLines;

  const CustomRowWithoutTitleInformation(
      {Key? key,
      this.icon,
      this.text,
      this.child,
      this.subText,
      this.textStyle,
      this.isExpand = true,
      this.maxLines})
      : super(key: key);

  final _iconSize = 16.0;

  Widget _buildSkeleton() {
    return Row(
      children: [
        CustomSkeleton(
          width: _iconSize,
          height: _iconSize,
          radius: _iconSize,
        ),
        SizedBox(
          width: AppSizes.minPadding,
        ),
        Expanded(
          child: CustomSkeleton(),
        )
      ],
    );
  }

  Widget _buildText() {
    return child ??
        Text(
          text!,
          style: textStyle ?? AppTextStyles.style14BlackNormal,
          maxLines: maxLines,
        );
  }

  @override
  Widget build(BuildContext context) {
    if (text == null && child == null) {
      return _buildSkeleton();
    }

    return Row(
      children: [
        if (icon != null)
          Padding(
            padding: EdgeInsets.only(right: AppSizes.minPadding),
            child: CustomImageIcon(
              icon: icon,
              size: _iconSize,
            ),
          ),
        if (isExpand)
          Expanded(
            child: _buildText(),
          )
        else
          _buildText(),
        if (subText != null)
          Padding(
            padding: EdgeInsets.only(left: AppSizes.minPadding),
            child: Text(
              subText!,
              style: AppTextStyles.style14PrimaryBold,
            ),
          )
      ],
    );
  }
}

class CustomTag extends StatelessWidget {
  final String? name;
  final String? icon;
  final Color? textColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;
  final Color? borderColor;
  final GestureTapCallback? onClose;

  const CustomTag(
      {Key? key,
      this.name,
      this.icon,
      this.textColor,
      this.backgroundColor,
      this.padding,
      this.style,
      this.borderColor,
      this.onClose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomChip(
          text: name,
          icon: icon,
          iconAsset: false,
          style: style ??
              AppTextStyles.style10WhiteBold
                  .copyWith(color: textColor ?? AppColors.white),
          borderColor: borderColor ?? null,
          radius: 5.0,
          backgroundColor: backgroundColor ?? AppColors.primaryColor,
          padding:
              padding ?? EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
          onClose: onClose,
        )
      ],
    );
  }
}
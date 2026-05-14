part of '../detail_potential_customer.dart';

extension GeneralInformationTabExtension on _DetailPotentialCustomerState {
  Widget _buildRow(Widget child, Widget child1) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: child),
        SizedBox(
          width: AppSizes.minPadding,
        ),
        Expanded(child: child1)
      ],
    );
  }

  Widget _buildInfo(DetailPotentialData model) {
    return Row(
      children: [
        CustomAvatar(
          url: model.avatar,
          name: model.fullName,
          size: 60.0,
        ),
        SizedBox(
          width: AppSizes.minPadding,
        ),
        Expanded(
            child: CustomListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Text(
              model.fullName ?? "",
              style: AppTextStyles.style14PrimaryBold,
            ),
            if ((model.customerTypeName ?? "").isNotEmpty)
              Text(
                model.customerTypeName ?? "",
                style: AppTextStyles.style14HintNormal,
              ),
            if ((model.phone ?? "").isNotEmpty)
              Text(
                hidePhone(model.phone,
                    checkVisibilityKey(VisibilityWidgetName.CM000004)),
                style: AppTextStyles.style14BlackNormal,
              ),
          ],
        )),
      ],
    );
  }

  Widget _buildCode(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconBarcode,
        title: "Mã khách hàng",
        content: model.customerLeadCode);
  }

  Widget _buildEmail(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconMail,
        title: AppLocalizations.text(LangKey.email),
        content: hideEmail(
            model.email, checkVisibilityKey(VisibilityWidgetName.CM000004)));
  }

  Widget _buildWebsite(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconWebsite,
        title: "Website",
        content: hideSocial(
            model.hotline, checkVisibilityKey(VisibilityWidgetName.CM000004)));
  }

  Widget _buildAddress(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconMarker,
        title: AppLocalizations.text(LangKey.address),
        content: model.fullAddress);
  }

  Widget _buildJourney(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconItinerary,
        title: AppLocalizations.text(LangKey.journey),
        content: model.journeyName);
  }

  Widget _buildPipeline(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconPin,
        title: AppLocalizations.text(LangKey.pipeline),
        content: model.pipelineName);
  }

  Widget _buildSource(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconUserGroup,
        title: AppLocalizations.text(LangKey.customer_source),
        content: model.customerSourceName);
  }

  Widget _buildGroup(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconGroup,
        title: AppLocalizations.text(LangKey.customer_group),
        content: model.customerGroupName);
  }

  Widget _buildTag(DetailPotentialData model) {
    return CustomColumnIconInformation(
      icon: Assets.iconTagFill,
      title: AppLocalizations.text(LangKey.tags),
      child: (model.tag?.length ?? 0) > 0
          ? SizedBox(
              width: double.infinity,
              child: Wrap(
                children: List.generate(detail!.tag!.length,
                    (index) => _tagDetail(detail!.tag![index])),
                spacing: 10,
                runSpacing: 10,
              ),
            )
          : null,
    );
  }

  Widget _buildAllottedPersone(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconPersonTag,
        title: AppLocalizations.text(LangKey.allottedPerson),
        content: model.saleName);
  }

  Widget _buildPresenter(DetailPotentialData model) {
    // return Text('${_bloc.detail!.customerLeadReferId}');
    return CustomColumnIconInformation(
      icon: Assets.iconSearch,
      title: AppLocalizations.text(LangKey.presenter),
      content: model.customerLeadReferName ?? "",
      styleContent: _bloc.detail!.customerLeadReferId == null
          ? null
          : AppTextStyles.style14PrimaryBold
              .copyWith(decoration: TextDecoration.underline),
      onTap: _bloc.detail!.customerLeadReferId == null
          ? null
          : () => _bloc.onPushPresenter(),
    );
  }

  Widget _buildFoundingDate(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconCalendarFill,
        title: AppLocalizations.text(LangKey.founding_date),
        content: model.birthday);
  }

  Widget _buildGender(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconGen,
        title: AppLocalizations.text(LangKey.gender),
        content: model.gender == genderMale
            ? AppLocalizations.text(LangKey.male)
            : model.gender == genderFemale
                ? AppLocalizations.text(LangKey.female)
                : AppLocalizations.text(LangKey.other));
  }

  Widget _buildDate(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconCalendarFill,
        title: AppLocalizations.text(LangKey.birthday),
        content: CustomAppFormat.formatDate(model.birthday ?? ""));
  }

  Widget _buildZalo(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconZalo,
        title: "Zalo",
        content: hideSocial(
            model.zalo, checkVisibilityKey(VisibilityWidgetName.CM000004)));
  }

  Widget _buildFacebook(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconFacebook,
        title: "Facebook",
        content: hideSocial(
            model.fanpage, checkVisibilityKey(VisibilityWidgetName.CM000004)));
  }

  Widget _buildTaxCode(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconTax,
        title: AppLocalizations.text(LangKey.tax_code_1),
        content: model.taxCode);
  }

  Widget _buildArea(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconBusinessArea,
        title: AppLocalizations.text(LangKey.business_areas),
        content: model.businessName);
  }

  Widget _buildRepresentative(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconUserStand,
        title: AppLocalizations.text(LangKey.representative),
        content: model.representative);
  }

  Widget _buildQuantity(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconQuantity,
        title: AppLocalizations.text(LangKey.number_of_employees),
        content: (model.employQty ?? "").toString());
  }

  Widget _buildBranch(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconBranch,
        title: AppLocalizations.text(LangKey.branch),
        content: model.branchName);
  }

  Widget _buildCreateBy(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconUserSetting,
        title: AppLocalizations.text(LangKey.creator),
        content: model.createdByName);
  }

  Widget _buildUpdateBy(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconUserUpdate,
        title: AppLocalizations.text(LangKey.updater),
        content: model.updatedByName);
  }

  Widget _buildNote(DetailPotentialData model) {
    return CustomColumnIconInformation(
        icon: Assets.iconEditNote,
        title: AppLocalizations.text(LangKey.note),
        content: model.note);
  }

  Widget generalInfomationV2() {
    return StreamBuilder(
      stream: _bloc.outputModel,
      initialData: null,
      builder: (_, snapshot) {
        DetailPotentialData? model = snapshot.data as DetailPotentialData?;
        return ContainerDataBuilder(
          data: model,
          skeletonBuilder: _buildSkeleton(),
          bodyBuilder: () {
            bool isPersonal = model!.customerType == customerTypePersonal;
            return CustomListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              separatorPadding: AppSizes.maxPadding,
              children: [
                _buildInfo(model),
                _buildRow(_buildCode(model), _buildEmail(model)),
                if (!isPersonal) _buildWebsite(model),
                _buildAddress(model),
                _buildRow(_buildPipeline(model), _buildJourney(model)),
                _buildRow(_buildSource(model), _buildGroup(model)),
                _buildAllottedPersone(model),
                _buildTag(model),
                _buildPresenter(model),
                if (!isPersonal)
                  _buildFoundingDate(model)
                else
                  _buildRow(
                    _buildGender(model),
                    _buildDate(model),
                  ),
                _buildRow(_buildZalo(model), _buildFacebook(model)),
                if (!isPersonal) ...[
                  _buildRow(_buildTaxCode(model), _buildArea(model)),
                  _buildRow(_buildRepresentative(model), _buildQuantity(model)),
                ],
                _buildRow(_buildBranch(model), _buildCreateBy(model)),
                _buildUpdateBy(model),
                _buildNote(model)
              ],
              onRefresh: () => _bloc.getData(_bloc.detail!.customerLeadCode!),
            );
          },
        );
      },
    );
  }

  Widget _infoItemV2(String icon, String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 13.0),
      margin: EdgeInsets.only(left: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            height: 15.0,
            width: 15.0,
            child: Image.asset(icon),
          ),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal),
              // maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagDetail(Tag item) {
    return Container(
      padding: EdgeInsets.only(left: 4.0, right: 4.0),
      height: 24,
      decoration: BoxDecoration(
          color: Color(0x420067AC), borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              height: 8.0,
              width: 8.0,
              margin: EdgeInsets.only(right: 5.0),
              decoration: BoxDecoration(
                  color: Color(0x790067AC),
                  borderRadius: BorderRadius.circular(1000.0))),
          Text(item.tagName!,
              style: TextStyle(
                  color: Color(0xFF0067AC),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600))
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return LoadingWidget(
        padding: EdgeInsets.zero,
        child: CustomListView(
          children: List.generate(
              5,
              (index) => CustomSkeleton(
                    height: 60,
                    radius: 4.0,
                  )),
        ));
  }
}

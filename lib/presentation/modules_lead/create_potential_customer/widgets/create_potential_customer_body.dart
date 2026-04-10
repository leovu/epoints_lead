import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/customer_type.dart';
import 'package:lead_plugin_epoint/model/custom_create_address_model.dart';
import 'package:lead_plugin_epoint/model/request/add_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/response/customer_response_model.dart';
import 'package:lead_plugin_epoint/model/response/get_branch_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_group_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_option_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_journey_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_pipeline_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_province_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modal/branch_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/create_new_phone_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/customer_source_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/group_customer_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/journey_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/pipeline_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/tag_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/bloc/create_potential_customer_bloc.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/build_more_address_create_potential.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_bottom_sheet.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/request/get_list_staff_request_model.dart';

class CreatePotentialCustomerBody extends StatefulWidget {
  final CreatePotentialCustomerBloc bloc;
  final TextEditingController fullNameText;
  final FocusNode fullnameFocusNode;
  final TextEditingController phoneNumberText;
  final FocusNode phoneNumberFocusNode;
  final TextEditingController emailText;
  final FocusNode emailFocusNode;
  final TextEditingController taxText;
  final FocusNode taxFocusNode;
  final AddLeadModelRequest detailPotential;
  final CustomerTypeModel Function() getCustomerTypeSelected;
  final void Function(CustomerTypeModel) setCustomerTypeSelected;

  const CreatePotentialCustomerBody({
    Key? key,
    required this.bloc,
    required this.fullNameText,
    required this.fullnameFocusNode,
    required this.phoneNumberText,
    required this.phoneNumberFocusNode,
    required this.emailText,
    required this.emailFocusNode,
    required this.taxText,
    required this.taxFocusNode,
    required this.detailPotential,
    required this.getCustomerTypeSelected,
    required this.setCustomerTypeSelected,
  }) : super(key: key);

  @override
  State<CreatePotentialCustomerBody> createState() =>
      _CreatePotentialCustomerBodyState();
}

class _CreatePotentialCustomerBodyState
    extends State<CreatePotentialCustomerBody> {
  bool showMoreAddress = false;
  bool selectedPersonal = true;

  List<ProvinceData> provinces = <ProvinceData>[];
  AddLeadModelRequest requestModel = AddLeadModelRequest();

  WorkListStaffModel? get _staffSelected => _bloc.staffSelected;
  set _staffSelected(WorkListStaffModel? val) => _bloc.staffSelected = val;

  List<CustomerTypeModel> customerTypeData = [
    CustomerTypeModel(
        customerTypeName: AppLocalizations.text(LangKey.personal),
        customerTypeID: 1,
        selected: true),
    CustomerTypeModel(
        customerTypeName: AppLocalizations.text(LangKey.business),
        customerTypeID: 2,
        selected: false),
  ];

  CreatePotentialCustomerBloc get _bloc => widget.bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(),
        const SizedBox(height: 15),
        _buildCustomerTypeSelector(),
        const SizedBox(height: 15),
        ..._buildFormFields(),
        _buildMoreInfoButton(),
        _buildMoreInfoSection(),
      ],
    );
  }

  // -- Section Title --
  Widget _buildSectionTitle() {
    return Text(
      AppLocalizations.text(LangKey.customerInformation)!,
      style: TextStyle(
          fontSize: AppTextSizes.size16,
          color: const Color(0xFF0067AC),
          fontWeight: FontWeight.normal),
    );
  }

  // -- Customer Type Toggle (Personal / Business) --
  Widget _buildCustomerTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTypeButton(
          label: AppLocalizations.text(LangKey.personal)!,
          isSelected: selectedPersonal,
          onTap: () {
            widget.detailPotential.customerType = "personal";
            widget.setCustomerTypeSelected(customerTypeData[0]);
            selectedPersonal = true;
            setState(() {});
          },
        ),
        _buildTypeButton(
          label: AppLocalizations.text(LangKey.business)!,
          isSelected: !selectedPersonal,
          onTap: () {
            widget.detailPotential.customerType = "business";
            widget.setCustomerTypeSelected(customerTypeData[1]);
            selectedPersonal = false;
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildTypeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 42.0,
        width: MediaQuery.of(context).size.width / 2 - 19,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color:
                isSelected ? AppColors.primaryColor : const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 2,
                color: Colors.black.withValues(alpha: 0.3),
              )
            ]),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF8E8E8E),
                fontSize: 14.0,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  // -- Form Fields --
  List<Widget> _buildFormFields() {
    return [
      // Full name / Business name
      _buildTextField(
          selectedPersonal
              ? AppLocalizations.text(LangKey.inputFullname)
              : AppLocalizations.text(LangKey.enterBusiness),
          "",
          selectedPersonal ? Assets.iconPerson : Assets.iconProvince,
          true,
          false,
          true,
          fillText: widget.fullNameText,
          focusNode: widget.fullnameFocusNode),

      // Phone number
      _buildTextField(AppLocalizations.text(LangKey.inputPhonenumber), "",
          Assets.iconCall, true, false, true,
          fillText: widget.phoneNumberText,
          focusNode: widget.phoneNumberFocusNode,
          inputType: const TextInputType.numberWithOptions(
              signed: false, decimal: false)),

      _buildAddPhone(),

      // Customer source (pre-selected first item)
      _buildTextField(
          AppLocalizations.text(LangKey.customerSource),
          _bloc.sourceSelected.sourceName ?? "",
          Assets.iconSourceCustomer,
          true,
          true,
          false,
          ontap: _onTapCustomerSource),

      // Pipeline
      _buildTextField(
          AppLocalizations.text(LangKey.choosePipeline),
          _bloc.pipelineSelected.pipelineName ?? "",
          Assets.iconChance,
          true,
          true,
          false,
          ontap: _onTapPipeline),

      // Journey
      _buildTextField(
          AppLocalizations.text(LangKey.chooseItinerary),
          _bloc.journeySelected?.journeyName ?? "",
          Assets.iconItinerary,
          true,
          true,
          false,
          ontap: _onTapJourney),

      // Branch
      _buildTextField(
          AppLocalizations.text(LangKey.chooseBranch),
          _bloc.branchSelected?.branchName ?? "",
          Assets.iconName,
          true,
          true,
          false,
          ontap: _onTapBranch),

      // Allocated person
      _buildTextField(
          AppLocalizations.text(LangKey.chooseAllottedPerson),
          _staffSelected?.staffName ?? "",
          Assets.imageAssign,
          true,
          true,
          false,
          ontap: _onTapAllocatedPerson,
          applyIconColor: false),

      // Tax code (business only)
      if (!selectedPersonal)
        _buildTextField(AppLocalizations.text(LangKey.tax), "", Assets.iconTax,
            false, false, true,
            fillText: widget.taxText,
            focusNode: widget.taxFocusNode,
            inputType: const TextInputType.numberWithOptions(
                signed: false, decimal: false)),

      // Email
      _buildTextField(AppLocalizations.text(LangKey.email), "",
          Assets.iconEmail, false, false, true,
          fillText: widget.emailText, focusNode: widget.emailFocusNode),

      _buildAddress(),

      // Customer group
      _buildTextField(
          AppLocalizations.text(LangKey.select_customer_group),
          _bloc.customerGroupSelected?.groupName ?? "",
          Assets.iconName,
          false,
          true,
          false,
          ontap: _onTapCustomerGroup),

      // Tags
      _buildTextField(AppLocalizations.text(LangKey.chooseCards) ?? "Chọn nhãn",
          _bloc.tagsString, Assets.iconTag, false, true, false,
          ontap: _onTapTags),

      _buildPresenter(),
    ];
  }

  // -- Tap Handlers --

  void _onTapCustomerSource() async {
    FocusScope.of(context).unfocus();
    CustomerOptionSource? source =
        await showModalBottomSheet<CustomerOptionSource>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          CustomerSourceModal(sources: _bloc.customerSourcesData),
    );
    if (source != null) {
      _bloc.sourceSelected = source;
      widget.detailPotential.customerSource =
          _bloc.sourceSelected.customerSourceId;
      setState(() {});
    }
  }

  void _onTapPipeline() async {
    FocusScope.of(context).unfocus();
    PipelineData? pipeline = await showModalBottomSheet<PipelineData>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PipelineModal(pipeLineData: _bloc.pipeLineData),
    );
    if (pipeline != null) {
      if (_bloc.pipelineSelected.pipelineName != pipeline.pipelineName) {
        _bloc.journeySelected = null;
      }
      _bloc.pipelineSelected = pipeline;
      widget.detailPotential.pipelineCode = _bloc.pipelineSelected.pipelineCode;

      await _bloc.loadJourneys(context, _bloc.pipelineSelected.pipelineCode);
      widget.detailPotential.journeyCode = _bloc.journeySelected?.journeyCode;
      setState(() {});
    }
  }

  void _onTapJourney() async {
    FocusScope.of(context).unfocus();
    JourneyData? journey = await showModalBottomSheet<JourneyData>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => JourneyModal(journeys: _bloc.journeysData),
    );
    if (journey != null) {
      _bloc.journeySelected = journey;
      widget.detailPotential.journeyCode = _bloc.journeySelected!.journeyCode;
      setState(() {});
    }
  }

  void _onTapBranch() async {
    FocusScope.of(context).unfocus();
    var val = await _bloc.getBranch(context);
    if (val != null) {
      BranchData? data;
      if (_bloc.listBranch.length > 10) {
        // Use searchable bottom sheet for large list
        data = await showModalBottomSheet<BranchData>(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,
          backgroundColor: Colors.transparent,
          builder: (context) => SearchableBranchBottomSheet(
            title: AppLocalizations.text(LangKey.chooseBranch),
            branches: _bloc.listBranch,
          ),
        );
      } else {
        data = await showModalBottomSheet<BranchData>(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,
          backgroundColor: Colors.transparent,
          builder: (context) => BranchModal(datas: _bloc.listBranch),
        );
      }
      if (data != null) {
        _bloc.branchSelected = data;
        // Reset allocated person and auto-fill by userId
        _bloc.staffSelected = null;
        widget.detailPotential.saleId = 0;
        LeadConnection.showLoading(context);
        await _bloc.autoFillStaffByUserId(context);
        Navigator.of(context).pop();
        if (_bloc.staffSelected != null) {
          widget.detailPotential.saleId = _bloc.staffSelected!.staffId;
        }
        setState(() {});
      }
    }
  }

  void _onTapAllocatedPerson() async {
    FocusScope.of(context).unfocus();

    LeadConnection.showLoading(context);
    var result = await LeadConnection.workListStaff(
      context,
      WorkListStaffRequestModel(
        branchId: _bloc.branchSelected?.branchId?.toString(),
      ),
    );
    Navigator.of(context).pop();

    if (result == null || result.data == null || result.data!.isEmpty) {
      LeadConnection.showMyDialog(
          context, "No staff available for the selected branch",
          warning: true);
      return;
    }

    WorkListStaffModel? selected =
        await showModalBottomSheet<WorkListStaffModel>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SearchableStaffBottomSheet(
          title: AppLocalizations.text(LangKey.chooseAllottedPerson),
          staffs: result.data!,
        );
      },
    );

    if (selected != null) {
      _staffSelected = selected;
      widget.detailPotential.saleId = selected.staffId;
      setState(() {});
    }
  }

  void _onTapCustomerGroup() async {
    FocusScope.of(context).unfocus();
    var val = await _bloc.getCustomerGroup(context);
    if (val != null) {
      CustomerGroupData? data = await showModalBottomSheet<CustomerGroupData>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        builder: (context) =>
            GroupCustomerModal(datas: _bloc.listCustomerGroupData),
      );
      if (data != null) {
        _bloc.customerGroupSelected = data;
        setState(() {});
      }
    }
  }

  void _onTapTags() async {
    FocusScope.of(context).unfocus();
    var listTagsSelected = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TagsModal(tagsData: _bloc.tagsData)));
    if (listTagsSelected != null) {
      List<int?> tagsSelected = [];
      _bloc.tagsString = "";
      _bloc.tagsData = listTagsSelected;

      for (int i = 0; i < _bloc.tagsData!.length; i++) {
        if (_bloc.tagsData![i].selected!) {
          tagsSelected.add(_bloc.tagsData![i].tagId);
          if (_bloc.tagsString == "") {
            _bloc.tagsString = _bloc.tagsData![i].name ?? "";
          } else {
            _bloc.tagsString += ", ${_bloc.tagsData![i].name}";
          }
        }
      }
      widget.detailPotential.tagId = tagsSelected;
      setState(() {});
    }
  }

  // -- Sub-widgets --

  Widget _buildAddPhone() {
    return Column(
      children: [
        _buildListPhone(),
        GestureDetector(
          onTap: () async {
            var result = await showModalBottomSheet(
                isDismissible: false,
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: CreateNewPhoneModal(
                        bloc: _bloc,
                      ));
                });
            if (result != null && result) {
              setState(() {});
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                  "+  ${AppLocalizations.text(LangKey.add_phone_number)}",
                  style: AppTextStyles.style14BlueWeight500),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildListPhone() {
    return (_bloc.listPhone.isNotEmpty)
        ? Column(
            children: [
              ..._bloc.listPhone.map((item) => _phoneItem(item)).toList()
            ],
          )
        : const SizedBox();
  }

  Widget _phoneItem(String phone) {
    return Column(
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey200, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  Assets.iconCall,
                  width: 16,
                ),
              ),
              Text(
                phone,
                style: AppTextStyles.style14BlackWeight500,
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _bloc.listPhone.remove(phone);
                    setState(() {});
                  },
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 8.0)
      ],
    );
  }

  Widget _buildPresenter() {
    return StreamBuilder(
        stream: _bloc.outputPresenterModel,
        initialData: _bloc.presenterModel,
        builder: (_, snapshot) {
          _bloc.presenterModel = snapshot.data as CustomerModel?;
          return _buildTextField(
              AppLocalizations.text(LangKey.presenter),
              _bloc.presenterModel?.fullName ?? "",
              Assets.iconSearch,
              false,
              true,
              false,
              ontap: _bloc.onPushPresenter);
        });
  }

  Widget _buildAddress() {
    return StreamBuilder(
        stream: _bloc.outputAddressModel,
        initialData: _bloc.addressModel,
        builder: (_, snapshot) {
          _bloc.addressModel = snapshot.data as CustomerCreateAddressModel?;
          return _buildTextField(
              AppLocalizations.text(LangKey.inputAddress),
              parseAddress(_bloc.addressModel),
              Assets.iconAddress,
              false,
              true,
              false,
              ontap: _bloc.onPushAddress);
        });
  }

  Widget _buildMoreInfoButton() {
    if (showMoreAddress) return const SizedBox();
    return InkWell(
      onTap: () {
        showMoreAddress = true;
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
                width: 1.0, color: Colors.blue, style: BorderStyle.solid)),
        child: Center(
          child: Text(
            "+ ${AppLocalizations.text(LangKey.moreInformation)}",
            style: TextStyle(
                fontSize: AppTextSizes.size16,
                color: const Color(0xFF0067AC),
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }

  Widget _buildMoreInfoSection() {
    if (!showMoreAddress) return const SizedBox();
    return BuildMoreAddressCreatPotential(
      provinces: provinces,
      requestModel: requestModel,
      detailPotential: widget.detailPotential,
      selectedPersonal: selectedPersonal,
      bloc: _bloc,
    );
  }

  // -- Shared TextField Builder --
  Widget _buildTextField(
    String? title,
    String? content,
    String icon,
    bool mandatory,
    bool dropdown,
    bool textfield, {
    GestureTapCallback? ontap,
    TextEditingController? fillText,
    FocusNode? focusNode,
    TextInputType? inputType,
    bool applyIconColor = true,
  }) {
    final commonBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        width: 1,
        color: Color(0xFFB8BFC9),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: ontap,
        child: TextField(
          enabled: textfield,
          readOnly: !textfield,
          controller: fillText,
          focusNode: focusNode,
          keyboardType: inputType ?? TextInputType.text,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            isCollapsed: true,
            isDense: true,
            contentPadding: const EdgeInsets.all(12.0),

            /// Same border for all states
            border: commonBorder,
            enabledBorder: commonBorder,
            focusedBorder: commonBorder,
            disabledBorder: commonBorder,

            label: (content == null || content.isEmpty)
                ? RichText(
                    text: TextSpan(
                      text: title,
                      style: TextStyle(
                        fontSize: AppTextSizes.size15,
                        color: const Color(0xFF858080),
                        fontWeight: FontWeight.normal,
                      ),
                      children: [
                        if (mandatory)
                          const TextSpan(
                            text: "*",
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  )
                : Text(
                    content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                icon,
                color: applyIconColor ? AppColors.primaryColor : null,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              maxHeight: 32.0,
              maxWidth: 32.0,
            ),

            suffixIcon: dropdown
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      Assets.iconDropDown,
                    ),
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              maxHeight: 32.0,
              maxWidth: 32.0,
            ),
          ),
          onChanged: (event) {},
        ),
      ),
    );
  }
}

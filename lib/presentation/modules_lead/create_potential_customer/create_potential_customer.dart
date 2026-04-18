import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/custom_create_address_model.dart';
import 'package:lead_plugin_epoint/model/customer_type.dart';
import 'package:lead_plugin_epoint/model/object_pop_detail_model.dart';
import 'package:lead_plugin_epoint/model/request/add_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/response/add_lead_model_response.dart';
import 'package:lead_plugin_epoint/model/response/customer_response_model.dart';
import 'package:lead_plugin_epoint/model/response/get_branch_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_group_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_option_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_district_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_journey_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/model/response/get_pipeline_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_province_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_tag_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_ward_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modal/branch_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/create_new_phone_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/customer_source_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/group_customer_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/journey_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/pipeline_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/staff_pick_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/tag_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/bloc/create_potential_customer_bloc.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/build_more_address_create_potential.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/widgets/create_potential_customer_widgets.dart';
import 'package:lead_plugin_epoint/utils/global.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';

part 'create_potential_customer_handlers.dart';

class CreatePotentialCustomer extends StatefulWidget {
  final String? fullname;
  final String? phoneNumber;
  CreatePotentialCustomer({Key? key, this.fullname, this.phoneNumber})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreatePotentialCustomerState createState() =>
      _CreatePotentialCustomerState();
}

class _CreatePotentialCustomerState extends State<CreatePotentialCustomer>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;

  late CreatePotentialCustomerBloc _bloc;

  ScrollController _controller = ScrollController();
  TextEditingController _fullNameText = TextEditingController();
  FocusNode _fullnameFocusNode = FocusNode();

  TextEditingController _phoneNumberText = TextEditingController();
  FocusNode _phoneNumberFocusNode = FocusNode();

  TextEditingController _emailText = TextEditingController();
  FocusNode _emailFocusNode = FocusNode();

  TextEditingController _taxText = TextEditingController();
  FocusNode _taxFocusNode = FocusNode();

  bool showMoreAddress = false;
  bool selectedPersonal = true;

  AddLeadModelRequest requestModel = AddLeadModelRequest();
  List<ProvinceData> provinces = <ProvinceData>[];
  List<DistrictData> districts = <DistrictData>[];
  List<WardData> wards = <WardData>[];

  CustomerOptionSource sourceSelected = CustomerOptionSource();
  PipelineData pipelineSelected = PipelineData();
  JourneyData? journeySelected;
  WorkListStaffModel? allocatorSelected;

  List<TagData>? tagsData;
  String tagsString = "";

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

  CustomerTypeModel customerTypeSelected = CustomerTypeModel(
      customerTypeName: AppLocalizations.text(LangKey.personal),
      customerTypeID: 1,
      selected: true);

  AddLeadModelRequest detailPotential = AddLeadModelRequest(
      avatar: "",
      customerType: "",
      customerSource: 0,
      fullName: "",
      taxCode: "",
      phone: "",
      email: "",
      representative: "",
      pipelineCode: "",
      journeyCode: "",
      saleId: 0,
      tagId: [],
      gender: "",
      bussinessId: 0,
      businessClue: "",
      birthday: "",
      employees: 0,
      position: "",
      provinceId: 0,
      districtId: 0,
      wardId: 0,
      address: "",
      zalo: "",
      fanpage: "",
      contactFullName: "",
      contactPhone: "",
      contactEmail: "",
      contactAddress: "");

  ObjectPopDetailModel modelResponse = ObjectPopDetailModel();

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = CreatePotentialCustomerBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.fullname != null) {
        _fullNameText.text = widget.fullname!;
      }
      if (widget.phoneNumber != null) {
        _phoneNumberText.text = widget.phoneNumber!;
      }
      await initData();
      if (mounted) _fullnameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(() {});
    _bloc.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = View.of(context).viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => keyboardDismissOnTap(context),
      child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppColors.primaryColor,
            title: Text(
              AppLocalizations.text(LangKey.addPotentialCustomer)!,
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
          body: Container(
              decoration: const BoxDecoration(color: AppColors.white),
              child: _buildBody())),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
            child: CustomListView(
          padding:
              EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _controller,
          children: _listWidget(),
        )),
        Visibility(
            visible: !_isKeyboardVisible,
            child: SubmitButton(
              label: AppLocalizations.text(LangKey.addPotentialCustomer)!,
              onTap: onSubmit,
            )),
        Container(height: 20.0)
      ],
    );
  }

  List<Widget> _listWidget() {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
              title: AppLocalizations.text(LangKey.customerInformation)!),
          CustomerTypeSelector(
            customerTypeData: customerTypeData,
            selectedPersonal: selectedPersonal,
            onChanged: (isPersonal) {
              detailPotential.customerType =
                  isPersonal ? "personal" : "business";
              customerTypeSelected =
                  isPersonal ? customerTypeData[0] : customerTypeData[1];
              selectedPersonal = isPersonal;
              setState(() {});
            },
          ),
          SizedBox(height: 15.0),

          // Họ và tên / doanh nghiệp
          CreatePotentialFieldRow(
              title: selectedPersonal
                  ? AppLocalizations.text(LangKey.inputFullname)
                  : AppLocalizations.text(LangKey.enterBusiness),
              content: "",
              icon: selectedPersonal ? Assets.iconPerson : Assets.iconProvince,
              mandatory: true,
              dropdown: false,
              textfield: true,
              fillText: _fullNameText,
              focusNode: _fullnameFocusNode),

          // Số điện thoại
          CreatePotentialFieldRow(
              title: AppLocalizations.text(LangKey.inputPhonenumber),
              content: "",
              icon: Assets.iconCall,
              mandatory: true,
              dropdown: false,
              textfield: true,
              fillText: _phoneNumberText,
              focusNode: _phoneNumberFocusNode,
              inputType: TextInputType.numberWithOptions(
                  signed: false, decimal: false)),

          _buildAddPhone(),
          // Nguồn khách hàng
          CreatePotentialFieldRow(
              title: AppLocalizations.text(LangKey.customerSource),
              content: sourceSelected.sourceName ?? "",
              icon: Assets.iconSourceCustomer,
              mandatory: true,
              dropdown: true,
              textfield: false,
              ontap: onPickCustomerSource),

          // Pipeline
          CreatePotentialFieldRow(
              title: AppLocalizations.text(LangKey.choosePipeline),
              content: pipelineSelected.pipelineName ?? "",
              icon: Assets.iconChance,
              mandatory: true,
              dropdown: true,
              textfield: false,
              ontap: onPickPipeline),

          // Hành trình
          CreatePotentialFieldRow(
              title: "Chọn hành trình",
              content: journeySelected?.journeyName ?? "",
              icon: Assets.iconItinerary,
              mandatory: true,
              dropdown: true,
              textfield: false,
              ontap: onPickJourney),

          // Người được phân bổ
          CreatePotentialFieldRow(
              title: AppLocalizations.text(LangKey.chooseAllottedPerson),
              content: allocatorSelected?.staffName ?? "",
              icon: Assets.iconName,
              mandatory: true,
              dropdown: true,
              textfield: false,
              ontap: onPickAllocator),

          // Chi nhánh
          CreatePotentialFieldRow(
              title: "Chọn chi nhánh",
              content: _bloc.branchSelected?.branchName ?? "",
              icon: Assets.iconName,
              mandatory: true,
              dropdown: true,
              textfield: false,
              ontap: onPickBranch),

          // Mã số thuế (business)
          if (!selectedPersonal)
            CreatePotentialFieldRow(
                title: AppLocalizations.text(LangKey.tax),
                content: "",
                icon: Assets.iconTax,
                mandatory: false,
                dropdown: false,
                textfield: true,
                fillText: _taxText,
                focusNode: _taxFocusNode,
                inputType: TextInputType.numberWithOptions(
                    signed: false, decimal: false)),

          // Email
          CreatePotentialFieldRow(
              title: AppLocalizations.text(LangKey.email),
              content: "",
              icon: Assets.iconEmail,
              mandatory: false,
              dropdown: false,
              textfield: true,
              fillText: _emailText,
              focusNode: _emailFocusNode),

          _buildAddress(),

          // Nhóm khách hàng
          CreatePotentialFieldRow(
              title: "Chọn nhóm khách hàng",
              content: _bloc.customerGroupSelected?.groupName ?? "",
              icon: Assets.iconName,
              mandatory: false,
              dropdown: true,
              textfield: false,
              ontap: onPickCustomerGroup),

          // Nhãn
          CreatePotentialFieldRow(
              title: AppLocalizations.text(LangKey.chooseCards) ?? "Chọn nhãn",
              content: tagsString,
              icon: Assets.iconTag,
              mandatory: false,
              dropdown: true,
              textfield: false,
              ontap: onPickTags),

          _buildPresenter(),

          // Thông tin người liên hệ (chỉ hiển thị khi business)
          if (!selectedPersonal) _buildContactInformation(),

          if (!showMoreAddress)
            AddMoreInfoButton(onTap: () {
              showMoreAddress = true;
              setState(() {});
            }),

          if (showMoreAddress)
            BuildMoreAddressCreatPotential(
              provinces: provinces,
              requestModel: requestModel,
              detailPotential: detailPotential,
              selectedPersonal: selectedPersonal,
              bloc: _bloc,
            )
        ],
      ),
    ];
  }

  Widget _buildContactInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.0),
        SectionTitle(title: AppLocalizations.text(LangKey.contactInformation)!),
        CreatePotentialFieldRow(
            title: AppLocalizations.text(LangKey.inputFullname),
            content: "",
            icon: Assets.iconPerson,
            mandatory: true,
            dropdown: false,
            textfield: true,
            fillText: _bloc.contactFullNameController,
            focusNode: _bloc.contactFullNameFocusNode,
            onChanged: (v) => detailPotential.contactFullName = v),
        CreatePotentialFieldRow(
            title: AppLocalizations.text(LangKey.inputPhonenumber),
            content: "",
            icon: Assets.iconCall,
            mandatory: true,
            dropdown: false,
            textfield: true,
            fillText: _bloc.contactPhoneController,
            focusNode: _bloc.contactPhoneFocusNode,
            inputType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            onChanged: (v) => detailPotential.contactPhone = v),
        CreatePotentialFieldRow(
            title: AppLocalizations.text(LangKey.email),
            content: "",
            icon: Assets.iconEmail,
            mandatory: false,
            dropdown: false,
            textfield: true,
            fillText: _bloc.contactEmailController,
            focusNode: _bloc.contactEmailFocusNode,
            onChanged: (v) => detailPotential.contactEmail = v),
      ],
    );
  }

  Widget _buildAddPhone() {
    return Column(
      children: [
        _buildListPhone(),
        AddPhoneButton(onTap: onAddPhone),
      ],
    );
  }

  Widget _buildListPhone() {
    if (_bloc.listPhone.isEmpty) return SizedBox();
    return Column(
      children: _bloc.listPhone
          .map((p) => PhoneListItem(
              phone: p,
              onDelete: () {
                _bloc.listPhone.remove(p);
                setState(() {});
              }))
          .toList(),
    );
  }

  Widget _buildPresenter() {
    return StreamBuilder(
        stream: _bloc.outputPresenterModel,
        initialData: _bloc.presenterModel,
        builder: (_, snapshot) {
          _bloc.presenterModel = snapshot.data as CustomerModel?;
          return CreatePotentialFieldRow(
              title: AppLocalizations.text(LangKey.presenter),
              content: _bloc.presenterModel?.fullName ?? "",
              icon: Assets.iconSearch,
              mandatory: false,
              dropdown: true,
              textfield: false,
              ontap: _bloc.onPushPresenter);
        });
  }

  Widget _buildAddress() {
    return StreamBuilder(
        stream: _bloc.outputAddressModel,
        initialData: _bloc.addressModel,
        builder: (_, snapshot) {
          _bloc.addressModel = snapshot.data as CustomerCreateAddressModel?;
          return CreatePotentialFieldRow(
              title: AppLocalizations.text(LangKey.inputAddress),
              content: parseAddress(_bloc.addressModel),
              icon: Assets.iconAddress,
              mandatory: false,
              dropdown: true,
              textfield: false,
              ontap: _bloc.onPushAddress);
        });
  }
}

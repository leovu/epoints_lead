import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/custom_create_address_model.dart';
import 'package:lead_plugin_epoint/model/customer_type.dart';
import 'package:lead_plugin_epoint/model/request/add_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/request/edit_potential_model_request.dart';
import 'package:lead_plugin_epoint/model/request/get_journey_model_request.dart';
import 'package:lead_plugin_epoint/model/request/get_list_staff_request_model.dart';
import 'package:lead_plugin_epoint/model/response/contact_list_model_response.dart';
import 'package:lead_plugin_epoint/model/response/customer_response_model.dart';
import 'package:lead_plugin_epoint/model/response/description_model_response.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_branch_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_group_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_option_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_district_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_journey_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/model/response/get_pipeline_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_province_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_status_work_response_model.dart';
import 'package:lead_plugin_epoint/model/response/get_tag_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_ward_model_response.dart';
import 'package:lead_plugin_epoint/model/response/list_business_areas_model_response.dart';
import 'package:lead_plugin_epoint/model/response/position_response_model.dart';
import 'package:lead_plugin_epoint/presentation/modal/branch_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/create_new_phone_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/customer_source_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/group_customer_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/journey_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/pipeline_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/tag_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/bloc/create_potential_customer_bloc.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/edit_potential_customer/build_more_address_edit_potential.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/pick_one_staff_screen/ui/pick_one_staff_screen.dart';

import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/utils/visibility_api_widget_name.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';

class EditPotentialCustomer extends StatefulWidget {
  final DetailPotentialData? detailPotential;
  final String? customer_lead_code;
  EditPotentialCustomer(
      {Key? key, this.detailPotential, this.customer_lead_code})
      : super(key: key);

  @override
  _EditPotentialCustomerState createState() => _EditPotentialCustomerState();
}

class _EditPotentialCustomerState extends State<EditPotentialCustomer>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;

  late CreatePotentialCustomerBloc _bloc;

  final ScrollController _controller = ScrollController();
  final TextEditingController _fullNameText = TextEditingController();
  final TextEditingController _phoneNumberText = TextEditingController();

  FocusNode _fullnameFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();

  TextEditingController _taxText = TextEditingController();
  FocusNode _taxFocusNode = FocusNode();

  TextEditingController _emailText = TextEditingController();
  FocusNode _emailFocusNode = FocusNode();

  TextEditingController _representativeText = TextEditingController();

  bool showMoreAddress = false;
  bool showMoreAll = false;
  bool selectedPersonal = true;

  AddLeadModelRequest requestModel = AddLeadModelRequest();
  List<ProvinceData>? provinces = <ProvinceData>[];
  List<DistrictData> districts = <DistrictData>[];
  List<WardData> wards = <WardData>[];

  CustomerOptionData? customerOptonData = CustomerOptionData();
  List<CustomerOptionSource>? customerSourcesData = <CustomerOptionSource>[];
  CustomerOptionSource customerSourceSelected = CustomerOptionSource();

  List<PipelineData>? pipeLineData = <PipelineData>[];
  PipelineData pipelineSelected = PipelineData();

  List<GetStatusWorkData> statusWorkData = [];
  GetStatusWorkData statusWorkSelected = GetStatusWorkData();

  List<JourneyData>? journeysData = <JourneyData>[];
  JourneyData? journeySelected = JourneyData();

  List<CustomerTypeModel> customerTypeData = <CustomerTypeModel>[];
  CustomerTypeModel customerTypeSelected = CustomerTypeModel();

  List<AllocatorData> allocatorData = <AllocatorData>[];

  List<WorkListStaffModel> _modelStaff = [];

  List<WorkListStaffModel> _modelStaffSelected = [];

  List<ListBusinessAreasItem>? listBusinessData;

  List<TagData>? tagsData;

  String tagsString = "";

  List<ContactListData>? contactListData;

  List<PositionData>? positionData;

  DetailPotentialData? detailNew;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = CreatePotentialCustomerBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      LeadConnection.showLoading(context);

      if (widget.detailPotential != null) {
        detailNew = widget.detailPotential;
        bool business = false;
        if (widget.detailPotential!.customerType == "business") {
          business = true;
          var contactList = await LeadConnection.getContactList(
              context, widget.detailPotential!.customerLeadCode);
          if (contactList != null) {
            if (contactList.errorCode == 0) {
              contactListData = contactList.data;
              setState(() {});
            }
          } else {
            LeadConnection.showMyDialog(
                context, "Không tìm thấy thông tin người liên hệ");
          }
        } else {
          business = false;
          contactListData = null;
        }

        detailPotential = AddLeadModelRequest(
            avatar: "",
            customerType: widget.detailPotential!.customerType ?? "",
            customerSource:
                widget.detailPotential!.customerSource ?? "" as int?,
            fullName: widget.detailPotential!.fullName ?? "",
            taxCode: widget.detailPotential!.taxCode,
            phone: widget.detailPotential!.phone ?? "",
            email: widget.detailPotential!.email ?? "",
            representative: widget.detailPotential!.representative ?? "",
            pipelineCode: widget.detailPotential!.pipelineCode ?? 0 as String?,
            journeyCode: widget.detailPotential!.journeyCode ?? 0 as String?,
            saleId: widget.detailPotential!.saleId ?? 0,
            tagId: [],
            gender: widget.detailPotential!.gender ?? "",
            bussinessId: widget.detailPotential!.bussinessId ?? 0,
            businessClue: "",
            birthday: widget.detailPotential!.birthday ?? "",
            employees: widget.detailPotential!.employees ?? 0,
            provinceId: widget.detailPotential!.provinceId ?? 0,
            districtId: widget.detailPotential!.districtId ?? 0,
            wardId: widget.detailPotential!.wardId ?? 0,
            address: widget.detailPotential!.address ?? "",
            zalo: widget.detailPotential!.zalo ?? "",
            fanpage: widget.detailPotential!.fanpage ?? "",
            contactFullName: (business &&
                    contactListData != null &&
                    contactListData!.length > 0)
                ? contactListData![0].fullName ?? ""
                : "",
            contactPhone: (business &&
                    contactListData != null &&
                    contactListData!.length > 0)
                ? contactListData![0].phone ?? ""
                : "",
            contactEmail: (business &&
                    contactListData != null &&
                    contactListData!.length > 0)
                ? contactListData![0].email ?? ""
                : "",
            position: (business &&
                    contactListData != null &&
                    contactListData!.length > 0)
                ? contactListData![0].positon ?? ""
                : "",
            contactAddress: (business &&
                    contactListData != null &&
                    contactListData!.length > 0)
                ? contactListData![0].address ?? ""
                : "");

        if (widget.detailPotential!.tag!.length > 0) {
          for (int i = 0; i < widget.detailPotential!.tag!.length; i++) {
            detailPotential.tagId!.add(widget.detailPotential!.tag![i].tagId);
          }
        }
        ;
      } else {
        DetailPotentialModelResponse? dataDetail =
            await LeadConnection.getdetailPotential(
                context, widget.customer_lead_code);

        if (dataDetail != null) {
          if (dataDetail.errorCode == 0) {
            detailNew = dataDetail.data!;
            bool business = false;
            if (dataDetail.data!.customerType == "business") {
              business = true;
              var contactList = await LeadConnection.getContactList(
                  context, dataDetail.data!.customerLeadCode);
              if (contactList != null) {
                if (contactList.errorCode == 0) {
                  contactListData = contactList.data;
                  setState(() {});
                }
              } else {
                LeadConnection.showMyDialog(
                    context, "Không tìm thấy thông tin người liên hệ");
              }
            } else {
              business = false;
              contactListData = null;
            }

            detailPotential = AddLeadModelRequest(
                avatar: "",
                customerType: dataDetail.data!.customerType ?? "",
                customerSource: dataDetail.data!.customerSource ?? "" as int?,
                fullName: dataDetail.data!.fullName ?? "",
                taxCode: dataDetail.data!.taxCode,
                phone: dataDetail.data!.phone ?? "",
                email: dataDetail.data!.email ?? "",
                representative: dataDetail.data!.representative ?? "",
                pipelineCode: dataDetail.data!.pipelineCode ?? 0 as String?,
                journeyCode: dataDetail.data!.journeyCode ?? 0 as String?,
                saleId: dataDetail.data!.saleId ?? 0,
                tagId: [],
                gender: dataDetail.data!.gender ?? "",
                bussinessId: dataDetail.data!.bussinessId ?? 0,
                businessClue: "",
                birthday: dataDetail.data!.birthday ?? "",
                employees: dataDetail.data!.employees ?? 0,
                provinceId: dataDetail.data!.provinceId ?? 0,
                districtId: dataDetail.data!.districtId ?? 0,
                wardId: dataDetail.data!.wardId ?? 0,
                address: dataDetail.data!.address ?? "",
                zalo: dataDetail.data!.zalo ?? "",
                fanpage: dataDetail.data!.fanpage ?? "",
                contactFullName: (business &&
                        contactListData != null &&
                        contactListData!.length > 0)
                    ? contactListData![0].fullName ?? ""
                    : "",
                contactPhone: (business &&
                        contactListData != null &&
                        contactListData!.length > 0)
                    ? contactListData![0].phone ?? ""
                    : "",
                contactEmail: (business &&
                        contactListData != null &&
                        contactListData!.length > 0)
                    ? contactListData![0].email ?? ""
                    : "",
                position: (business &&
                        contactListData != null &&
                        contactListData!.length > 0)
                    ? contactListData![0].positon ?? ""
                    : "",
                contactAddress: (business &&
                        contactListData != null &&
                        contactListData!.length > 0)
                    ? contactListData![0].address ?? ""
                    : "");

            if (dataDetail.data!.tag!.length > 0) {
              for (int i = 0; i < dataDetail.data!.tag!.length; i++) {
                detailPotential.tagId!.add(dataDetail.data!.tag![i].tagId);
              }
            }
            ;
            setState(() {});
          } else {
            await LeadConnection.showMyDialog(
                context, dataDetail.errorDescription);
            Navigator.of(context).pop();
          }
        }
      }

      await callApi();
    });
  }

  callApi() async {
    _bloc.getBranch(context, showLoading: false).then((val) async {
      if (val != null) {
        try {
          var result = _bloc.listBranch.firstWhereOrNull(
              (element) => (element.branchCode == detailNew?.branchCode));
          if (result != null) {
            result.selected = true;
            _bloc.branchSelected = result;
            setState(() {});
          }
        } catch (e) {}
      }
    });

    _bloc.getCustomerGroup(context, showLoading: false).then((val) async {
      if (val != null) {
        try {
          var result = _bloc.listCustomerGroupData.firstWhereOrNull((element) =>
              (element.customerGroupId == detailNew?.customerGroupId));
          if (result != null) {
            result.selected = true;
            _bloc.customerGroupSelected = result;
            setState(() {});
          }
        } catch (e) {}
      }
    });

    _bloc.websiteController.text = detailNew?.zalo ?? "";

    if (detailNew?.provinceId != null || detailNew?.address != null) {
      _bloc.addressModel = CustomerCreateAddressModel(
          provinceModel: detailPotential.provinceId == null
              ? null
              : ProvinceModel(
                  provinceid: detailNew!.provinceId,
                  name: detailNew!.provinceName),
          districtModel: detailNew?.districtId == null
              ? null
              : DistrictModel(
                  districtid: detailNew!.districtId,
                  name: detailNew!.districtName),
          wardModel: detailNew?.wardId == null
              ? null
              : WardModel(wardId: detailNew!.wardId, name: detailNew!.wardName),
          street: detailNew!.address);
      _bloc.setAddressModel(_bloc.addressModel);
    }

    if (detailNew?.customerLeadReferId != null) {
      _bloc.presenterModel = CustomerModel(
          customerId: detailNew?.customerLeadReferId,
          fullName: detailNew?.customerLeadReferName ?? "");
    }

    var dataType_Source = await LeadConnection.getCustomerOption(context);
    if (dataType_Source != null) {
      customerOptonData = dataType_Source.data;
      customerSourcesData = customerOptonData!.source;

      customerTypeData.add(CustomerTypeModel(
          customerTypeName: customerOptonData!.customerType!.personal,
          customerTypeID: 1,
          selected: false));
      customerTypeData.add(CustomerTypeModel(
          customerTypeName: customerOptonData!.customerType!.business,
          customerTypeID: 2,
          selected: false));
    }

    var dataProvinces = await LeadConnection.getProvince(context);
    if (dataProvinces != null) {
      provinces = dataProvinces;
      print(provinces);
    }

    var pipelines = await LeadConnection.getPipeline(context);
    if (pipelines != null) {
      pipeLineData = pipelines.data;
    }

    var journeys = await LeadConnection.getJourney(context,
        GetJourneyModelRequest(pipelineCode: [requestModel.journeyCode]));
    if (journeys != null) {
      journeysData = journeys.data;
    }

    var response = await LeadConnection.workListStaff(
        context, WorkListStaffRequestModel(manageProjectId: null));
    if (response != null) {
      _modelStaff = response.data ?? [];
    } else {
      _modelStaff = [];
    }

    ListBusinessAreasModelResponse? model =
        await LeadConnection.getListBusinessAreas(context);

    if (model != null) {
      listBusinessData = model.data;
    }

    PositionResponseModel? positions =
        await LeadConnection.getPosition(context);
    if (positions != null) {
      positionData = positions.data;
    }

    var tags = await LeadConnection.getTag(context);
    if (tags != null) {
      tagsData = tags.data;

      if (detailPotential.tagId!.length > 0) {
        for (int i = 0; i < detailPotential.tagId!.length; i++) {
          try {
            tagsData!
                .firstWhereOrNull(
                    (element) => element.tagId == detailPotential.tagId![i])
                ?.selected = true;
          } catch (e) {}
        }

        for (int i = 0; i < tagsData!.length; i++) {
          if (tagsData![i].selected!) {
            // widget.detailDeal.tag.add(tagsSelected[i].tagId);
            if (tagsString == "") {
              tagsString = tagsData![i].name ?? "";
            } else {
              tagsString += ", ${tagsData![i].name}";
            }
          }
        }
      }
    }

    var listStaff = await LeadConnection.workListStaff(
        context, WorkListStaffRequestModel(manageProjectId: null));
    if (listStaff != null) {
      _modelStaff = listStaff.data ?? [];

      try {
        var item = _modelStaff.firstWhereOrNull(
            (element) => element.staffId == detailPotential.saleId);
        if (item != null) {
          _modelStaffSelected.add(item);
        } else {
          _modelStaffSelected = [];
        }
      } catch (e) {}
    }

    initModel();
  }

  void initModel() async {
    _fullNameText.text = detailPotential.fullName ?? "";
    _phoneNumberText.text = detailPotential.phone ?? "";
    _emailText.text = detailPotential.email ?? "";
    _representativeText.text = detailPotential.representative ?? "";
    _taxText.text = detailPotential.taxCode ?? "";

    try {
      var itemCustomerType = customerTypeData.firstWhereOrNull((element) =>
          element.customerTypeName!.toLowerCase() ==
          (detailPotential.customerType ?? "").toLowerCase());
      if (itemCustomerType != null) {
        itemCustomerType.selected = true;
        customerTypeSelected = itemCustomerType;
        selectedPersonal =
            itemCustomerType.customerTypeName == "Personal" ? true : false;
      }
    } catch (_) {}

    try {
      var itemCustomerSource = customerSourcesData!.firstWhereOrNull(
          (element) =>
              element.customerSourceId ==
              (detailPotential.customerSource ?? 0));
      if (itemCustomerSource != null) {
        itemCustomerSource.selected = true;
        customerSourceSelected = itemCustomerSource;
      }
    } catch (e) {}
    try {
      var itemPipeline = pipeLineData!.firstWhereOrNull((element) =>
          element.pipelineCode == (detailPotential.pipelineCode ?? 0));
      if (itemPipeline != null) {
        itemPipeline.selected = true;
        pipelineSelected = itemPipeline;
      }
    } catch (e) {}

    var journeys = await LeadConnection.getJourney(context,
        GetJourneyModelRequest(pipelineCode: [detailPotential.pipelineCode]));
    if (journeys != null) {
      journeysData = journeys.data;

      try {
        var itemJourney = journeysData!.firstWhereOrNull(
            (element) => element.journeyCode == detailPotential.journeyCode);
        if (itemJourney != null) {
          itemJourney.selected = true;
          journeySelected = itemJourney;
        }
      } catch (e) {}
    }
    Navigator.of(context).pop();

    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(() {});
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
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
      onTap: () {
        keyboardDismissOnTap(context);
      },
      child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: AppColors.primaryColor,
            title: Text(
              AppLocalizations.text(LangKey.editPotential)!,
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            // leadingWidth: 20.0,
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
          // separator: const Divider(),
          children: _listWidget(),
        )),
        Visibility(visible: !_isKeyboardVisible, child: _buildButton()),
        Container(
          height: 20.0,
        )
      ],
    );
  }

  List<Widget> _listWidget() {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.text(LangKey.customerInformation)!,
            style: TextStyle(
                fontSize: AppTextSizes.size16,
                color: const Color(0xFF0067AC),
                fontWeight: FontWeight.normal),
          ),

          Container(
            height: 10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  customerTypeSelected = customerTypeData[0];
                  selectedPersonal = true;
                  setState(() {});
                },
                child: Container(
                  height: 42.0,
                  width: MediaQuery.of(context).size.width / 2 - 19,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: selectedPersonal
                          ? AppColors.primaryColor
                          : Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.3),
                        )
                      ]),
                  child: Center(
                    child: Text(
                      AppLocalizations.text(LangKey.personal)!,
                      style: TextStyle(
                          color: selectedPersonal
                              ? Colors.white
                              : Color(0xFF8E8E8E),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  customerTypeSelected = customerTypeData[1];
                  selectedPersonal = false;
                  setState(() {});
                },
                child: Container(
                  height: 42.0,
                  width: MediaQuery.of(context).size.width / 2 - 19,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: !selectedPersonal
                          ? AppColors.primaryColor
                          : Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.3),
                        )
                      ]),
                  child: Center(
                    child: Text(
                      AppLocalizations.text(LangKey.business)!,
                      style: TextStyle(
                          color: !selectedPersonal
                              ? Colors.white
                              : Color(0xFF8E8E8E),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              )
            ],
          ),

          SizedBox(
            height: 15.0,
          ),

          // nhap ten doanh nghiep/ ca nhan
          _buildTextField(
              selectedPersonal
                  ? AppLocalizations.text(LangKey.inputFullname)
                  : AppLocalizations.text(LangKey.enterBusiness),
              "",
              selectedPersonal ? Assets.iconPerson : Assets.iconProvince,
              true,
              false,
              true,
              fillText: _fullNameText,
              focusNode: _fullnameFocusNode),
          // nguồn khách hàng
          _buildTextField(
              AppLocalizations.text(LangKey.customerSource),
              customerSourceSelected.sourceName ?? "",
              Assets.iconSourceCustomer,
              false,
              true,
              false, ontap: () async {
            FocusScope.of(context).unfocus();
            CustomerOptionSource? source = await showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return GestureDetector(
                    child: CustomerSourceModal(
                      sources: customerSourcesData,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    behavior: HitTestBehavior.opaque,
                  );
                });
            if (source != null) {
              customerSourceSelected = source;
              detailPotential.customerSource =
                  customerSourceSelected.customerSourceId;
              setState(() {});
            }
          }),
          // Nhập ma so thue
          !selectedPersonal
              ? _buildTextField(AppLocalizations.text(LangKey.tax), "",
                  Assets.iconTax, false, false, true,
                  fillText: _taxText, focusNode: _taxFocusNode)
              : Container(),

          checkVisibilityKey(VisibilityWidgetName.LE000003)
              ? _buildTextField(AppLocalizations.text(LangKey.inputPhonenumber),
                  "", Assets.iconCall, true, false, true,
                  fillText: _phoneNumberText,
                  focusNode: _phoneNumberFocusNode,
                  inputType: TextInputType.phone)
              : Container(),

          checkVisibilityKey(VisibilityWidgetName.LE000003)
              ? _buildAddPhone()
              : Container(),

          // email
          checkVisibilityKey(VisibilityWidgetName.LE000003)
              ? _buildTextField(AppLocalizations.text(LangKey.email), "",
                  Assets.iconEmail, false, false, true,
                  fillText: _emailText, focusNode: _emailFocusNode)
              : Container(),
          // chọn pipeline
          _buildTextField(
              AppLocalizations.text(LangKey.choosePipeline),
              pipelineSelected.pipelineName ?? "",
              Assets.iconChance,
              true,
              true,
              false, ontap: () async {
            FocusScope.of(context).unfocus();
            print("Pipeline");
            PipelineData? pipeline = await showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return GestureDetector(
                    child: PipelineModal(
                      pipeLineData: pipeLineData,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    behavior: HitTestBehavior.opaque,
                  );
                });
            if (pipeline != null) {
              if (pipelineSelected.pipelineName != pipeline.pipelineName) {
                journeySelected = null;
              }

              pipelineSelected = pipeline;
              detailPotential.pipelineCode = pipelineSelected.pipelineCode;
              detailPotential.journeyCode = "";
              LeadConnection.showLoading(context);
              var journeys = await LeadConnection.getJourney(
                  context,
                  GetJourneyModelRequest(
                      pipelineCode: [pipelineSelected.pipelineCode]));
              Navigator.of(context).pop();
              if (journeys != null) {
                journeysData = journeys.data;
              }
              setState(() {});
            }
          }),

          // chọn hành trình
          _buildTextField("Chọn hành trình", journeySelected?.journeyName ?? "",
              Assets.iconItinerary, true, true, false, ontap: () async {
            print("Chọn hành trình");

            FocusScope.of(context).unfocus();
            JourneyData? journey = await CustomNavigator.showCustomBottomDialog(
              context,
              JourneyModal(journeys: journeysData),
            );

            if (journey != null) {
              journeySelected = journey;
              detailPotential.journeyCode = journeySelected!.journeyCode;
              setState(() {});
            }
          }),

          // Chọn người được phân bổ
          _buildTextField(
              AppLocalizations.text(LangKey.chooseAllottedPerson),
              (_modelStaffSelected.length > 0)
                  ? _modelStaffSelected[0].staffName ?? ""
                  : "",
              Assets.iconName,
              false,
              true,
              false, ontap: () async {
            FocusScope.of(context).unfocus();
            print("Chọn người được phân bổ");

            List<WorkListStaffModel>? _model =
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PickOneStaffScreen(
                          models: _modelStaffSelected,
                        )));

            if (_model != null && _model.length > 0) {
              print(_modelStaffSelected);
              _modelStaffSelected = _model;
              detailPotential.saleId = _modelStaffSelected[0].staffId;
              detailPotential.position = _modelStaffSelected[0].departmentName;
              setState(() {});
            }
          }),

          // Chọn chi nhánh
          _buildTextField(
              "Chọn chi nhánh",
              _bloc.branchSelected?.branchName ?? "",
              Assets.iconName,
              true,
              true,
              false, ontap: () async {
            FocusScope.of(context).unfocus();
            _bloc.getBranch(context).then((val) async {
              if (val != null) {
                BranchData? data = await CustomNavigator.showCustomBottomDialog(
                  context,
                  BranchModal(datas: _bloc.listBranch),
                );
                if (data != null) {
                  _bloc.branchSelected = data;
                  setState(() {});
                }
              }
            });
          }),

          _buildAddress(),

          // nhóm khách hàng
          _buildTextField(
              "Chọn nhóm khách hàng",
              _bloc.customerGroupSelected?.groupName ?? "",
              Assets.iconName,
              false,
              true,
              false, ontap: () async {
            FocusScope.of(context).unfocus();
            _bloc.getCustomerGroup(context).then((val) async {
              if (val != null) {
                CustomerGroupData? data =
                    await CustomNavigator.showCustomBottomDialog(
                  context,
                  GroupCustomerModal(datas: _bloc.listCustomerGroupData),
                );
                if (data != null) {
                  _bloc.customerGroupSelected = data;
                  setState(() {});
                }
                return;
              }
            });
          }),

          // // Nhập người giới thiệu
          // _buildTextField("Nhập người giới thiệu", "", Assets.iconSearch, false,
          //     false, true,
          //     fillText: _bloc.referrerController,
          //     focusNode: _bloc.referrerFocusNode),

          _buildTextField(AppLocalizations.text(LangKey.chooseCards),
              tagsString, Assets.iconTag, false, true, false, ontap: () async {
            print("Tag");
            FocusScope.of(context).unfocus();

            List<int?> tagsSeletecd = [];

            var listTagsSelected = await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => TagsModal(tagsData: tagsData)));
            if (listTagsSelected != null) {
              // widget.detailDeal.tag = [];
              tagsString = "";
              tagsData = listTagsSelected;

              for (int i = 0; i < tagsData!.length; i++) {
                if (tagsData![i].selected!) {
                  tagsSeletecd.add(tagsData![i].tagId);

                  if (tagsString == "") {
                    tagsString = tagsData![i].name ?? "";
                  } else {
                    tagsString += ", ${tagsData![i].name}";
                  }
                }
              }
              detailPotential.tagId = tagsSeletecd;
              setState(() {});
            }
          }),

          _buildPresenter(),

          !showMoreAddress
              ? InkWell(
                  onTap: () {
                    showMoreAddress = true;
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                            width: 1.0,
                            color: Colors.blue,
                            style: BorderStyle.solid)),
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
                )
              : Container(),

          // Tỉnh/ thành phố
          showMoreAddress
              ? BuildMoreAddressEditPotential(
                  provinces: provinces,
                  requestModel: requestModel,
                  detailPotential: detailPotential,
                  modelStaff: _modelStaff,
                  selectedPersonal: selectedPersonal,
                  listBusinessData: listBusinessData,
                  positionData: positionData,
                  bloc: _bloc,
                )
              : Container()
        ],
      ),
    ];
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

  Widget _buildButton() {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () async {
          if (_phoneNumberText.text.isNotEmpty) {
            if ((!Validators().isValidPhone(_phoneNumberText.text.trim())) &&
                (!Validators().isNumber(_phoneNumberText.text.trim()))) {
              LeadConnection.showMyDialog(context,
                  AppLocalizations.text(LangKey.phoneNumberNotCorrectFormat),
                  warning: true);
              return;
            }
          }

          if (detailPotential.contactPhone!.isNotEmpty) {
            if ((!Validators()
                    .isValidPhone(detailPotential.contactPhone!.trim())) &&
                (!Validators()
                    .isNumber(detailPotential.contactPhone!.trim()))) {
              LeadConnection.showMyDialog(
                  context, "Số điện thoại người liên hệ không đúng định dạng",
                  warning: true);
              return;
            }
          }

          if (_fullNameText.text == "" ||
              detailPotential.pipelineCode == "" ||
              detailPotential.journeyCode == "" ||
              detailPotential.saleId == 0 ||
              _bloc.branchSelected == null) {
            LeadConnection.showMyDialog(context,
                AppLocalizations.text(LangKey.warningChooseAllRequiredInfo),
                warning: true);
            return;
          }

          if (_bloc.images.length > 0) {
            await _bloc.uploadFileAWS(_bloc.images[0]).then((value) {
              if (value != "") {
                _bloc.imgAvatar = value;
              }
              editPotential(customerTypeSelected.customerTypeID ?? 0);
            });
          } else {
            await editPotential(customerTypeSelected.customerTypeID ?? 0);
          }
        },
        child: Center(
          child: Text(
            AppLocalizations.text(LangKey.editPotential)!,
            style: TextStyle(
                fontSize: 12.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ),
      ),
    );
  }

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
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text("+ Thêm số điện thoại",
                  style: AppTextStyles.style14BlueWeight500),
            ),
          ),
        )
      ],
    );
  }

  _buildListPhone() {
    return (_bloc.listPhone.isNotEmpty)
        ? Container(
            child: Column(
              children: [
                ..._bloc.listPhone.map((item) => _phoneItem(item)).toList()
              ],
            ),
          )
        : SizedBox();
  }

  _phoneItem(String phone) {
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
                padding: EdgeInsets.all(8.0),
                child: Image.asset(
                  Assets.iconCall,
                  width: 16,
                ),
              ),
              Text(
                phone,
                style: AppTextStyles.style14BlackWeight500,
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                padding: EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(
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
        SizedBox(
          height: 8.0,
        )
      ],
    );
  }

  Widget _buildTextField(String? title, String? content, String icon,
      bool mandatory, bool dropdown, bool textfield,
      {GestureTapCallback? ontap,
      TextEditingController? fillText,
      FocusNode? focusNode,
      TextInputType? inputType}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: (ontap != null) ? ontap : null,
        child: TextField(
          enabled: textfield,
          readOnly: !textfield,
          controller: fillText,
          focusNode: focusNode,
          keyboardType: (inputType != null) ? inputType : TextInputType.text,
          decoration: InputDecoration(
            isCollapsed: false,
            contentPadding: EdgeInsets.all(12.0),
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: Color.fromARGB(255, 230, 21, 84)),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xFFB8BFC9)),
            ),
            label: (content == "")
                ? RichText(
                    text: TextSpan(
                        text: title,
                        style: TextStyle(
                            fontSize: AppTextSizes.size15,
                            color: const Color(0xFF858080),
                            fontWeight: FontWeight.normal),
                        children: [
                        if (mandatory)
                          TextSpan(
                              text: "*", style: TextStyle(color: Colors.red))
                      ]))
                : Text(
                    content!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset(
                icon,
              ),
            ),
            prefixIconConstraints:
                BoxConstraints(maxHeight: 32.0, maxWidth: 32.0),
            suffixIcon: dropdown
                ? Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset(
                      Assets.iconDropDown,
                    ),
                  )
                : Container(),
            suffixIconConstraints:
                BoxConstraints(maxHeight: 32.0, maxWidth: 32.0),
            isDense: true,
          ),
          onChanged: (event) {
            print(event.toLowerCase());
            if (fillText == _fullNameText) {
              detailPotential.fullName = _fullNameText.text;
            } else if (fillText == _phoneNumberText) {
              detailPotential.phone = _phoneNumberText.text;
            } else if (fillText == _emailText) {
              detailPotential.email = _emailText.text;
            } else if (fillText == _taxText) {
              detailPotential.taxCode = _taxText.text;
            } else if (fillText == _representativeText) {
              detailPotential.representative = _representativeText.text;
            }
          },
        ),
      ),
    );
  }

  Future<void> editPotentialPersonal() async {
    print(detailPotential);
    print("theemmm khtn");

    if (detailPotential.phone!.isNotEmpty) {
      if ((!Validators().isValidPhone(_phoneNumberText.text.trim())) &&
          (!Validators().isNumber(_phoneNumberText.text.trim()))) {
        print("so dien thoai sai oy");
        LeadConnection.showMyDialog(
            context, AppLocalizations.text(LangKey.phoneNumberNotCorrectFormat),
            warning: true);
        return;
      }
    }

    if (_fullNameText.text == "" ||
        _phoneNumberText.text == "" ||
        detailPotential.pipelineCode == "" ||
        detailPotential.journeyCode == "" ||
        detailPotential.saleId == 0) {
      LeadConnection.showMyDialog(
          context, AppLocalizations.text(LangKey.warningChooseAllRequiredInfo),
          warning: true);
    } else {
      LeadConnection.showLoading(context);
      DescriptionModelResponse? result = await LeadConnection.updateLead(
          context,
          EditPotentialRequestModel(
            customerLeadCode: widget.detailPotential!.customerLeadCode ?? "",
            avatar: "",
            customerType: "personal",
            customerSource: detailPotential.customerSource,
            fullName: _fullNameText.text,
            taxCode: "",
            phone: detailPotential.phone,
            email: detailPotential.email,
            representative: "",
            pipelineCode: pipelineSelected.pipelineCode,
            journeyCode: journeySelected!.journeyCode,
            saleId: detailPotential.saleId,
            tagId: detailPotential.tagId,
            gender: detailPotential.gender,
            birthday: detailPotential.birthday,
            bussinessId: 0,
            employees: 0,
            address: detailPotential.address,
            provinceId: detailPotential.provinceId,
            districtId: detailPotential.districtId,
            wardId: detailPotential.wardId,
            businessClue: detailPotential.businessClue,
            zalo: detailPotential.zalo ?? "",
            fanpage: detailPotential.fanpage ?? "",
            contactAddress: "",
            contactEmail: "",
            contactFullName: "",
            contactPhone: "",
            position: detailPotential.position,
            customerGroupId: _bloc.customerGroupSelected?.customerGroupId ?? 0,
            branchId: _bloc.branchSelected?.branchId ?? 0,
            note: _bloc.noteController.text,
            customerLeadReferId: _bloc.presenterModel?.customerId ?? 0,
            arrPhoneAttack: _bloc.listPhone,
            website: _bloc.websiteController.text,
          ));
      Navigator.of(context).pop();
      if (result != null) {
        if (result.errorCode == 0) {
          print(result.errorDescription);

          await LeadConnection.showMyDialog(context, result.errorDescription);

          Navigator.of(context).pop(true);
        } else {
          LeadConnection.showMyDialog(context, result.errorDescription);
        }
      }
    }
  }

  Future<void> editPotential(int customerTypeID) async {
    bool typePersonnal = customerTypeID == 1;
    LeadConnection.showLoading(context);
    DescriptionModelResponse? result = await LeadConnection.updateLead(
        context,
        EditPotentialRequestModel(
          customerLeadCode: widget.detailPotential!.customerLeadCode,
          avatar: _bloc.imgAvatar ?? "",
          customerType: typePersonnal ? "personal" : "business",
          customerSource: detailPotential.customerSource,
          fullName: _fullNameText.text,
          taxCode: typePersonnal ? "" : _taxText.text,
          phone: _phoneNumberText.text,
          email: _emailText.text,
          representative: typePersonnal ? "" : _representativeText.text,
          pipelineCode: detailPotential.pipelineCode,
          journeyCode: detailPotential.journeyCode,
          saleId: detailPotential.saleId,
          tagId: detailPotential.tagId,
          gender: detailPotential.gender,
          birthday: detailPotential.birthday,
          bussinessId: typePersonnal ? 0 : detailPotential.bussinessId,
          employees: typePersonnal ? 0 : detailPotential.employees,
          address: "${_bloc.addressModel?.street ?? ""} ",
          provinceId: _bloc.addressModel?.provinceModel?.provinceid ?? 0,
          districtId: _bloc.addressModel?.districtModel?.districtid ?? 0,
          wardId: _bloc.addressModel?.wardModel?.wardId ?? 0,
          businessClue: detailPotential.businessClue,
          zalo: detailPotential.zalo ?? "",
          fanpage: detailPotential.fanpage ?? "",
          contactAddress: typePersonnal ? "" : detailPotential.contactAddress,
          contactEmail: typePersonnal ? "" : detailPotential.contactEmail,
          contactFullName: typePersonnal ? "" : detailPotential.contactFullName,
          contactPhone: typePersonnal ? "" : detailPotential.contactPhone,
          position: typePersonnal ? "" : detailPotential.position,
          customerGroupId: _bloc.customerGroupSelected?.customerGroupId ?? 0,
          branchId: _bloc.branchSelected?.branchId ?? 0,
          note: _bloc.noteController.text,
          customerLeadReferId: 0,
          arrPhoneAttack: _bloc.listPhone,
          website: _bloc.websiteController.text,
        ));
    Navigator.of(context).pop();
    if (result != null) {
      if (result.errorCode == 0) {
        print(result.errorDescription);

        await LeadConnection.showMyDialog(context, result.errorDescription);

        Navigator.of(context).pop(true);
      } else {
        LeadConnection.showMyDialog(context, result.errorDescription);
      }
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/customer_type.dart';
import 'package:lead_plugin_epoint/model/request/add_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/request/edit_potential_model_request.dart';
import 'package:lead_plugin_epoint/model/request/get_journey_model_request.dart';
import 'package:lead_plugin_epoint/model/request/get_list_staff_request_model.dart';
import 'package:lead_plugin_epoint/model/response/add_lead_model_response.dart';
import 'package:lead_plugin_epoint/model/response/description_model_response.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';
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
import 'package:lead_plugin_epoint/presentation/modal/customer_source_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/journey_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/pipeline_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/tag_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/edit_potential_customer/build_more_address_edit_potential.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/pick_one_staff_screen/ui/pick_one_staff_screen.dart';

import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';

class EditPotentialCustomer extends StatefulWidget {
  DetailPotentialData detailPotential;
  String customer_lead_code;
  EditPotentialCustomer({Key key, this.detailPotential, this.customer_lead_code}) : super(key: key);

  @override
  _EditPotentialCustomerState createState() => _EditPotentialCustomerState();
}

class _EditPotentialCustomerState extends State<EditPotentialCustomer>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;

  final ScrollController _controller = ScrollController();
  final TextEditingController _fullNameText = TextEditingController();
  final TextEditingController _phoneNumberText = TextEditingController();

  FocusNode _fullnameFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();

  TextEditingController _businessText = TextEditingController();
  FocusNode _businessFocusNode = FocusNode();

  TextEditingController _taxText = TextEditingController();
  FocusNode _taxFocusNode = FocusNode();

  TextEditingController _emailText = TextEditingController();
  FocusNode _emailFocusNode = FocusNode();

  TextEditingController _representativeText = TextEditingController();
  FocusNode _representativeFocusNode = FocusNode();

  bool showMoreAddress = false;
  bool showMoreAll = false;
  bool selectedPersonal = true;

  String _imgAvatar = "";
  File _image;
  PickedFile _pickedFile;
  final _picker = ImagePicker();

  AddLeadModelRequest requestModel = AddLeadModelRequest();
  List<ProvinceData> provinces = <ProvinceData>[];
  List<DistrictData> districts = <DistrictData>[];
  List<WardData> wards = <WardData>[];

  CustomerOptionData customerOptonData = CustomerOptionData();
  List<CustomerOptionSource> customerSourcesData = <CustomerOptionSource>[];
  CustomerOptionSource customerSourceSelected = CustomerOptionSource();

  List<PipelineData> pipeLineData = <PipelineData>[];
  PipelineData pipelineSelected = PipelineData();

  List<GetStatusWorkData> statusWorkData = [];
  GetStatusWorkData statusWorkSelected = GetStatusWorkData();

  List<JourneyData> journeysData = <JourneyData>[];
  JourneyData journeySelected = JourneyData();

  List<CustomerTypeModel> customerTypeData = <CustomerTypeModel>[];
  CustomerTypeModel customerTypeSelected = CustomerTypeModel();

  List<AllocatorData> allocatorData = <AllocatorData>[];

  List<WorkListStaffModel> _modelStaff = [];

  List<WorkListStaffModel> _modelStaffSelected = [];

   List<ListBusinessAreasItem> listBusinessData;

  List<TagData> tagsData;

  String tagsString = "";

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      LeadConnection.showLoading(context);

      if (widget.detailPotential != null) {
        detailPotential = AddLeadModelRequest(
            avatar: "",
            customerType: widget.detailPotential.customerType ?? "",
            customerSource: widget.detailPotential.customerSource ?? "",
            fullName: widget.detailPotential.fullName ?? "",
            taxCode: widget.detailPotential.taxCode,
            phone: widget.detailPotential.phone ?? "",
            email: widget.detailPotential.email ?? "",
            representative: widget.detailPotential.representative ?? "",
            pipelineCode: widget.detailPotential.pipelineCode ?? 0,
            journeyCode: widget.detailPotential.journeyCode ?? 0,
            saleId: widget.detailPotential.saleId ?? 0,
            tagId: [],
            gender: widget.detailPotential.gender ?? "",
            bussinessId: widget.detailPotential.bussinessId ?? 0,
            businessClue: "",
            birthday: widget.detailPotential.birthday ?? "",
            employees:  widget.detailPotential.employees ?? 0,
            position: widget.detailPotential.position ?? "",
            provinceId: widget.detailPotential.provinceId ?? 0,
            districtId: widget.detailPotential.districtId ?? 0,
            wardId: widget.detailPotential.wardId ?? 0,
            address: widget.detailPotential.address ?? "",
            zalo: widget.detailPotential.zalo ?? "",
            fanpage: widget.detailPotential.fanpage ?? "",
            contactFullName: widget.detailPotential.contactList.length > 0 ? widget.detailPotential.contactList[0].fullName ?? "" : "",
            contactPhone: widget.detailPotential.contactList.length > 0 ? widget.detailPotential.contactList[0].phone ?? "": "",
            contactEmail: widget.detailPotential.contactList.length > 0 ? widget.detailPotential.contactList[0].email ?? "": "",
            contactAddress: widget.detailPotential.contactList.length > 0 ? widget.detailPotential.contactList[0].address ?? "": "");

            if (widget.detailPotential.tag.length > 0) {
              for (int i = 0; i < widget.detailPotential.tag.length; i++) {
                detailPotential.tagId.add(widget.detailPotential.tag[i].tagId);
              }
            };
      } else {

        DetailPotentialModelResponse dataDetail = await LeadConnection.getdetailPotential( context, widget.customer_lead_code);
    // var dataDetail = await LeadConnection.getdetailPotential( context, "LEAD_08112022190");
    if (dataDetail != null) {
      if (dataDetail.errorCode == 0) {
         detailPotential = AddLeadModelRequest(
            avatar: "",
            customerType: dataDetail.data.customerType ?? "",
            customerSource: dataDetail.data.customerSource ?? "",
            fullName: dataDetail.data.fullName ?? "",
            taxCode: dataDetail.data.taxCode,
            phone: dataDetail.data.phone ?? "",
            email: dataDetail.data.email ?? "",
            representative: dataDetail.data.representative ?? "",
            pipelineCode: dataDetail.data.pipelineCode ?? 0,
            journeyCode: dataDetail.data.journeyCode ?? 0,
            saleId: dataDetail.data.saleId ?? 0,
            tagId: [],
            gender: dataDetail.data.gender ?? "",
            bussinessId: dataDetail.data.bussinessId ?? 0,
            businessClue: "",
            birthday: dataDetail.data.birthday ?? "",
            employees:  dataDetail.data.employees ?? 0,
            position: dataDetail.data.position ?? "",
            provinceId: dataDetail.data.provinceId ?? 0,
            districtId: dataDetail.data.districtId ?? 0,
            wardId: dataDetail.data.wardId ?? 0,
            address: dataDetail.data.address ?? "",
            zalo: dataDetail.data.zalo ?? "",
            fanpage: dataDetail.data.fanpage ?? "",
            contactFullName: dataDetail.data.contactList.length > 0 ? dataDetail.data.contactList[0].fullName ?? "" : "",
            contactPhone: dataDetail.data.contactList.length > 0 ? dataDetail.data.contactList[0].phone ?? "": "",
            contactEmail: dataDetail.data.contactList.length > 0 ? dataDetail.data.contactList[0].email ?? "": "",
            contactAddress: dataDetail.data.contactList.length > 0 ? dataDetail.data.contactList[0].address ?? "": "");

            if (dataDetail.data.tag.length > 0) {
              for (int i = 0; i < dataDetail.data.tag.length; i++) {
                detailPotential.tagId.add(dataDetail.data.tag[i].tagId);
              }
            };
        setState(() {});
      } else {
        await LeadConnection.showMyDialog(context, dataDetail.errorDescription);
        Navigator.of(context).pop();
      }
    }

      }

      

      await callApi();
    });
  }

  void callApi() async {
    var dataType_Source = await LeadConnection.getCustomerOption(context);
    if (dataType_Source != null) {
      customerOptonData = dataType_Source.data;
      customerSourcesData = customerOptonData.source;

      customerTypeData.add(CustomerTypeModel(
          customerTypeName: customerOptonData.customerType.personal,
          customerTypeID: 1,
          selected: false));
      customerTypeData.add(CustomerTypeModel(
          customerTypeName: customerOptonData.customerType.business,
          customerTypeID: 2,
          selected: false));
    }

    var dataProvinces = await LeadConnection.getProvince(context);
    if (dataProvinces != null) {
      provinces = dataProvinces.data;
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

    ListBusinessAreasModelResponse model =
          await LeadConnection.getListBusinessAreas(context);
     
      if (model != null) {
        listBusinessData = model.data;
      }
      

    var tags = await LeadConnection.getTag(context);
    if (tags != null) {
      tagsData = tags.data;

      if (detailPotential.tagId.length > 0) {
        for (int i = 0; i < detailPotential.tagId.length; i++) {
          try {
            tagsData
                .firstWhere(
                    (element) => element.tagId == detailPotential.tagId[i])
                .selected = true;
          } catch (e) {}
        }

        for (int i = 0; i < tagsData.length; i++) {
          if (tagsData[i].selected) {
            // widget.detailDeal.tag.add(tagsSelected[i].tagId);
            if (tagsString == "") {
              tagsString = tagsData[i].name;
            } else {
              tagsString += ", ${tagsData[i].name}";
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
        var item = _modelStaff.firstWhere((element) => element.staffId == detailPotential.saleId);
    if (item != null) {
      _modelStaffSelected.add(item);
    } else {
      _modelStaffSelected = [];
    }
      } catch (e) {
      }
    }


    initModel();
  }

  void initModel() async {
    _fullNameText.text = detailPotential?.fullName ?? "";
    _phoneNumberText.text = detailPotential?.phone ?? "";
    _emailText.text = detailPotential.email ?? "";
    _representativeText.text = detailPotential.representative;
    _taxText.text = detailPotential.taxCode;

    // for (int i = 0; i < customerTypeData.length; i++) {
    //   if ((widget.detailPotential?.customerType ?? "").toLowerCase() ==
    //       customerTypeData[i].customerTypeName.toLowerCase()) {
    //     customerTypeData[i].selected = true;
    //     customerTypeSelected = customerTypeData[i];
    //   } else {
    //     customerTypeData[i].selected = false;
    //   }
    // }

    // try {
    //   customerTypeData.firstWhere((element) => element.selected).selected = false;
    // } catch (_) {}

    try {
      var itemCustomerType = customerTypeData.firstWhere((element) =>
          element.customerTypeName.toLowerCase() ==
          (detailPotential?.customerType ?? "").toLowerCase());
      if (itemCustomerType != null) {
        itemCustomerType.selected = true;
        customerTypeSelected = itemCustomerType;
        selectedPersonal = itemCustomerType.customerTypeName == "Personal" ? true : false;
      }

      // var itemCustomerSource = customerSourcesData.firstWhere((element) =>
      //     element.customerSourceId == (detailPotential?.customerSource ?? 0));
      // if (itemCustomerSource != null) {
      //   itemCustomerSource.selected = true;
      // }

      // var itemPipeline = pipeLineData.firstWhere((element) =>
      //     element.pipelineCode == (detailPotential?.pipelineCode ?? 0));
      // if (itemPipeline != null) {
      //   itemPipeline.selected = true;
      // }


    } catch (_) {}

    try {
      var itemCustomerSource = customerSourcesData.firstWhere((element) =>
          element.customerSourceId == (detailPotential?.customerSource ?? 0));
      if (itemCustomerSource != null) {
        itemCustomerSource.selected = true;
        customerSourceSelected = itemCustomerSource;
      }
    } catch (e) {
    }
    try {
        var itemPipeline = pipeLineData.firstWhere((element) =>
          element.pipelineCode == (detailPotential?.pipelineCode ?? 0));
      if (itemPipeline != null) {
        itemPipeline.selected = true;
        pipelineSelected = itemPipeline;
      }
    } catch (e) {
    }

    // for (int i = 0; i < customerSourcesData.length; i++) {
    //   if ((widget.detailPotential?.customerSourceName ?? "").toLowerCase() ==
    //       customerSourcesData[i].sourceName.toLowerCase()) {
    //     customerSourcesData[i].selected = true;
    //     customerSourceSelected = customerSourcesData[i];
    //   } else {
    //     customerSourcesData[i].selected = false;
    //   }
    // }

    // for (int i = 0; i < pipeLineData.length; i++) {
    //   if ((widget.detailPotential?.pipelineName ?? "").toLowerCase() ==
    //       pipeLineData[i].pipelineName.toLowerCase()) {
    //     pipeLineData[i].selected = true;
    //     pipelineSelected = pipeLineData[i];
    //   } else {
    //     pipeLineData[i].selected = false;
    //   }
    // }

    var journeys = await LeadConnection.getJourney(context,
        GetJourneyModelRequest(pipelineCode: [detailPotential.pipelineCode]));
    if (journeys != null) {
      journeysData = journeys.data;

      try {
        var itemJourney = journeysData.firstWhere((element) =>
          element.journeyCode == detailPotential?.journeyCode ?? 0);
      if (itemJourney != null) {
        itemJourney.selected = true;
        journeySelected = itemJourney;
      }
      } catch (e) {
      }
    }

    // for (int i = 0; i < journeysData.length; i++) {
    //   if ((widget.detailPotential.journeyName ?? "").toLowerCase() ==
    //       journeysData[i].journeyName.toLowerCase()) {
    //     journeysData[i].selected = true;
    //     journeySelected = journeysData[i];
    //   } else {
    //     journeysData[i].selected = false;
    //   }
    // }

  

    Navigator.of(context).pop();

    setState(() {});
  }

  // Future<void> _pickImage() async {
  //   _pickedFile = await _picker.getImage(source: ImageSource.gallery);

  //   if (_pickedFile != null) {
  //     _image = File(_pickedFile.path);

  //     UploadImageModelResponse result =
  //         await LeadConnection.upload(context, _image);

  //     if (result != null) {
  //       _imgAvatar = result.data.link;
  //       setState(() {
  //         print(_image);
  //       });
  //     } else {
  //       LeadConnection.showMyDialog(
  //           context, AppLocalizations.text(LangKey.uploadImageFail));
  //     }
  //   }
  // }

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
              AppLocalizations.text(LangKey.editPotential),
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
            AppLocalizations.text(LangKey.customerInformation),
            style: TextStyle(
                fontSize: AppTextSizes.size16,
                color: const Color(0xFF0067AC),
                fontWeight: FontWeight.normal),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(8),
          //   child: Text(
          //     AppLocalizations.text(LangKey.picture),
          //     style: TextStyle(
          //         fontSize: AppTextSizes.size15,
          //         color: const Color(0xFF858080),
          //         fontWeight: FontWeight.normal),
          //   ),
          // ),

          // Center(
          //     child: Stack(
          //       clipBehavior: Clip.none,
          //       children: [
          //         InkWell(
          //   onTap: () {
          //         print("chon anh");
          //         _pickImage();
          //   },
          //   child: (_imgAvatar != "")
          //           ? _buildAvatarWithImage(_imgAvatar)
          //           : _buildAvatarImg(_fullNameText.text ?? ""),
          // ),

          // Positioned(
          //           left: 60,
          //           bottom: 55,
          //           child: InkWell(
          //             onTap: () {
          //               _imgAvatar = "";
          //               setState(() {

          //               });
          //             },
          //             child:  (_imgAvatar != "") ? Container(
          //               width: 20,
          //               height: 20,
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(100),
          //                   color: Colors.red
          //                   ),
          //               child: Center(child: Icon(Icons.clear, color: Colors.white,
          //               size: 15,)),
          //             ) : Container(),
          //           ))

          //       ],
          //     )),

          Container(
            height: 10,
          ),
          // Loại khách hàng
          // _buildTextField(
          //     AppLocalizations.text(LangKey.customerStyle),
          //     customerTypeSelected?.customerTypeName ?? "",
          //     Assets.iconStyleCustomer,
          //     true,
          //     true,
          //     false, ontap: () async {
          //   print("loại khách hàng");
          //   FocusScope.of(context).unfocus();

          //   CustomerTypeModel customerType = await showModalBottomSheet(
          //       context: context,
          //       useRootNavigator: true,
          //       isScrollControlled: true,
          //       backgroundColor: Colors.transparent,
          //       builder: (context) {
          //         return GestureDetector(
          //           child: CustomerTypeModal(
          //             customerTypeData: customerTypeData,
          //           ),
          //           onTap: () {
          //             Navigator.of(context).pop();
          //           },
          //           behavior: HitTestBehavior.opaque,
          //         );
          //       });
          //   if (customerType != null) {
          //     customerTypeSelected = customerType;
          //     setState(() {});
          //   }

          //   // print("loại khách hàng");
          // }),

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
                      AppLocalizations.text(LangKey.personal),
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
                      AppLocalizations.text(LangKey.business),
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
          // nguồn khách hàng
          _buildTextField(
              AppLocalizations.text(LangKey.customerSource),
              customerSourceSelected?.sourceName ?? "",
              Assets.iconSourceCustomer,
              false,
              true,
              false, ontap: () async {
            print("nguồn khách hàng");

            FocusScope.of(context).unfocus();

            CustomerOptionSource source = await showModalBottomSheet(
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
              detailPotential.customerSource = customerSourceSelected.customerSourceId;
              setState(() {});
            }
          }),
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

          // Nhập ma so thue
          !selectedPersonal
              ? _buildTextField(AppLocalizations.text(LangKey.tax), "",
                  Assets.iconTax, false, false, true,
                  fillText: _taxText, focusNode: _taxFocusNode)
              : Container(),

          

          _buildTextField(AppLocalizations.text(LangKey.inputPhonenumber), "",
              Assets.iconCall, false, false, true,
              fillText: _phoneNumberText,
              focusNode: _phoneNumberFocusNode,
              inputType: TextInputType.phone),

          // email
          _buildTextField(AppLocalizations.text(LangKey.email), "",
              Assets.iconEmail, false, false, true,
              fillText: _emailText, focusNode: _emailFocusNode),

          // người đại diện
          !selectedPersonal
              ? _buildTextField(AppLocalizations.text(LangKey.representative),
                  "", Assets.iconRepresentative, false, false, true,
                  fillText: _representativeText,
                  focusNode: _representativeFocusNode)
              : Container(),

          // chọn pipeline
          _buildTextField(
              AppLocalizations.text(LangKey.choosePipeline),
              pipelineSelected?.pipelineName ?? "",
              Assets.iconChance,
              true,
              true,
              false, ontap: () async {
            FocusScope.of(context).unfocus();
            print("Pipeline");
            PipelineData pipeline = await showModalBottomSheet(
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
              if (pipelineSelected?.pipelineName != pipeline.pipelineName) {
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
          _buildTextField(
              AppLocalizations.text(LangKey.chooseStatus),
              journeySelected?.journeyName ?? "",
              Assets.iconItinerary,
              true,
              true,
              false, ontap: () async {
            print("Chọn hành trình");

            FocusScope.of(context).unfocus();
            JourneyData journey = await CustomNavigator.showCustomBottomDialog(
              context,
              JourneyModal(journeys: journeysData),
            );

            if (journey != null) {
              journeySelected = journey;
              detailPotential.journeyCode = journeySelected.journeyCode;
              setState(() {
                // await LeadConnection.getDistrict(context, province.provinceid);
              });
            }
          }),

          // _buildTextField(
          //     AppLocalizations.text(LangKey.chooseStatus),
          //     statusWorkSelected?.manageStatusName ?? "",
          //     Assets.iconItinerary,
          //     false,
          //     true,
          //     false, ontap: () async {
          //   FocusScope.of(context).unfocus();

          //   if (statusWorkData.length == 0) {
          //     LeadConnection.showLoading(context);
          //     var statusWorkModel = await LeadConnection.getStatusWork(context);

          //     Navigator.of(context).pop();
          //     if (statusWorkModel != null) {
          //       statusWorkData = statusWorkModel.data;

          //       GetStatusWorkData status =
          //           await CustomNavigator.showCustomBottomDialog(
          //         context,
          //         StatusWorkModal(statusWorkData: statusWorkData),
          //       );
          //       if (status != null) {
          //         statusWorkSelected = status;
          //         setState(() {});
          //       }
          //     }
          //   } else {
          //     GetStatusWorkData status =
          //         await CustomNavigator.showCustomBottomDialog(
          //       context,
          //       StatusWorkModal(statusWorkData: statusWorkData),
          //     );
          //     if (status != null) {
          //       statusWorkSelected = status;
          //       setState(() {});
          //     }
          //   }
          // }),

          // Chọn người được phân bổ
          _buildTextField(
              AppLocalizations.text(LangKey.chooseAllottedPerson),
              (_modelStaffSelected != null && _modelStaffSelected.length > 0)
                  ? _modelStaffSelected[0]?.staffName ?? ""
                  : "",
              Assets.iconName,
              false,
              true,
              false, ontap: () async {
            FocusScope.of(context).unfocus();
            print("Chọn người được phân bổ");

            List<WorkListStaffModel> _model =
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

          _buildTextField(AppLocalizations.text(LangKey.chooseCards),
              tagsString, Assets.iconTag, false, true, false, ontap: () async {
            print("Tag");
            FocusScope.of(context).unfocus();

             List<int> tagsSeletecd = [];

            
              var listTagsSelected = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => TagsModal(tagsData: tagsData)));
              if (listTagsSelected != null) {
                // widget.detailDeal.tag = [];
                tagsString = "";
                tagsData = listTagsSelected;

                for (int i = 0; i < tagsData.length; i++) {
                  if (tagsData[i].selected) {
                    tagsSeletecd.add(tagsData[i].tagId);

                    if (tagsString == "") {
                      tagsString = tagsData[i].name;
                    } else {
                      tagsString += ", ${tagsData[i].name}";
                    }
                  }
                }
                detailPotential.tagId = tagsSeletecd;
                setState(() {});
              
            }
          }),

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
                  // allocatorData: allocatorData,
                  requestModel: requestModel,
                  detailPotential: detailPotential,
                  modelStaff: _modelStaff,
                  selectedPersonal: selectedPersonal,
                  listBusinessData: listBusinessData)
              : Container()
        ],
      ),
    ];
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
          print("edit khtn");
          print(detailPotential);

          if (customerTypeSelected.customerTypeID == 1) {
            await editPotentialPersonal();
          } else {
            await editPotentialBusiness();
          }
        },
        child: Center(
          child: Text(
            AppLocalizations.text(LangKey.editPotential),
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

  Widget _buildAvatarImg(String name) {
    return Container(
      width: 80.0,
      height: 80.0,
      padding: const EdgeInsets.all(2.0),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightGrey,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10000.0),
        child: CustomAvatar(
          name: name,
          textSize: AppTextSizes.size22,
        ),
      ),
    );
  }

  Widget _buildAvatarWithImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10000.0),
      child: FittedBox(
        child: Container(
          width: 80.0,
          height: 80.0,
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(1), BlendMode.dstATop),
                  image: NetworkImage(image))),
        ),
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildTextField(String title, String content, String icon,
      bool mandatory, bool dropdown, bool textfield,
      {Function ontap,
      TextEditingController fillText,
      FocusNode focusNode,
      TextInputType inputType}) {
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
            isCollapsed: true,
            contentPadding: EdgeInsets.all(12.0),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1, color: Color.fromARGB(255, 21, 230, 129)),
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
                    content,
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
                detailPotential?.phone = _phoneNumberText.text;
              } else if (fillText == _emailText) {
                detailPotential?.email = _emailText.text;
              } else if (fillText == _taxText) {
                detailPotential?.taxCode = _taxText.text;
              } else if (fillText == _representativeText) {
                detailPotential?.representative = _representativeText.text;
              }
          },
        ),
      ),
    );
  }

    Future<void> editPotentialPersonal() async {
    print(detailPotential);
    print("theemmm khtn");

    if (detailPotential.phone.isNotEmpty) {
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
        detailPotential.journeyCode == "" || detailPotential.saleId == 0) {
      LeadConnection.showMyDialog(
          context, AppLocalizations.text(LangKey.warningChooseAllRequiredInfo),
          warning: true);
    } else {
      LeadConnection.showLoading(context);
      DescriptionModelResponse result = await LeadConnection.updateLead(
          context,
          EditPotentialRequestModel(
            customerLeadCode: widget.detailPotential.customerLeadCode ?? "",
              avatar: "",
              customerType: "personal",
              customerSource: detailPotential.customerSource,
              fullName: _fullNameText.text,
              taxCode: "",
              phone: detailPotential.phone,
              email: detailPotential.email,
              representative : "",
              pipelineCode: pipelineSelected.pipelineCode,
              journeyCode: journeySelected.journeyCode,
              saleId:detailPotential.saleId,
              tagId:detailPotential.tagId,
              gender:detailPotential.gender,
              birthday:detailPotential.birthday,
              bussinessId:0,
              employees:0,
              address:detailPotential.address,
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
              position: detailPotential.position
              ));
      Navigator.of(context).pop();
      if (result != null) {
              if (result.errorCode == 0) {
                print(result.errorDescription);

                await LeadConnection.showMyDialog(
                    context, result.errorDescription);

                Navigator.of(context).pop(true);
              } else {
                LeadConnection.showMyDialog(context, result.errorDescription);
              }
            }
    }
  }

  Future<void> editPotentialBusiness() async {  
     print(detailPotential);
    print("Business");

    if (_phoneNumberText.text.isNotEmpty) {
      if ((!Validators().isValidPhone(_phoneNumberText.text.trim())) &&
          (!Validators().isNumber(_phoneNumberText.text.trim()))) {
        print("so dien thoai sai oy");
        LeadConnection.showMyDialog(
            context, AppLocalizations.text(LangKey.phoneNumberNotCorrectFormat),
            warning: true);
        return;
      }
    }

    if (detailPotential.contactPhone.isNotEmpty) {
      if ((!Validators().isValidPhone(detailPotential.contactPhone.trim())) &&
          (!Validators().isNumber(detailPotential.contactPhone.trim()))) {
        print("so dien thoai sai oy");
        LeadConnection.showMyDialog(
            context, "Số điện thoại người liên hệ không đúng định dạng" ,
            warning: true);
        return;
      }
    }

    if (_fullNameText.text == "" ||
        _phoneNumberText.text == "" ||
        detailPotential.pipelineCode == ""||
        detailPotential.journeyCode == "" || detailPotential.saleId == 0) {
      LeadConnection.showMyDialog(
          context, AppLocalizations.text(LangKey.warningChooseAllRequiredInfo),
          warning: true);
    } else {
      LeadConnection.showLoading(context);
      DescriptionModelResponse result = await LeadConnection.updateLead(
          context,
          EditPotentialRequestModel(
            customerLeadCode: widget.detailPotential.customerLeadCode,
              avatar: "",
              customerType: "business",
              customerSource: detailPotential.customerSource,
              fullName: _fullNameText.text,
              taxCode: detailPotential.taxCode,
              phone: detailPotential.phone,
              email: detailPotential.email,
              representative : detailPotential.representative,
              pipelineCode: pipelineSelected.pipelineCode,
              journeyCode: journeySelected.journeyCode,
              saleId:detailPotential.saleId,
              tagId:detailPotential.tagId,
              gender:"",
              birthday:detailPotential.birthday,
              bussinessId:detailPotential.bussinessId,
              employees:detailPotential.employees,
              address:detailPotential.address,
              provinceId: detailPotential.provinceId,
              districtId: detailPotential.districtId,
              wardId: detailPotential.wardId,
              businessClue: detailPotential.businessClue,
              zalo: detailPotential.zalo ?? "",
              fanpage: detailPotential.fanpage ,
              contactAddress: detailPotential.contactAddress,
              contactEmail: detailPotential.contactEmail,
              contactFullName: detailPotential.contactFullName,
              contactPhone: detailPotential.contactPhone,
              position: detailPotential.position
              ));
      Navigator.of(context).pop();
      if (result != null) {
              if (result.errorCode == 0) {
                print(result.errorDescription);

                await LeadConnection.showMyDialog(
                    context, result.errorDescription);

                Navigator.of(context).pop(true);
              } else {
                LeadConnection.showMyDialog(context, result.errorDescription);
              }
            }
    }
  }

}

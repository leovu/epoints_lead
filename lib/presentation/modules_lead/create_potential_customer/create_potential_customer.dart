// import 'dart:html';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/customer_type.dart';
import 'package:lead_plugin_epoint/model/object_pop_detail_model.dart';
import 'package:lead_plugin_epoint/model/request/add_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/request/get_journey_model_request.dart';
import 'package:lead_plugin_epoint/model/response/add_lead_model_response.dart';
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
import 'package:lead_plugin_epoint/presentation/modal/journey_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/tag_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/build_more_address_create_potential.dart';
import 'package:lead_plugin_epoint/presentation/modal/customer_source_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/pipeline_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/pick_one_staff_screen/ui/pick_one_staff_screen.dart';

import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';

class CreatePotentialCustomer extends StatefulWidget {
  String? fullname;
  String? phoneNumber;
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

  ScrollController _controller = ScrollController();
  TextEditingController _fullNameText = TextEditingController();
  FocusNode _fullnameFocusNode = FocusNode();

  TextEditingController _phoneNumberText = TextEditingController();
  FocusNode _phoneNumberFocusNode = FocusNode();

  TextEditingController _businessText = TextEditingController();
  FocusNode _businessFocusNode = FocusNode();

  TextEditingController _emailText = TextEditingController();
  FocusNode _emailFocusNode = FocusNode();

  TextEditingController _taxText = TextEditingController();
  FocusNode _taxFocusNode = FocusNode();

  TextEditingController _representativeText = TextEditingController();
  FocusNode _representativeFocusNode = FocusNode();

  bool showMoreAddress = false;
  bool showMoreAll = false;
  bool selectedPersonal = true;

  String _imgAvatar = "";

  // File _image;
  PickedFile? _pickedFile;
  final _picker = ImagePicker();

  AddLeadModelRequest requestModel = AddLeadModelRequest();
  List<ProvinceData> provinces = <ProvinceData>[];
  List<DistrictData> districts = <DistrictData>[];
  List<WardData> wards = <WardData>[];

  CustomerOptionData? customerOptonData = CustomerOptionData();

  List<CustomerOptionSource>? customerSourcesData = <CustomerOptionSource>[];
  CustomerOptionSource sourceSelected = CustomerOptionSource();

  List<PipelineData>? pipeLineData = <PipelineData>[];
  PipelineData pipelineSelected = PipelineData();

  List<JourneyData>? journeysData = <JourneyData>[];
  JourneyData? journeySelected = JourneyData();

  List<AllocatorData> allocatorData = <AllocatorData>[];

  List<GetStatusWorkData> statusWorkData = [];
  GetStatusWorkData statusWorkSelected = GetStatusWorkData();

  List<WorkListStaffModel>? _modelStaffSelected = [];

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.fullname != null) {
        _fullNameText.text = widget.fullname!;
      }

      if (widget.phoneNumber != null) {
        _phoneNumberText.text = widget.phoneNumber!;
      }
    });
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
              AppLocalizations.text(LangKey.addPotentialCustomer)!,
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
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

          SizedBox(
            height: 15,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  detailPotential.customerType = "personal";
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
                  detailPotential.customerType = "business";
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

          // nguồn khách hàng
          _buildTextField(
              AppLocalizations.text(LangKey.customerSource),
              sourceSelected?.sourceName ?? "",
              Assets.iconSourceCustomer,
              false,
              true,
              false, ontap: () async {
            print("nguồn khách hàng");

            FocusScope.of(context).unfocus();

            if (customerSourcesData == null ||
                customerSourcesData!.length == 0) {
              LeadConnection.showLoading(context);
              var dataType_Source =
                  await LeadConnection.getCustomerOption(context);
              Navigator.of(context).pop();
              if (dataType_Source != null) {
                customerOptonData = dataType_Source.data;
                customerSourcesData = customerOptonData!.source;

                CustomerOptionSource source =
                    await CustomNavigator.showCustomBottomDialog(
                  context,
                  CustomerSourceModal(sources: customerSourcesData),
                );
                if (source != null) {
                  sourceSelected = source;
                  detailPotential.customerSource =
                    sourceSelected.customerSourceId;
                  setState(() {});
                }
              }
            } else {
              CustomerOptionSource source =
                  await CustomNavigator.showCustomBottomDialog(
                context,
                CustomerSourceModal(sources: customerSourcesData),
              );
              if (source != null) {
                sourceSelected = source;

                detailPotential.customerSource =
                    sourceSelected.customerSourceId;
                setState(() {});
              }
            }
          }),
          // // nhap ten doanh nghiep
          // !selectedPersonal
          //     ? _buildTextField( AppLocalizations.text(LangKey.enterBusiness),
          //         "", Assets.iconProvince, true, false, true,
          //         fillText: _businessText, focusNode: _businessFocusNode)
          //     : Container(),

          // Nhập họ và tên / doanh nghiep
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
                  fillText: _taxText, focusNode: _taxFocusNode, inputType: TextInputType.numberWithOptions(
                  signed: false, decimal: false))
              : Container(),

          _buildTextField(AppLocalizations.text(LangKey.inputPhonenumber), "",
              Assets.iconCall, true, false, true,
              fillText: _phoneNumberText,
              focusNode: _phoneNumberFocusNode,
              inputType: TextInputType.numberWithOptions(
                  signed: false, decimal: false)),

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
              pipelineSelected.pipelineName ?? "",
              Assets.iconChance,
              true,
              true,
              false, ontap: () async {
            FocusScope.of(context).unfocus();

            if (pipeLineData == null || pipeLineData!.length == 0) {
              LeadConnection.showLoading(context);
              var pipelines = await LeadConnection.getPipeline(context);
              Navigator.of(context).pop();
              if (pipelines != null) {
                pipeLineData = pipelines.data;

                PipelineData pipeline =
                    await CustomNavigator.showCustomBottomDialog(
                  context,
                  PipelineModal(pipeLineData: pipeLineData),
                );

                if (pipeline != null) {
                  if ((pipelineSelected.pipelineName ?? "") != pipeline.pipelineName) {
                    journeySelected = null;
                  }

                  pipelineSelected = pipeline;
                  detailPotential.pipelineCode =
                      pipelineSelected.pipelineCode;
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
              }
            } else {
              PipelineData pipeline =
                  await CustomNavigator.showCustomBottomDialog(
                context,
                PipelineModal(pipeLineData: pipeLineData),
              );
              if (pipeline != null) {
                if (pipelineSelected?.pipelineName != pipeline.pipelineName) {
                  journeySelected = null;
                }

                pipelineSelected = pipeline;
                detailPotential.pipelineCode = pipelineSelected.pipelineCode;
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
            }
          }),

          //  chọn hành trình
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
              detailPotential.journeyCode = journeySelected!.journeyCode;
              setState(() {
                // await LeadConnection.getDistrict(context, province.provinceid);
              });
            }
          }),

          // _buildTextField(
          //     AppLocalizations.text(LangKey.chooseStatus),
          //     statusWorkSelected?.manageStatusName ?? "",
          //     Assets.iconItinerary,
          //     true,
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
              (_modelStaffSelected != null && _modelStaffSelected!.length > 0)
                  ? _modelStaffSelected![0]?.staffName ?? ""
                  : "",
              Assets.iconName,
              true,
              true,
              false, ontap: () async {
            FocusScope.of(context).unfocus();
            print("Chọn người được phân bổ");

            _modelStaffSelected =
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PickOneStaffScreen(
                          models: _modelStaffSelected,
                        )));

            if (_modelStaffSelected != null && _modelStaffSelected!.length > 0) {
              print(_modelStaffSelected);
              detailPotential.saleId = _modelStaffSelected![0].staffId;
              setState(() {});
            }
          }),

          _buildTextField(AppLocalizations.text(LangKey.chooseCards) ?? "Chọn nhãn",
              tagsString, Assets.iconTag, false, true, false, ontap: () async {
            print("Tag");
            FocusScope.of(context).unfocus();
            List<int?> tagsSeletecd = [];

            if (tagsData == null || tagsData!.length == 0) {
              LeadConnection.showLoading(context);
              var tags = await LeadConnection.getTag(context);
              Navigator.of(context).pop();
              if (tags != null) {
                tagsData = tags.data;

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
              }
            } else {
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
              ? BuildMoreAddressCreatPotential(
                  provinces: provinces,
                  requestModel: requestModel,
                  detailPotential: detailPotential,
                  selectedPersonal: selectedPersonal,
                )
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
          if (customerTypeSelected.customerTypeID == 1) {
            await addPotentialPersonal();
          } else {
            await addPotentialBusiness();
          }
        },
        child: Center(
          child: Text(
            // AppLocalizations.text(LangKey.convertCustomers),
            AppLocalizations.text(LangKey.addPotentialCustomer)!,
            style: TextStyle(
                fontSize: 14.0,
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

  // Widget _buildAvatarWithImage(String image) {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(10000.0),
  //     child: FittedBox(
  //       child: Container(
  //         width: 80.0,
  //         height: 80.0,
  //         padding: const EdgeInsets.all(2.0),
  //         decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             color: Colors.blueGrey,
  //             image: DecorationImage(
  //                 fit: BoxFit.cover,
  //                 colorFilter: ColorFilter.mode(
  //                     Colors.black.withOpacity(1), BlendMode.dstATop),
  //                 image: NetworkImage(image))),
  //       ),
  //       fit: BoxFit.fill,
  //     ),
  //   );
  // }

  Widget _buildTextField(String? title, String? content, String icon,
      bool mandatory, bool dropdown, bool textfield,
      {Function? ontap,
      TextEditingController? fillText,
      FocusNode? focusNode,
      TextInputType? inputType}) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: (ontap != null) ? ontap as void Function()? : null,
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
                    content!,
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
            if (fillText != null) {
              print(fillText.text);
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
            }
          },
          // onSubmitted: (event) {
          //   if (fillText == _fullNameText) {
          //     _buildAvatarImg(_fullNameText.text);
          //   }
          // },
        ),
      ),
    );
  }

  Future<void> addPotentialPersonal() async {
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
        detailPotential.journeyCode == "" || detailPotential.saleId == 0) {
      LeadConnection.showMyDialog(
          context, AppLocalizations.text(LangKey.warningChooseAllRequiredInfo),
          warning: true);
    } else {
      LeadConnection.showLoading(context);
      AddLeadModelResponse? result = await LeadConnection.addLead(
          context,
          AddLeadModelRequest(
              avatar: "",
              customerType: "personal",
              customerSource: detailPotential.customerSource,
              fullName: _fullNameText.text,
              taxCode: "",
              phone: detailPotential.phone,
              email: detailPotential.email,
              representative : "",
              pipelineCode: detailPotential.pipelineCode,
              journeyCode: detailPotential.journeyCode,
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
          await LeadConnection.showMyDialog(context, result.errorDescription);
          if (result.data != null) {
            modelResponse = ObjectPopDetailModel(
                customer_lead_code: "",
                customer_lead_id: result.data!.customerLeadId,
                status: true);
          }
          Navigator.of(context).pop(modelResponse.toJson());
        } else {
          LeadConnection.showMyDialog(context, result.errorDescription);
        }
      }
    }
  }

  Future<void> addPotentialBusiness() async {  
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

    if (detailPotential.contactPhone!.isNotEmpty) {
      if ((!Validators().isValidPhone(detailPotential.contactPhone!.trim())) &&
          (!Validators().isNumber(detailPotential.contactPhone!.trim()))) {
        print("so dien thoai sai oy");
        LeadConnection.showMyDialog(
            context, "Số điện thoại người liên hệ không đúng định dạng" ,
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
      AddLeadModelResponse? result = await LeadConnection.addLead(
          context,
          AddLeadModelRequest(
              avatar: "",
              customerType: "business",
              customerSource: detailPotential.customerSource,
              fullName: _fullNameText.text,
              taxCode: detailPotential.taxCode,
              phone: detailPotential.phone,
              email: detailPotential.email,
              representative : detailPotential.representative,
              pipelineCode: detailPotential.pipelineCode,
              journeyCode: detailPotential.journeyCode,
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
          await LeadConnection.showMyDialog(context, result.errorDescription);
          if (result.data != null) {
            modelResponse = ObjectPopDetailModel(
                customer_lead_code: "",
                customer_lead_id: result.data!.customerLeadId,
                status: true);
          }
          Navigator.of(context).pop(modelResponse.toJson());
        } else {
          LeadConnection.showMyDialog(context, result.errorDescription);
        }
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/customer_type.dart';
import 'package:lead_plugin_epoint/model/object_pop_detail_model.dart';
import 'package:lead_plugin_epoint/model/request/add_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/response/add_lead_model_response.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_option_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_district_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_journey_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_pipeline_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_province_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_ward_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modal/customer_type_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/build_more_address_create_potential.dart';
import 'package:lead_plugin_epoint/presentation/modal/customer_source_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/journey_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/pipeline_modal.dart';

import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';

class CreatePotentialCustomer extends StatefulWidget {
  const CreatePotentialCustomer({Key key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreatePotentialCustomerState createState() =>
      _CreatePotentialCustomerState();
}

class _CreatePotentialCustomerState extends State<CreatePotentialCustomer> with WidgetsBindingObserver {

  var _isKeyboardVisible = false;

  ScrollController _controller = ScrollController();
  TextEditingController _fullNameText = TextEditingController();
  FocusNode _fullnameFocusNode = FocusNode();

  TextEditingController _phoneNumberText = TextEditingController();
  FocusNode _phoneNumberFocusNode = FocusNode();

  bool showMoreAddress = false;
  bool showMoreAll = false;

  AddLeadModelRequest requestModel = AddLeadModelRequest();
  List<ProvinceData> provinces = <ProvinceData>[];
  List<DistrictData> districts = <DistrictData>[];
  List<WardData> wards = <WardData>[];

  CustomerOptionData customerOptonData = CustomerOptionData();

  List<CustomerOptionSource> customerSourcesData = <CustomerOptionSource>[];
  CustomerOptionSource sourceSelected = CustomerOptionSource();

  List<PipelineData> pipeLineData = <PipelineData>[];
  PipelineData pipelineSelected = PipelineData();

  List<JourneyData> journeysData = <JourneyData>[];
  JourneyData journeySelected = JourneyData();

  List<AllocatorData> allocatorData = <AllocatorData>[];

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

  
  DetailPotentialData detailPotential = DetailPotentialData(provinceId: 0,districtId: 0,address: "",saleId: 0,businessClue: "",zalo: "");

  ObjectPopDetailModel modelResponse = ObjectPopDetailModel(); 
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      LeadConnection.showLoading(context);
      await callApi();
      Navigator.of(context).pop();
    });
  }

  void callApi() async {
    var dataType_Source = await LeadConnection.getCustomerOption(context);
    if (dataType_Source != null) {
      customerOptonData = dataType_Source.data;
      // customerType = customerOptonData.customerType;
      customerSourcesData = customerOptonData.source;

      // customerTypeData.add(CustomerTypeModel(
      //     customerTypeName: customerOptonData.customerType.personal,
      //     customerTypeID: 1,
      //     selected: false));
      // customerTypeData.add(CustomerTypeModel(
      //     customerTypeName: customerOptonData.customerType.business,
      //     customerTypeID: 2,
      //     selected: false));
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

    var allocator = await LeadConnection.getAllocator(context);
    if (allocator != null) {
      allocatorData = allocator.data;
    }
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
              AppLocalizations.text(LangKey.addPotentialCustomer),
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            leadingWidth: 20.0,
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
        Visibility(
          visible: !_isKeyboardVisible,
          child: _buildButton()),
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

          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              AppLocalizations.text(LangKey.picture),
              style: TextStyle(
                  fontSize: AppTextSizes.size15,
                  color: const Color(0xFF858080),
                  fontWeight: FontWeight.normal),
            ),
          ),

          Center(
            child: _buildAvatarImg("Duc Tran Tan"),
          ),

          Container(
            height: 10,
          ),
          // Loại khách hàng
          _buildTextField(
              AppLocalizations.text(LangKey.customerStyle),
              customerTypeSelected?.customerTypeName ?? "",
              Assets.iconStyleCustomer,
              true,
              true,
              false, ontap: () async {
            print("loại khách hàng");
            FocusScope.of(context).unfocus();

            CustomerTypeModel customerType = await showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return GestureDetector(
                    child: CustomerTypeModal(
                      customerTypeData: customerTypeData,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    behavior: HitTestBehavior.opaque,
                  );
                });
            if (customerType != null) {
              customerTypeSelected = customerType;
              setState(() {});
            }

            // print("loại khách hàng");
          }),
          // Nhập họ và tên
          _buildTextField(AppLocalizations.text(LangKey.inputFullname), "",
              Assets.iconPerson, true, false, true,
              fillText: _fullNameText, focusNode: _fullnameFocusNode),
          // _buildPhoneNumber("0945160061"),
          _buildTextField(AppLocalizations.text(LangKey.inputPhonenumber), "",
              Assets.iconCall, true, false, true,
              fillText: _phoneNumberText,
              focusNode: _phoneNumberFocusNode,
              inputType: TextInputType.phone),

          // nguồn khách hàng
          _buildTextField(
              AppLocalizations.text(LangKey.customerSource),
              sourceSelected?.sourceName ?? "",
              Assets.iconSourceCustomer,
              true,
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
              sourceSelected = source;
              setState(() {});
            }
          }),

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
              LeadConnection.showLoading(context);
              var journeys = await LeadConnection.getJourney(
                  context, pipelineSelected.pipelineCode);
                  Navigator.of(context).pop();
              if (journeys != null) {
                journeysData = journeys.data;
              }
              setState(() {});
            }
          }),

          // chọn hành trình
          _buildTextField(
              AppLocalizations.text(LangKey.chooseItinerary),
              journeySelected?.journeyName ?? "",
              Assets.iconItinerary,
              true,
              true,
              false, ontap: () async {
            print("Chọn hành trình");

            FocusScope.of(context).unfocus();

            JourneyData journey = await showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return GestureDetector(
                    child: JourneyModal(
                      journeys: journeysData,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    behavior: HitTestBehavior.opaque,
                  );
                });
            if (journey != null) {
              journeySelected = journey;
              setState(() {
                // await LeadConnection.getDistrict(context, province.provinceid);
              });
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
                  allocatorData: allocatorData,
                  requestModel: requestModel,
                  detailPotential: detailPotential,
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
          print("theemmm khtn");

          if (_fullNameText.text == "" ||
              _phoneNumberText.text == "" ||
              customerTypeSelected == null ||
              sourceSelected == null ||
              pipelineSelected == null ||
              journeySelected == null) {
            LeadConnection.showMyDialog(context, 'Vui lòng nhập và chọn đầy đủ thông tin bắt buộc (*)');
          } else {
            LeadConnection.showLoading(context);
            AddLeadModelResponse result = await LeadConnection.addLead(
                context,
                AddLeadModelRequest(
                  avatar: "",
                  customerType: customerTypeSelected.customerTypeName,
                  fullName: _fullNameText.text,
                  phone: _phoneNumberText.text,
                  customerSource: sourceSelected.customerSourceId,
                  pipelineCode: pipelineSelected.pipelineCode,
                  journeyCode: journeySelected.journeyCode,
                  provinceId: detailPotential.provinceId,
                  districtId: detailPotential.districtId,
                  address: detailPotential.address,
                  saleId: detailPotential.saleId,
                  businessClue: detailPotential.businessClue,
                  zalo: detailPotential.zalo ?? "",
                  gender: detailPotential.gender,
                  email: detailPotential.email
                ));
            Navigator.of(context).pop();
              if (result != null ) {
                if (result.errorCode == 0) {
                  print(result.errorDescription);
                  await LeadConnection.showMyDialog(context, result.errorDescription);
                  if (result.data != null) {
                     modelResponse = ObjectPopDetailModel(
                      customer_lead_id: result.data.customerLeadId,
                      status: true
                      );
                    }
                  Navigator.of(context).pop(modelResponse.toJson());
 
                } else {
                  LeadConnection.showMyDialog(context, result.errorDescription);
                }
              }
                
            print("Okie call api add");
          }
        },
        child: Center(
          child: Text(
            // AppLocalizations.text(LangKey.convertCustomers),
            AppLocalizations.text(LangKey.addPotentialCustomer),
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
      width: 65.0,
      height: 65.0,
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
            if (fillText != null) {
              print(fillText.text);
            }
          },
        ),
      ),
    );
  }
}

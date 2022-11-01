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
import 'package:lead_plugin_epoint/model/response/description_model_response.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_option_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_district_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_journey_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_pipeline_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_province_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_ward_model_response.dart';
import 'package:lead_plugin_epoint/model/response/upload_image_response_model.dart';
import 'package:lead_plugin_epoint/presentation/modal/customer_source_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/customer_type_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/journey_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/pipeline_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/edit_potential_customer/build_more_address_edit_potential.dart';

import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';

class EditPotentialCustomer extends StatefulWidget {
  DetailPotentialData detailPotential;
  EditPotentialCustomer({Key key, this.detailPotential}) : super(key: key);

  @override
  _EditPotentialCustomerState createState() => _EditPotentialCustomerState();
}

class _EditPotentialCustomerState extends State<EditPotentialCustomer> with WidgetsBindingObserver {

  var _isKeyboardVisible = false;

  final ScrollController _controller = ScrollController();
  final TextEditingController _fullNameText = TextEditingController();
  final TextEditingController _phoneNumberText = TextEditingController();

  FocusNode _fullnameFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();

  bool showMoreAddress = false;
  bool showMoreAll = false;

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

  List<JourneyData> journeysData = <JourneyData>[];
  JourneyData journeySelected = JourneyData();

  List<CustomerTypeModel> customerTypeData = <CustomerTypeModel>[];
  CustomerTypeModel customerTypeSelected = CustomerTypeModel();

  List<AllocatorData> allocatorData = <AllocatorData>[];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      LeadConnection.showLoading(context);
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

    var journeys =
        await LeadConnection.getJourney(context, requestModel.journeyCode);
    if (journeys != null) {
      journeysData = journeys.data;
    }

    var allocator = await LeadConnection.getAllocator(context);
    if (allocator != null) {
      allocatorData = allocator.data;
    }

    initModel();
  }

  void initModel() async {
    // _imgAvatar =  widget.detailPotential?.avatar ?? "";
    _fullNameText.text = widget.detailPotential?.fullName ?? "";
    _phoneNumberText.text = widget.detailPotential?.phone ?? "";
    for (int i = 0; i < customerTypeData.length; i++) {
      if ((widget.detailPotential?.customerType ?? "").toLowerCase() ==
          customerTypeData[i].customerTypeName.toLowerCase()) {
        customerTypeData[i].selected = true;
        customerTypeSelected = customerTypeData[i];
      } else {
        customerTypeData[i].selected = false;
      }
    }

    for (int i = 0; i < customerSourcesData.length; i++) {
      if ((widget.detailPotential?.customerSourceName ?? "").toLowerCase() ==
          customerSourcesData[i].sourceName.toLowerCase()) {
        customerSourcesData[i].selected = true;
        customerSourceSelected = customerSourcesData[i];
      } else {
        customerSourcesData[i].selected = false;
      }
    }

    for (int i = 0; i < pipeLineData.length; i++) {
      if ((widget.detailPotential?.pipelineName ?? "").toLowerCase() ==
          pipeLineData[i].pipelineName.toLowerCase()) {
        pipeLineData[i].selected = true;
        pipelineSelected = pipeLineData[i];
      } else {
        pipeLineData[i].selected = false;
      }
    }
    var journeys =
        await LeadConnection.getJourney(context, pipelineSelected.pipelineCode);
    if (journeys != null) {
      journeysData = journeys.data;
    }

    for (int i = 0; i < journeysData.length; i++) {
      if ((widget.detailPotential.journeyName ?? "").toLowerCase() ==
          journeysData[i].journeyName.toLowerCase()) {
        journeysData[i].selected = true;
        journeySelected = journeysData[i];
      } else {
        journeysData[i].selected = false;
      }
    }

     Navigator.of(context).pop();

    setState(() {});
  }

    Future<void> _pickImage() async {
    _pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (_pickedFile != null) {
      _image = File(_pickedFile.path);

      UploadImageModelResponse result =
          await LeadConnection.upload(context, _image);

      if (result != null) {
        _imgAvatar = result.data.link;
        setState(() {
          print(_image);
        });
      }
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
              AppLocalizations.text(LangKey.editPotential),
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
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
              "Hình ảnh",
              style: TextStyle(
                  fontSize: AppTextSizes.size15,
                  color: const Color(0xFF858080),
                  fontWeight: FontWeight.normal),
            ),
          ),

          Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
            onTap: () {
                  print("chon anh");
                  _pickImage();
            },
            child: (_imgAvatar != "")
                    ? _buildAvatarWithImage(_imgAvatar)
                    : _buildAvatarImg(_fullNameText.text ?? ""),
          ),

          Positioned(
                    left: 60,
                    bottom: 55,
                    child: InkWell(
                      onTap: () {
                        _imgAvatar = "";
                        setState(() {
                          
                        });
                      },
                      child:  (_imgAvatar != "") ? Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.red
                            ),
                        child: Center(child: Icon(Icons.clear, color: Colors.white,
                        size: 15,)),
                      ) : Container(),
                    ))

                ],
              )),

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
              customerSourceSelected?.sourceName ?? "",
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
              customerSourceSelected = source;
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
              ? BuildMoreAddressEditPotential(
                  provinces: provinces,
                  allocatorData: allocatorData,
                  requestModel: requestModel,
                  detailPotential: widget.detailPotential,
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
          print("edit khtn");

          if (_fullNameText.text == "" ||
              _phoneNumberText.text == "" ||
              customerTypeSelected == null ||
              customerSourceSelected == null ||
              pipelineSelected == null ||
              journeySelected == null) {
            _showMyDialog('Vui lòng nhập và chọn đầy đủ thông tin bắt buộc (*)');
          } else {
            DescriptionModelResponse result = await LeadConnection.updateLead(
                context,
                EditPotentialRequestModel(
                  
                  customerLeadCode: widget.detailPotential.customerLeadCode,
                  customerType: customerTypeSelected.customerTypeName,
                  fullName: _fullNameText.text,
                  phone: _phoneNumberText.text,
                  customerSource: customerSourceSelected.customerSourceId,
                  pipelineCode: pipelineSelected.pipelineCode,
                  journeyCode: journeySelected.journeyCode,
                  avatar: _imgAvatar,
                  provinceId: "${widget.detailPotential.provinceId}",
                  districtId: "${widget.detailPotential.districtId}",
                  address: widget.detailPotential.address,
                  saleId: "${widget.detailPotential.saleId}",
                  businessClue: widget.detailPotential.businessClue,
                  zalo: widget.detailPotential.zalo ?? "",
                  gender: widget.detailPotential.gender,
                  email: widget.detailPotential.email
                ));

                if (result != null) {
                if (result.errorCode == 0) {
                  print(result.errorDescription);

                  await _showMyDialog(result.errorDescription);
                  Navigator.of(context).pop(true);
 
                } else {
                  _showMyDialog(result.errorDescription);
                }
              }
            print("Okie call api edit");
          }
        },
        child: Center(
          child: Text(
            // AppLocalizations.text(LangKey.convertCustomers),
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

  Future<void> _showMyDialog(String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title:  Text(''),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child: Text(
                  'Thông báo\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                )),
                Center(child: Text(title)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Center(child: Text('Đồng ý')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
              image: NetworkImage(image)
            )
          ),
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
            if (fillText != null) {
              print(fillText.text);
            }
          },
        ),
      ),
    );
  }
}

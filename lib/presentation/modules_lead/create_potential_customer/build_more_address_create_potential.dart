
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/gender_model.dart';
import 'package:lead_plugin_epoint/model/request/add_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_district_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_province_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_ward_model_response.dart';
import 'package:lead_plugin_epoint/model/response/list_business_areas_model_response.dart';
import 'package:lead_plugin_epoint/model/response/list_customer_lead_model_response.dart';
import 'package:lead_plugin_epoint/model/response/position_response_model.dart';
import 'package:lead_plugin_epoint/presentation/interface/base_bloc.dart';
import 'package:lead_plugin_epoint/presentation/modal/business_areas_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/bloc/create_potential_customer_bloc.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_date_picker.dart';
import 'package:lead_plugin_epoint/widget/custom_menu_bottom_sheet.dart';
import 'package:lead_plugin_epoint/widget/widget.dart';

class BuildMoreAddressCreatPotential extends StatefulWidget {
  AddLeadModelRequest? detailPotential;
  List<ProvinceData>? provinces = <ProvinceData>[];
  bool? selectedPersonal;
  AddLeadModelRequest? requestModel = AddLeadModelRequest();
  final CreatePotentialCustomerBloc bloc;
  BuildMoreAddressCreatPotential(
      {Key? key,
      this.provinces,
      // this.allocatorData,
      this.requestModel,
      this.detailPotential,
      this.selectedPersonal,
      required this.bloc})
      : super(key: key);
  @override
  _BuildMoreAddressCreatPotentialState createState() =>
      _BuildMoreAddressCreatPotentialState();
}

class _BuildMoreAddressCreatPotentialState
    extends State<BuildMoreAddressCreatPotential> {
  TextEditingController _addressText = TextEditingController();

  TextEditingController _addressContactText = TextEditingController();

  TextEditingController _emailContactPersonText = TextEditingController();

  TextEditingController _numberOfEmployeesText = TextEditingController();
  FocusNode _numberOfEmployeesFocusNode = FocusNode();

  TextEditingController _zaloText = TextEditingController();
  FocusNode _zaloFocusNode = FocusNode();
  TextEditingController _fanpageFBText = TextEditingController();
  FocusNode _fanpageFBFocusNode = FocusNode();
  // FocusNode _emailFocusNode = FocusNode();
  TextEditingController _birthdayText = TextEditingController();
  TextEditingController _establishDateText = TextEditingController();

  TextEditingController _fullNameText = TextEditingController();
  TextEditingController _phoneNumberText = TextEditingController();

  ProvinceData provinceSeleted = ProvinceData();
  AllocatorData allocatorSelected = AllocatorData();

  List<DistrictData>? districts = <DistrictData>[];
  DistrictData? distictSelected = DistrictData();
  List<WardData>? wards = <WardData>[];
  WardData? wardSelected = WardData();
  DateTime? selectedBirthDay;
  DateTime? selectedEstablishDate;

  List<ListCustomLeadItems> businessFocalPointData = <ListCustomLeadItems>[];
  List<ListBusinessAreasItem> listBusinessData = [];
  ListBusinessAreasItem? businessAreasSelected;
  ListCustomLeadItems businessFocalPointSeleted = ListCustomLeadItems();
  List<GenderModel> genderData = [
    GenderModel(
        genderName: AppLocalizations.text(LangKey.male),
        genderEnName: "male",
        genderID: 0,
        selected: false),
    GenderModel(
        genderName: AppLocalizations.text(LangKey.female),
        genderEnName: "female",
        genderID: 1,
        selected: false),
    GenderModel(
        genderName: AppLocalizations.text(LangKey.male),
        genderEnName: "other",
        genderID: 2,
        selected: false)
  ];
  GenderModel genderSelected = GenderModel();

  List<PositionData>? positionData;
  PositionData? positionSelected;
  // List<WorkListStaffModel> _modelStaffSelected = [];

  bool showMoreAll = false;

  @override
  Widget build(BuildContext context) {
    widget.detailPotential!.birthday =
        widget.selectedPersonal! ? _birthdayText.text : _establishDateText.text;

    return GestureDetector(
      onTap: () {
        keyboardDismissOnTap(context);
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.text(LangKey.moreInformation)!,
                style: TextStyle(
                    fontSize: 16.0,
                    color: const Color(0xFF0067AC),
                    fontWeight: FontWeight.normal),
              ),
              showMoreAll
                  ? InkWell(
                      child: Text(
                        AppLocalizations.text(LangKey.collapse)!,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: const Color(0xFF0067AC),
                            fontWeight: FontWeight.normal),
                      ),
                      onTap: () {
                        showMoreAll = false;
                        setState(() {});

                        print("thu gon");
                      },
                    )
                  : Container()
            ],
          ),
          Container(
            height: 16.0,
          ),

          // Người đại diện (business only) - đặt lên đầu
          !widget.selectedPersonal!
              ? _buildTextField(AppLocalizations.text(LangKey.representative),
                  "", Assets.iconRepresentative, false, false, true,
                  fillText: widget.bloc.representativeController,
                  focusNode: widget.bloc.representativeFocusNode)
              : Container(),

          widget.selectedPersonal!
              ? sexInfo(genderSelected.genderID ?? 0)
              : _buildTextField(
                  AppLocalizations.text(LangKey.businessAreas),
                  businessAreasSelected?.businessName ?? "",
                  Assets.iconMenu,
                  false,
                  true,
                  false, ontap: () async {
                  FocusScope.of(context).unfocus();

                  var listBusiness =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BusinessAreasModal(
                                listBusinessData: listBusinessData,
                              )));

                  if (listBusiness != null && listBusiness.length > 0) {
                    listBusinessData = listBusiness;

                    try {
                      var result = listBusinessData
                          .firstWhere((element) => element.selected!);
                      businessAreasSelected = result;
                      widget.detailPotential!.bussinessId =
                          businessAreasSelected!.businessId;

                      // widget.detailPotential.saleId = _modelStaffSelected[0].staffId;
                    }
                    catch(_){}
                    setState(() {});
                  }
                }),

          widget.selectedPersonal!
              ? _buildTextField(
                  AppLocalizations.text(LangKey.choose_birth_day),
                  _birthdayText.text,
                  Assets.iconBirthday,
                  false,
                  true,
                  false, ontap: () async {
                  FocusScope.of(context).unfocus();
                  _showBirthDay();
                })
              : _buildTextField(
                  AppLocalizations.text(LangKey.chooseDateOfEstablishment),
                  _establishDateText.text,
                  Assets.iconEstablish,
                  false,
                  true,
                  false, ontap: () async {
                  FocusScope.of(context).unfocus();
                  _showEstablishDate();
                }),

          // so luong nhan vien
          !widget.selectedPersonal!
              ? _buildTextField(AppLocalizations.text(LangKey.numberEmployees),
                  "", Assets.iconNumberEmployees, false, false, true,
                  fillText: _numberOfEmployeesText,
                  focusNode: _numberOfEmployeesFocusNode,
                  inputType: TextInputType.numberWithOptions(
                      signed: false, decimal: false))
              : Container(),

          (showMoreAll == false)
              ? InkWell(
                  onTap: () {
                    showMoreAll = true;
                    setState(() {});
                  },
                  child: Center(
                    child: Column(
                      children: [
                        Divider(),
                        Text(
                          AppLocalizations.text(LangKey.showMore)!,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: const Color(0xFF0067AC),
                              fontWeight: FontWeight.normal),
                        ),
                        Container(
                          height: 6.0,
                        ),
                        Image.asset(
                          Assets.iconDropDown,
                          width: 16.0,
                        )
                      ],
                    ),
                  ),
                )
              : Container(),

          showMoreAll ? _buildMoreAll() : Container()
        ],
      ),
    );
  }


  _showBirthDay() {
    DateTime selectedDate = selectedBirthDay ?? DateTime.now();

    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: CustomMenuBottomSheet(
              title: AppLocalizations.text(LangKey.choose_birth_day),
              widget: CustomDatePicker(
                minimumTime: DateTime(1970, 12, 31),
                initTime: selectedDate,
                maximumTime: DateTime.now(),
                dateOrder: DatePickerDateOrder.dmy,
                onChange: (DateTime date) {
                  selectedDate = date;
                },
              ),
              ontapConfirm: () {
                selectedBirthDay = selectedDate;
                _birthdayText.text = DateFormat("dd/MM/yyyy")
                    .format(selectedBirthDay!)
                    .toString();
                widget.detailPotential!.birthday = _birthdayText.text;

                Navigator.of(context).pop();
                setState(() {});
              },
              haveBnConfirm: true,
            ),
          );
        });
  }

  _showEstablishDate() {
    DateTime selectedDate = selectedEstablishDate ?? DateTime.now();

    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: CustomMenuBottomSheet(
              title: AppLocalizations.text(LangKey.chooseDateOfEstablishment),
              widget: CustomDatePicker(
                minimumTime: DateTime(1970, 12, 31),
                initTime: selectedDate,
                maximumTime: DateTime.now(),
                dateOrder: DatePickerDateOrder.dmy,
                onChange: (DateTime date) {
                  selectedDate = date;
                },
              ),
              ontapConfirm: () {
                selectedEstablishDate = selectedDate;
                _establishDateText.text = DateFormat("dd/MM/yyyy")
                    .format(selectedEstablishDate!)
                    .toString();
                // widget.filterScreenModel.fromDate_created_at = selectedDate;

                Navigator.of(context).pop();
                setState(() {});
              },
              haveBnConfirm: true,
            ),
          );
        });
  }

  Widget _buildMoreAll() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Website
        _buildTextField("Website", "",
            Assets.iconWebsite, false, false, true,
            fillText: widget.bloc.websiteController, focusNode: widget.bloc.websiteFocusNode),
   
        // Zalo
        _buildTextField(AppLocalizations.text(LangKey.zalo), "",
            Assets.iconSource, false, false, true,
            fillText: _zaloText, focusNode: _zaloFocusNode),
        // Nhập Fanpage
        _buildTextField(AppLocalizations.text(LangKey.inputFanpage), "",
            Assets.iconFanpage, false, false, true,
            fillText: _fanpageFBText, focusNode: _fanpageFBFocusNode),

        Text(
          AppLocalizations.text(LangKey.note)!,
          style: TextStyle(
                fontWeight: FontWeight.bold,
                color:  AppColors.primaryColor),
        ),

        SizedBox(height: 8.0),

        TextField(
          controller: widget.bloc.noteController,
          focusNode: widget.bloc.noteFocusNode,
          textInputAction: TextInputAction.done,
          maxLength: 500,
          decoration: InputDecoration(
            counterText: "",
            hintText: AppLocalizations.text(LangKey.thisIsANote),
            hintStyle: AppTextStyles.style13GrayWeight400,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.grey700Color, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.grey700Color, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          maxLines: 4,
          minLines: 4,
          onSubmitted: (value) {
            widget.bloc.noteFocusNode.unfocus();
          },
        ),

        _buildImage()

      ],
    );
  }

   Widget _buildImage() {
    return StreamBuilder(
        stream: widget.bloc.streamImages.output,
        initialData: widget.bloc.images,
        builder: (_, snapshot) {
          return CustomImageList(
            models: widget.bloc.images
                .map((e) => CustomImageListModel(file: e))
                .toList(),
            onAdd: widget.bloc.onImageAdd,
            onRemove: widget.bloc.onImageRemove,
          );
        });
  }

  Widget sexInfo(int index) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              width: 1.0, color: Color(0xFFC3C8D3), style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10.0)),
      padding: const EdgeInsets.only(left: 5.0),
      margin: EdgeInsets.only(bottom: 15.0 / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5.0),
                  height: 20.0,
                  width: 20.0,
                  child: Image.asset(Assets.iconSex),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    AppLocalizations.text(LangKey.sex)!,
                    style: AppTextStyles.style15BlackNormal,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            // padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                // color: AppColors.darkGrey,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    selectedGender(0);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: (genderSelected.genderID == 0)
                            ? AppColors.primaryColor
                            : AppColors.darkGrey,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(right: 5.0, top: 5.0, bottom: 5.0),
                    padding: EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
                    child: Center(
                      child: Text(
                        AppLocalizations.text(LangKey.male)!,
                        style: TextStyle(
                            fontSize: AppTextSizes.size15,
                            color: (genderSelected.genderID == 0)
                                ? Colors.white
                                : Color(0xFF9E9E9E),
                            fontWeight: FontWeight.normal),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    selectedGender(1);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: (genderSelected.genderID == 1)
                            ? AppColors.primaryColor
                            : AppColors.darkGrey,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(right: 5.0, top: 5.0, bottom: 5.0),
                    padding: EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
                    child: Text(
                      AppLocalizations.text(LangKey.female)!,
                      style: TextStyle(
                          fontSize: AppTextSizes.size15,
                          color: (genderSelected.genderID == 1)
                              ? Colors.white
                              : Color(0xFF9E9E9E),
                          fontWeight: FontWeight.normal),
                      maxLines: 1,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    selectedGender(2);
                  },
                  child: Container(
                    height: 28,
                    decoration: BoxDecoration(
                        color: (genderSelected.genderID == 2)
                            ? AppColors.primaryColor
                            : AppColors.darkGrey,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(right: 5.0),
                    padding: EdgeInsets.only(
                        top: 3.0, bottom: 3.0, left: 15.0, right: 15.0),
                    child: Center(
                      child: Text(
                        AppLocalizations.text(LangKey.other)!,
                        style: TextStyle(
                            fontSize: AppTextSizes.size15,
                            color: (genderSelected.genderID == 2)
                                ? Colors.white
                                : Color(0xFF9E9E9E),
                            fontWeight: FontWeight.normal),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void selectedGender(int index) async {
    for (int i = 0; i < genderData.length; i++) {
      genderData[i].selected = false;
    }
    genderData[index].selected = true;
    genderSelected = genderData[index];
    widget.detailPotential!.gender = genderSelected.genderEnName;

    setState(() {});
  }

  Widget _buildTextField(String? title, String content, String icon,
      bool mandatory, bool dropdown, bool textfield,
      {GestureTapCallback? ontap,
      TextEditingController? fillText,
      FocusNode? focusNode,
      TextInputType? inputType,
      bool applyIconColor = true}) {
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

            label: (content.isEmpty)
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
          onChanged: (event) {
            print(event.toLowerCase());
            if (fillText == _addressText) {
              widget.detailPotential?.address = event;
            } else if (fillText == _zaloText) {
              widget.detailPotential?.zalo = event;
            } else if (fillText == _fanpageFBText) {
              widget.detailPotential?.fanpage = event;
            } else if (fillText == _emailContactPersonText) {
              widget.detailPotential?.contactEmail =
                  _emailContactPersonText.text;
            } else if (fillText == _numberOfEmployeesText) {
              widget.detailPotential?.employees =
                  (_numberOfEmployeesText.text != "")
                      ? int.parse(_numberOfEmployeesText.text)
                      : 0;
            } else if (fillText == _fullNameText) {
              widget.detailPotential?.contactFullName = _fullNameText.text;
            } else if (fillText == _phoneNumberText) {
              widget.detailPotential?.contactPhone = _phoneNumberText.text;
            } else if (fillText == _emailContactPersonText) {
              widget.detailPotential?.contactEmail =
                  _emailContactPersonText.text;
            } else if (fillText == _addressContactText) {
              widget.detailPotential?.contactAddress = _addressContactText.text;
            }
          },
        ),
      ),
    );
  }
}

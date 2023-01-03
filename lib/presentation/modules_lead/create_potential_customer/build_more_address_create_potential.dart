import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/gender_model.dart';
import 'package:lead_plugin_epoint/model/request/add_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_district_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/model/response/get_province_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_ward_model_response.dart';
import 'package:lead_plugin_epoint/model/response/list_business_areas_model_response.dart';
import 'package:lead_plugin_epoint/model/response/list_customer_lead_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modal/business_areas_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/district_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/province_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/ward_modal.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_date_picker.dart';
import 'package:lead_plugin_epoint/widget/custom_menu_bottom_sheet.dart';

class BuildMoreAddressCreatPotential extends StatefulWidget {
  AddLeadModelRequest detailPotential;
  List<ProvinceData> provinces = <ProvinceData>[];
  bool selectedPersonal;
  AddLeadModelRequest requestModel = AddLeadModelRequest();
  BuildMoreAddressCreatPotential(
      {Key key,
      this.provinces,
      // this.allocatorData,
      this.requestModel,
      this.detailPotential,
      this.selectedPersonal})
      : super(key: key);
  @override
  _BuildMoreAddressCreatPotentialState createState() =>
      _BuildMoreAddressCreatPotentialState();
}

class _BuildMoreAddressCreatPotentialState
    extends State<BuildMoreAddressCreatPotential> {
  TextEditingController _addressText = TextEditingController();
  FocusNode _addressFocusNode = FocusNode();

  TextEditingController _addressContactText = TextEditingController();
  FocusNode _addressContactFocusNode = FocusNode();

  TextEditingController _emailContactPersonText = TextEditingController();
  FocusNode _emailContactPersonFocusNode = FocusNode();

  TextEditingController _numberOfEmployeesText = TextEditingController();
  FocusNode _numberOfEmployeesFocusNode = FocusNode();

  TextEditingController _zaloText = TextEditingController();
  FocusNode _zaloFocusNode = FocusNode();
  TextEditingController _fanpageFBText = TextEditingController();
  FocusNode _fanpageFBFocusNode = FocusNode();
  TextEditingController _emailText = TextEditingController();
  // FocusNode _emailFocusNode = FocusNode();
  TextEditingController _birthdayText = TextEditingController();
  TextEditingController _establishDateText = TextEditingController();

  TextEditingController _fullNameText = TextEditingController();
  FocusNode _fullnameFocusNode = FocusNode();
  TextEditingController _phoneNumberText = TextEditingController();
  FocusNode _phoneNumberFocusNode = FocusNode();

  ProvinceData provinceSeleted = ProvinceData();
  AllocatorData allocatorSelected = AllocatorData();

  List<DistrictData> districts = <DistrictData>[];
  DistrictData distictSelected = DistrictData();
  List<WardData> wards = <WardData>[];
  WardData wardSelected = WardData();
  DateTime selectedBirthDay;
  DateTime selectedEstablishDate;

  List<ListCustomLeadItems> businessFocalPointData = <ListCustomLeadItems>[];
  List<ListBusinessAreasItem> listBusinessData = [];
  ListBusinessAreasItem businessAreasSelected;
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
  // List<WorkListStaffModel> _modelStaffSelected = [];

  bool showMoreAll = false;

  @override
  Widget build(BuildContext context) {
    widget.detailPotential.birthday =
        widget.selectedPersonal ? _birthdayText.text : _establishDateText.text;

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
                AppLocalizations.text(LangKey.moreInformation),
                style: TextStyle(
                    fontSize: 16.0,
                    color: const Color(0xFF0067AC),
                    fontWeight: FontWeight.normal),
              ),
              showMoreAll
                  ? InkWell(
                      child: Text(
                        AppLocalizations.text(LangKey.collapse),
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
          widget.selectedPersonal
              ? sexInfo(genderSelected?.genderID ?? 0)
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

                    var result = listBusinessData
                        .firstWhere((element) => element.selected);
                    if (result != null) {
                      businessAreasSelected = result;
                      widget.detailPotential.bussinessId =
                          businessAreasSelected.createdBy;
                    }

                    // widget.detailPotential.saleId = _modelStaffSelected[0].staffId;
                    setState(() {});
                  }
                }),

          // _buildTextField(AppLocalizations.text(LangKey.email), "",
          //     Assets.iconEmail, false, false, true,
          //     fillText: _emailText, focusNode: _emailFocusNode),

          widget.selectedPersonal
              ? _buildTextField(
                  AppLocalizations.text(LangKey.choose_birth_day),
                  _birthdayText.text ?? "",
                  Assets.iconBirthday,
                  false,
                  true,
                  false, ontap: () async {
                    FocusScope.of(context).unfocus();
                  _showBirthDay();
                })
              : _buildTextField(
                  AppLocalizations.text(LangKey.chooseDateOfEstablishment),
                  _establishDateText.text ?? "",
                  Assets.iconEstablish,
                  false,
                  true,
                  false, ontap: () async {
                    FocusScope.of(context).unfocus();
                  _showEstablishDate();
                }),
          //    _buildTextField(
          //   AppLocalizations.text(LangKey.businessAreas),
          //   "",
          //   Assets.iconMenu,
          //   false,
          //   true,
          //   false, ontap: () async {
          // FocusScope.of(context).unfocus(); }),

          //  _buildTextField(
          // AppLocalizations.text(LangKey.chooseDateOfEstablishment),
          // _establishDateText.text ?? "",
          // Assets.iconEstablish,
          // false,
          // true,
          // false, ontap: () async {
          //   _showEstablishDate();
          // }),

          // so luong nhan vien
          !widget.selectedPersonal
              ? _buildTextField(AppLocalizations.text(LangKey.numberEmployees),
                  "", Assets.iconNumberEmployees, false, false, true,
                  fillText: _numberOfEmployeesText,
                  focusNode: _numberOfEmployeesFocusNode,
                  inputType: TextInputType.numberWithOptions(
                      signed: false, decimal: false))
              : Container(),

          _buildTextField(
              AppLocalizations.text(LangKey.provinceCity),
              provinceSeleted?.name ?? "",
              Assets.iconProvince,
              false,
              true,
              false, ontap: () async {
            FocusScope.of(context).unfocus();

            if (widget.provinces == null || widget.provinces.length == 0) {
              LeadConnection.showLoading(context);
              var dataProvinces = await LeadConnection.getProvince(context);
              Navigator.of(context).pop();
              if (dataProvinces != null) {
                widget.provinces = dataProvinces.data;

                ProvinceData province = await showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return ProvinceModal(
                          provinces: widget.provinces,
                          provinceSeleted: provinceSeleted);
                    });
                if (province != null) {
                  if (provinceSeleted?.provinceid != province.provinceid) {
                    distictSelected = null;
                    wardSelected = null;
                  }
                  provinceSeleted = province;
                  widget.detailPotential.provinceId =
                      provinceSeleted.provinceid;
                  var dataDistrict = await LeadConnection.getDistrict(
                      context, provinceSeleted.provinceid);
                  if (dataDistrict != null) {
                    districts = dataDistrict.data;
                  }
                  setState(() {});
                }
              }
            } else {
              ProvinceData province = await showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return ProvinceModal(
                        provinces: widget.provinces,
                        provinceSeleted: provinceSeleted);
                  });
              if (province != null) {
                if (provinceSeleted?.provinceid != province.provinceid) {
                  distictSelected = null;
                  wardSelected = null;
                }
                provinceSeleted = province;
                widget.detailPotential.provinceId = provinceSeleted.provinceid;
                var dataDistrict = await LeadConnection.getDistrict(
                    context, provinceSeleted.provinceid);
                if (dataDistrict != null) {
                  districts = dataDistrict.data;
                }
                setState(() {});
              }
            }
          }),
          Row(
            children: [
              Container(
                // margin: const EdgeInsets.only(bottom: 10.0),
                width: (MediaQuery.of(context).size.width - 16) / 2 - 8,
                child: _buildTextField(
                    AppLocalizations.text(LangKey.district),
                    distictSelected?.name ?? "",
                    Assets.iconDistrict,
                    false,
                    true,
                    false, ontap: () async {
                  FocusScope.of(context).unfocus();
                  print("quận/ huyện");
                  DistrictData distict = await showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return GestureDetector(
                          child: DistrictModal(
                            districts: districts,
                            distictSelected: distictSelected,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          behavior: HitTestBehavior.opaque,
                        );
                      });
                  if (distict != null) {
                    if (distictSelected?.districtid != distict.districtid) {
                      wardSelected = null;
                    }
                    distictSelected = distict;
                    widget.detailPotential.districtId =
                        distictSelected.districtid;
                    var wardData = await LeadConnection.getWard(
                        context, distictSelected.districtid);
                    if (wardData != null) {
                      wards = wardData.data;
                    }
                    setState(() {
                      // await LeadConnection.getDistrict(context, province.provinceid);
                    });
                  }
                }),
              ),

              // phường / xã
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  child: _buildTextField(
                      AppLocalizations.text(LangKey.wards),
                      wardSelected?.name ?? "",
                      Assets.iconWards,
                      false,
                      true,
                      false, ontap: () async {
                    print("phường xã");

                    WardData ward = await showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return GestureDetector(
                            child: WardModal(
                              ward: wards,
                              wardSelected: wardSelected,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            behavior: HitTestBehavior.opaque,
                          );
                        });
                    if (ward != null) {
                      wardSelected = ward;
                      widget.detailPotential.wardId = wardSelected.wardid;

                      setState(() {});
                    }
                  }),
                ),
              ),
            ],
          ),

          // điền địa chỉ
          _buildTextField(AppLocalizations.text(LangKey.inputAddress), "",
              Assets.iconAddress, false, false, true,
              fillText: _addressText, focusNode: _addressFocusNode),

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
                          AppLocalizations.text(LangKey.showMore),
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
              onTapConfirm: () {
                selectedBirthDay = selectedDate;
                _birthdayText.text = DateFormat("dd/MM/yyyy")
                    .format(selectedBirthDay)
                    .toString();
                widget.detailPotential.birthday = _birthdayText.text;

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
              onTapConfirm: () {
                selectedEstablishDate = selectedDate;
                _establishDateText.text = DateFormat("dd/MM/yyyy")
                    .format(selectedEstablishDate)
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
        // Chọn người được phân bổ
        // _buildTextField(
        //     AppLocalizations.text(LangKey.chooseAllottedPerson),
        //     (_modelStaffSelected.length > 0 && _modelStaffSelected != null)
        //         ? _modelStaffSelected[0]?.staffName ?? ""
        //         : "",
        //     Assets.iconName,
        //     false,
        //     true,
        //     false, ontap: () async {
        //   FocusScope.of(context).unfocus();
        //   print("Chọn người được phân bổ");

        //   _modelStaffSelected =
        //       await Navigator.of(context).push(MaterialPageRoute(
        //           builder: (context) => PickOneStaffScreen(
        //                 models: _modelStaffSelected,
        //               )));

        //   if (_modelStaffSelected != null && _modelStaffSelected.length > 0) {
        //     print(_modelStaffSelected);
        //     widget.detailPotential.saleId = _modelStaffSelected[0].staffId;
        //     setState(() {});
        //   }

        // if (widget.allocatorData == null ||
        //     widget.allocatorData.length == 0) {
        //   LeadConnection.showLoading(context);
        //   var allocators = await LeadConnection.getAllocator(context);
        //   Navigator.of(context).pop();

        //   if (allocators != null) {
        //     widget.allocatorData = allocators.data;

        //     AllocatorData allocator = await showModalBottomSheet(
        //         context: context,
        //         useRootNavigator: true,
        //         isScrollControlled: true,
        //         backgroundColor: Colors.transparent,
        //         builder: (context) {
        //           return GestureDetector(
        //             child: AllocatorModal(
        //               allocatorData: widget.allocatorData,
        //               allocatorSelected:allocatorSelected
        //             ),
        //             onTap: () {
        //               Navigator.of(context).pop();
        //             },
        //             behavior: HitTestBehavior.opaque,
        //           );
        //         });
        //     if (allocator != null) {
        //       allocatorSelected = allocator;
        //       widget.detailPotential?.saleId = allocatorSelected.staffId;
        //       setState(() {});
        //     }
        //   }
        // } else {
        //   AllocatorData allocator = await showModalBottomSheet(
        //       context: context,
        //       useRootNavigator: true,
        //       isScrollControlled: true,
        //       backgroundColor: Colors.transparent,
        //       builder: (context) {
        //         return GestureDetector(
        //           child: AllocatorModal(
        //             allocatorData: widget.allocatorData,
        //             allocatorSelected:allocatorSelected
        //           ),
        //           onTap: () {
        //             Navigator.of(context).pop();
        //           },
        //           behavior: HitTestBehavior.opaque,
        //         );
        //       });
        //   if (allocator != null) {
        //     allocatorSelected = allocator;
        //     widget.detailPotential?.saleId = allocatorSelected.staffId;
        //     setState(() {});
        //   }
        // }
        // }),
        // Đầu mối doanh nghiệp
        // _buildTextField(
        //     AppLocalizations.text(LangKey.businessFocalPoint),
        //     businessFocalPointSeleted?.customerLeadCode ?? "",
        //     Assets.iconPoint,
        //     false,
        //     true,
        //     false, ontap: () async {
        //   FocusScope.of(context).unfocus();
        //   ListCustomLeadItems businessFocalPoint =
        //       await Navigator.of(context).push(MaterialPageRoute(
        //           builder: (context) => BusinessFocalPointModal(
        //                 businessFocalPointData: businessFocalPointData,
        //                 businessFocalPointSeleted: businessFocalPointSeleted,
        //               )));

        //   if (businessFocalPoint != null) {
        //     businessFocalPointSeleted = businessFocalPoint;
        //     widget.detailPotential.businessClue =
        //         businessFocalPointSeleted.customerLeadCode;
        //     // widget.detailPotential.
        //     setState(() {});
        //   }
        // }),

        // Zalo
        _buildTextField(AppLocalizations.text(LangKey.zalo), "",
            Assets.iconSource, false, false, true,
            fillText: _zaloText, focusNode: _zaloFocusNode),
        // Nhập Fanpage
        _buildTextField(AppLocalizations.text(LangKey.inputFanpage), "",
            Assets.iconFanpage, false, false, true,
            fillText: _fanpageFBText, focusNode: _fanpageFBFocusNode),

        !widget.selectedPersonal
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  Text(
                    AppLocalizations.text(LangKey.contactInformation),
                    style: TextStyle(
                        fontSize: AppTextSizes.size16,
                        color: const Color(0xFF0067AC),
                        fontWeight: FontWeight.normal),
                  ),

                  SizedBox(height: 15.0),

                  // nhap ho va ten
                  _buildTextField(AppLocalizations.text(LangKey.inputFullname),
                      "", Assets.iconPerson, false, false, true,
                      fillText: _fullNameText, focusNode: _fullnameFocusNode),
                  // so dien thoai
                  _buildTextField(
                      AppLocalizations.text(LangKey.inputPhonenumber),
                      "",
                      Assets.iconCall,
                      false,
                      false,
                      true,
                      fillText: _phoneNumberText,
                      focusNode: _phoneNumberFocusNode,
                      inputType: TextInputType.numberWithOptions(
                      signed: false, decimal: false)),

                  // email
                  _buildTextField(AppLocalizations.text(LangKey.email), "",
                      Assets.iconEmail, false, false, true,
                      fillText: _emailContactPersonText,
                      focusNode: _emailContactPersonFocusNode),

                  _buildTextField(AppLocalizations.text(LangKey.inputAddress),
                      "", Assets.iconAddress, false, false, true,
                      fillText: _addressContactText,
                      focusNode: _addressContactFocusNode),
                ],
              )
            : Container()
      ],
    );
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
                    AppLocalizations.text(LangKey.sex),
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
                        color: (genderSelected?.genderID == 0)
                            ? AppColors.primaryColor
                            : AppColors.darkGrey,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(right: 5.0, top: 5.0, bottom: 5.0),
                    padding: EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
                    child: Center(
                      child: Text(
                        AppLocalizations.text(LangKey.male),
                        style: TextStyle(
                            fontSize: AppTextSizes.size15,
                            color: (genderSelected?.genderID == 0)
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
                        color: (genderSelected?.genderID == 1)
                            ? AppColors.primaryColor
                            : AppColors.darkGrey,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(right: 5.0, top: 5.0, bottom: 5.0),
                    padding: EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
                    child: Text(
                      AppLocalizations.text(LangKey.female),
                      style: TextStyle(
                          fontSize: AppTextSizes.size15,
                          color: (genderSelected?.genderID == 1)
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
                        color: (genderSelected?.genderID == 2)
                            ? AppColors.primaryColor
                            : AppColors.darkGrey,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(right: 5.0),
                    padding: EdgeInsets.only(
                        top: 3.0, bottom: 3.0, left: 15.0, right: 15.0),
                    child: Center(
                      child: Text(
                        AppLocalizations.text(LangKey.other),
                        style: TextStyle(
                            fontSize: AppTextSizes.size15,
                            color: (genderSelected?.genderID == 2)
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
    widget.detailPotential.gender = genderSelected.genderEnName;

    setState(() {});
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
                            fontSize: 14.0,
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
                        fontSize: 14.0,
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

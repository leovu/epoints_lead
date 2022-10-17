import 'package:flutter/material.dart';
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
import 'package:lead_plugin_epoint/model/response/get_province_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_ward_model_response.dart';
import 'package:lead_plugin_epoint/model/response/list_customer_lead_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modal/allocator_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/business_focal_point_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/district_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/province_modal.dart';
import 'package:lead_plugin_epoint/utils/navigator.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';

class BuildMoreAddressEditPotential extends StatefulWidget {
  DetailPotentialData detailPotential;
  List<ProvinceData> provinces = <ProvinceData>[];
  List<AllocatorData> allocatorData = <AllocatorData>[];
  AddLeadModelRequest requestModel = AddLeadModelRequest();
  BuildMoreAddressEditPotential(
      {Key key,
      this.provinces,
      this.allocatorData,
      this.requestModel,
      this.detailPotential})
      : super(key: key);

  @override
  _BuildMoreAddressEditPotentialState createState() =>
      _BuildMoreAddressEditPotentialState();
}

class _BuildMoreAddressEditPotentialState
    extends State<BuildMoreAddressEditPotential> {
  final TextEditingController _addressText = TextEditingController();
  final TextEditingController _focalPointText = TextEditingController();
  final TextEditingController _zaloText = TextEditingController();
  final TextEditingController _fanpageFBText = TextEditingController();
  final TextEditingController _emailText = TextEditingController();

  FocusNode _addressFocusNode = FocusNode();
  FocusNode _focalPointFocusNode = FocusNode();
  FocusNode _zaloFocusNode = FocusNode();
  FocusNode _fanpageFBFocusNode = FocusNode();
   FocusNode _emailFocusNode = FocusNode();

  ProvinceData provinceSeleted = ProvinceData();
  AllocatorData allocatorSelected = AllocatorData();

  List<DistrictData> districts = <DistrictData>[];
  DistrictData distictSelected = DistrictData();
  List<WardData> wards = <WardData>[];
  WardData wardSelected = WardData();

  List<ListCustomLeadItems>  businessFocalPointData = <ListCustomLeadItems>[];
  ListCustomLeadItems businessFocalPointSeleted = ListCustomLeadItems();

  List<GenderModel> genderData = [
    GenderModel(genderName: AppLocalizations.text(LangKey.male),
        genderEnName: "male",
            genderID: 0,
            selected: false
  ),
  GenderModel(genderName: AppLocalizations.text(LangKey.female),
  genderEnName: "female",
            genderID: 1,
            selected: false
  ),
  GenderModel(genderName: AppLocalizations.text(LangKey.other),
  genderEnName: "other",
            genderID: 2,
            selected: false
  )
  
  ];
  GenderModel genderSelected = GenderModel();

  bool showMoreAll = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // LeadConnection.showLoading(context);

      _addressText.text =
          widget.detailPotential?.address ?? "";
      _focalPointText.text =
          widget.detailPotential?.businessClue ?? "";
      _zaloText.text = widget.detailPotential?.zalo ?? "";
      _fanpageFBText.text =
          widget.detailPotential?.fanpage ?? "";

          _emailText.text = widget.detailPotential?.email ?? "";

      businessFocalPointSeleted = ListCustomLeadItems(customerLeadCode:widget.detailPotential?.businessClue ?? "");

      if (widget.detailPotential?.saleId != null ) {
          for (int i = 0; i < widget.allocatorData.length; i++) {
        if ((widget.detailPotential?.saleId ?? 0)
                 ==
            widget.allocatorData[i].staffId) {
                 widget.allocatorData[i].selected = true;

          allocatorSelected = widget.allocatorData[i];
        } else {
          widget.allocatorData[i].selected = false;
        }
      }
      }

      for (int i = 0; i < genderData.length; i++) {
        if ((widget.detailPotential?.gender ?? "")
                .toLowerCase() ==
            genderData[i].genderEnName) {
          genderSelected = genderData[i];
        }
      }

      for (int i = 0; i < widget.provinces.length; i++) {
        if ((widget.detailPotential.provinceName ?? "")
                .toLowerCase() ==
            widget.provinces[i].name.toLowerCase()) {
          widget.provinces[i].selected = true;
          provinceSeleted = widget.provinces[i];
        } else {
          widget.provinces[i].selected = false;
        }
      }
      var dataDistrict = await LeadConnection.getDistrict(
            context, provinceSeleted.provinceid);
        if (dataDistrict != null) {
          districts = dataDistrict.data;
        }

      for (int i = 0; i < districts.length; i++) {
        if ((widget.detailPotential.districtName ?? "")
                .toLowerCase() ==
            districts[i].name.toLowerCase()) {
          districts[i].selected = true;
          distictSelected = districts[i];
        } else {
          districts[i].selected = false;
        }
      }
       var wardData =
            await LeadConnection.getWard(context, distictSelected.districtid);
        if (wardData != null) {
          wards = wardData.data;
        }



      // for (int i = 0; i < wards.length; i++) {
      //   if ((widget.detailPotential.wardName ?? "")
      //           .toLowerCase() ==
      //       wards[i].name.toLowerCase()) {
      //     wards[i].selected = true;
      //     wardSelected = wards[i];
      //   } else {
      //     wards[i].selected = false;
      //   }
      // }

      // Navigator.of(context).pop;


      

      setState(() {
        // Navigator.of(context).pop;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
          sexInfo(genderSelected?.genderID ?? 0),

          _buildTextField(AppLocalizations.text(LangKey.email), "",
              Assets.iconEmail, false, false, true,
              fillText: _emailText, focusNode: _emailFocusNode),

          _buildTextField(
              AppLocalizations.text(LangKey.provinceCity),
              provinceSeleted?.name ?? "",
              Assets.iconProvince,
              false,
              true,
              false, ontap: () async {
            FocusScope.of(context).unfocus();
            ProvinceData province = await showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return GestureDetector(
                    child: ProvinceModal(
                      provinces: widget.provinces,
                    ),
                    onTap: () {
                      LeadNavigator.pop(context);
                    },
                    behavior: HitTestBehavior.opaque,
                  );
                });
            if (province != null) {
              if (provinceSeleted?.provinceid != province.provinceid) {
                distictSelected = null;
                wardSelected = null;
              }
              provinceSeleted = province;
              widget.detailPotential.provinceId = provinceSeleted.provinceid;
              widget.detailPotential.districtId = 0;
              var dataDistrict = await LeadConnection.getDistrict(
                  context, provinceSeleted.provinceid);
              if (dataDistrict != null) {
                districts = dataDistrict.data;
              }
              setState(() {});
            }
          }),
          Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            // width: (MediaQuery.of(context).size.width - 16) / 2 - 8,
            child: _buildTextField(
                AppLocalizations.text(LangKey.district),
                distictSelected?.name ?? "",
                Assets.iconDistrict,
                false,
                true,
                false, ontap: () async {
              print("quận/ huyện");
              FocusScope.of(context).unfocus();
              DistrictData distict = await showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return GestureDetector(
                      child: DistrictModal(
                        districts: districts,
                      ),
                      onTap: () {
                        LeadNavigator.pop(context);
                      },
                      behavior: HitTestBehavior.opaque,
                    );
                  });
              if (distict != null) {
                if (distictSelected?.districtid != distict.districtid) {
                  wardSelected = null;
                }
                distictSelected = distict;
                widget.detailPotential.districtId = distictSelected.districtid;
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
          // Container(
          //   margin: const EdgeInsets.only(bottom: 10.0, left: 10.0),
          //   width: (MediaQuery.of(context).size.width - 16) / 2 - 4,
          //   child: _buildTextField(
          //       AppLocalizations.text(LangKey.wards),
          //       wardSelected?.name ?? "",
          //       Assets.iconWards,
          //       false,
          //       true,
          //       false, ontap: () async {
          //     print("phường xã");

          //     WardData ward = await showModalBottomSheet(
          //         context: context,
          //         useRootNavigator: true,
          //         isScrollControlled: true,
          //         backgroundColor: Colors.transparent,
          //         builder: (context) {
          //           return GestureDetector(
          //             child: WardModal(
          //               ward: wards,
          //             ),
          //             onTap: () {
          //               LeadNavigator.pop(context);
          //             },
          //             behavior: HitTestBehavior.opaque,
          //           );
          //         });
          //     if (ward != null) {
          //       wardSelected = ward;

          //       setState(() {});
          //     }
          //   }),
          // ),
          // điền địa chỉ
          _buildTextField(AppLocalizations.text(LangKey.inputAddress), "",
              Assets.iconAddress, false, false, true,
              fillText: _addressText, focusNode: _addressFocusNode),

          !showMoreAll
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
                          "Xem thêm",
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

  Widget _buildMoreAll() {
    return Column(
      children: [
        // Chọn người được phân bổ
        _buildTextField(
            AppLocalizations.text(LangKey.chooseAllottedPerson),
            allocatorSelected?.fullName ?? "",
            Assets.iconName,
            false,
            true,
            false, ontap: () async {
          print("Chọn người được phân bổ");
          FocusScope.of(context).unfocus();
          AllocatorData allocator = await showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return GestureDetector(
                  child: AllocatorModal(
                    allocatorData: widget.allocatorData,
                  ),
                  onTap: () {
                    LeadNavigator.pop(context);
                  },
                  behavior: HitTestBehavior.opaque,
                );
              });
          if (allocator != null) {
            allocatorSelected = allocator;
            widget.detailPotential.saleId = allocatorSelected.staffId;
            setState(() {});
          }
        }),
        // Đầu mối doanh nghiệp
        _buildTextField(AppLocalizations.text(LangKey.businessFocalPoint), businessFocalPointSeleted?.customerLeadCode ?? "",
            Assets.iconPoint, false, true, false, ontap: () async {
              FocusScope.of(context).unfocus();
  

          // ListCustomLeadItems businessFocalPoint = await showModalBottomSheet(
          //     context: context,
          //     useRootNavigator: true,
          //     isScrollControlled: true,
          //     backgroundColor: Colors.transparent,
          //     builder: (context) {
          //       return BusinessFocalPointModal(
          //       );
          //     });
          ListCustomLeadItems businessFocalPoint = await LeadNavigator.push(context, BusinessFocalPointModal(businessFocalPointData: businessFocalPointData, businessFocalPointSeleted:  businessFocalPointSeleted,));

          if (businessFocalPoint != null) {
             businessFocalPointSeleted = businessFocalPoint;
             widget.detailPotential.businessClue = businessFocalPointSeleted.customerLeadCode;
            // widget.detailPotential.
            setState(() {});
          }
            }),
        // Zalo
        _buildTextField(AppLocalizations.text(LangKey.zalo), "",
            Assets.iconSource, false, false, true,
            fillText: _zaloText, focusNode: _zaloFocusNode),
        // Nhập Fanpage
        // _buildTextField(AppLocalizations.text(LangKey.inputFanpage), "",
        //     Assets.iconFanpage, false, false, true,
        //     fillText: _fanpageFBText, focusNode: _fanpageFBFocusNode),
      ],
    );
  }

    Widget sexInfo(int index) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              width: 1.0, color: Color(0xFFC3C8D3), style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10.0)),
      padding: const EdgeInsets.only( left: 5.0),
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
                  onTap: ()  {
                    selectedGender(0);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.darkGrey,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(right: 5.0),
                    padding: EdgeInsets.only(
                      top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            right: 4.0,
                          ),
                          height: 15.0,
                          width: 15.0,
                          child: Image.asset(Assets.iconMale),
                        ),
                        Text(
                          AppLocalizations.text(LangKey.male),
                          style: TextStyle(
                              fontSize: AppTextSizes.size15,
                              color: (genderSelected?.genderID  == 0) ? Colors.black : Color(0xFF9E9E9E),
                              fontWeight: FontWeight.normal),
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                      selectedGender(1);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.darkGrey,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(right: 5.0),
                    padding: EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            right: 4.0,
                          ),
                          height: 15.0,
                          width: 15.0,
                          child: Image.asset(Assets.iconFemale),
                        ),
                        Text(
                          AppLocalizations.text(LangKey.female),
                          style: TextStyle(
                              fontSize: AppTextSizes.size15,
                              color: (genderSelected?.genderID == 1) ? Colors.black : Color(0xFF9E9E9E),
                              fontWeight: FontWeight.normal),
                          maxLines: 1,
                        )
                      ],
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
                        color: AppColors.darkGrey,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(right: 5.0),
                    padding: EdgeInsets.only(
                        top: 3.0, bottom: 3.0, left: 8.0, right: 8.0),
                    child: Center(
                      child: Text(
                        AppLocalizations.text(LangKey.other),
                        style: TextStyle(
                            fontSize: AppTextSizes.size15,
                            color: (genderSelected?.genderID == 2) ? Colors.black : Color(0xFF9E9E9E),
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
    
    setState(() {
    });
  }

  Widget _buildTextField(String title, String content, String icon,
      bool mandatory, bool dropdown, bool textfield,
      {Function ontap, TextEditingController fillText, FocusNode focusNode ,TextInputType inputType }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: (ontap != null) ? ontap : null,
        child: TextField(
          enabled: textfield,
          readOnly: !textfield,
          controller: fillText,
          focusNode: focusNode,
          keyboardType: (inputType != null) ? inputType: TextInputType.text,
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
                            fontSize: 15.0,
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
            if (fillText == _addressText) {
              widget.detailPotential?.address = event;
            } else if (fillText == _zaloText) {
              widget.detailPotential?.zalo = event;
            } else if (fillText == _fanpageFBText){
              widget.detailPotential?.fanpage = event;
            } else {
              widget.detailPotential?.email = _emailText.text;
            }

          },
        ),
      ),
    );
  }
}

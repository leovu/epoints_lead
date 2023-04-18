import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/aws_connection.dart';
import 'package:lead_plugin_epoint/connection/aws_interaction.dart';
import 'package:lead_plugin_epoint/connection/http_connection.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/request/add_work_model_request.dart';
import 'package:lead_plugin_epoint/model/response/description_model_response.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/model/response/get_status_work_response_model.dart';
import 'package:lead_plugin_epoint/model/response/get_tag_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_type_work_response_model.dart';
// import 'package:lead_plugin_epoint/model/response/list_customer_lead_model_response.dart';
import 'package:lead_plugin_epoint/model/response/list_project_model_response.dart';
import 'package:lead_plugin_epoint/model/type_card_model.dart';
import 'package:lead_plugin_epoint/model/work_upload_file_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modal/list_projects_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/status_work_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/tag_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/type_of_work_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/customer_care_potential/customer_care_bloc.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/detail_potential_customer.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/multi_staff_screen_customer_care/ui/multi_staff_screen_customer_care.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/pick_one_staff_screen/ui/pick_one_staff_screen.dart';
import 'package:lead_plugin_epoint/utils/custom_document_picker.dart';
import 'package:lead_plugin_epoint/utils/custom_permission_request.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_chip.dart';
import 'package:lead_plugin_epoint/widget/custom_column_infomation.dart';
import 'package:lead_plugin_epoint/widget/custom_date_picker.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_menu_bottom_sheet.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:lead_plugin_epoint/widget/custom_size_transaction.dart';
import 'package:lead_plugin_epoint/widget/custom_textfield.dart';

class CustomerCarePotential extends StatefulWidget {
  DetailPotentialData detail;

  CustomerCarePotential({Key key, this.detail}) : super(key: key);

  @override
  _CustomerCarePotentialState createState() => _CustomerCarePotentialState();
}

class _CustomerCarePotentialState extends State<CustomerCarePotential>
    with WidgetsBindingObserver {
  ScrollController _controller = ScrollController();

  TextEditingController _titleText = TextEditingController();
  FocusNode _titleFocusNode = FocusNode();

  TextEditingController _customerCareContentText = TextEditingController();
  FocusNode _customerCareContentFocusNode = FocusNode();

  TextEditingController _enterWorkDescText = TextEditingController();
  FocusNode _enterWorkDescFocusNode = FocusNode();

  List<GetTypeWorkData> typeOfWorkData = [];
  GetTypeWorkData typeOfWorkSelected = GetTypeWorkData();

  List<GetStatusWorkData> statusWorkData = [];
  GetStatusWorkData statusWorkSelected = GetStatusWorkData();
  ListProjectItems projectSelected;

  List<TypeCardModel> typeCardData = [
    TypeCardModel(
      name: AppLocalizations.text(LangKey.bonus),
      id: 0,
      selected: true,
    ),
    TypeCardModel(
      name: AppLocalizations.text(LangKey.kpi),
      id: 1,
      selected: false,
    ),
  ];

  TypeCardModel typeCardSelected = TypeCardModel(
      name: AppLocalizations.text(LangKey.bonus), id: 0, selected: true);

  List<WorkListStaffModel> _modelStaffSelected = [];
  List<WorkListStaffModel> _modelStaffSSupportSelected = [];
  List<TagData> tagsData = [];
  // List<TagData> tagsSelected = [];
  String tagsString = "";
  String staffs = "";

  AddWorkRequestModel addWorkModel = AddWorkRequestModel(
      manageWorkTitle: "",
      manageWorkCustomerType: "",
      manageTypeWorkId: 0,
      // date_start: "",
      // date_finish: "",
      time: 0,
      timeType: "d",
      processorId: 0,
      approveId: 0,
      remindWork:
          RemindWork(dateRemind: "", time: 15, timeType: "m", description: ""),
      progress: 0,
      staffSupport: [],
      parentId: 0,
      description: "",
      manageProjectId: 0,
      customerId: 0,
      listTag: [],
      typeCardWork: "",
      priority: 0,
      manageStatusId: 0,
      isApproveId: 0,
      repeatWork: RepeatWork(
          repeatType: "",
          repeatEnd: "",
          repeatEndFullTime: "",
          repeatTime: "",
          listDate: []),
      createObjectType: "",
      createObjectId: 0);

  DateTime _fromDate;
  DateTime _toDate;
  DateTime _now = DateTime.now();

  final TextEditingController _fromDateText = TextEditingController();
  final TextEditingController _toDateText = TextEditingController();

  var _isKeyboardVisible = false;
  bool _switchValue = false;
  bool showMore = false;
  bool has_approved = false;

  CustomerCareBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CustomerCareBloc(context);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await callApi();
    });
  }

  void callApi() async {
    var typeOfWorkModel = await LeadConnection.getTypeWork(context);
    if (typeOfWorkModel != null) {
      typeOfWorkData = typeOfWorkModel.data;
      print(typeOfWorkData);
    }

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

  _uploadFile() async {
    File file = await CustomDocumentPicker.openDocument(context, params: [
      "txt",
      "pdf",
      "doc",
      "docx",
      "xls",
      "xlsx",
      "xlsm",
      "pptx",
      "ppt",
      "jpeg",
      "jpg",
      "png"
    ]);

    if (file != null) {
      _bloc.workUploadFile(file);
      

    }
  }

  static Future<List<File>> openMultiDocument(
    BuildContext context, {
    List<String> params,
  }) async {
    try {
      bool permission = true;
      permission = await CustomPermissionRequest.request(
          context, PermissionRequestType.STORAGE);

      if (!permission) return null;
    } catch (_) {
      return null;
    }

    FilePickerResult files = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: params, allowMultiple: true);

    return files == null ? null : files.files.map((e) => File(e.path)).toList();
  }

  String getNameFromPath(String path) {
    String event = path ?? "";
    return event.contains("/") ? event.split("/").last : event;
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
              AppLocalizations.text(LangKey.customerCareUpcase),
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
          SizedBox(height: 9.0),
          _buildTextField(
              AppLocalizations.text(LangKey.enterWorkTitle),
              // customerTypeSelected?.customerTypeName ?? "",
              "",
              Assets.iconWorkTitle,
              true,
              false,
              true,
              fillText: _titleText,
              focusNode: _titleFocusNode),
          _buildTextField(
              AppLocalizations.text(LangKey.chooseTypeOfWork),
              typeOfWorkSelected?.manageTypeWorkName ?? "",
              Assets.iconMenu,
              false,
              true,
              false,
              fillText: _customerCareContentText,
              focusNode: _customerCareContentFocusNode, ontap: () async {
            FocusScope.of(context).unfocus();
            if (typeOfWorkData.length == 0) {
              LeadConnection.showLoading(context);
              var types = await LeadConnection.getTypeWork(context);

              Navigator.of(context).pop();
              if (types != null) {
                typeOfWorkData = types.data;

                GetTypeWorkData typeSelected =
                    await CustomNavigator.showCustomBottomDialog(
                  context,
                  TypeOfWorkModal(typeOfWorkData: typeOfWorkData),
                );
                if (typeSelected != null) {
                  typeOfWorkSelected = typeSelected;
                  addWorkModel.manageTypeWorkId =
                      typeOfWorkSelected.manageTypeWorkId;

                  setState(() {});
                }
              }
            } else {
              GetTypeWorkData typeSelected =
                  await CustomNavigator.showCustomBottomDialog(
                context,
                TypeOfWorkModal(typeOfWorkData: typeOfWorkData),
              );
              if (typeSelected != null) {
                typeOfWorkSelected = typeSelected;
                setState(() {});
              }
            }
          }),

          _buildTextField(
              AppLocalizations.text(LangKey.chooseStartDay),
              _fromDateText.text ?? "",
              Assets.iconEstablish,
              false,
              true,
              false, ontap: () async {
            FocusScope.of(context).unfocus();
            _showFromDate();
          }),

          _buildTextField(
              AppLocalizations.text(LangKey.chooseCompleteDay),
              _toDateText.text ?? "",
              Assets.iconEstablish,
              true,
              true,
              false, ontap: () async {
            _showToDate();
          }),

          _buildTextField(
              AppLocalizations.text(LangKey.chooseStatus),
              statusWorkSelected?.manageStatusName ?? "",
              Assets.iconStatus,
              true,
              true,
              false, ontap: () async {
            FocusScope.of(context).unfocus();

            if (statusWorkData.length == 0) {
              LeadConnection.showLoading(context);
              var statusWorkModel = await LeadConnection.getStatusWork(context);

              Navigator.of(context).pop();
              if (statusWorkModel != null) {
                statusWorkData = statusWorkModel.data;

                GetStatusWorkData status =
                    await CustomNavigator.showCustomBottomDialog(
                  context,
                  StatusWorkModal(statusWorkData: statusWorkData),
                );
                if (status != null) {
                  statusWorkSelected = status;
                  addWorkModel.manageStatusId =
                      statusWorkSelected.manageStatusId;
                  setState(() {});
                }
              }
            } else {
              GetStatusWorkData status =
                  await CustomNavigator.showCustomBottomDialog(
                context,
                StatusWorkModal(statusWorkData: statusWorkData),
              );
              if (status != null) {
                statusWorkSelected = status;
                addWorkModel.manageStatusId = statusWorkSelected.manageStatusId;
                setState(() {});
              }
            }
          }),

          // Chọn người thực hiện
          _buildTextField(
              AppLocalizations.text(LangKey.chooseExecutor),
              (_modelStaffSelected != null && _modelStaffSelected.length > 0)
                  ? _modelStaffSelected[0]?.staffName ?? ""
                  : "",
              Assets.iconPerson,
              true,
              true,
              false, ontap: () async {
            FocusScope.of(context).unfocus();
            print("Chọn người thực hiện");

            _modelStaffSelected =
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PickOneStaffScreen(
                          models: _modelStaffSelected,
                          title: AppLocalizations.text(
                              LangKey.chooseExecutorUpcase),
                        )));

            if (_modelStaffSelected != null && _modelStaffSelected.length > 0) {
              if (addWorkModel.processorId == _modelStaffSelected[0].staffId) {
                return;
              }

              print(_modelStaffSelected);
              addWorkModel.processorId = _modelStaffSelected[0].staffId;

              staffs = "";
              _modelStaffSSupportSelected = [];
              addWorkModel.staffSupport = [];

              setState(() {});
            }
          }),

          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: CustomTextField(
              maxLines: 4,
              backgroundColor: Colors.transparent,
              borderColor: AppColors.borderColor,
              hintText: AppLocalizations.text(LangKey.enterWorkDesc),
              controller: _enterWorkDescText,
              focusNode: _enterWorkDescFocusNode,
            ),
          ),

          CustomColumnInformation(
            title: "File",
            child: Column(
              children: [
                StreamBuilder(
                    stream: _bloc.outputFiles,
                    initialData: null,
                    builder: (_, snapshot) {
                      List<String> models = snapshot.data ?? [];
                      return models.isEmpty
                          ? Container()
                          : Container(
                              padding:
                                  EdgeInsets.only(bottom: AppSizes.minPadding),
                              margin: EdgeInsets.only(right: 5.0),
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                spacing: AppSizes.minPadding,
                                runSpacing: AppSizes.minPadding,
                                children: models
                                    .map((e) => Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: CustomChip(
                                                isExpand: true,
                                                radius: 5.0,
                                                backgroundColor:
                                                    Color(0xFFC4C4C4),
                                                text: getNameFromPath(e),
                                                style: AppTextStyles
                                                    .style13WhiteNormal,
                                                onClose: () =>
                                                    _bloc.removeFile(e),
                                              ),
                                            )
                                          ],
                                        ))
                                    .toList(),
                              ),
                            );
                    }),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      _uploadFile();
                    },
                    child: DottedBorder(
                      color: AppColors.borderColor,
                      borderType: BorderType.RRect,
                      radius: Radius.circular(10),
                      padding: EdgeInsets.all(6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Container(
                          height: 40.0,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                                AppLocalizations.text(
                                    LangKey.pressUploadPhotosAndVideos),
                                style: TextStyle(
                                    color: Color(0xFF9E9E9E),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.text(LangKey.setReminderSchedule),
                style: TextStyle(
                    color: Color(0xFF0067AC),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700),
              ),
              CupertinoSwitch(
                value: _switchValue,
                onChanged: (value) {
                  setState(() {
                    _switchValue = value;
                  });
                },
              ),
            ],
          ),

          !showMore
              ? InkWell(
                  onTap: () {
                    showMore = true;
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

          CustomSizeTransaction(
            open: showMore,
            child: Container(
              margin: EdgeInsets.only(top: 15.0),
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
                      showMore
                          ? InkWell(
                              child: Text(
                                AppLocalizations.text(LangKey.collapse),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: const Color(0xFF0067AC),
                                    fontWeight: FontWeight.normal),
                              ),
                              onTap: () {
                                showMore = false;
                                setState(() {});

                                print("thu gon");
                              },
                            )
                          : Container()
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.text(LangKey.customerStyle),
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        AppLocalizations.text(LangKey.potentialCustomer),
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  (widget.detail.customerType == "business")
                      ? Container(
                          margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Flexible(
                              //   fit: FlexFit.loose,
                              //   child: Container(
                              //     height: 36.0,
                              //     // width: 70.0,
                              //     decoration: BoxDecoration(
                              //         color: Colors.white,
                              //         boxShadow: [
                              //           BoxShadow(
                              //             offset: Offset(0, 1),
                              //             blurRadius: 2,
                              //             color: Colors.black.withOpacity(0.3),
                              //           )
                              //         ],
                              //         borderRadius: BorderRadius.circular(5.0)),
                              //     child: Image.asset(Assets.imgFeatureDeveloping),
                              //   ),
                              // ),
                              // SizedBox(
                              //   width: 11.0,
                              // ),
                              Text(
                                widget.detail.fullName,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: const Color(0xFF121212),
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )
                      : Container(
                          height: 15.0,
                        ),

                  _buildTextField(
                      AppLocalizations.text(LangKey.chooseSupporter),
                      staffs,
                      Assets.iconPerson,
                      false,
                      true,
                      false, ontap: () async {
                    FocusScope.of(context).unfocus();
                    print("Chọn người ho tro");

                    if (_modelStaffSelected.length == 0) {
                      await LeadConnection.showMyDialog(
                          context, "Vui lòng chọn trước nhân viên thực hiện!");
                    } else {
                      _modelStaffSSupportSelected = await Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) =>
                                  MultipleStaffScreenCustomerCare(
                                    models: _modelStaffSSupportSelected,
                                    modelsSelectedCustomerCare:
                                        _modelStaffSelected,
                                  )));

                      if (_modelStaffSSupportSelected != null &&
                          _modelStaffSSupportSelected.length > 0) {
                        List<StaffSupport> _modelStaffIDSeleted = [];

                        staffs = "";
                        print(_modelStaffSSupportSelected);
                        for (int i = 0;
                            i < _modelStaffSSupportSelected.length;
                            i++) {
                          if (_modelStaffSSupportSelected[i].isSelected) {
                            _modelStaffIDSeleted.add(StaffSupport(
                                staffId:
                                    _modelStaffSSupportSelected[i].staffId));
                            if (staffs == "") {
                              staffs = _modelStaffSSupportSelected[i].staffName;
                            } else {
                              staffs +=
                                  ", ${_modelStaffSSupportSelected[i].staffName}";
                            }
                          }
                        }

                        addWorkModel.staffSupport = _modelStaffIDSeleted;
                        setState(() {});
                      }
                    }
                  }),
                  _buildTextField(
                      AppLocalizations.text(LangKey.chooseCards),
                      tagsString,
                      Assets.iconTag,
                      false,
                      true,
                      false, ontap: () async {
                    print("Tag");
                    FocusScope.of(context).unfocus();

                    if (tagsData == null || tagsData.length == 0) {
                      LeadConnection.showLoading(context);
                      var tags = await LeadConnection.getTag(context);
                      Navigator.of(context).pop();
                      if (tags != null) {
                        tagsData = tags.data;

                        var listTagsSelected = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    TagsModal(tagsData: tagsData)));

                        if (listTagsSelected != null) {
                          List<ListTag> listTag = [];
                          // widget.detailDeal.tag = [];
                          tagsString = "";
                          tagsData = listTagsSelected;

                          for (int i = 0; i < tagsData.length; i++) {
                            if (tagsData[i].selected) {
                              listTag
                                  .add(ListTag(manageTagId: tagsData[i].tagId));
                              if (tagsString == "") {
                                tagsString = tagsData[i].name;
                              } else {
                                tagsString += ", ${tagsData[i].name}";
                              }
                            }
                          }

                          addWorkModel.listTag = listTag;
                          setState(() {});
                        }
                      }
                    } else {
                      var listTagsSelected = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  TagsModal(tagsData: tagsData)));
                      if (listTagsSelected != null) {
                        // widget.detailDeal.tag = [];
                        tagsString = "";
                        tagsData = listTagsSelected;

                        for (int i = 0; i < listTagsSelected.length; i++) {
                          if (listTagsSelected[i].selected) {
                            // widget.detailDeal.tag.add(tagsSelected[i].tagId);

                            if (tagsString == "") {
                              tagsString = listTagsSelected[i].name;
                            } else {
                              tagsString += ", ${listTagsSelected[i].name}";
                            }
                          }
                        }
                        setState(() {});
                      }
                    }
                  }),

                  // Row(
                  //   children: [
                  //     Text(
                  //       AppLocalizations.text(LangKey.tagType),
                  //       style: TextStyle(
                  //           fontSize: 14.0,
                  //           color: const Color(0xFF121212),
                  //           fontWeight: FontWeight.w600),
                  //     ),
                  //     SizedBox(
                  //       width: 20.0,
                  //     ),
                  //     InkWell(
                  //       onTap: () {
                  //         typeCardData[0].selected = true;
                  //         typeCardData[1].selected = false;
                  //         typeCardSelected = typeCardData[0];

                  //         setState(() {});
                  //       },
                  //       child: Row(
                  //         children: [
                  //           typeCardData[0].selected
                  //               ? Icon(
                  //                   Icons.radio_button_on,
                  //                   color: AppColors.primaryColor,
                  //                 )
                  //               : Icon(Icons.radio_button_off),
                  //           SizedBox(
                  //             width: 5.0,
                  //           ),
                  //           Text(
                  //             typeCardData[0].name,
                  //             style: TextStyle(
                  //                 fontSize: 15.0,
                  //                 color: typeCardData[0].selected
                  //                     ? AppColors.primaryColor
                  //                     : Color(0xFF121212),
                  //                 fontWeight: FontWeight.normal),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     SizedBox(width: 20),
                  //     InkWell(
                  //       onTap: () {
                  //         typeCardData[0].selected = false;
                  //         typeCardData[1].selected = true;
                  //         typeCardSelected = typeCardData[1];

                  //         setState(() {});
                  //       },
                  //       child: Row(
                  //         children: [
                  //           typeCardData[1].selected
                  //               ? Icon(
                  //                   Icons.radio_button_on,
                  //                   color: AppColors.primaryColor,
                  //                 )
                  //               : Icon(Icons.radio_button_off),
                  //           SizedBox(
                  //             width: 5.0,
                  //           ),
                  //           Text(
                  //             typeCardData[1].name,
                  //             style: TextStyle(
                  //                 fontSize: 15.0,
                  //                 color: typeCardData[1].selected
                  //                     ? AppColors.primaryColor
                  //                     : Color.fromARGB(255, 56, 48, 48),
                  //                 fontWeight: FontWeight.normal),
                  //           ),
                  //         ],
                  //       ),
                  //     )
                  //   ],
                  // ),

                  // SizedBox(
                  //   height: 15.0,
                  // ),

                  // chon du an
                  _buildTextField(
                      // ListProjectItems projectSelected
                      AppLocalizations.text(LangKey.chooseProject),
                      projectSelected?.manageProjectName ?? "",
                      Assets.iconProject,
                      false,
                      true,
                      false, ontap: () async {
                    FocusScope.of(context).unfocus();
                    print("Chọn người thực hiện");

                    projectSelected =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ListProjectsModal(
                                  projectSelected: projectSelected,
                                )));

                    if (projectSelected != null) {
                      print(projectSelected);

                      addWorkModel.manageProjectId =
                          projectSelected.manageProjectId;
                      setState(() {});
                    }
                  }),

                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            has_approved = !has_approved;
                            setState(() {});
                          },
                          child: has_approved
                              ? Icon(Icons.check_box_outlined,
                                  size: 30, color: AppColors.primaryColor)
                              : Icon(Icons.check_box_outline_blank, size: 30)),
                      SizedBox(width: 10.0),
                      Text(
                        AppLocalizations.text(LangKey.workNeedCensorship),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          )
        ],
      )
    ];
  }

  Future selectFile() async {
    File file;
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;
    setState(() => file = File(path));
    print(file);
  }

  _showFromDate() {
    DateTime selectedDate = _fromDate ?? _toDate ?? _now;
    //   DateTime maximumTime = _now;
    // if (_toDate?.year == _now.year &&
    //     _toDate?.month == _now.month &&
    //     _toDate?.day > _now.day) maximumTime = _toDate;

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
              title: AppLocalizations.text(LangKey.fromDate),
              widget: CustomDatePicker(
                minimumTime: _now,
                initTime: selectedDate,
                maximumTime: _toDate ?? DateTime(2050, 12, 31),
                dateOrder: DatePickerDateOrder.dmy,
                onChange: (DateTime date) {
                  selectedDate = date;
                },
              ),
              onTapConfirm: () {
                _fromDate = selectedDate;

                _fromDateText.text =
                    DateFormat("yyyy-MM-dd").format(selectedDate).toString();
                Navigator.of(context).pop();

                setState(() {});
              },
              haveBnConfirm: true,
            ),
          );
        });
  }

  _showToDate() {
    DateTime selectedDate = _toDate ?? _fromDate ?? _now;
    DateTime maximumTime = _now;
    if (_toDate?.year == _now.year &&
        _toDate?.month == _now.month &&
        _toDate?.day > _now.day) maximumTime = _toDate;
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
              title: AppLocalizations.text(LangKey.toDate),
              widget: CustomDatePicker(
                initTime: selectedDate,
                maximumTime: DateTime(2050, 12, 31),
                minimumTime: _fromDate ?? _now,
                dateOrder: DatePickerDateOrder.dmy,
                onChange: (DateTime date) {
                  selectedDate = date;
                },
              ),
              onTapConfirm: () {
                _toDate = selectedDate;
                _toDateText.text =
                    DateFormat("yyyy-MM-dd").format(selectedDate).toString();
                Navigator.of(context).pop();
                setState(() {});
              },
              haveBnConfirm: true,
            ),
          );
        });
  }

  Widget typeOfWorkItem(String title, bool selected, Function ontap) {
    return InkWell(
      onTap: ontap,
      child: Container(
        // width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            selected
                ? Icon(
                    Icons.radio_button_checked,
                    color: Color(0xFF0067AC),
                  )
                : Icon(Icons.radio_button_unchecked),
            SizedBox(width: 9.0),
            Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }

  selectedItem(int index) async {
    for (int i = 0; i < typeOfWorkData.length; i++) {
      typeOfWorkData[i].selected = false;
    }
    typeOfWorkData[index].selected = true;
    setState(() {});
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
          List<String> list_document = [];
          if (_bloc.outputFiles.hasValue) {
            List<String> models = _bloc.outputFiles.value;
            if (models.length > 0) {
              models.forEach((element) {
                list_document.add(element);
              });
            }
            print(models);
          }
          if ((_titleText.text == "") ||
              (_toDateText.text == "") ||
              (addWorkModel.manageStatusId == 0) ||
              (addWorkModel.processorId == 0)) {
            LeadConnection.showMyDialog(context,
                AppLocalizations.text(LangKey.warningChooseAllRequiredInfo));
          } else {
            LeadConnection.showLoading(context);
            DescriptionModelResponse result = await LeadConnection.addWork(
                context,
                AddWorkRequestModel(
                    manageWorkTitle: _titleText.text ?? "",
                    manageWorkCustomerType: "lead",
                    manageTypeWorkId: addWorkModel.manageTypeWorkId,
                    from_date: _fromDateText.text ?? "",
                    to_date: _toDateText.text ?? "",
                    // date_start: _fromDateText.text ?? "",
                    // date_finish: _toDateText.text ?? "",
                    time: null,
                    timeType: null,
                    processorId: addWorkModel.processorId,
                    approveId: null,
                    remindWork: _switchValue
                        ? RemindWork(
                            dateRemind: _toDateText.text ?? "",
                            timeType: "m",
                            time: 15,
                            description: "Nhắc nhở " + _enterWorkDescText.text)
                        : null,
                    progress: null,
                    staffSupport: addWorkModel.staffSupport,
                    parentId: null,
                    description: _enterWorkDescText.text ?? "",
                    manageProjectId: addWorkModel.manageProjectId,
                    customerId: widget.detail.customerLeadId,
                    listTag: addWorkModel.listTag,
                    typeCardWork: null,
                    priority: 1,
                    manageStatusId: addWorkModel.manageStatusId,
                    isApproveId: has_approved ? 1 : 0,
                    repeatWork: null,
                    createObjectType: "",
                    createObjectId: null,
                    listDocument: list_document));
            Navigator.of(context).pop();
            if (result != null) {
              if (result.errorCode == 0) {
                print(result.errorDescription);

                await LeadConnection.showMyDialog(
                    context, result.errorDescription);

                Navigator.of(context).pop(true);

                // Navigator.of(context).push(MaterialPageRoute(
                //             builder: (context) => DetailPotentialCustomer(
                //               customer_lead_code: widget.item.customerLeadCode,
                //                   customerCare: true,
                //                   indexTab: 2,
                //                 )));

              } else {
                LeadConnection.showMyDialog(context, result.errorDescription);
              }
            }
          }
        },
        child: Center(
          child: Text(
            AppLocalizations.text(LangKey.saveWork),
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w700),
          ),
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
      margin: EdgeInsets.only(bottom: 15),
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
                        overflow: TextOverflow.ellipsis,
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
          onSubmitted: (event) {},
        ),
      ),
    );
  }
}

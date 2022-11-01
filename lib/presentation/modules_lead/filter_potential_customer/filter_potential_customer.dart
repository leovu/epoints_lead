import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/allocate_date.dart';
import 'package:lead_plugin_epoint/model/convert_status.dart';
import 'package:lead_plugin_epoint/model/create_date.dart';
import 'package:lead_plugin_epoint/model/customer_type.dart';
import 'package:lead_plugin_epoint/model/filter_screen_model.dart';
import 'package:lead_plugin_epoint/model/request/list_customer_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_option_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_journey_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_pipeline_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_tag_model_response.dart';
import 'package:lead_plugin_epoint/model/status_assign_model.dart';
import 'package:lead_plugin_epoint/presentation/modal/allocator_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/journey_modal.dart';
import 'package:lead_plugin_epoint/presentation/modal/pipeline_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_by_allocate_date.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_by_convert_status.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_by_create_date.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_by_customer_source.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_by_customer_type.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_by_status.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_by_tags.dart';
import 'package:lead_plugin_epoint/utils/global.dart';


class FilterPotentialCustomer extends StatefulWidget {
  FilterScreenModel filterScreenModel = FilterScreenModel();

  // ListCustomLeadModelRequest filterModel = ListCustomLeadModelRequest();
  FilterPotentialCustomer({Key key, this.filterScreenModel}) : super(key: key);

  @override
  _FilterPotentialCustomerState createState() =>
      _FilterPotentialCustomerState();
}

class _FilterPotentialCustomerState extends State<FilterPotentialCustomer> {
  final ScrollController _controller = ScrollController();

  List<AllocatorData> allocatorData = <AllocatorData>[];
  AllocatorData allocatorSelected = AllocatorData();
  List<PipelineData> pipeLineData = <PipelineData>[];
  PipelineData pipelineSelected = PipelineData();

  List<JourneyData> journeysData = <JourneyData>[];
  JourneyData journeySelected = JourneyData();

  List<TagData> tagDatas = [
    TagData(
        tagId: 0,
        keyword: AppLocalizations.text(LangKey.all),
        name: AppLocalizations.text(LangKey.all),
        selected: true)
  ];
  GetTagModelReponse _modeltTagDatas = GetTagModelReponse();


  List<CustomerOptionSource> customerSources = [
    CustomerOptionSource(
      customerSourceId: 0,
      customerSourceType: AppLocalizations.text(LangKey.all),
      sourceName: AppLocalizations.text(LangKey.all),
      selected: true,
    )
  ];

  CustomerOptionData customerOptionData = CustomerOptionData();

  List<CreateDateModel> createDateOptions = [
    CreateDateModel(
        createDateName: AppLocalizations.text(LangKey.today),
        createDateID: 0,
        selected: false),
    CreateDateModel(
        createDateName: AppLocalizations.text(LangKey.tomorrow),
        createDateID: 1,
        selected: false),
    CreateDateModel(
        createDateName: AppLocalizations.text(LangKey.seven_day_ago),
        createDateID: 2,
        selected: false),
    CreateDateModel(
        createDateName: AppLocalizations.text(LangKey.thirty_day_ago),
        createDateID: 3,
        selected: false),
    CreateDateModel(
        createDateName: AppLocalizations.text(LangKey.in_month),
        createDateID: 4,
        selected: false),
    CreateDateModel(
        createDateName: AppLocalizations.text(LangKey.last_month),
        createDateID: 5,
        selected: false),
    CreateDateModel(
        createDateName: AppLocalizations.text(LangKey.date_option),
        createDateID: 6,
        selected: false)
  ];

  List<AllocateDateModel> allocateDateOptions = [
    AllocateDateModel(
        allocateDateName: AppLocalizations.text(LangKey.today),
        allocateDateID: 0,
        selected: false),
    AllocateDateModel(
        allocateDateName: AppLocalizations.text(LangKey.tomorrow),
        allocateDateID: 1,
        selected: false),
    AllocateDateModel(
        allocateDateName: AppLocalizations.text(LangKey.seven_day_ago),
        allocateDateID: 2,
        selected: false),
    AllocateDateModel(
        allocateDateName: AppLocalizations.text(LangKey.thirty_day_ago),
        allocateDateID: 3,
        selected: false),
    AllocateDateModel(
        allocateDateName: AppLocalizations.text(LangKey.in_month),
        allocateDateID: 4,
        selected: false),
    AllocateDateModel(
        allocateDateName: AppLocalizations.text(LangKey.last_month),
        allocateDateID: 5,
        selected: false),
    AllocateDateModel(
        allocateDateName: AppLocalizations.text(LangKey.date_option),
        allocateDateID: 6,
        selected: false)
  ];

  List<CustomerTypeModel> customerTypeData = [
    CustomerTypeModel(
        customerTypeName: AppLocalizations.text(LangKey.all),
        customerTypeID: 0,
        selected: true)
  ];

  List<StatusAssignModel> statusOptions = [
    StatusAssignModel(
        statusName: AppLocalizations.text(LangKey.all),
        statusID: 0,
        selected: true),
    StatusAssignModel(
        statusName: AppLocalizations.text(LangKey.assigned),
        statusID: 1,
        selected: false),
    StatusAssignModel(
        statusName: AppLocalizations.text(LangKey.unassigned),
        statusID: 2,
        selected: false)
  ];

  List<ConvertStatusModel> convertStatusOptions = [
    ConvertStatusModel(
        statusName: AppLocalizations.text(LangKey.all),
        statusID: 2,
        selected: true),
    ConvertStatusModel(
        statusName: AppLocalizations.text(LangKey.convertCustomersSuccess),
        statusID: 1,
        selected: false),
    ConvertStatusModel(
        statusName: AppLocalizations.text(LangKey.convertCustomersNotSuccess),
        statusID: 0,
        selected: false)
  ];

 

  FilterScreenModel filterScreenModel = FilterScreenModel(
      filterModel: ListCustomLeadModelRequest(
          search: "",
          page: 1,
          statusAssign: "",
          customerType: "",
          tagId: "",
          customerSourceName: "",
          isConvert: "",
          staffFullName:"",
          pipelineName: "",
          journeyName: "",
          createdAt:"",
          allocationDate: ""),
      fromDate_created_at: null,
      toDate_created_at: null,
      fromDate_allocation_date: null,
      toDate_allocation_date: null,
      id_created_at: "",
      id_allocation_date: "");

  // bool isSelected = false;
  @override
  void initState() {
    super.initState();
    filterScreenModel = FilterScreenModel(
      filterModel: ListCustomLeadModelRequest.fromJson(widget.filterScreenModel.filterModel.toJson()),
      fromDate_created_at: widget.filterScreenModel.fromDate_created_at,
      toDate_created_at: widget.filterScreenModel.toDate_created_at,
      fromDate_allocation_date: widget.filterScreenModel.fromDate_allocation_date,
      toDate_allocation_date: widget.filterScreenModel.toDate_allocation_date,
      id_created_at: widget.filterScreenModel.id_created_at,
      id_allocation_date: widget.filterScreenModel.id_allocation_date
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      LeadConnection.showLoading(context);
      await getData();
      Navigator.of(context).pop();
    });
  }

  void bindingModel() async {

    for (int i = 0; i < tagDatas.length; i++) {
      if (filterScreenModel.filterModel.tagId != "") {
        if (widget.filterScreenModel.filterModel.tagId ==
            "${tagDatas[i].tagId}") {
          tagDatas[i].selected = true;
        } else {
          tagDatas[i].selected = false;
        }
      }
    }

    for (int i = 0; i < customerTypeData.length; i++) {
      if (filterScreenModel.filterModel.customerType != "") {
        if (widget.filterScreenModel.filterModel.customerType ==
            customerTypeData[i].customerTypeName) {
          customerTypeData[i].selected = true;
        } else {
          customerTypeData[i].selected = false;
        }
      }
    }

    for (int i = 0; i < statusOptions.length; i++) {
      if (filterScreenModel.filterModel.statusAssign != "") {
        if (widget.filterScreenModel.filterModel.statusAssign ==
            "${statusOptions[i].statusID}") {
          statusOptions[i].selected = true;
        } else {
          statusOptions[i].selected = false;
        }
      }
    }

    for (int i = 0; i < customerSources.length; i++) {
      if (filterScreenModel.filterModel.customerSourceName != "") {
        if (widget.filterScreenModel.filterModel.customerSourceName ==
            customerSources[i].sourceName) {
          customerSources[i].selected = true;
        } else {
          customerSources[i].selected = false;
        }
      }
    }

    for (int i = 0; i < convertStatusOptions.length; i++) {
      if (filterScreenModel.filterModel.isConvert != "") {
        if (widget.filterScreenModel.filterModel.isConvert ==
            "${convertStatusOptions[i].statusID}") {
          convertStatusOptions[i].selected = true;
        } else {
          convertStatusOptions[i].selected = false;
        }
      }
    }

    if (filterScreenModel.filterModel.staffFullName != "") {
      AllocatorData data = allocatorData.firstWhere((element) =>
          element.fullName ==
          widget.filterScreenModel.filterModel.staffFullName);
      allocatorSelected = data;
      allocatorSelected.selected = true;
    }

    if (filterScreenModel.filterModel.pipelineName != "") {
      PipelineData data = pipeLineData.firstWhere((element) =>
          element.pipelineName ==
          widget.filterScreenModel.filterModel.pipelineName);
      pipelineSelected = data;
      pipelineSelected.selected = true;

      var journeys = await LeadConnection.getJourney(
          context, pipelineSelected.pipelineCode);
      if (journeys != null) {
        journeysData = journeys.data;

        if (filterScreenModel.filterModel.journeyName != "") {
          JourneyData data = journeysData.firstWhere((element) =>
              element.journeyName ==
              widget.filterScreenModel.filterModel.journeyName);
          journeySelected = data;
          journeySelected.selected = true;
        }
      }
    }
    setState(() {});
  }

  void getData() async {
    var tags = await LeadConnection.getTag(context);
    if (tags != null) {
      tagDatas.addAll(tags.data);
      
    }
    var sources = await LeadConnection.getCustomerOption(context);
    if (sources != null) {
      customerOptionData = sources.data;
      customerSources.addAll(customerOptionData.source);

      customerTypeData.add(CustomerTypeModel(
          customerTypeName: customerOptionData.customerType.personal,
          customerTypeID: 1,
          selected: false));
      customerTypeData.add(CustomerTypeModel(
          customerTypeName: customerOptionData.customerType.business,
          customerTypeID: 2,
          selected: false));
    }
    var pipelines = await LeadConnection.getPipeline(context);
    if (pipelines != null) {
      pipeLineData = pipelines.data;
    }
    var allocator = await LeadConnection.getAllocator(context);
    if (allocator != null) {
      allocatorData = allocator.data;
    }
    bindingModel();
  }


  @override
  void dispose() {
    _controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: AppColors.primaryColor,
          title: Text(
            AppLocalizations.text(LangKey.filter),
            style: const TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
        body: Container(
            decoration: const BoxDecoration(color: AppColors.white),
            child: _buildBody()));
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: ListView(
          padding:
              EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 8.0),
          physics: ClampingScrollPhysics(),
          controller: _controller,
          // separator: const Divider(),
          children: _listWidget(),
        )),
        _buildButton(),
        Container(
          height: 20.0,
        )
      ],
    );
  }

  List<Widget> _listWidget() {
    return [
      // theo nhãn
      Text(
        AppLocalizations.text(LangKey.byLabel),
        style: TextStyle(
            fontSize: 16.0,
            color: const Color(0xFF0067AC),
            fontWeight: FontWeight.bold),
      ),
      FilterByTags(
        tagDatas: tagDatas,
      ),

      // theo loại khách hàng
      Text(
        AppLocalizations.text(LangKey.byCustomerType),
        style: TextStyle(
            fontSize: 16.0,
            color: const Color(0xFF0067AC),
            fontWeight: FontWeight.bold),
      ),
      FilterByCustomerType(customerTypeData: customerTypeData),

      // theo trạng thái
      Text(
        AppLocalizations.text(LangKey.byStatus),
        style: TextStyle(
            fontSize: 16.0,
            color: const Color(0xFF0067AC),
            fontWeight: FontWeight.bold),
      ),
      FilterBySatus(
        statusOptions: statusOptions,
      ),

      // theo nguồn khách hàng
      Text(
        AppLocalizations.text(LangKey.byCustomerSource),
        style: TextStyle(
            fontSize: 16.0,
            color: const Color(0xFF0067AC),
            fontWeight: FontWeight.bold),
      ),
      FilterByCustomerSource(
        customerSources: customerSources,
      ),

      // theo ngày tạo
      Text(
        AppLocalizations.text(LangKey.byCreationDate),
        style: TextStyle(
            fontSize: 16.0,
            color: const Color(0xFF0067AC),
            fontWeight: FontWeight.bold),
      ),
      FilterByCreateDate(
        filterScreenModel: filterScreenModel,
        createDateOptions: createDateOptions,
        id_create_date: filterScreenModel.id_created_at,
      ),

      Text(
        AppLocalizations.text(LangKey.byAllocateDate),
        style: TextStyle(
            fontSize: 16.0,
            color: const Color(0xFF0067AC),
            fontWeight: FontWeight.bold),
      ),

      FilterByAllocateDate(
        filterScreenModel: filterScreenModel,
        allocateDateOptions: allocateDateOptions,
        id_allocate_date: filterScreenModel.id_allocation_date,
      ),

      // khung thời gian tự chọn
      // Text(
      //   AppLocalizations.text(LangKey.customerTimeFrame),
      //   style: TextStyle(
      //       fontSize: 15.0,
      //       color: const Color(0xFF8E8E8E),
      //       fontWeight: FontWeight.normal),
      // ),

      // Container(
      //   height: 10.0,
      // ),

      // Row(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     Container(
      //         margin: const EdgeInsets.only(bottom: 10.0),
      //         width: (MediaQuery.of(context).size.width - 60) / 2 - 8,
      //         child: _buildDatePicker(
      //             AppLocalizations.text(LangKey.fromDate), _fromDateText, () {
      //           _showFromDatePickerAllocateDate();
      //         })),
      //     Container(
      //         margin: EdgeInsets.only(left: 15, right: 5),
      //         child: Text(
      //           "-",
      //           style: TextStyle(color: Color(0xFF8E8E8E)),
      //         )),
      //     Container(
      //         margin: const EdgeInsets.only(bottom: 10.0, left: 10.0),
      //         width: (MediaQuery.of(context).size.width - 60) / 2 - 4,
      //         child: _buildDatePicker(
      //             AppLocalizations.text(LangKey.toDate), _toDateText, () {
      //           _showToDatePickerAllocateDate();
      //         }))
      //   ],
      // ),
      Container(height: 10.0),

      Text(
        AppLocalizations.text(LangKey.byConvertStatus),
        style: TextStyle(
            fontSize: 16.0,
            color: const Color(0xFF0067AC),
            fontWeight: FontWeight.bold),
      ),
      FilterByConvertStatus(
        convertStatusOptions: convertStatusOptions,
      ),
      Text(
        AppLocalizations.text(LangKey.byAllocator),
        style: TextStyle(
            fontSize: 16.0,
            color: const Color(0xFF0067AC),
            fontWeight: FontWeight.bold),
      ),

      Container(
        height: 10.0,
      ),

      _buildTextField(
          AppLocalizations.text(LangKey.chooseAllottedPerson),
          allocatorSelected?.fullName ?? "",
          Assets.iconName,
          false,
          true,
          false, ontap: () async {
        print("Chọn người được phân bổ");
        AllocatorData allocator = await showModalBottomSheet(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return GestureDetector(
                child: AllocatorModal(
                  allocatorData: allocatorData,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
                behavior: HitTestBehavior.opaque,
              );
            });
        if (allocator != null) {
          allocatorSelected = allocator;
          filterScreenModel.filterModel.staffFullName =
              allocatorSelected.fullName;
          setState(() {});
        }
      }),
      Container(height: 10.0),

      Text(
        AppLocalizations.text(LangKey.byPipeline),
        style: TextStyle(
            fontSize: 16.0,
            color: const Color(0xFF0067AC),
            fontWeight: FontWeight.bold),
      ),

      Container(height: 10.0),

      // chọn pipeline
      _buildTextField(
          AppLocalizations.text(LangKey.choosePipeline),
          pipelineSelected?.pipelineName ?? "",
          Assets.iconChance,
          false,
          true,
          false, ontap: () async {
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
          filterScreenModel.filterModel.pipelineName =
              pipelineSelected.pipelineName;

          var journeys = await LeadConnection.getJourney(
              context, pipelineSelected.pipelineCode);
          if (journeys != null) {
            journeysData = journeys.data;
          }
          setState(() {});
        }
      }),

      Container(height: 10.0),

      Text(
        AppLocalizations.text(LangKey.byJourney),
        style: TextStyle(
            fontSize: 16.0,
            color: const Color(0xFF0067AC),
            fontWeight: FontWeight.bold),
      ),

      Container(height: 10.0),
      _buildTextField(
          AppLocalizations.text(LangKey.chooseItinerary),
          journeySelected?.journeyName ?? "",
          Assets.iconItinerary,
          false,
          true,
          false, ontap: () async {
        print("Chọn hành trình");

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
          filterScreenModel.filterModel.journeyName =
              journeySelected.journeyName;

          setState(() {
            // await LeadConnection.getDistrict(context, province.provinceid);
          });
        }
      }),
    ];
  }

  Widget _buildTextField(String title, String content, String icon,
      bool mandatory, bool dropdown, bool textfield,
      {Function ontap, TextEditingController fillText}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: ontap,
        child: TextField(
          enabled: textfield,
          readOnly: !textfield,
          controller: fillText,
          // focusNode: _focusNode,
          keyboardType: TextInputType.text,
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
            if (fillText != null) {
              print(fillText.text);
            }
          },
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
          height: 40,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () {
              print("ap dung");

               if (Global.validateCreateDate == false ||
                  Global.validateAllocateDate == false) {
                LeadConnection.showMyDialog(
                    context,
                    AppLocalizations.text(
                        LangKey.warningChooseFullFromdateTodate));
                return;
              }
              var tagData = tagDatas.firstWhere((element) => element.selected);
              if (tagData.name == AppLocalizations.text(LangKey.all)){
                filterScreenModel.filterModel.tagId = "";
              } else {
               filterScreenModel.filterModel.tagId = "${tagData.tagId}";
              }

              var cusType =
                  customerTypeData.firstWhere((element) => element.selected);

              if (cusType.customerTypeName == AppLocalizations.text(LangKey.all)) {
                filterScreenModel.filterModel.customerType = "";
              } else {
                filterScreenModel.filterModel.customerType =
                    cusType.customerTypeName;
              }

              var statusOption =
                  statusOptions.firstWhere((element) => element.selected);
              if (statusOption.statusName == AppLocalizations.text(LangKey.all)) {
                widget.filterScreenModel.filterModel.statusAssign = "";
              } else {
                filterScreenModel.filterModel.statusAssign =
                    "${statusOption.statusID}";
              }

              var cusSource =
                  customerSources.firstWhere((element) => element.selected);
                    if (cusSource.sourceName == AppLocalizations.text(LangKey.all)) {
                filterScreenModel.filterModel.customerSourceName =
                  "";
              } else {
                filterScreenModel.filterModel.customerSourceName =
                  cusSource.sourceName;
              }

              var convertStatusOption = convertStatusOptions
                  .firstWhere((element) => element.selected);

                  if (convertStatusOption.statusName == AppLocalizations.text(LangKey.all)) {
                filterScreenModel.filterModel.isConvert =
                  "";
              } else {
                filterScreenModel.filterModel.isConvert =
                  "${convertStatusOption.statusID}";
              }


              widget.filterScreenModel = filterScreenModel;

              Navigator.of(context).pop(widget.filterScreenModel);
            },
            child: Center(
              child: Text(
                // AppLocalizations.text(LangKey.convertCustomers),
                AppLocalizations.text(LangKey.apply),
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
          height: 40,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: 1.0, color: Colors.blue, style: BorderStyle.solid)),
          child: InkWell(
            onTap: ()  async {
              print("xoa");
              await clearData();
            },
            child: Center(
              child: Text(
                AppLocalizations.text(LangKey.delete),
                style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF1A76B4),
                    fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
          ),
        )
      ],
    );
  }

  void clearData() async {
      widget.filterScreenModel = FilterScreenModel(filterModel: ListCustomLeadModelRequest(
        search: "",
        page: 1,
        statusAssign: "",
        customerType: "",
        tagId: "",
        customerSourceName: "",
        isConvert: "",
        staffFullName: "",
        pipelineName: "",
        journeyName: "",
        createdAt: "",
        allocationDate: ""), fromDate_allocation_date: null, toDate_allocation_date: null, fromDate_created_at: null, toDate_created_at:  null,id_created_at: "");

  filterScreenModel = FilterScreenModel(
      filterModel: ListCustomLeadModelRequest.fromJson(widget.filterScreenModel.filterModel.toJson()),
      fromDate_created_at: widget.filterScreenModel.fromDate_created_at,
      toDate_created_at: widget.filterScreenModel.toDate_created_at,
      fromDate_allocation_date: widget.filterScreenModel.fromDate_allocation_date,
      toDate_allocation_date: widget.filterScreenModel.toDate_allocation_date,
      id_created_at: widget.filterScreenModel.id_created_at,
      id_allocation_date: widget.filterScreenModel.id_allocation_date
    );


  allocatorSelected = null;
   pipelineSelected = null;
   journeySelected = null;


   for (int i = 0; i < tagDatas.length; i++) {
      if (i == 0) {
        tagDatas[i].selected = true;
      } else {
        tagDatas[i].selected = false;
      }
    }

    for (int i = 0; i < customerTypeData.length; i++) {
      if (i == 0) {
        customerTypeData[i].selected = true;
      } else {
        customerTypeData[i].selected = false;
      }
    }
   for (int i = 0; i < customerSources.length; i++) {
      if (i == 0) {
        customerSources[i].selected = true;
      } else {
        customerSources[i].selected = false;
      }
    }
    for (int i = 0; i < createDateOptions.length; i++) {
      createDateOptions[i].selected = false;
    }

    for (int i = 0; i < allocateDateOptions.length; i++) {
      allocateDateOptions[i].selected = false;
    }

    for (int i = 0; i < statusOptions.length; i++) {
      if (i == 0) {
        statusOptions[i].selected = true;
      } else {
        statusOptions[i].selected = false;
      }
    }
 

    for (int i = 0; i < convertStatusOptions.length; i++) {
      if (i == 0) {
        convertStatusOptions[i].selected = true;
      } else {
        convertStatusOptions[i].selected = false;
      }
    }

    Global.validateAllocateDate = true;
    Global.validateCreateDate = true;

    setState(() {
      
    });
  }
}

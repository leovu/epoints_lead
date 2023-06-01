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
import 'package:lead_plugin_epoint/model/history_customer_care_date.dart';
import 'package:lead_plugin_epoint/model/request/get_journey_model_request.dart';
import 'package:lead_plugin_epoint/model/request/get_list_staff_request_model.dart';
import 'package:lead_plugin_epoint/model/request/list_customer_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_option_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_journey_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/model/response/get_pipeline_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_status_work_response_model.dart';
import 'package:lead_plugin_epoint/model/response/get_tag_model_response.dart';
import 'package:lead_plugin_epoint/model/status_assign_model.dart';
import 'package:lead_plugin_epoint/model/work_schedule_date.dart';
import 'package:lead_plugin_epoint/presentation/modal/tag_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_by_allocate_date.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_by_convert_status.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_by_create_date.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_by_customer_source.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_by_customer_type.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_by_journey.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_by_pipeline.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_by_status.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/filter_potential_customer/filter_history_care_date.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/multi_staff_screen_customer_care/ui/multi_staff_screen_customer_care.dart';
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
  bool allowPop = false;

  List<AllocatorData> allocatorData = <AllocatorData>[];
  AllocatorData allocatorSelected = AllocatorData();
  List<PipelineData> pipeLineData = <PipelineData>[];
  List<PipelineData> pipelineSelected = <PipelineData>[];

  List<JourneyData> journeysData = <JourneyData>[];
  List<JourneyData> journeySelected = <JourneyData>[];
  List<WorkListStaffModel> _modelStaffSSupportSelected = [];
  List<WorkListStaffModel> _modelStaff = [];
  List<TagData> tagsData = [];
  List<CustomerOptionSource> customerSources = [];

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

  List<HistoryCareDateModel> historyCareDateOptions = [
    HistoryCareDateModel(
        historyCareDateName: AppLocalizations.text(LangKey.today),
        historyCareDateID: 0,
        selected: false),
    HistoryCareDateModel(
        historyCareDateName: AppLocalizations.text(LangKey.tomorrow),
        historyCareDateID: 1,
        selected: false),
    HistoryCareDateModel(
        historyCareDateName: AppLocalizations.text(LangKey.seven_day_ago),
        historyCareDateID: 2,
        selected: false),
    HistoryCareDateModel(
        historyCareDateName: AppLocalizations.text(LangKey.thirty_day_ago),
        historyCareDateID: 3,
        selected: false),
    HistoryCareDateModel(
        historyCareDateName: AppLocalizations.text(LangKey.in_month),
        historyCareDateID: 4,
        selected: false),
    HistoryCareDateModel(
        historyCareDateName: AppLocalizations.text(LangKey.last_month),
        historyCareDateID: 5,
        selected: false),
    HistoryCareDateModel(
        historyCareDateName: AppLocalizations.text(LangKey.date_option),
        historyCareDateID: 6,
        selected: false)
  ];

  List<WorkScheduleModel> workScheduleDateOptions = [
    WorkScheduleModel(
        workscheduleDateName: AppLocalizations.text(LangKey.today),
        workscheduleDateID: 0,
        selected: false),
    WorkScheduleModel(
        workscheduleDateName: AppLocalizations.text(LangKey.tomorrow),
        workscheduleDateID: 1,
        selected: false),
    WorkScheduleModel(
        workscheduleDateName: AppLocalizations.text(LangKey.seven_day_ago),
        workscheduleDateID: 2,
        selected: false),
    WorkScheduleModel(
        workscheduleDateName: AppLocalizations.text(LangKey.thirty_day_ago),
        workscheduleDateID: 3,
        selected: false),
    WorkScheduleModel(
        workscheduleDateName: AppLocalizations.text(LangKey.in_month),
        workscheduleDateID: 4,
        selected: false),
    WorkScheduleModel(
        workscheduleDateName: AppLocalizations.text(LangKey.last_month),
        workscheduleDateID: 5,
        selected: false),
    WorkScheduleModel(
        workscheduleDateName: AppLocalizations.text(LangKey.date_option),
        workscheduleDateID: 6,
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
        statusID: "",
        selected: true),
    StatusAssignModel(
        statusName: AppLocalizations.text(LangKey.assigned),
        statusID: "assigned",
        selected: false),
    StatusAssignModel(
        statusName: AppLocalizations.text(LangKey.unassigned),
        statusID: "unassigned",
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

  List<GetStatusWorkData> statusWorkData;
  String statusWorkString = "";
  String tagsString = "";
  String staffs = "";
  String customerSourceString = "";
  String pipelineString = "";
  String journeyString = "";

  FilterScreenModel filterScreenModel = FilterScreenModel(
      filterModel: ListCustomLeadModelRequest(
        search: "",
        page: 1,
        statusAssign: "",
        customerType: "",
        tagId: [],
        customerSourceId: [],
        staffId: [],
        pipelineId: [],
        journeyId: [],
        careHistory: "",
        isConvert: "",
        createdAt: "",
        allocationDate: "",
      ),
      fromDate_created_at: null,
      toDate_created_at: null,
      fromDate_allocation_date: null,
      toDate_allocation_date: null,
      fromDate_history_care_date: null,
      toDate_history_care_date: null,
      fromDate_work_schedule_date: null,
      toDate_work_schedule_date: null,
      id_history_care_date: "",
      id_work_schedule_date: "",
      id_created_at: "",
      id_allocation_date: "");

  // bool isSelected = false;
  @override
  void initState() {
    super.initState();
    filterScreenModel = FilterScreenModel(
        filterModel: ListCustomLeadModelRequest.fromJson(
            widget.filterScreenModel.filterModel.toJson()),
        fromDate_created_at: widget.filterScreenModel.fromDate_created_at,
        toDate_created_at: widget.filterScreenModel.toDate_created_at,
        fromDate_allocation_date:
            widget.filterScreenModel.fromDate_allocation_date,
        toDate_allocation_date: widget.filterScreenModel.toDate_allocation_date,
        fromDate_history_care_date:
            widget.filterScreenModel.fromDate_history_care_date,
        toDate_history_care_date:
            widget.filterScreenModel.toDate_history_care_date,
        fromDate_work_schedule_date:
            widget.filterScreenModel.fromDate_work_schedule_date,
        toDate_work_schedule_date:
            widget.filterScreenModel.toDate_work_schedule_date,
        id_history_care_date: widget.filterScreenModel.id_history_care_date,
        id_work_schedule_date: widget.filterScreenModel.id_work_schedule_date,
        id_created_at: widget.filterScreenModel.id_created_at,
        id_allocation_date: widget.filterScreenModel.id_allocation_date);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      LeadConnection.showLoading(context);
      await getData();
      Navigator.of(context).pop();
    });
  }

  void bindingModel() async {
    // for (int i = 0; i < tagsData.length; i++) {
    //   if (filterScreenModel.filterModel.tagId != "") {
    //     if (widget.filterScreenModel.filterModel.tagId ==
    //         "${tagsData[i].tagId}") {
    //       tagsData[i].selected = true;
    //     } else {
    //       tagsData[i].selected = false;
    //     }
    //   }
    // }

     if (filterScreenModel.filterModel.tagId.length > 0) {
        for (int i = 0; i < filterScreenModel.filterModel.tagId.length; i++) {
          try {
            tagsData
                .firstWhere(
                    (element) => element.tagId == filterScreenModel.filterModel.tagId[i])
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

    for (int i = 0; i < customerTypeData.length; i++) {
      if (filterScreenModel.filterModel.customerType != "") {
        if (widget.filterScreenModel.filterModel.customerType.toLowerCase() ==
            customerTypeData[i].customerTypeName.toLowerCase()) {
          customerTypeData[i].selected = true;
        } else {
          customerTypeData[i].selected = false;
        }
      }
    }

    for (int i = 0; i < statusOptions.length; i++) {
      if (widget.filterScreenModel.filterModel.statusAssign ==
          statusOptions[i].statusID) {
        statusOptions[i].selected = true;
      } else {
        statusOptions[i].selected = false;
      }
    }

    // for (int i = 0; i < customerSources.length; i++) {
    //   if (filterScreenModel.filterModel.customerSourceId != "") {
    //     if (widget.filterScreenModel.filterModel.customerSourceName ==
    //         customerSources[i].sourceName) {
    //       customerSources[i].selected = true;
    //     } else {
    //       customerSources[i].selected = false;
    //     }
    //   }
    // }

    // if (filterScreenModel.filterModel.customerSourceId.length > 0) {
    //   for (int i = 0;
    //       i < filterScreenModel.filterModel.customerSourceId.length;
    //       i++) {
    //     try {
    //       customerSources
    //           .firstWhere((element) =>
    //               element.customerSourceId ==
    //               filterScreenModel.filterModel.customerSourceId[i])
    //           .selected = true;
    //     } catch (e) {}
    //   }

    //   for (int i = 0; i < customerSources.length; i++) {
    //     if (customerSources[i].selected) {
    //       if (customerSourceString == "") {
    //         customerSourceString = customerSources[i].sourceName;
    //       } else {
    //         customerSourceString += ", ${customerSources[i].sourceName}";
    //       }
    //     }
    //   }
    // }

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

    // if (filterScreenModel.filterModel.staffFullName != "") {
    //   AllocatorData data = allocatorData.firstWhere((element) =>
    //       element.fullName ==
    //       widget.filterScreenModel.filterModel.staffFullName);
    //   allocatorSelected = data;
    //   allocatorSelected.selected = true;
    // }

    if (filterScreenModel.filterModel.customerSourceId.length > 0) {
      for (int i = 0;
          i < filterScreenModel.filterModel.customerSourceId.length;
          i++) {
        try {
          customerSources
              .firstWhere((element) =>
                  element.customerSourceId ==
                  filterScreenModel.filterModel.customerSourceId[i])
              .selected = true;
        } catch (e) {}
      }

      for (int i = 0; i < customerSources.length; i++) {
        if (customerSources[i].selected) {
          if (customerSourceString == "") {
            customerSourceString = customerSources[i].sourceName;
          } else {
            customerSourceString += ", ${customerSources[i].sourceName}";
          }
        }
      }
    }

    if (filterScreenModel.filterModel.staffId.length > 0) {
      _modelStaffSSupportSelected = [];
      for (int i = 0;
          i < filterScreenModel.filterModel.staffId.length;
          i++) {
        try {
          _modelStaff
              .firstWhere((element) =>
                  element.staffId ==
                  filterScreenModel.filterModel.staffId[i])
              .isSelected = true;
        } catch (e) {}
      }

      for (int i = 0; i < _modelStaff.length; i++) {
        if (_modelStaff[i].isSelected) {
          _modelStaffSSupportSelected.add(_modelStaff[i]);
          if (staffs == "") {
            staffs = _modelStaff[i].staffName;
          } else {
            staffs += ", ${_modelStaff[i].staffName}";
          }
        }
      }
    }

    

    if (filterScreenModel.filterModel.pipelineId.length > 0) {
      for (int i = 0;
          i < filterScreenModel.filterModel.pipelineId.length;
          i++) {
        try {
          pipeLineData
              .firstWhere((element) =>
                  element.pipelineId ==
                  filterScreenModel.filterModel.pipelineId[i])
              .selected = true;
        } catch (e) {}
      }

      List<String> listPipeline = [];

      for (int i = 0; i < pipeLineData.length; i++) {
        if (pipeLineData[i].selected) {
          listPipeline.add(pipeLineData[i].pipelineCode);
          if (pipelineString == "") {
            pipelineString = pipeLineData[i].pipelineName;
          } else {
            pipelineString += ", ${pipeLineData[i].pipelineName}";
          }
        }
      }

      var journeys = await LeadConnection.getJourney(
        context, GetJourneyModelRequest(pipelineCode: listPipeline));
    if (journeys != null) {
      journeysData = journeys.data;

      if (filterScreenModel.filterModel.journeyId.length > 0) {
        for (int i = 0;
            i < filterScreenModel.filterModel.journeyId.length;
            i++) {
          try {
            journeysData
                .firstWhere((element) =>
                    element.journeyId ==
                    filterScreenModel.filterModel.journeyId[i])
                .selected = true;
          } catch (e) {}
        }

        for (int i = 0; i < journeysData.length; i++) {
          if (journeysData[i].selected) {
            if (journeyString == "") {
              journeyString = journeysData[i].journeyName;
            } else {
              journeyString += ", ${journeysData[i].journeyName}";
            }
          }
        }
      }
    }

    }

    
    setState(() {});
  }

  void getData() async {
    var tags = await LeadConnection.getTag(context);
    if (tags != null) {
      tagsData.addAll(tags.data);
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

      List<String> listPipeline = [];

      for (int i = 0; i < pipeLineData.length; i++) {
        listPipeline.add(pipeLineData[i].pipelineCode);
      }

      var journeys = await LeadConnection.getJourney(
          context, GetJourneyModelRequest(pipelineCode: listPipeline));
      if (journeys != null) {
        journeysData = journeys.data;
      }

    }

    var response = await LeadConnection.workListStaff(
        context, WorkListStaffRequestModel(manageProjectId: null));
    if (response != null) {
      _modelStaff = response.data ?? [];

    }
    


    // var allocator = await LeadConnection.getAllocator(context);
    // if (allocator != null) {
    //   allocatorData = allocator.data;
    // }
    bindingModel();
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (allowPop) {
          widget.filterScreenModel = FilterScreenModel(
              filterModel: ListCustomLeadModelRequest(
                search: "",
                page: 1,
                statusAssign: "",
                customerType: "",
                tagId: [],
                customerSourceId: [],
                staffId: [],
                pipelineId: [],
                journeyId: [],
                careHistory: "",
                isConvert: "",
                createdAt: "",
                allocationDate: "",
              ),
              fromDate_allocation_date: null,
              toDate_allocation_date: null,
              fromDate_created_at: null,
              toDate_created_at: null,
              id_created_at: "",
              id_allocation_date: "");

          Navigator.of(context).pop(widget.filterScreenModel);
        } else {
          Navigator.of(context).pop();
        }
        return;
      },
      child: Scaffold(
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
              child: _buildBody())),
    );
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
      (tagsData.length > 1)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.text(LangKey.byLabel),
                  style: TextStyle(
                      fontSize: 16.0,
                      color: const Color(0xFF0067AC),
                      fontWeight: FontWeight.bold),
                ),
                // FilterByTags(
                //   tagsData: tagsData,
                // ),

                SizedBox(height: 10.0,),
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
                filterScreenModel.filterModel.tagId = tagsSeletecd;
                setState(() {});
              
            }
          }),

              ],
            )
          : Container(),

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
      // FilterByCustomerSource(
      //   customerSources: customerSources,
      // ),
      SizedBox(
        height: 15.0,
      ),
// nguon khach hang
      _buildTextField(
          AppLocalizations.text(LangKey.byCustomerSource),
          customerSourceString,
          Assets.iconName,
          false,
          true,
          false, ontap: () async {
        List<int> customerSourceSelected = [];
        var customerSourceData = await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    FilterByCustomerSource(customerSources: customerSources)));

        if (customerSourceData != null) {
          // widget.detailDeal.tag = [];
          customerSourceString = "";
          customerSources = customerSourceData;

          for (int i = 0; i < customerSources.length; i++) {
            if (customerSources[i].selected) {
              customerSourceSelected.add(customerSources[i].customerSourceId);
              // widget.detailDeal.tag.add(tagsSelected[i].tagId);
              if (customerSourceString == "") {
                customerSourceString = customerSources[i].sourceName;
              } else {
                customerSourceString += ", ${customerSources[i].sourceName}";
              }
            }
          }
          filterScreenModel.filterModel.customerSourceId =
              customerSourceSelected;
          setState(() {});
        }
      }),
      SizedBox(
        height: 5.0,
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

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),

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

      _buildTextField(AppLocalizations.text(LangKey.chooseAllottedPerson),
          staffs, Assets.iconName, false, true, false, ontap: () async {
        print("Chọn người được phân bổ");
        List<int> listStaff = [];
        _modelStaffSSupportSelected =
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MultipleStaffScreenCustomerCare(
                      models: _modelStaffSSupportSelected,
                    )));

        if (_modelStaffSSupportSelected != null &&
            _modelStaffSSupportSelected.length > 0) {
          staffs = "";
          for (int i = 0; i < _modelStaffSSupportSelected.length; i++) {
            if (_modelStaffSSupportSelected[i].isSelected) {
              listStaff.add(_modelStaffSSupportSelected[i].staffId);
              if (staffs == "") {
                staffs = _modelStaffSSupportSelected[i].staffName;
              } else {
                staffs += ", ${_modelStaffSSupportSelected[i].staffName}";
              }
            }
          }
          filterScreenModel.filterModel.staffId = listStaff;
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
          pipelineString,
          Assets.iconChance,
          false,
          true,
          false, ontap: () async {
        print("Pipeline");

        List<int> pipelineSelected = [];
        List<String> pipelineStringSelected = [];
        List<PipelineData> pipeline = await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => FilterByPipeline(pipeLineData)));

        if (pipeline != null) {
          journeyString = "";
          pipelineString = "";
          pipeLineData = pipeline;

          for (int i = 0; i < pipeLineData.length; i++) {
            if (pipeLineData[i].selected) {
              pipelineSelected.add(pipeLineData[i].pipelineId);
              pipelineStringSelected.add(pipeLineData[i].pipelineCode);
              if (pipelineString == "") {
                pipelineString = pipeLineData[i].pipelineName;
              } else {
                pipelineString += ", ${pipeLineData[i].pipelineName}";
              }
            }
          }
          filterScreenModel.filterModel.pipelineId = pipelineSelected;

          var journeys = await LeadConnection.getJourney(context,
              GetJourneyModelRequest(pipelineCode: pipelineStringSelected));
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
          journeyString,
          Assets.iconItinerary,
          false,
          true,
          false, ontap: () async {
        print("Chọn hành trình");

        List<int> journeySelected = [];
        List<JourneyData> journeys =
            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FilterByJourney(
                      journeys: journeysData,
                    )));

        if (journeys != null) {
          journeyString = "";
          journeysData = journeys;

          for (int i = 0; i < journeysData.length; i++) {
            if (journeysData[i].selected) {
              journeySelected.add(journeysData[i].journeyId);
              if (journeyString == "") {
                journeyString = journeysData[i].journeyName;
              } else {
                journeyString += ", ${journeysData[i].journeyName}";
              }
            }
          }
          filterScreenModel.filterModel.journeyId = journeySelected;
          setState(() {});
        }
      }),
      Container(height: 10.0),

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.text(LangKey.byHistoryCustomerCare),
            style: TextStyle(
                fontSize: 16.0,
                color: const Color(0xFF0067AC),
                fontWeight: FontWeight.bold),
          ),
          FilterHistoryCareDate(
            filterScreenModel: filterScreenModel,
            historyCareDateOptions: historyCareDateOptions,
            id_history_care_date: filterScreenModel.id_history_care_date,
          ),
        ],
      ),
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
                  Global.validateAllocateDate == false ||
                  Global.validateHistoryCareDate == false ||
                  Global.validateWorkScheduleDate == false) {
                LeadConnection.showMyDialog(
                    context,
                    AppLocalizations.text(
                        LangKey.warningChooseFullFromdateTodate),
                    warning: true);
                return;
              }

              var cusType =
                  customerTypeData.firstWhere((element) => element.selected);

              if (cusType.customerTypeName ==
                  AppLocalizations.text(LangKey.all)) {
                filterScreenModel.filterModel.customerType = "";
              } else {
                filterScreenModel.filterModel.customerType =
                    cusType.customerTypeName.toLowerCase();
              }

              var statusOption =
                  statusOptions.firstWhere((element) => element.selected);
              if (statusOption.statusName ==
                  AppLocalizations.text(LangKey.all)) {
                filterScreenModel.filterModel.statusAssign = "";
              } else {
                filterScreenModel.filterModel.statusAssign =
                    statusOption.statusID;
              }

              // var cusSource =
              //     customerSources.firstWhere((element) => element.selected);
              // if (cusSource.sourceName == AppLocalizations.text(LangKey.all)) {
              //   filterScreenModel.filterModel.customerSourceName = "";
              // } else {
              //   filterScreenModel.filterModel.customerSourceName =
              //       cusSource.sourceName;
              // }

              var convertStatusOption = convertStatusOptions
                  .firstWhere((element) => element.selected);

              if (convertStatusOption.statusName ==
                  AppLocalizations.text(LangKey.all)) {
                filterScreenModel.filterModel.isConvert = "";
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
            onTap: () async {
              allowPop = false;
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
    widget.filterScreenModel = FilterScreenModel(
        filterModel: ListCustomLeadModelRequest(
          search: "",
          page: 1,
          statusAssign: "",
          customerType: "",
          tagId: [],
          customerSourceId: [],
          staffId: [],
          pipelineId: [],
          journeyId: [],
          careHistory: "",
          isConvert: "",
          createdAt: "",
          allocationDate: "",
        ),
        fromDate_created_at: null,
        toDate_created_at: null,
        fromDate_allocation_date: null,
        toDate_allocation_date: null,
        fromDate_history_care_date: null,
        toDate_history_care_date: null,
        fromDate_work_schedule_date: null,
        toDate_work_schedule_date: null,
        id_history_care_date: "",
        id_work_schedule_date: "",
        id_created_at: "",
        id_allocation_date: "");

    filterScreenModel = FilterScreenModel(
        filterModel: ListCustomLeadModelRequest.fromJson(
            widget.filterScreenModel.filterModel.toJson()),
        fromDate_created_at: widget.filterScreenModel.fromDate_created_at,
        toDate_created_at: widget.filterScreenModel.toDate_created_at,
        fromDate_allocation_date:
            widget.filterScreenModel.fromDate_allocation_date,
        toDate_allocation_date: widget.filterScreenModel.toDate_allocation_date,
        fromDate_history_care_date:
            widget.filterScreenModel.fromDate_history_care_date,
        toDate_history_care_date:
            widget.filterScreenModel.toDate_history_care_date,
        fromDate_work_schedule_date:
            widget.filterScreenModel.fromDate_work_schedule_date,
        toDate_work_schedule_date:
            widget.filterScreenModel.toDate_work_schedule_date,
        id_history_care_date: widget.filterScreenModel.id_history_care_date,
        id_work_schedule_date: widget.filterScreenModel.id_work_schedule_date,
        id_created_at: widget.filterScreenModel.id_created_at,
        id_allocation_date: widget.filterScreenModel.id_allocation_date);

    // allocatorSelected = null;
    // pipelineSelected = [];
    // journeySelected = null;

    journeyString = "";
    staffs = "";
    customerSourceString = "";
    pipelineString = "";
    tagsString = "";

    for (int i = 0; i < tagsData.length; i++) {
        tagsData[i].selected = false;
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

    for (int i = 0; i < historyCareDateOptions.length; i++) {
      historyCareDateOptions[i].selected = false;
    }

    for (int i = 0; i < workScheduleDateOptions.length; i++) {
      workScheduleDateOptions[i].selected = false;
    }

    for (int i = 0; i < statusOptions.length; i++) {
      if (i == 0) {
        statusOptions[i].selected = true;
      } else {
        statusOptions[i].selected = false;
      }
    }

    for (int i = 0; i < customerSources.length; i++) {
      customerSources[i].selected = false;
    }

    for (int i = 0; i < pipeLineData.length; i++) {
      pipeLineData[i].selected = false;
    }
    pipelineSelected = null;

     for (int i = 0; i < journeysData.length; i++) {
      journeysData[i].selected = false;
    }
    journeySelected = null;

    

    _modelStaffSSupportSelected = [];

    for (int i = 0; i < convertStatusOptions.length; i++) {
      if (i == 0) {
        convertStatusOptions[i].selected = true;
      } else {
        convertStatusOptions[i].selected = false;
      }
    }

    Global.validateAllocateDate = true;
    Global.validateCreateDate = true;
    Global.validateHistoryCareDate = true;
    Global.validateWorkScheduleDate = true;

    setState(() {});
  }
}

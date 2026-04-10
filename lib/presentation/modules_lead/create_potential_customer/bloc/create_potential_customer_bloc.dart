import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/custom_create_address_model.dart';
import 'package:lead_plugin_epoint/model/request/get_customer_group_model_request.dart';
import 'package:lead_plugin_epoint/model/request/get_journey_model_request.dart';
import 'package:lead_plugin_epoint/model/response/customer_response_model.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_branch_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_group_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_option_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_journey_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_pipeline_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/model/response/get_tag_model_response.dart';
import 'package:lead_plugin_epoint/model/request/get_list_staff_request_model.dart';
import 'package:lead_plugin_epoint/model/response_model.dart';
import 'package:lead_plugin_epoint/presentation/interface/base_bloc.dart';
import 'package:lead_plugin_epoint/presentation/module_address/src/ui/create_address_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/customer_new_screen.dart';
import 'package:lead_plugin_epoint/utils/custom_image_picker.dart';
import 'package:lead_plugin_epoint/utils/global.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

import '../../../../connection/http_connection.dart';

class CreatePotentialCustomerBloc extends BaseBloc {
  CreatePotentialCustomerBloc(BuildContext context) {
    setContext(context);
  }

  TextEditingController noteController = TextEditingController();
  FocusNode noteFocusNode = FocusNode();

  final streamImages = BehaviorSubject<List<File>>();
  final BehaviorSubject<String?> streamImageError = BehaviorSubject<String?>();

  final images = <File>[];
  String? imgAvatar;
  final int maxImages = 1;

  @override
  void dispose() {
    super.dispose();
  }

  List<String> listPhone = [];
  BranchData? branchSelected;
  List<BranchData> listBranch = [];

  CustomerGroupData? customerGroupSelected;
  List<CustomerGroupData> listCustomerGroupData = [];

  TextEditingController referrerController = TextEditingController();
  FocusNode referrerFocusNode = FocusNode();

  TextEditingController websiteController = TextEditingController();
  FocusNode websiteFocusNode = FocusNode();

  TextEditingController representativeController = TextEditingController();
  FocusNode representativeFocusNode = FocusNode();

  CustomerCreateAddressModel? addressModel;

  final _streamAddressModel = BehaviorSubject<CustomerCreateAddressModel?>();
  ValueStream<CustomerCreateAddressModel?> get outputAddressModel =>
      _streamAddressModel.stream;

  final _streamPresenterModel = BehaviorSubject<CustomerModel?>();
  ValueStream<CustomerModel?> get outputPresenterModel =>
      _streamPresenterModel.stream;
  setPresenterModel(CustomerModel? event) => set(_streamPresenterModel, event);

  CustomerModel? presenterModel;

  late DetailPotentialData? detail;

  setAddressModel(CustomerCreateAddressModel? event) =>
      set(_streamAddressModel, event);

  // Data loaded from APIs
  CustomerOptionData? customerOptionData = CustomerOptionData();
  List<CustomerOptionSource>? customerSourcesData = <CustomerOptionSource>[];
  CustomerOptionSource sourceSelected = CustomerOptionSource();

  List<PipelineData>? pipeLineData = <PipelineData>[];
  PipelineData pipelineSelected = PipelineData();

  List<JourneyData>? journeysData = <JourneyData>[];
  JourneyData? journeySelected = JourneyData();

  List<TagData>? tagsData;

  String tagsString = "";

  WorkListStaffModel? staffSelected;

  bool isLoading = false;

  /// Load all APIs when entering screen
  Future<void> initData(BuildContext context) async {
    isLoading = true;
    LeadConnection.showLoading(context);

    await Future.wait([
      _loadCustomerOption(context),
      _loadPipeline(context),
      _loadBranch(context),
      _loadTag(context),
    ]);

    // Load journeys after pipeline is selected
    if (pipelineSelected.pipelineCode != null) {
      await _loadJourneys(context, pipelineSelected.pipelineCode!);
    }

    // Auto-fill staff by userId
    await autoFillStaffByUserId(context);

    Navigator.of(context).pop();
    isLoading = false;
  }

  Future<void> _loadCustomerOption(BuildContext context) async {
    var dataTypeSource = await LeadConnection.getCustomerOption(context);
    if (dataTypeSource != null) {
      customerOptionData = dataTypeSource.data;
      customerSourcesData = customerOptionData!.source;
      // Default select first item
      if (customerSourcesData != null && customerSourcesData!.isNotEmpty) {
        sourceSelected = customerSourcesData!.first;
      }
    }
  }

  Future<void> _loadPipeline(BuildContext context) async {
    var pipelines = await LeadConnection.getPipeline(context);
    if (pipelines != null) {
      pipeLineData = pipelines.data;
      // Auto select pipeline with isDefault == 1
      if (pipeLineData != null && pipeLineData!.isNotEmpty) {
        try {
          pipelineSelected = pipeLineData!.firstWhere(
            (p) => p.isDefault == 1,
          );
        } catch (_) {
          pipelineSelected = pipeLineData!.first;
        }
      }
    }
  }

  Future<void> _loadBranch(BuildContext context) async {
    List<BranchData>? data = await getBranch(context, showLoading: false);
    if (data != null && data.isNotEmpty) {
      // Find branch matching Global.branchId
      if (Global.branchId != null) {
        try {
          branchSelected = data.firstWhere(
            (b) => b.branchId.toString() == Global.branchId,
          );
        } catch (_) {
          branchSelected = data.first;
        }
      } else {
        branchSelected = data.first;
      }
    }
  }

  Future<void> _loadTag(BuildContext context) async {
    var tags = await LeadConnection.getTag(context);
    if (tags != null) {
      tagsData = tags.data;
    }
  }

  /// Auto-fill allocated person based on Global.userId
  Future<void> autoFillStaffByUserId(BuildContext context) async {
    if (Global.userId == null || Global.userId!.isEmpty) return;

    var result = await LeadConnection.workListStaff(
      context,
      WorkListStaffRequestModel(
        branchId: branchSelected?.branchId?.toString(),
      ),
    );

    if (result != null && result.data != null && result.data!.isNotEmpty) {
      try {
        staffSelected = result.data!.firstWhere(
          (staff) => staff.staffId.toString() == Global.userId,
        );
      } catch (_) {
        staffSelected = null;
      }
    }
  }

  /// Load journeys internally (no loading dialog)
  Future<void> _loadJourneys(BuildContext context, String pipelineCode) async {
    var journeys = await LeadConnection.getJourney(
        context, GetJourneyModelRequest(pipelineCode: [pipelineCode]));
    if (journeys != null) {
      journeysData = journeys.data;
      if (journeysData != null && journeysData!.isNotEmpty) {
        journeySelected = journeysData!.first;
      }
    }
  }

  /// Load journeys after selecting pipeline (with loading dialog)
  Future<void> loadJourneys(BuildContext context, String? pipelineCode) async {
    if (pipelineCode == null) return;
    LeadConnection.showLoading(context);
    var journeys = await LeadConnection.getJourney(
        context, GetJourneyModelRequest(pipelineCode: [pipelineCode]));
    Navigator.of(context).pop();
    if (journeys != null) {
      journeysData = journeys.data;
      if (journeysData != null && journeysData!.isNotEmpty) {
        journeySelected = journeysData!.first;
      }
    }
  }

  onImageAdd(List<File> files) {
    images.addAll(files);
    streamImages.set(images);
  }

  onImageRemove(int index) {
    images.removeAt(index);
    streamImages.set(images);
  }

  onPushAddress() async {
    CustomerCreateAddressModel? result = await CustomNavigator.push(
        context!,
        CreateAddressScreen(
          model: addressModel,
        ));
    if (result != null) {
      addressModel = result;
      setAddressModel(addressModel);
    }
  }

  onPickImage() {
    CustomImagePicker.showPicker(context!, (files) {
      onImageAdd([files]);
    });
  }

  Future<List<BranchData>?> getBranch(BuildContext context,
      {bool showLoading = true}) async {
    if (listBranch.length > 0) {
      return listBranch;
    }
    if (showLoading) LeadConnection.showLoading(context);
    ResponseModel responseData = await repository.getBranch(context);
    if (showLoading) Navigator.of(context).pop();
    if (responseData.success ?? false) {
      var response = GetBranchModelReponse.fromList(responseData.datas);
      listBranch = response.data ?? [];
      return listBranch;
    }
    return null;
  }

  Future<void> onGetBranch(BuildContext context) async {
    List<BranchData>? data = await getBranch(context);
    branchSelected = data?.first;
  }

  Future<List<CustomerGroupData>?> getCustomerGroup(BuildContext context,
      {bool showLoading = true}) async {
    if (listCustomerGroupData.length > 0) {
      return listCustomerGroupData;
    }
    if (showLoading) LeadConnection.showLoading(context);
    GetCustomerGroupModelRequest model =
        GetCustomerGroupModelRequest(brandCode: Global.brandCode);
    ResponseModel responseData =
        await repository.getCustomerGroup(context, model);
    if (showLoading) Navigator.of(context).pop();
    if (responseData.success ?? false) {
      var response = GetCustomerGroupModelResponse.fromList(responseData.datas);

      listCustomerGroupData = response.data ?? [];

      return listCustomerGroupData;
    }
    return null;
  }

  Future<String> uploadFileAWS(File images, {String content = ""}) async {
    try {
      CustomNavigator.showProgressDialog(context);
      ResponseData? result = await LeadConnection.uploadFile(context, MultipartFileModel(file: images));
      CustomNavigator.hideProgressDialog();
      return result?.data?['Data']['link'];
    } catch (e) {
      return "";
    }
  }

  onPushPresenter() async {
    CustomerModel? result = await CustomNavigator.push(
        context!,
        CustomerNewScreen(
          isCartChoose: true,
        ));
    if (result != null) {
      presenterModel = result;
      setPresenterModel(presenterModel);
    }
  }
}

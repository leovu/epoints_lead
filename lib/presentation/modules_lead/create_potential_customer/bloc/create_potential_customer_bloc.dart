import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/custom_create_address_model.dart';
import 'package:lead_plugin_epoint/model/request/get_customer_group_model_request.dart';
import 'package:lead_plugin_epoint/model/request/get_journey_model_request.dart';
import 'package:lead_plugin_epoint/model/response/customer_response_model.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_branch_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_group_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_option_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_journey_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_pipeline_model_response.dart';
import 'package:lead_plugin_epoint/model/response_model.dart';
import 'package:lead_plugin_epoint/presentation/interface/base_bloc.dart';
import 'package:lead_plugin_epoint/presentation/module_address/src/ui/create_address_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/customer_new_screen.dart';
import 'package:lead_plugin_epoint/utils/custom_image_picker.dart';
import 'package:lead_plugin_epoint/utils/global.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

import '../../../../model/response/get_list_staff_responese_model.dart';

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

  TextEditingController contactFullNameController = TextEditingController();
  FocusNode contactFullNameFocusNode = FocusNode();

  TextEditingController contactPhoneController = TextEditingController();
  FocusNode contactPhoneFocusNode = FocusNode();

  TextEditingController contactEmailController = TextEditingController();
  FocusNode contactEmailFocusNode = FocusNode();

  CustomerOptionData? customerOptionData;
  List<CustomerOptionSource> listCustomerSource = [];

  List<PipelineData> listPipeline = [];
  List<JourneyData> listJourney = [];

  WorkListStaffResponseModel? listAllocator;

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

  Future<void> onGetBranch(BuildContext context,
      {bool showLoading = true}) async {
    List<BranchData>? data = await getBranch(context, showLoading: showLoading);
    if (data == null || data.isEmpty) return;
    if (Global.branchId != null) {
      try {
        branchSelected = data.firstWhere((b) => b.branchId == Global.branchId);
      } catch (_) {
        branchSelected = data.first;
      }
    } else {
      branchSelected = data.first;
    }
  }

  Future<List<CustomerOptionSource>> getCustomerSources(
      BuildContext context) async {
    if (listCustomerSource.isNotEmpty) return listCustomerSource;
    var res = await LeadConnection.getCustomerOption(context);
    if (res != null) {
      customerOptionData = res.data;
      listCustomerSource = customerOptionData?.source ?? [];
    }
    return listCustomerSource;
  }

  Future<List<PipelineData>> getPipelines(BuildContext context) async {
    if (listPipeline.isNotEmpty) return listPipeline;
    var res = await LeadConnection.getPipeline(context);
    listPipeline = res?.data ?? [];
    return listPipeline;
  }

  Future<List<JourneyData>> getJourneys(
      BuildContext context, String? pipelineCode) async {
    if (pipelineCode == null || pipelineCode.isEmpty) return [];
    var res = await LeadConnection.getJourney(
        context, GetJourneyModelRequest(pipelineCode: [pipelineCode]));
    listJourney = res?.data ?? [];
    return listJourney;
  }

  Future<WorkListStaffResponseModel?> getAllocatorByBranch(
      BuildContext context, int? branchId,
      {bool showLoading = true}) async {
    var res = await LeadConnection.workListStaffPermission(context,
        branchId: branchId, showLoading: showLoading);
    listAllocator = res;
    return listAllocator;                      
  }

  // TODO: tạm thời — dùng API cũ get-allocator (không filter theo branch).
  // Bỏ hàm này khi backend đã ổn định endpoint workListStaffPermission.
  Future<WorkListStaffResponseModel?> getAllocatorByBranchLegacy(
      BuildContext context, int? branchId,
      {bool showLoading = true}) async {
    if (showLoading) LeadConnection.showLoading(context);
    var res = await LeadConnection.getAllocator(context, branchId: branchId);
    if (showLoading) Navigator.of(context).pop();
    final List<AllocatorData> raw = res?.data ?? [];
    final mapped = raw
        .map((a) => WorkListStaffModel(
              staffId: a.staffId,
              staffName: a.fullName,
            ))
        .toList();
    listAllocator = WorkListStaffResponseModel(data: mapped);
    return listAllocator;
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
      String? result = await LeadConnection.uploadFileAWS(context, images);
      CustomNavigator.hideProgressDialog();
      return result ?? "";
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

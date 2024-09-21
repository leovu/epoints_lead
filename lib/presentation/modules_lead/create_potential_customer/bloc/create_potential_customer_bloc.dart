import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/custom_create_address_model.dart';
import 'package:lead_plugin_epoint/model/request/get_customer_group_model_request.dart';
import 'package:lead_plugin_epoint/model/response/customer_response_model.dart';
import 'package:lead_plugin_epoint/model/response/detail_lead_info_deal_response_model.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_branch_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_group_model_response.dart';
import 'package:lead_plugin_epoint/model/response_model.dart';
import 'package:lead_plugin_epoint/presentation/interface/base_bloc.dart';
import 'package:lead_plugin_epoint/presentation/module_address/src/ui/create_address_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/customer_new_screen.dart';
import 'package:lead_plugin_epoint/utils/custom_image_picker.dart';
import 'package:lead_plugin_epoint/utils/global.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

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

  onImageAdd(List<File> files) {
    images.addAll(files);
    streamImages.set(images);
    // if (images.length == 3) {
    //   streamImageError.add(null);
    // }
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

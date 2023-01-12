import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/http_connection.dart';
import 'package:lead_plugin_epoint/model/request/add_business_areas_model_request.dart';
import 'package:lead_plugin_epoint/model/request/add_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/request/add_tag_model_request.dart';
import 'package:lead_plugin_epoint/model/request/add_work_model_request.dart';
import 'package:lead_plugin_epoint/model/request/assign_revoke_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/request/edit_potential_model_request.dart';
import 'package:lead_plugin_epoint/model/request/get_journey_model_request.dart';
import 'package:lead_plugin_epoint/model/request/get_list_staff_request_model.dart';
import 'package:lead_plugin_epoint/model/request/list_customer_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/request/list_project_model_request.dart';
import 'package:lead_plugin_epoint/model/request/work_create_comment_request_model.dart';
import 'package:lead_plugin_epoint/model/request/work_list_comment_request_model.dart';
import 'package:lead_plugin_epoint/model/request/work_upload_file_document_request_model.dart';
import 'package:lead_plugin_epoint/model/response/add_lead_model_response.dart';
import 'package:lead_plugin_epoint/model/response/care_lead_response_model.dart';
import 'package:lead_plugin_epoint/model/response/contact_list_model_response.dart';
import 'package:lead_plugin_epoint/model/response/description_model_response.dart';
import 'package:lead_plugin_epoint/model/response/detail_lead_info_deal_response_model.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_branch_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_option_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_deal_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_district_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_journey_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_list_business_response_model.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/model/response/get_pipeline_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_province_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_status_work_response_model.dart';
import 'package:lead_plugin_epoint/model/response/get_tag_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_type_work_response_model.dart';
import 'package:lead_plugin_epoint/model/response/get_ward_model_response.dart';
import 'package:http/http.dart' as http;
import 'package:lead_plugin_epoint/model/response/list_business_areas_model_response.dart';
import 'package:lead_plugin_epoint/model/response/list_project_model_response.dart';
import 'package:lead_plugin_epoint/model/response/position_response_model.dart';
import 'package:lead_plugin_epoint/model/response/upload_image_response_model.dart';
import 'package:lead_plugin_epoint/model/response/work_list_branch_responese_model.dart';
import 'package:lead_plugin_epoint/model/response/work_list_comment_model_response.dart';
import 'package:lead_plugin_epoint/model/response/work_list_department_response_model.dart';
import 'package:lead_plugin_epoint/model/response/work_list_file_response_model.dart';
import 'package:lead_plugin_epoint/model/work_upload_file_model_response.dart';

import '../model/response/list_customer_lead_model_response.dart';

class LeadConnection {
  static BuildContext buildContext;
  static HTTPConnection connection = HTTPConnection();
  // static Account account;
  // static Locale locale = Locale('vi', 'VN');
  static Locale locale;

  static Future<bool> init(String token, {String domain}) async {
    if (domain != null && token != null) {
      HTTPConnection.domain = domain;
      HTTPConnection.asscessToken = token;
      return true;
    } else {
      return false;
    }
  }

  static Future<ListCustomLeadModelReponse> getList(
      BuildContext context, ListCustomLeadModelRequest model) async {
    showLoading(context);
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/list-customer-lead', model.toJson());
    Navigator.of(context).pop();
    if (responseData.isSuccess) {
      if (responseData.data != null) {
        ListCustomLeadModelReponse data =
            ListCustomLeadModelReponse.fromJson(responseData.data);
        return data;
      }
      return null;
    }
    return null;
  }

  static Future<String> uploadImage(filepath, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(http.MultipartFile.fromBytes(
        'picture', File(filepath).readAsBytesSync(),
        filename: filepath.split("/").last));
    var res = await request.send();
    if (res != null) {}
  }

  static Future<DetailPotentialModelResponse> getdetailPotential(
      BuildContext context, String customer_lead_code) async {
    showLoading(context);
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/detail-lead',
        {"customer_lead_code": customer_lead_code});
    Navigator.of(context).pop();
    if (responseData.isSuccess) {
      DetailPotentialModelResponse data =
          DetailPotentialModelResponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<DetailLeadInfoDealResponseModel> getDetailLeadInfoDeal(
      BuildContext context, String customer_lead_code) async {
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/detail-lead-info-deal',
        {"customer_lead_code": customer_lead_code});
    if (responseData.isSuccess) {
      DetailLeadInfoDealResponseModel data =
          DetailLeadInfoDealResponseModel.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<GetCustomerOptionModelReponse> getCustomerOption(
      BuildContext context) async {
    ResponseData responseData = await connection
        .post('/customer-lead/customer-lead/get-customer-option', {});
    if (responseData.isSuccess) {
      GetCustomerOptionModelReponse data =
          GetCustomerOptionModelReponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<GetPipelineModelReponse> getPipeline(
      BuildContext context) async {
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/get-pipeline',
        {"pipeline_category_code": "CUSTOMER"});
    if (responseData.isSuccess) {
      GetPipelineModelReponse data =
          GetPipelineModelReponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<GetJourneyModelReponse> getJourney(
      BuildContext context, GetJourneyModelRequest model) async {
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/get-journey',
        {"pipeline_code": model.toJson()});
    if (responseData.isSuccess) {
      GetJourneyModelReponse data =
          GetJourneyModelReponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<GetProvinceModelReponse> getProvince(
      BuildContext context) async {
    ResponseData responseData =
        await connection.post('/customer-lead/customer-lead/get-province', {});
    if (responseData.isSuccess) {
      GetProvinceModelReponse data =
          GetProvinceModelReponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<GetDistrictModelReponse> getDistrict(
      BuildContext context, int provinceid) async {
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/get-district',
        {"provinceid": provinceid});
    if (responseData.isSuccess) {
      GetDistrictModelReponse data =
          GetDistrictModelReponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<GetWardModelReponse> getWard(
      BuildContext context, int districtid) async {
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/get-ward', {"districtid": districtid});
    if (responseData.isSuccess) {
      GetWardModelReponse data =
          GetWardModelReponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<GetAllocatorModelReponse> getAllocator(
      BuildContext context) async {
    ResponseData responseData =
        await connection.post('/customer-lead/customer-lead/get-allocator', {});
    if (responseData.isSuccess) {
      GetAllocatorModelReponse data =
          GetAllocatorModelReponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<AddLeadModelResponse> addLead(
      BuildContext context, AddLeadModelRequest model) async {
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/add-lead', model.toJson());
    if (responseData.isSuccess) {
      AddLeadModelResponse data =
          AddLeadModelResponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<DescriptionModelResponse> deleteLead(
      BuildContext context, String customer_lead_code) async {
    showLoading(context);
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/delete-lead',
        {"customer_lead_code": customer_lead_code});
    Navigator.of(context).pop();
    if (responseData.isSuccess) {
      DescriptionModelResponse data =
          DescriptionModelResponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<GetDealModelReponse> getDealName(BuildContext context) async {
    ResponseData responseData =
        await connection.post('/customer-lead/customer-lead/get-deal-name', {});
    if (responseData.isSuccess) {
      GetDealModelReponse data =
          GetDealModelReponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<GetBranchModelReponse> getBranch(BuildContext context) async {
    ResponseData responseData =
        await connection.post('/customer-lead/customer-lead/get-branch', {});
    if (responseData.isSuccess) {
      GetBranchModelReponse data =
          GetBranchModelReponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<GetTagModelReponse> getTag(BuildContext context) async {
    ResponseData responseData =
        await connection.post('/customer-lead/customer-lead/get-tag', {});
    if (responseData.isSuccess) {
      GetTagModelReponse data = GetTagModelReponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<DescriptionModelResponse> updateLead(
      BuildContext context, EditPotentialRequestModel model) async {
    showLoading(context);
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/update-lead', model.toJson());
    Navigator.of(context).pop();
    if (responseData.isSuccess) {
      DescriptionModelResponse data =
          DescriptionModelResponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<DescriptionModelResponse> assignRevokeLead(
      BuildContext context, AssignRevokeLeadRequestModel model) async {
    showLoading(context);
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/assign-revoke-lead', model.toJson());
    Navigator.of(context).pop();
    if (responseData.isSuccess) {
      DescriptionModelResponse data =
          DescriptionModelResponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<ContactListModelResponse> getContactList(
      BuildContext context, String customer_lead_code) async {
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/contact-list',
        {"customer_lead_code": customer_lead_code});
    if (responseData.isSuccess && responseData.data != null) {
      ContactListModelResponse data =
          ContactListModelResponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<PositionResponseModel> getPosition(BuildContext context) async {
    showLoading(context);
    ResponseData responseData =
        await connection.post('/customer-lead/customer-lead/position', {});
    Navigator.of(context).pop();
    if (responseData.isSuccess) {
      PositionResponseModel data =
          PositionResponseModel.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<CareLeadResponseModel> getCareLead(
      BuildContext context, int customer_lead_id) async {
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/care-lead',
        {"customer_lead_id": customer_lead_id});
    if (responseData.isSuccess && responseData != null) {
      CareLeadResponseModel data =
          CareLeadResponseModel.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<WorkListBranchResponseModel> workListBranch(
      BuildContext context) async {
    // showLoading(context);
    ResponseData responseData =
        await connection.post('/manage-work/list-branch', {});
    if (responseData.isSuccess) {
      WorkListBranchResponseModel data =
          WorkListBranchResponseModel.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<WorkListStaffResponseModel> workListStaff(
      BuildContext context, WorkListStaffRequestModel model) async {
    // showLoading(context);
    ResponseData responseData =
        await connection.post('/manage-work/list-staff', model.toJson());
    if (responseData.isSuccess) {
      WorkListStaffResponseModel data =
          WorkListStaffResponseModel.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<WorkListDepartmentResponseModel> workListDepartment(
      BuildContext context) async {
    ResponseData responseData =
        await connection.post('/manage-work/list-department', {});
    if (responseData.isSuccess) {
      WorkListDepartmentResponseModel data =
          WorkListDepartmentResponseModel.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<GetStatusWorkResponseModel> getStatusWork(
      BuildContext context) async {
    ResponseData responseData = await connection
        .post('/customer-lead/customer-lead/get-status-work', {});
    if (responseData.isSuccess) {
      GetStatusWorkResponseModel data =
          GetStatusWorkResponseModel.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<GetListBusinessResponseModel> getListBusiness(
      BuildContext context) async {
    ResponseData responseData = await connection
        .post('/customer-lead/customer-lead/get-list-business', {});
    if (responseData.isSuccess) {
      GetListBusinessResponseModel data =
          GetListBusinessResponseModel.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<GetTypeWorkModelResponse> getTypeWork(
      BuildContext context) async {
    ResponseData responseData =
        await connection.post('/customer-lead/customer-lead/get-type-work', {});
    if (responseData.isSuccess && responseData.data != null) {
      GetTypeWorkModelResponse data =
          GetTypeWorkModelResponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<DescriptionModelResponse> addWork(
      BuildContext context, AddWorkRequestModel model) async {
    // showLoading(context);
    ResponseData responseData =
        await connection.post('/manage-work/add-work', model.toJson());
    if (responseData.isSuccess) {
      DescriptionModelResponse data =
          DescriptionModelResponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<ListProjectModelResponse> getListProject(
      BuildContext context, ListProjectModelRequest model) async {
    showLoading(context);
    ResponseData responseData = await connection.post(
        '/project-management/list-project', model.toJson());
    Navigator.of(context).pop();
    if (responseData.isSuccess && responseData.data != null) {
      if (responseData.data != null) {
        ListProjectModelResponse data =
            ListProjectModelResponse.fromJson(responseData.data);
        return data;
      }
      return null;
    }
    return null;
  }

  static Future<ListBusinessAreasModelResponse> getListBusinessAreas(
      BuildContext context) async {
    // showLoading(context);
    ResponseData responseData = await connection
        .post('/customer-lead/customer-lead/list-business-areas', {});
    if (responseData.isSuccess) {
      ListBusinessAreasModelResponse data =
          ListBusinessAreasModelResponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<DescriptionModelResponse> addBusinessAreas(
      BuildContext context, AddBusinessAreasModelRequest model) async {
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/add-business-areas', model.toJson());
    if (responseData.isSuccess) {
      DescriptionModelResponse data =
          DescriptionModelResponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<DescriptionModelResponse> addTag(
      BuildContext context, AddTagModelRequest model) async {
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/add-tag', model.toJson());
    if (responseData.isSuccess) {
      DescriptionModelResponse data =
          DescriptionModelResponse.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<WorkUploadFileResponseModel> workUploadFile(
      BuildContext context, MultipartFileModel model) async {
    ResponseData response =  await connection.upload('/manage-work/upload-file', model);
    if (response.isSuccess) {
      WorkUploadFileResponseModel responseModel =
          WorkUploadFileResponseModel.fromJson(response.data);

      return responseModel;
    } else {
      showMyDialog(context, "Lỗi máy chủ");
    }
    return null;
  }

  //  static Future<UploadImageModelResponse> upload(
  //     BuildContext context, MultipartFileModel model) async {
  //   showLoading(context);
  //   ResponseData responseData =
  //       await LeadConnection.connection.upload('/user/upload-file', model);
  //   Navigator.of(context).pop();
  //   if (responseData.isSuccess) {
  //     UploadImageModelResponse data =
  //         UploadImageModelResponse.fromJson(responseData.data);
  //     return data;
  //   }
  //   return null;
  // }

  static Future<List<WorkListFileModel>> workUploadFileDocument(
      WorkUploadFileDocumentRequestModel model) async {
    List<WorkListFileModel> _fileModels;
    ResponseData response = await connection.post(
        '/manage-work/upload-file-document', model.toJson());
    if (response.isSuccess) {
      var responseModel = WorkListFileModel.fromJson(response.data);

      _fileModels.insert(0, responseModel);
      // setFileModels(_fileModels);
      return _fileModels;
    }
    return null;
  }

  static Future<WorkListCommentResponseModel> workListComment(
      BuildContext context, WorkListCommentRequestModel model) async {
    // showLoading(context);
    ResponseData responseData =
        await connection.post('/customer-lead/list-comment', model.toJson());
    if (responseData.isSuccess) {
      WorkListCommentResponseModel data =
          WorkListCommentResponseModel.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future<WorkListCommentResponseModel> workCreatedComment(
      BuildContext context, WorkCreateCommentRequestModel model) async {
    showLoading(context);
    ResponseData responseData =
        await connection.post('/customer-lead/created-comment', model.toJson());
    Navigator.of(context).pop();
    if (responseData.isSuccess) {
      WorkListCommentResponseModel data =
          WorkListCommentResponseModel.fromJson(responseData.data);
      return data;
    }
    return null;
  }

  static Future showLoading(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            children: <Widget>[
              Center(
                child: Platform.isAndroid
                    ? const CircularProgressIndicator()
                    : const CupertinoActivityIndicator(),
              )
            ],
          );
        });
  }

  static Future showMyDialog(BuildContext context, String title,
      {bool warning = false}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child: Text(
                  warning
                      ? AppLocalizations.text(LangKey.warning)
                      : AppLocalizations.text(LangKey.notify) + "\n",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                )),
                Container(
                  height: 10,
                ),
                Center(
                    child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.grey[700]),
                )),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 15.0),
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                child: Center(
                    child: Text(
                  // AppLocalizations.text(LangKey.argree),
                  "OK",
                  style: TextStyle(color: AppColors.white),
                )),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  static Future showMyDialogWithFunction(BuildContext context, String title,
      {Function ontap, bool isCancle = true}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title:  Text(''),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(),
                    Center(
                        child: Text(
                      AppLocalizations.text(LangKey.notify) + "\n",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    )),
                    InkWell(
                      child: Icon(
                        Icons.clear,
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                Center(
                    child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                )),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Center(
                        child: Text(
                      AppLocalizations.text(LangKey.no),
                      style: TextStyle(color: Color(0xFF0067AC)),
                    )),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child:
                        Center(child: Text(AppLocalizations.text(LangKey.yes))),
                    onPressed: ontap,
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

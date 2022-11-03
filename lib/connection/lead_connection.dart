import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/connection/http_connection.dart';
import 'package:lead_plugin_epoint/model/acount.dart';
import 'package:lead_plugin_epoint/model/request/add_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/request/assign_revoke_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/request/edit_potential_model_request.dart';
import 'package:lead_plugin_epoint/model/request/list_customer_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/response/add_lead_model_response.dart';
import 'package:lead_plugin_epoint/model/response/description_model_response.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_allocator_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_branch_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_customer_option_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_deal_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_district_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_journey_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_pipeline_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_province_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_tag_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_ward_model_response.dart';
import 'package:http/http.dart' as http;
import 'package:lead_plugin_epoint/model/response/upload_image_response_model.dart';

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

  static  Future<String> uploadImage(filepath, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(
        http.MultipartFile.fromBytes(
            'picture',
            File(filepath).readAsBytesSync(),
            filename: filepath.split("/").last
        )
    );
    var res = await request.send();
    if (res != null) {

    }
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
      BuildContext context, String pipeline_code) async {
    ResponseData responseData = await connection.post(
        '/customer-lead/customer-lead/get-journey',
        {"pipeline_code": pipeline_code});
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

  static Future<UploadImageModelResponse> upload(BuildContext context, File file) async {
    showLoading(context);
    ResponseData responseData = await LeadConnection.connection.upload('/user/upload-file', file);
    Navigator.of(context).pop();
    if (responseData.isSuccess) {
      UploadImageModelResponse data = UploadImageModelResponse.fromJson(responseData.data);
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



  static Future showMyDialog(BuildContext context, String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title:  Text(''),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child: Text(
                  AppLocalizations.text(LangKey.notify) + "\n",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                )),
                Center(child: Text(title)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Center(child: Text(AppLocalizations.text(LangKey.argree))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future showMyDialogWithFunction(BuildContext context, String title ,{Function ontap}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title:  Text(''),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                    child: Text(
                  AppLocalizations.text(LangKey.notify) + "\n",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                )),
                Center(child: Text(title)),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [TextButton(
                child: Center(child: Text(AppLocalizations.text(LangKey.no),
                style: TextStyle(
                  color: Colors.red
                ),)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              TextButton(
                child: Center(child: Text(AppLocalizations.text(LangKey.yes))),
                onPressed: ontap,
              ),],
              ),
            )
          ],
        );
      },
    );
  }


}

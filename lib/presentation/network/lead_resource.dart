import 'package:flutter/cupertino.dart';
import 'package:lead_plugin_epoint/model/note_file_req_res_model.dart';
import 'package:lead_plugin_epoint/model/request/add_contact_req_model.dart';
import 'package:lead_plugin_epoint/model/request/customer_request_model.dart';
import 'package:lead_plugin_epoint/model/request/get_care_list_req_model.dart';
import 'package:lead_plugin_epoint/model/request/get_contact_lead_req_model.dart';
import 'package:lead_plugin_epoint/model/request/get_customer_group_model_request.dart';
import 'package:lead_plugin_epoint/presentation/network/api.dart';
import 'package:lead_plugin_epoint/presentation/network/interaction.dart';

class LeadResource{
  getBranch(BuildContext? context) => Interaction(
      context: context,
      url: API.getBranch()
  ).post();

  getCustomerGroup(BuildContext? context, GetCustomerGroupModelRequest model) => Interaction(
      context: context,
      url: API.getCustomerGroup(),
      param: model.toJson()
  ).post();

  getCareLead(BuildContext? context, GetCareListReqModel model) => Interaction(
      context: context,
      url: API.getCareLead(),
      param: model.toJson()
  ).post();

  getContactList(BuildContext? context, GetContactLeadReqModel model) => Interaction(
      context: context,
      url: API.getContactList(),
      param: model.toJson()
  ).post();

  getDetailLeadInfoDeal(BuildContext? context, GetContactLeadReqModel model) => Interaction(
      context: context,
      url: API.getDetailLeadInfoDeal(),
      param: model.toJson()
  ).post();

  addContact(BuildContext? context, AddContactRequest model) => Interaction(
      context: context,
      url: API.addContact(),
      param: model.toJson(),
      showError: true
  ).post();

  getListNote(BuildContext? context, GetListNoteModel model) => Interaction(
    context: context,
    url: API.getListNote(),
    param: model.toJson(),
  ).post();

  addNote(BuildContext? context, CreateNoteReqModel model) => Interaction(
    context: context,
    url: API.addNote(),
    param: model.toJson(),
  ).post();

  getListFile(BuildContext? context, GetFileReqModel model) => Interaction(
    context: context,
    url: API.getListFile(),
    param: model.toJson(),
  ).post();

  addFile(BuildContext? context, UploadFileReqModel model) => Interaction(
    context: context,
    url: API.addFile(),
    param: model.toJson(),
  ).post();

   getCustomer(BuildContext? context, CustomerRequestModel model) => Interaction(
      context: context,
      url: API.getCustomer(),
      param: model.toJson()
  ).post();


}
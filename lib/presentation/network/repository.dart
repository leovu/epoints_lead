import 'package:flutter/widgets.dart';
import 'package:lead_plugin_epoint/model/note_file_req_res_model.dart';
import 'package:lead_plugin_epoint/model/request/add_contact_req_model.dart';
import 'package:lead_plugin_epoint/model/request/customer_request_model.dart';
import 'package:lead_plugin_epoint/model/request/district_model_request.dart';
import 'package:lead_plugin_epoint/model/request/get_care_list_req_model.dart';
import 'package:lead_plugin_epoint/model/request/get_contact_lead_req_model.dart';
import 'package:lead_plugin_epoint/model/request/get_customer_group_model_request.dart';
import 'package:lead_plugin_epoint/presentation/network/booking_resource.dart';
import 'package:lead_plugin_epoint/presentation/network/lead_resource.dart';

class Repository { 
var _bookingResource = BookingResource();
var _leadResource = LeadResource();



  provinceFull(BuildContext? context) => _bookingResource.provinceFull(context);
  district(BuildContext? context, DistrictRequestModel model) =>
      _bookingResource.district(context, model);
  ward(BuildContext? context, WardRequestModel model) =>
      _bookingResource.ward(context, model);


  getBranch(BuildContext? context) =>
      _leadResource.getBranch(context);
  getCustomerGroup(BuildContext? context, GetCustomerGroupModelRequest model) => _leadResource.getCustomerGroup(context, model);
  getCareLead(BuildContext? context, GetCareListReqModel model) => _leadResource.getCareLead(context, model);
  getContactList(BuildContext? context, GetContactLeadReqModel model) => _leadResource.getContactList(context, model);
  getDetailLeadInfoDeal(BuildContext? context, GetContactLeadReqModel model) => _leadResource.getDetailLeadInfoDeal(context, model);
  addContact(BuildContext? context, AddContactRequest model) => _leadResource.addContact(context, model);

  getListNote(BuildContext? context, GetListNoteModel model) =>
      _leadResource.getListNote(context, model);
  addNote(BuildContext? context, CreateNoteReqModel model) =>
      _leadResource.addNote(context, model);
  getListFile(BuildContext? context, GetFileReqModel model) =>
      _leadResource.getListFile(context, model);

  addFile(BuildContext? context, UploadFileReqModel model) =>
      _leadResource.addFile(context, model);

  getCustomer(BuildContext? context, CustomerRequestModel model) =>
      _leadResource.getCustomer(context, model);



}
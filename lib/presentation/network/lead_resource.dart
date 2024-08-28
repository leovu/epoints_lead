import 'package:flutter/cupertino.dart';
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



}
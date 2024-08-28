import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:lead_plugin_epoint/model/request/get_care_list_req_model.dart';
import 'package:lead_plugin_epoint/model/request/get_contact_lead_req_model.dart';
import 'package:lead_plugin_epoint/model/response/care_lead_response_model.dart';
import 'package:lead_plugin_epoint/model/response/contact_list_model_response.dart';
import 'package:lead_plugin_epoint/model/response/detail_lead_info_deal_response_model.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response_model.dart';
import 'package:lead_plugin_epoint/presentation/interface/base_bloc.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/list_ui/list_contact_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/list_ui/list_customer_care_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/list_ui/list_deal_screen.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

class DetailPotentialCustomerBloc extends BaseBloc {
  DetailPotentialCustomerBloc(BuildContext context) {
    setContext(context);
  }

  @override
  void dispose() {
    super.dispose();
    _streamContactList.close();
    _streamCareLead.close();
    _streamLeadInfoDeal.close();
    _streamExpandDeal.close();
    _streamExpandCustomerCare.close();
    _streamExpandListContact.close();
  }

  List<CareLeadData> listCareLead = [];
  List<ContactListData> listContact = [];
  List<DetailLeadInfoDealData> listDealFromLead = [];
  late DetailPotentialData? detail;
  List<Widget>? children;

  bool expandCare = false;
  bool expandDeal = false;
  bool expandListContact = false;

  final _streamModel = BehaviorSubject<DetailPotentialData?>();
  ValueStream<DetailPotentialData?> get outputModel =>
      _streamModel.stream;
  setModel(DetailPotentialData? event) => set(_streamModel, event);

  final _streamContactList = BehaviorSubject<List<ContactListData>?>();
  ValueStream<List<ContactListData>?> get outputContactList =>
      _streamContactList.stream;

  setContactList(List<ContactListData>? event) =>
      set(_streamContactList, event);

  final _streamCareLead = BehaviorSubject<List<CareLeadData>?>();
  ValueStream<List<CareLeadData>?> get outputCareLead => _streamCareLead.stream;

  setCareLead(List<CareLeadData>? event) => set(_streamCareLead, event);

  final _streamLeadInfoDeal = BehaviorSubject<List<DetailLeadInfoDealData>?>();
  ValueStream<List<DetailLeadInfoDealData>?> get outputLeadInfoDeal =>
      _streamLeadInfoDeal.stream;

  setLeadInfoDeal(List<DetailLeadInfoDealData>? event) =>
      set(_streamLeadInfoDeal, event);

  final _streamExpandDeal = BehaviorSubject<bool>();
  ValueStream<bool> get outputExpandDeal => _streamExpandDeal.stream;
  setExpandDeal(bool event) => set(_streamExpandDeal, event);

  final _streamExpandCustomerCare = BehaviorSubject<bool>();
  ValueStream<bool> get outputExpandCustomerCare => _streamExpandCustomerCare.stream;
  setExpandCustomerCare(bool event) => set(_streamExpandCustomerCare, event);

  final _streamExpandListContact = BehaviorSubject<bool>();
  ValueStream<bool> get outputExpandListContact => _streamExpandListContact.stream;
  setExpandistContact(bool event) => set(_streamExpandListContact, event);

  resetExpand(){
    expandListContact = false;
    expandDeal = false;
    expandCare = false;
  }

  onSetExpand(Function onFunction){
    resetExpand();
    onFunction();
    resetStreamExpand();
  }

  resetStreamExpand(){
    setExpandDeal(expandDeal);
    setExpandCustomerCare(expandCare);
    setExpandistContact(expandListContact);
  }

  callPhone(String phone) async {
    await FlutterPhoneDirectCaller.callNumber(phone);
  }


  Future<List<CareLeadData>?> getCareLead(BuildContext context) async {
    ResponseModel responseData = await repository.getCareLead(
        context, GetCareListReqModel(customer_lead_id: detail?.customerLeadId));
    if (responseData.success ?? false) {
      var response = CareLeadResponseModel.fromList(responseData.datas);

      listCareLead = response.data ?? [];
      setCareLead(listCareLead);
      return listCareLead;
    }
    return null;
  }

  Future<List<ContactListData>?> getContactList(BuildContext context) async {
    ResponseModel responseData = await repository.getContactList(context,
        GetContactLeadReqModel(customer_lead_code: detail?.customerLeadCode));
    if (responseData.success ?? false) {
      var response = ContactListModelResponse.fromList(responseData.datas);
      listContact = response.data ?? [];
      setContactList(listContact);
      return listContact;
    }
    return null;
  }

  Future<List<DetailLeadInfoDealData>?> getDetailLeadInfoDeal(
      BuildContext context) async {
    ResponseModel responseData = await repository.getDetailLeadInfoDeal(context,
        GetContactLeadReqModel(customer_lead_code: detail?.customerLeadCode));
    if (responseData.success ?? false) {
      var response =
          DetailLeadInfoDealResponseModel.fromList(responseData.datas);
      listDealFromLead = response.data ?? [];
      setLeadInfoDeal(listDealFromLead);
      return listDealFromLead;
    }
    return null;
  }

  onTapListCustomerCare() {
    CustomNavigator.push(context!, ListCustomerCareScreen(bloc: this));
  }

  onTapListContact() {
    CustomNavigator.push(context!, ListContactScreen(bloc: this));
  }

  onTapListDeal() {
    CustomNavigator.push(context!, ListDealScreen(bloc: this));
  }
}

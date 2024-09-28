import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/connection/http_connection.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/note_file_req_res_model.dart';
import 'package:lead_plugin_epoint/model/request/add_contact_req_model.dart';
import 'package:lead_plugin_epoint/model/request/assign_revoke_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/request/get_care_list_req_model.dart';
import 'package:lead_plugin_epoint/model/request/get_contact_lead_req_model.dart';
import 'package:lead_plugin_epoint/model/response/care_lead_response_model.dart';
import 'package:lead_plugin_epoint/model/response/contact_list_model_response.dart';
import 'package:lead_plugin_epoint/model/response/detail_lead_info_deal_response_model.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/position_response_model.dart';
import 'package:lead_plugin_epoint/model/response_model.dart';
import 'package:lead_plugin_epoint/presentation/interface/base_bloc.dart';
import 'package:lead_plugin_epoint/presentation/modal/position_modal.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/add_contact/ui/add_contact_business_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/list_ui/list_contact_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/list_ui/list_customer_care_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/list_ui/list_deal_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/list_ui/list_files_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/note_module/ui/add_file_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/note_module/ui/create_note_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/note_module/ui/list_note_screen.dart';
import 'package:lead_plugin_epoint/utils/custom_document_picker.dart';
import 'package:lead_plugin_epoint/widget/custom_file_view.dart';
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

  List<PositionData>? positionData;
  PositionData? positionSelected;
  
  final _streamModel = BehaviorSubject<DetailPotentialData?>();
  ValueStream<DetailPotentialData?> get outputModel => _streamModel.stream;
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

       final _streamListNote = BehaviorSubject<List<NoteData>?>();
  ValueStream<List<NoteData>?> get outputListNote => _streamListNote.stream;
  setListNoteData(List<NoteData>? event) => set(_streamListNote, event);

  final _streamDealsFile = BehaviorSubject<List<LeadFilesModel>?>();
  ValueStream<List<LeadFilesModel>?> get outputDealsFile =>
      _streamDealsFile.stream;
  setLeadsFile(List<LeadFilesModel>? event) => set(_streamDealsFile, event);

  final _streamExpandDeal = BehaviorSubject<bool>();
  ValueStream<bool> get outputExpandDeal => _streamExpandDeal.stream;
  setExpandDeal(bool event) => set(_streamExpandDeal, event);

  final _streamExpandCustomerCare = BehaviorSubject<bool>();
  ValueStream<bool> get outputExpandCustomerCare =>
      _streamExpandCustomerCare.stream;
  setExpandCustomerCare(bool event) => set(_streamExpandCustomerCare, event);

  final _streamExpandListContact = BehaviorSubject<bool>();
  ValueStream<bool> get outputExpandListContact =>
      _streamExpandListContact.stream;
  setExpandistContact(bool event) => set(_streamExpandListContact, event);


  final _streamExpandListNote = BehaviorSubject<bool>();
  ValueStream<bool> get outputExpandListNote => _streamExpandListNote.stream;
  setExpandListNote(bool event) => set(_streamExpandListNote, event);

  final _streamExpandListFile = BehaviorSubject<bool>();
  ValueStream<bool> get outputExpandListFile => _streamExpandListFile.stream;
  setExpandListFile(bool event) => set(_streamExpandListFile, event);

  List<NoteData> listNoteData = [];
  List<LeadFilesModel> listLeadsFiles = [];
  bool allowPop = false;

  bool expandDeal = false;
  bool expandCare = false;
  bool expandListContact = false;
  bool expandListNote = false;
  bool expandListFile = false;



  resetExpand() {
    expandDeal = false;
    expandCare = false;
    expandListContact = false;
    expandListNote = false;
    expandListFile = false;
  }

  onSetExpand(Function onFunction) {
    resetExpand();
    onFunction();
    resetStreamExpand();
  }

  resetStreamExpand() {
    setExpandDeal(expandDeal);
    setExpandCustomerCare(expandCare);
    setExpandistContact(expandListContact);
    setExpandListNote(expandListNote);
    setExpandListFile(expandListFile);
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

  Future<bool> getData(String customer_lead_code) async {
    var dataDetail = await LeadConnection.getdetailPotential(
        context!, customer_lead_code);
    if (dataDetail != null) {
      if (dataDetail.errorCode == 0) {
        detail = dataDetail.data;
        setModel(detail);
        getCareLead(context!);
        getContactList(context!);
        getDetailLeadInfoDeal(context!);
        getListNote(context!);
        getListFile(context!);
        return true;

      } else {
        await LeadConnection.showMyDialog(context!, dataDetail.errorDescription);
        Navigator.of(context!).pop();
        return false;
      }
    }
    return false;
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

  Future<bool?> addContact(
      BuildContext context, AddContactRequest model) async {
    CustomNavigator.showProgressDialog(context);
    ResponseModel responseData = await repository.addContact(context, model);
    CustomNavigator.hideProgressDialog();
    if (responseData.success ?? false) {
      return true;
    }
    return false;
  }

  Future<bool> assignRevokeLead(AssignRevokeLeadRequestModel model) async {
    try {
       CustomNavigator.showProgressDialog(context);
    final value = await LeadConnection.assignRevokeLead(context!, model);
     CustomNavigator.hideProgressDialog();
    return value != null;
  } catch (e) {
    // Handle any errors if necessary
    return false;
  }
  }

   Future<bool> convertLead(int customer_lead_id) async {
    try {
      CustomNavigator.showProgressDialog(context);
    final value = await LeadConnection.convertLead(context!, customer_lead_id);
    CustomNavigator.hideProgressDialog();
    return value != null;
  } catch (e) {
    // Handle any errors if necessary
    return false;
  }
  }

  Future<List<LeadFilesModel>?> getListFile(BuildContext context) async {
    ResponseModel responseData = await repository.getListFile(
        context, GetFileReqModel(customer_lead_id: detail?.customerLeadId));
    if (responseData.success ?? false) {
      var response = ListLeadFilesModel.fromList(responseData.datas);

      listLeadsFiles = response.data ?? [];
      setLeadsFile(listLeadsFiles);
      return listLeadsFiles;
    }
    return null;
  }

  Future<List<NoteData>?> getListNote(BuildContext context) async {
    ResponseModel responseData = await repository.getListNote(
        context, GetListNoteModel(customer_lead_id: detail?.customerLeadId));
    if (responseData.success ?? false) {
      var response = ListNoteResponseModel.fromList(responseData.datas);

      listNoteData = response.data ?? [];
      setListNoteData(listNoteData);
      return listNoteData;
    }
    return null;
  }

  onTapListCustomerCare() async {
   await CustomNavigator.push(context!, ListCustomerCareScreen(bloc: this));
   allowPop = true;
  }

  onTapListContact() async {
   await CustomNavigator.push(context!, ListContactScreen(bloc: this));
  }

  onTapListDeal() async {
    await CustomNavigator.push(context!, ListDealScreen(bloc: this));
     allowPop = true;
  }

  onAddContact() async {
    await CustomNavigator.push(context!, AddContactBusinessScreen(bloc: this));
  }

  onTapListNote() {
    CustomNavigator.push(context!, ListNoteScreen(bloc: this, model: detail!));
  }

  onAddNote(Function? onReload) async {
    bool? event = await CustomNavigator.showCustomBottomDialog(
        context!,
        CreateNoteScreen(
          model: detail!,
        ));
    if (event == null || event) {
      onReload?.call();
    }
  }



  Future<bool> loadPositionModal() async {
    PositionData? position = await CustomNavigator.showCustomBottomDialog(
      context!,
      PositionModal(positionData: positionData),
    );
    if (position != null) {
      positionSelected = position;
      return true;
    }
    return false;
  }

  onTapListFile() {
    CustomNavigator.push(context!, ListFileScreen(bloc: this));
  }

  onOpenFile(String? name, String? path) {
    print("object");
    Navigator.of(context!).push(
        MaterialPageRoute(builder: (context) => CustomFileView(path, name)));
  }

  onAddFile() {
    Navigator.of(context!).push(MaterialPageRoute(
        builder: (context) => AddFileScreen(
              bloc: this,
            )));
  }

  Future<File?> uploadFile() async {
    File? file = await CustomDocumentPicker.openDocument(context!, params: [
      "txt",
      "pdf",
      "doc",
      "docx",
      "xls",
      "xlsx",
      "xlsm",
      "pptx",
      "ppt",
      "jpeg",
      "jpg",
      "png"
    ]);
    if (file != null) {
      return file;
    }
    return null;
  }

  onSaveFile(File file, String content) {
    uploadFileAWS(file, content: content);
  }

  uploadFileAWS(File model, {String content = ""}) async {
    CustomNavigator.showProgressDialog(context);
    String? result = await LeadConnection.uploadFileAWS(context, model);
    CustomNavigator.hideProgressDialog();
    if (result != null) {
      bool value = await addFile(UploadFileReqModel(
          customer_lead_id: detail?.customerLeadId,
          path: result,
          content: content,
          fileName: model.path.split("/").last));
        return value;
    } else {
      LeadConnection.handleError(
          context!, AppLocalizations.text(LangKey.server_error));
    }
  }

  Future<bool> addFile(UploadFileReqModel model) async {
    try {
      ResponseModel responseData = await repository.addFile(context, model);
      return responseData.success ?? false;
    } catch (e) {
      return false;
    }
  }

  onPushPresenter () {
    
  }




}

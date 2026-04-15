import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/customer_type.dart';
import 'package:lead_plugin_epoint/model/object_pop_detail_model.dart';
import 'package:lead_plugin_epoint/model/request/add_lead_model_request.dart';
import 'package:lead_plugin_epoint/model/response/add_lead_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/bloc/create_potential_customer_bloc.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/widgets/create_potential_customer_body.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_scaffold.dart';

class CreatePotentialCustomer extends StatefulWidget {
  final String? fullname;
  final String? phoneNumber;
  CreatePotentialCustomer({Key? key, this.fullname, this.phoneNumber})
      : super(key: key);

  @override
  _CreatePotentialCustomerState createState() =>
      _CreatePotentialCustomerState();
}

class _CreatePotentialCustomerState extends State<CreatePotentialCustomer>
    with WidgetsBindingObserver {
  var _isKeyboardVisible = false;

  late CreatePotentialCustomerBloc _bloc;

  final ScrollController _controller = ScrollController();
  final TextEditingController _fullNameText = TextEditingController();
  final FocusNode _fullnameFocusNode = FocusNode();

  final TextEditingController _phoneNumberText = TextEditingController();
  final FocusNode _phoneNumberFocusNode = FocusNode();

  final TextEditingController _emailText = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  final TextEditingController _taxText = TextEditingController();
  final FocusNode _taxFocusNode = FocusNode();

  AddLeadModelRequest detailPotential = AddLeadModelRequest(
      avatar: "",
      customerType: "",
      customerSource: 0,
      fullName: "",
      taxCode: "",
      phone: "",
      email: "",
      representative: "",
      pipelineCode: "",
      journeyCode: "",
      saleId: 0,
      tagId: [],
      gender: "",
      bussinessId: 0,
      businessClue: "",
      birthday: "",
      employees: 0,
      position: "",
      provinceId: 0,
      districtId: 0,
      wardId: 0,
      address: "",
      zalo: "",
      fanpage: "",
      contactFullName: "",
      contactPhone: "",
      contactEmail: "",
      contactAddress: "");

  CustomerTypeModel customerTypeSelected = CustomerTypeModel(
      customerTypeName: AppLocalizations.text(LangKey.personal),
      customerTypeID: 1,
      selected: true);

  ObjectPopDetailModel modelResponse = ObjectPopDetailModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = CreatePotentialCustomerBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.fullname != null) {
        _fullNameText.text = widget.fullname!;
      }
      if (widget.phoneNumber != null) {
        _phoneNumberText.text = widget.phoneNumber!;
      }
      await _bloc.initData(context);
      // Auto-fill saleId from staffSelected
      if (_bloc.staffSelected != null) {
        detailPotential.saleId = _bloc.staffSelected!.staffId;
      }
      // Auto-fill customerSource from sourceSelected
      if (_bloc.sourceSelected.customerSourceId != null) {
        detailPotential.customerSource = _bloc.sourceSelected.customerSourceId;
      }
      // Auto-fill pipeline and journey
      if (_bloc.pipelineSelected.pipelineCode != null) {
        detailPotential.pipelineCode = _bloc.pipelineSelected.pipelineCode;
      }
      if (_bloc.journeySelected?.journeyCode != null) {
        detailPotential.journeyCode = _bloc.journeySelected!.journeyCode;
      }
      setState(() {});
    });
    _fullnameFocusNode.requestFocus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(() {});
    _bloc.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = View.of(context).viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        keyboardDismissOnTap(context);
      },
      child: CustomScaffold(
        title: AppLocalizations.text(LangKey.addPotentialCustomer),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
            child: CustomListView(
          padding: const EdgeInsets.only(
              top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _controller,
          children: [
            CreatePotentialCustomerBody(
              bloc: _bloc,
              fullNameText: _fullNameText,
              fullnameFocusNode: _fullnameFocusNode,
              phoneNumberText: _phoneNumberText,
              phoneNumberFocusNode: _phoneNumberFocusNode,
              emailText: _emailText,
              emailFocusNode: _emailFocusNode,
              taxText: _taxText,
              taxFocusNode: _taxFocusNode,
              detailPotential: detailPotential,
              getCustomerTypeSelected: () => customerTypeSelected,
              setCustomerTypeSelected: (val) {
                customerTypeSelected = val;
                setState(() {});
              },
            ),
          ],
        )),
        Visibility(visible: !_isKeyboardVisible, child: _buildButton()),
        const SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () async {
          if (_phoneNumberText.text.isNotEmpty) {
            if ((!Validators().isValidPhone(_phoneNumberText.text.trim())) &&
                (!Validators().isNumber(_phoneNumberText.text.trim()))) {
              LeadConnection.showMyDialog(context,
                  AppLocalizations.text(LangKey.phoneNumberNotCorrectFormat),
                  warning: true);
              return;
            }
          }
          // if (detailPotential.contactPhone!.isNotEmpty &&
          //     customerTypeSelected.customerTypeID != 1) {
          //   if ((!Validators()
          //           .isValidPhone(detailPotential.contactPhone!.trim())) &&
          //       (!Validators()
          //           .isNumber(detailPotential.contactPhone!.trim()))) {
          //     LeadConnection.showMyDialog(
          //         context, AppLocalizations.text(LangKey.contactPhoneInvalid),
          //         warning: true);
          //     return;
          //   }
          // }
          if (_fullNameText.text == "" ||
              detailPotential.pipelineCode == "" ||
              detailPotential.journeyCode == "" ||
              detailPotential.saleId == 0 ||
              _bloc.branchSelected == null) {
            LeadConnection.showMyDialog(context,
                AppLocalizations.text(LangKey.warningChooseAllRequiredInfo),
                warning: true);
            return;
          }
          // Validate contact fullname & phone for business
          if (customerTypeSelected.customerTypeID != 1) {
            if (detailPotential.contactFullName == null ||
                detailPotential.contactFullName!.isEmpty) {
              LeadConnection.showMyDialog(context,
                  AppLocalizations.text(LangKey.warningChooseAllRequiredInfo),
                  warning: true);
              return;
            }
          }
          if (_bloc.images.length > 0) {
            await _bloc.uploadFileAWS(_bloc.images[0]).then((value) {
              if (value != "") {
                _bloc.imgAvatar = value;
              }
              addPotential(customerTypeSelected.customerTypeID ?? 0);
            });
          } else {
            await addPotential(customerTypeSelected.customerTypeID ?? 0);
          }
        },
        child: Center(
          child: Text(
            AppLocalizations.text(LangKey.addPotentialCustomer)!,
            style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  Future<void> addPotential(int customerTypeID) async {
    bool typePersonnal = customerTypeID == 1;
    LeadConnection.showLoading(context);
    final req = AddLeadModelRequest(
      avatar: _bloc.imgAvatar ?? "",
      customerType: typePersonnal ? "personal" : "business",
      customerSource: detailPotential.customerSource,
      fullName: _fullNameText.text,
      taxCode: typePersonnal ? "" : _taxText.text,
      phone: _phoneNumberText.text,
      email: _emailText.text,
      representative: typePersonnal ? "" : _bloc.representativeController.text,
      pipelineCode: detailPotential.pipelineCode,
      journeyCode: detailPotential.journeyCode,
      saleId: detailPotential.saleId,
      tagId: detailPotential.tagId,
      gender: detailPotential.gender,
      birthday: detailPotential.birthday,
      bussinessId: typePersonnal ? 0 : detailPotential.bussinessId,
      employees: typePersonnal ? 0 : detailPotential.employees,
      address: "${_bloc.addressModel?.street ?? ""} ",
      provinceId: _bloc.addressModel?.provinceModel?.provinceid ?? 0,
      districtId: _bloc.addressModel?.districtModel?.districtid ?? 0,
      wardId: _bloc.addressModel?.wardModel?.wardId ?? 0,
      businessClue: detailPotential.businessClue,
      zalo: detailPotential.zalo ?? "",
      fanpage: detailPotential.fanpage ?? "",
      contactAddress: typePersonnal ? "" : detailPotential.contactAddress,
      contactEmail: typePersonnal ? "" : detailPotential.contactEmail,
      contactFullName: typePersonnal ? "" : detailPotential.contactFullName,
      contactPhone: typePersonnal ? "" : detailPotential.contactPhone,
      position: typePersonnal ? "" : detailPotential.position,
      customerGroupId: _bloc.customerGroupSelected?.customerGroupId ?? 0,
      branchId: _bloc.branchSelected?.branchId ?? 0,
      note: _bloc.noteController.text,
      customerLeadReferId: _bloc.presenterModel?.customerId ?? 0,
      arrPhoneAttack: _bloc.listPhone,
      website: _bloc.websiteController.text,
    );
    print('____REQUEST CREATE: ${req.toJson()}');
    AddLeadModelResponse? result = await LeadConnection.addLead(context, req);
    Navigator.of(context).pop();
    if (result != null) {
      if (result.errorCode == 0) {
        print(result.errorDescription);
        await LeadConnection.showMyDialog(context, result.errorDescription);
        if (result.data != null) {
          modelResponse = ObjectPopDetailModel(
              customer_lead_code: "",
              customer_lead_id: result.data!.customerLeadId,
              status: true);
        }
        Navigator.of(context).pop(modelResponse.toJson());
      } else {
        LeadConnection.showMyDialog(context, result.errorDescription);
      }
    }
  }
}

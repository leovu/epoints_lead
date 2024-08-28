
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/custom_create_address_model.dart';
import 'package:lead_plugin_epoint/presentation/module_address/src/bloc/create_address_bloc.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_bottom.dart';
import 'package:lead_plugin_epoint/widget/custom_column_infomation.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_scaffold.dart';
import 'package:lead_plugin_epoint/widget/custom_textfield.dart';

class CreateAddressScreen extends StatefulWidget {
  final CustomerCreateAddressModel? model;

  const CreateAddressScreen({super.key, this.model});

  @override
  CreateAddressScreenState createState() => CreateAddressScreenState();
}

class CreateAddressScreenState extends State<CreateAddressScreen> {
  late CreateAddressBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = CreateAddressBloc(context);

    if(widget.model != null){
      _bloc.addressModel = CustomerCreateAddressModel(
        provinceModel: widget.model!.provinceModel,
        districtModel: widget.model!.districtModel,
        wardModel: widget.model!.wardModel,
      );
      _bloc.controllerAddress.text = parseAddress(_bloc.addressModel);
      _bloc.controllerStreet.text = widget.model!.street ?? "";
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    super.dispose();
  }

  Widget _buildAddress(){
    return new CustomColumnInformation(
        title: "${AppLocalizations.text(LangKey.province)}/${AppLocalizations.text(LangKey.city)}, ${AppLocalizations.text(LangKey.district)}, ${AppLocalizations.text(LangKey.ward)}",
        titleIcon: Assets.iconCity,
        child: CustomTextField(
          focusNode: _bloc.focusAddress,
          controller: _bloc.controllerAddress,
          backgroundColor: Colors.transparent,
          borderColor: AppColors.borderColor,
          readOnly: true,
          suffixIconData: Icons.navigate_next,
          hintText: AppLocalizations.text(LangKey.select),
          ontap: _bloc.onAddress,
        ));
  }

  Widget _buildStreet(){
    return CustomColumnInformation(
      title: "${AppLocalizations.text(LangKey.street_name)}, ${AppLocalizations.text(LangKey.house_number)!.toLowerCase()}",
      titleIcon: Assets.iconMarker,
      child: CustomTextField(
        focusNode: _bloc.focusStreet,
        controller: _bloc.controllerStreet,
        backgroundColor: Colors.transparent,
        borderColor: AppColors.borderColor,
        hintText: AppLocalizations.text(LangKey.enter_content),
      ),
    );
  }

  Widget _buildContent(){
    return CustomListView(
      separatorPadding: AppSizes.maxPadding,
      children: [
        _buildAddress(),
        _buildStreet(),
      ],
    );
  }

  Widget _buildBottom(){
    return CustomBottom(
      text: AppLocalizations.text(LangKey.confirm),
      ontap: _bloc.onConfirm,
    );
  }

  Widget _buildBody(){
    return Column(
      children: [
        Expanded(child: _buildContent()),
        _buildBottom()
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF0067AC),
        title: Text(
          AppLocalizations.text(LangKey.enter_address)!,
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        // leadingWidth: 20.0,
      ),
      body: _buildBody(),
    );
  }
}

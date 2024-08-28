import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/model/custom_create_address_model.dart';
import 'package:lead_plugin_epoint/presentation/module_address/src/bloc/create_address_select_bloc.dart';
import 'package:lead_plugin_epoint/presentation/module_address/src/ui/create_address_district_screen.dart';
import 'package:lead_plugin_epoint/presentation/module_address/src/ui/create_address_province_screen.dart';
import 'package:lead_plugin_epoint/presentation/module_address/src/ui/create_address_ward_screen.dart';
import 'package:lead_plugin_epoint/widget/custom_bottom.dart';
import 'package:lead_plugin_epoint/widget/widget.dart';

class CreateAddressSelectScreen extends StatefulWidget {
  final CustomerCreateAddressModel? model;

  const CreateAddressSelectScreen({super.key, this.model});

  @override
  CreateAddressSelectScreenState createState() => CreateAddressSelectScreenState();
}

class CreateAddressSelectScreenState extends State<CreateAddressSelectScreen> with SingleTickerProviderStateMixin {
  late CreateAddressSelectBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = CreateAddressSelectBloc(context);

    _bloc.provinceModel = widget.model?.provinceModel;
    _bloc.districtModel = widget.model?.districtModel;
    _bloc.wardModel = widget.model?.wardModel;

    _bloc.tabs = [
      CustomModelTabBar(
        name: "${AppLocalizations.text(LangKey.province)}/${AppLocalizations.text(LangKey.city)}",
        child: CreateAddressProvinceScreen(bloc: _bloc,)
      ),
      CustomModelTabBar(
          name: AppLocalizations.text(LangKey.district),
          child: CreateAddressDistrictScreen(bloc: _bloc,)
      ),
      CustomModelTabBar(
          name: AppLocalizations.text(LangKey.ward),
          child: CreateAddressWardScreen(bloc: _bloc,)
      ),
    ];

    _bloc.tabController = TabController(length: _bloc.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    super.dispose();
  }
  
  Widget _buildBody(){
    return Column(
      children: [
        CustomTabBar(
          tabs: _bloc.tabs,
          controller: _bloc.tabController,
        ),
        Expanded(child: CustomTabBarView(
          tabs: _bloc.tabs,
          controller: _bloc.tabController,
        )),
        CustomBottom(
          text: AppLocalizations.text(LangKey.confirm),
          ontap: _bloc.onConfirm,
        )
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
          AppLocalizations.text(LangKey.select_address)!,
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        // leadingWidth: 20.0,
      ),
      body: _buildBody(),
    );
  }
}

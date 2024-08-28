
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/model/custom_create_address_model.dart';
import 'package:lead_plugin_epoint/presentation/interface/base_bloc.dart';
import 'package:lead_plugin_epoint/presentation/module_address/src/ui/create_address_select_screen.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';

class CreateAddressBloc extends BaseBloc {

  CreateAddressBloc(BuildContext context){
    setContext(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  CustomerCreateAddressModel? addressModel;

  final FocusNode focusAddress = FocusNode();
  final TextEditingController controllerAddress = TextEditingController();
  final FocusNode focusStreet = FocusNode();
  final TextEditingController controllerStreet = TextEditingController();

  onAddress() async {
    CustomerCreateAddressModel? event = await  Navigator.of(context!).push(
        MaterialPageRoute(builder: (context) =>CreateAddressSelectScreen(model: addressModel,)));

    if(event != null){
      addressModel = event;
      controllerAddress.text = parseAddress(addressModel);
    }
  }

  onConfirm(){
    CustomNavigator.pop(context!, object: CustomerCreateAddressModel(
      provinceModel: addressModel?.provinceModel,
      districtModel: addressModel?.districtModel,
      wardModel: addressModel?.wardModel,
      street: controllerStreet.text
    ));
  }
}
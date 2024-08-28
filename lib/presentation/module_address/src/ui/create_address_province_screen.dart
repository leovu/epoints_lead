import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/model/custom_create_address_model.dart';
import 'package:lead_plugin_epoint/presentation/module_address/src/bloc/create_address_select_bloc.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_bottom_option.dart';
import 'package:lead_plugin_epoint/widget/custom_debounce.dart';
import 'package:lead_plugin_epoint/widget/custom_search_box.dart';

class CreateAddressProvinceScreen extends StatefulWidget {
  final CreateAddressSelectBloc bloc;

  const CreateAddressProvinceScreen({super.key, required this.bloc});

  @override
  CreateAddressProvinceScreenState createState() =>
      CreateAddressProvinceScreenState();
}

class CreateAddressProvinceScreenState
    extends State<CreateAddressProvinceScreen>
    with AutomaticKeepAliveClientMixin {
  CustomDebounce _debounce = CustomDebounce();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => widget.bloc.onRefreshProvince(isRefresh: false));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _clearSearch() {
    fieldFocus(context, FocusNode());
    widget.bloc.controllerProvinceSearch.clear();
    _listener();
  }

  _listener() {
    _debounce.onChange(() => widget.bloc.onRefreshProvince(isRefresh: false));
    widget.bloc.setProvinceSearch(widget.bloc.controllerProvinceSearch.text);
  }

  Widget _buildSearchBox() {
    return StreamBuilder(
        stream: widget.bloc.outputProvinceSearch,
        initialData: "",
        builder: (_, snapshot) {
          String event = snapshot.data as String;
          return CustomSearchBox(
            focusNode: widget.bloc.focusProvinceSearch,
            controller: widget.bloc.controllerProvinceSearch,
            suffixIcon:
                event.isEmpty ? Assets.iconSearch : Assets.iconCloseCircle,
            onSuffixTap: event.isEmpty ? null : _clearSearch,
            onChanged: (_) => _listener(),
          );
        });
  }

  Widget _buildBody() {
    return StreamBuilder(
        stream: widget.bloc.outputProvinceModels,
        initialData: null,
        builder: (_, snapshot) {
          List<ProvinceModel>? models = snapshot.data as List<ProvinceModel>?;
          return CustomBottomOption(
            options: models == null
                ? null
                : models
                    .map((e) => CustomBottomOptionModel(
                        text: e.name,
                        isSelected: e.provinceid ==
                            widget.bloc.provinceModel?.provinceid,
                        onTap: () => widget.bloc.selectProvince(e)))
                    .toList(),
            shrinkWrap: false,
            onRefresh: widget.bloc.onRefreshProvince,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [_buildSearchBox(), Expanded(child: _buildBody())],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

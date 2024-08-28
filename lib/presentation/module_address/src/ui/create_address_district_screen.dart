
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/model/custom_create_address_model.dart';
import 'package:lead_plugin_epoint/presentation/module_address/src/bloc/create_address_select_bloc.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_bottom_option.dart';
import 'package:lead_plugin_epoint/widget/custom_debounce.dart';
import 'package:lead_plugin_epoint/widget/custom_search_box.dart';

class CreateAddressDistrictScreen extends StatefulWidget {
  final CreateAddressSelectBloc bloc;

  const CreateAddressDistrictScreen({super.key, required this.bloc});

  @override
  CreateAddressDistrictScreenState createState() =>
      CreateAddressDistrictScreenState();
}

class CreateAddressDistrictScreenState
    extends State<CreateAddressDistrictScreen>
    with AutomaticKeepAliveClientMixin {
  CustomDebounce _debounce = CustomDebounce();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => widget.bloc.onRefreshDistrict(isRefresh: false));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _clearSearch() {
    fieldFocus(context, FocusNode());
    widget.bloc.controllerDistrictSearch.clear();
    _listener();
  }

  _listener() {
    _debounce.onChange(() => widget.bloc.onRefreshDistrict(isRefresh: false));
    widget.bloc.setDistrictSearch(widget.bloc.controllerDistrictSearch.text);
  }

  Widget _buildSearchBox() {
    return StreamBuilder(
        stream: widget.bloc.outputDistrictSearch,
        initialData: "",
        builder: (_, snapshot) {
          String event = snapshot.data as String;
          return CustomSearchBox(
            focusNode: widget.bloc.focusDistrictSearch,
            controller: widget.bloc.controllerDistrictSearch,
            suffixIcon:
                event.isEmpty ? Assets.iconSearch : Assets.iconCloseCircle,
            onSuffixTap: event.isEmpty ? null : _clearSearch,
            onChanged: (_) => _listener(),
          );
        });
  }

  Widget _buildBody() {
    return StreamBuilder(
        stream: widget.bloc.outputDistrictModels,
        initialData: null,
        builder: (_, snapshot) {
          List<DistrictModel>? models = snapshot.data as List<DistrictModel>?;
          return CustomBottomOption(
            options: models == null
                ? null
                : models
                    .map((e) => CustomBottomOptionModel(
                        text: e.name,
                        isSelected: e.districtid ==
                            widget.bloc.districtModel?.districtid,
                        onTap: () => widget.bloc.selectDistrict(e)))
                    .toList(),
            shrinkWrap: false,
            onRefresh: widget.bloc.onRefreshDistrict,
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

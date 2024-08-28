import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/model/custom_create_address_model.dart';
import 'package:lead_plugin_epoint/presentation/module_address/src/bloc/create_address_select_bloc.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_bottom_option.dart';
import 'package:lead_plugin_epoint/widget/custom_debounce.dart';
import 'package:lead_plugin_epoint/widget/custom_search_box.dart';

class CreateAddressWardScreen extends StatefulWidget {
  final CreateAddressSelectBloc bloc;

  const CreateAddressWardScreen({super.key, required this.bloc});

  @override
  CreateAddressWardScreenState createState() => CreateAddressWardScreenState();
}

class CreateAddressWardScreenState extends State<CreateAddressWardScreen>
    with AutomaticKeepAliveClientMixin {
  CustomDebounce _debounce = CustomDebounce();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => widget.bloc.onRefreshWard(isRefresh: false));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _clearSearch() {
    fieldFocus(context, FocusNode());
    widget.bloc.controllerWardSearch.clear();
    _listener();
  }

  _listener() {
    _debounce.onChange(() => widget.bloc.onRefreshWard(isRefresh: false));
    widget.bloc.setWardSearch(widget.bloc.controllerWardSearch.text);
  }

  Widget _buildSearchBox() {
    return StreamBuilder(
        stream: widget.bloc.outputWardSearch,
        initialData: "",
        builder: (_, snapshot) {
          String event = snapshot.data as String;
          return CustomSearchBox(
            focusNode: widget.bloc.focusWardSearch,
            controller: widget.bloc.controllerWardSearch,
            suffixIcon:
                event.isEmpty ? Assets.iconSearch : Assets.iconCloseCircle,
            onSuffixTap: event.isEmpty ? null : _clearSearch,
            onChanged: (_) => _listener(),
          );
        });
  }

  Widget _buildBody() {
    return StreamBuilder(
        stream: widget.bloc.outputWardModels,
        initialData: null,
        builder: (_, snapshot) {
          List<WardModel>? models = snapshot.data as List<WardModel>?;
          return CustomBottomOption(
            options: models == null
                ? null
                : models
                    .map((e) => CustomBottomOptionModel(
                        text: e.name,
                        isSelected: e.wardId == widget.bloc.wardModel?.wardId,
                        onTap: () => widget.bloc.selectWard(e)))
                    .toList(),
            shrinkWrap: false,
            onRefresh: widget.bloc.onRefreshWard,
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

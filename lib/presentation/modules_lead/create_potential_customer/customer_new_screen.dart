import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/model/request/customer_request_model.dart';
import 'package:lead_plugin_epoint/model/response/customer_response_model.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/create_potential_customer/bloc/customer_bloc.dart';
import 'package:lead_plugin_epoint/utils/global.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/utils/visibility_api_widget_name.dart';
import 'package:lead_plugin_epoint/widget/container_data_builder.dart';
import 'package:lead_plugin_epoint/widget/custom_appbar.dart';
import 'package:lead_plugin_epoint/widget/custom_debounce.dart';
import 'package:lead_plugin_epoint/widget/custom_empty.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:lead_plugin_epoint/widget/custom_scaffold.dart';
import 'package:lead_plugin_epoint/widget/custom_search_box.dart';
import 'package:lead_plugin_epoint/widget/widget.dart';

import '../../../common/assets.dart';

class CustomerNewScreen extends StatefulWidget {
  final bool isCartChoose;
  CustomerNewScreen({this.isCartChoose = false});
  @override
  _CustomerNewScreenState createState() => _CustomerNewScreenState();
}

class _CustomerNewScreenState extends State<CustomerNewScreen> {
  final FocusNode _focusSearch = FocusNode();
  final TextEditingController _controllerSearch = TextEditingController();

  late CustomDebounce _debounce;

  List<CustomOptionAppBar>? _options;

  late CustomerBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = CustomerBloc(context);
    _debounce = CustomDebounce();

    // if (checkVisibilityKey(VisibilityWidgetName.CM000001)) {
      // _options = [
      //   CustomOptionAppBar(icon: Assets.iconPlus, onTap: _addCustomer)
      // ];
    // }

    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => _onRefresh(isRefresh: false));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _debounce.dispose();
    _bloc.dispose();
    super.dispose();
  }

  Future _onRefresh({bool isRefresh = true}) {
    return _bloc.getCustomer(
        requestModel: CustomerRequestModel(
            search: _controllerSearch.text,
            brandCode: Global.brandCode,
            view: widget.isCartChoose ? null : "booking"
        ),
        isRefresh: isRefresh);
  }

  _listener() {
    _debounce.onChange(() => _onRefresh(isRefresh: false));
    _bloc.setSearch(_controllerSearch.text);
  }

  _clearSearch() {
    fieldFocus(context, FocusNode());
    _controllerSearch.clear();
    _listener();
  }

  Widget _buildSearchBox() {
    return StreamBuilder(
        stream: _bloc.outputSearch,
        initialData: "",
        builder: (_, snapshot) {
          return CustomSearchBox(
            focusNode: _focusSearch,
            controller: _controllerSearch,
            hint: AppLocalizations.text(LangKey.finding_customers),
            suffixIcon: _controllerSearch.text.isEmpty
                ? Assets.iconSearch
                : Assets.iconCloseCircle,
            onSuffixTap: _controllerSearch.text.isEmpty ? null : _clearSearch,
            onChanged: (_) => _listener(),
          );
        });
  }

  Widget _buildEmpty() {
    return CustomEmpty(title: AppLocalizations.text(LangKey.data_empty));
  }

  Widget _buildContent() {
    return StreamBuilder(
        stream: _bloc.outputModel,
        initialData: null,
        builder: (_, snapshot) {
          CustomerResponseModel? model = snapshot.data as CustomerResponseModel?;
          return ContainerDataBuilder(
            data: model?.items,
            emptyBuilder: _buildEmpty(),
            skeletonBuilder: ContainerCustomer(),
            bodyBuilder: () => ContainerCustomer(
              model: model,
              onLoadmore: () => _bloc.getCustomer(isLoadmore: true),
              onTap: (event) => CustomNavigator.pop(context, object: event),
            ),
            onRefresh: _onRefresh,
          );
        });
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildSearchBox(),
        Expanded(child: _buildContent()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: AppLocalizations.text(LangKey.list_customers),
      body: _buildBody(),
      options: _options,
    );
  }
}

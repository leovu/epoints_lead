
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/model/request/customer_request_model.dart';
import 'package:lead_plugin_epoint/model/response/customer_response_model.dart';
import 'package:lead_plugin_epoint/model/response_model.dart';
import 'package:lead_plugin_epoint/presentation/interface/base_bloc.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

class CustomerBloc extends BaseBloc {
  CustomerBloc(BuildContext context) {
    setContext(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamModel.close();
    _streamSearch.close();
    super.dispose();
  }

  CustomerRequestModel? _requestModel;
  CustomerResponseModel? _model;
  DateTime? _fl;

  final _streamModel = BehaviorSubject<CustomerResponseModel?>();
  ValueStream<CustomerResponseModel?> get outputModel => _streamModel.stream;
  setModel(CustomerResponseModel? event) => set(_streamModel, event);

  final _streamSearch = BehaviorSubject<String>();
  ValueStream<String> get outputSearch => _streamSearch.stream;
  setSearch(String event) => set(_streamSearch, event);

  getCustomer(
      {CustomerRequestModel? requestModel,
      bool isRefresh = true,
      bool isLoadmore = false}) async {
    if (isLoadmore && !(_model?.pageInfo?.enableLoadmore ?? false)) {
      return;
    }

    if (!isRefresh) {
      setModel(null);
    }

    CustomerRequestModel model;
    model = requestModel ?? (_requestModel == null
        ? CustomerRequestModel()
        : CustomerRequestModel.fromJson(_requestModel!.toJson()));
    if (isLoadmore) {
      model.page = model.page! + 1;
    } else {
      model.page = 1;
    }
    DateTime now = _fl = DateTime.now();
    ResponseModel response = await repository.getCustomer(context, model);
    if(now != _fl){
      return;
    }
    if (response.success!) {
      var modelResponse = CustomerResponseModel.fromJson(response.data!);

      _requestModel = model;
      if (isLoadmore) {
        if (_model!.pageInfo?.currentPage !=
            modelResponse.pageInfo?.currentPage) {
          if (_model!.items == null) {
            _model!.items = [];
          }
          _model!.items!.addAll(modelResponse.items ?? []);
        }
        _model!.pageInfo = modelResponse.pageInfo;
      } else {
        _model = modelResponse;
      }

      setModel(_model);
    } else {
      if (!isLoadmore && !isRefresh) {
        setModel(CustomerResponseModel(items: []));
      }
    }
  }
}

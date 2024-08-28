
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/model/custom_create_address_model.dart';
import 'package:lead_plugin_epoint/model/request/district_model_request.dart';
import 'package:lead_plugin_epoint/model/response_model.dart';
import 'package:lead_plugin_epoint/presentation/interface/base_bloc.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/allocator_screen.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:lead_plugin_epoint/widget/widget.dart';
import 'package:rxdart/rxdart.dart';

class CreateAddressSelectBloc extends BaseBloc {

  CreateAddressSelectBloc(BuildContext context){
    setContext(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamProvinceSearch.close();
    _streamDistrictSearch.close();
    _streamWardSearch.close();
    _streamProvinceModels.close();
    _streamDistrictModels.close();
    _streamWardModels.close();
    super.dispose();
  }

  late List<CustomModelTabBar> tabs;
  late TabController tabController;

  /// Tab Province
  List<ProvinceModel>? _provinceModels;
  ProvinceModel? provinceModel;

  final FocusNode focusProvinceSearch = FocusNode();
  final TextEditingController controllerProvinceSearch = TextEditingController();

  final _streamProvinceSearch = BehaviorSubject<String>();
  ValueStream<String> get outputProvinceSearch => _streamProvinceSearch.stream;
  setProvinceSearch(String event) => set(_streamProvinceSearch, event);

  final _streamProvinceModels = BehaviorSubject<List<ProvinceModel>?>();
  ValueStream<List<ProvinceModel>?> get outputProvinceModels => _streamProvinceModels.stream;
  setProvinceModels(List<ProvinceModel>? event) => set(_streamProvinceModels, event);

  Future onRefreshProvince({bool isRefresh = true}) {
    return provinceFull(controllerProvinceSearch.text, isRefresh);
  }

  selectProvince(ProvinceModel model) {
    provinceModel = model;
    districtModel = null;
    wardModel = null;
    setProvinceModels(_provinceModels);
    tabController.index = 1;
    onRefreshDistrict(isRefresh: false);
  }

  searchProvince(String event){
    if(event.isEmpty || (_provinceModels?.length ?? 0) == 0){
      setProvinceModels(_provinceModels);
    }
    else{
      List<ProvinceModel>? results;
      try{
        results = _provinceModels!.where((model){
          List<String> searchs = event.toLowerCase().removeAccents().split(" ");
          bool result = true;

          for(String element in searchs){
            if(!((model.name ?? "")
                .toLowerCase()
                .removeAccents()
                .contains(element))){
              result = false;
              break;
            }
          }

          return result;
        }).toList();
      }
      catch(_){}

      setProvinceModels(results ?? []);
    }
  }

  provinceFull(String event, bool isRefresh) async {
    if(!isRefresh) setProvinceModels(null);
    ResponseModel response = await repository.provinceFull(context);
    if(response.success!){
      var responseModel = ProvinceResponseModel.fromJson(response.datas);

      _provinceModels = responseModel.data ?? [];
    }
    else{
      _provinceModels = [];
    }

    searchProvince(event);
  }

  /// Tab District
  List<DistrictModel>? _districtModels;
  DistrictModel? districtModel;

  final FocusNode focusDistrictSearch = FocusNode();
  final TextEditingController controllerDistrictSearch = TextEditingController();

  final _streamDistrictSearch = BehaviorSubject<String>();
  ValueStream<String> get outputDistrictSearch => _streamDistrictSearch.stream;
  setDistrictSearch(String event) => set(_streamDistrictSearch, event);

  final _streamDistrictModels = BehaviorSubject<List<DistrictModel>?>();
  ValueStream<List<DistrictModel>?> get outputDistrictModels => _streamDistrictModels.stream;
  setDistrictModels(List<DistrictModel>? event) => set(_streamDistrictModels, event);

  Future onRefreshDistrict({bool isRefresh = true}) {
    return district(controllerDistrictSearch.text, isRefresh);
  }

  selectDistrict(DistrictModel model) {
    districtModel = model;
    wardModel = null;
    setDistrictModels(_districtModels);
    tabController.index = 2;
    onRefreshWard(isRefresh: false);
  }

  searchDistrict(String event){
    if(event.isEmpty || (_districtModels?.length ?? 0) == 0){
      setDistrictModels(_districtModels);
    }
    else{
      List<DistrictModel>? results;
      try{
        results = _districtModels!.where((model){
          List<String> searchs = event.toLowerCase().removeAccents().split(" ");
          bool result = true;

          for(String element in searchs){
            if(!((model.name ?? "")
                .toLowerCase()
                .removeAccents()
                .contains(element))){
              result = false;
              break;
            }
          }

          return result;
        }).toList();
      }
      catch(_){}

      setDistrictModels(results ?? []);
    }
  }

  district(String event, bool isRefresh) async {
    if(!isRefresh) setDistrictModels(null);
    ResponseModel response = await repository.district(context, DistrictRequestModel(
      provinceid: provinceModel?.provinceid
    ));
    if(response.success!){
      var responseModel = DistrictResponseModel.fromJson(response.datas);

      _districtModels = responseModel.data ?? [];
    }
    else{
      _districtModels = [];
    }

    searchDistrict(event);
  }

  /// Tab Ward
  List<WardModel>? _wardModels;
  WardModel? wardModel;

  final FocusNode focusWardSearch = FocusNode();
  final TextEditingController controllerWardSearch = TextEditingController();

  final _streamWardSearch = BehaviorSubject<String>();
  ValueStream<String> get outputWardSearch => _streamWardSearch.stream;
  setWardSearch(String event) => set(_streamWardSearch, event);

  final _streamWardModels = BehaviorSubject<List<WardModel>?>();
  ValueStream<List<WardModel>?> get outputWardModels => _streamWardModels.stream;
  setWardModels(List<WardModel>? event) => set(_streamWardModels, event);

  Future onRefreshWard({bool isRefresh = true}) {
    return ward(controllerWardSearch.text, isRefresh);
  }

  selectWard(WardModel model) {
    wardModel = model;
    setWardModels(_wardModels);
    onConfirm();
  }

  searchWard(String event){
    if(event.isEmpty || (_wardModels?.length ?? 0) == 0){
      setWardModels(_wardModels);
    }
    else{
      List<WardModel>? results;
      try{
        results = _wardModels!.where((model){
          List<String> searchs = event.toLowerCase().removeAccents().split(" ");
          bool result = true;

          for(String element in searchs){
            if(!((model.name ?? "")
                .toLowerCase()
                .removeAccents()
                .contains(element))){
              result = false;
              break;
            }
          }

          return result;
        }).toList();
      }
      catch(_){}

      setWardModels(results ?? []);
    }
  }

  ward(String event, bool isRefresh) async {
    if(!isRefresh) setWardModels(null);
    ResponseModel response = await repository.ward(context, WardRequestModel(
        districtId: districtModel?.districtid
    ));
    if(response.success!){
      var responseModel = WardResponseModel.fromJson(response.datas);

      _wardModels = responseModel.data ?? [];
    }
    else{
      _wardModels = [];
    }

    searchWard(event);
  }

  onConfirm(){
    CustomNavigator.pop(context!, object: CustomerCreateAddressModel(
      provinceModel: provinceModel,
      districtModel: districtModel,
      wardModel: wardModel
    ));
  }
}
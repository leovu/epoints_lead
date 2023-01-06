import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/connection/http_connection.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/work_upload_file_model_response.dart';
import 'package:lead_plugin_epoint/presentation/interface/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class CustomerCareBloc extends BaseBloc {

  CustomerCareBloc(BuildContext context){
    setContext(context);
  }

  @override
  void dispose() {
    _streamFiles.close();
    super.dispose();
  }

   List<WorkUploadFileResponseModel> _files = [];


  final _streamFiles = BehaviorSubject<List<WorkUploadFileResponseModel>>();
  ValueStream<List<WorkUploadFileResponseModel>> get outputFiles => _streamFiles.stream;
  setFiles(List<WorkUploadFileResponseModel> event) => set(_streamFiles, event);


  workUploadFile(MultipartFileModel model) async {
    LeadConnection.showLoading(context);
    var result = await LeadConnection.workUploadFile(context, model);
    Navigator.of(context).pop();
    if(result != null){
      WorkUploadFileResponseModel response = result;

      _files.add(response);
      setFiles(_files);
    }
  }

  removeFile(WorkUploadFileResponseModel model){
    _files.remove(model);
    setFiles(_files);
  }
}
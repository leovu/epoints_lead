import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/connection/http_connection.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/request/work_create_comment_request_model.dart';
import 'package:lead_plugin_epoint/model/request/work_list_comment_request_model.dart';
import 'package:lead_plugin_epoint/model/response/work_list_comment_model_response.dart';
import 'package:lead_plugin_epoint/model/work_upload_file_model_response.dart';
import 'package:lead_plugin_epoint/presentation/interface/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class CommentBloc extends BaseBloc {

  static HTTPConnection connection = HTTPConnection();

  CommentBloc(BuildContext context){
    setContext(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamModels.close();
    _streamCallback.close();
    _streamFile.close();
    super.dispose();
  }

  List<WorkListCommentModel> _models;

  final _streamModels = BehaviorSubject<List<WorkListCommentModel>>();
  ValueStream<List<WorkListCommentModel>> get outputModels => _streamModels.stream;
  setModels(List<WorkListCommentModel> event) => set(_streamModels, event);

  final _streamCallback = BehaviorSubject<WorkListCommentModel>();
  ValueStream<WorkListCommentModel> get outputCallback => _streamCallback.stream;
  setCallback(WorkListCommentModel event) => set(_streamCallback, event);

  final _streamFile = BehaviorSubject<String>();
  ValueStream<String> get outputFile => _streamFile.stream;
  setFile(String event) => set(_streamFile, event);

  workListComment(WorkListCommentRequestModel model) async {
    var response = await LeadConnection.workListComment(context, model);
    if(response != null){

      _models = response.data ?? [];
    }
    else{
      _models = [];
    }

    setModels(_models);
  }

  workUploadFile(MultipartFileModel model) async {
    LeadConnection.showLoading(context);
    ResponseData response = await connection.upload(
        '/manage-work/upload-file',model.file);
    Navigator.of(context).pop();
    if(response.isSuccess){
      var responseModel = WorkUploadFileResponseModel.fromJson(response.data);

      setFile(responseModel.path);

      Navigator.of(context).pop();
    }
  }



  workCreatedComment(WorkCreateCommentRequestModel model, TextEditingController controller, Function(int) onCallback) async {
    LeadConnection.showLoading(context);
    var response = await LeadConnection.workCreatedComment(context, model);
    Navigator.of(context).pop();
    if(response != null){

      _models = response.data ?? [];
      setModels(_models);
      setFile(null);
      setCallback(null);
      controller.text = "";

      if(onCallback != null){
        int total = 0;
        for(var e in _models){
          total += _getTotalComment(e);
        }

        onCallback(total);
      }
    }
  }

  int _getTotalComment(WorkListCommentModel model){
    int total = 1;
    if((model.listObject?.length ?? 0) != 0){
      for(var e in model.listObject){
        total += _getTotalComment(e);
      }
    }
    return total;
  }
}
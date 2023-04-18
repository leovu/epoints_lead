import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
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

   List<String> _files = [];


  final _streamFiles = BehaviorSubject<List<String>>();
  ValueStream<List<String>> get outputFiles => _streamFiles.stream;
  setFiles(List<String> event) => set(_streamFiles, event);


  workUploadFile(File model) async {
    LeadConnection.showLoading(context);

    
    String result = await LeadConnection.uploadFileAWS(context, model);


    Navigator.of(context).pop();
    if(result != null){
      // WorkUploadFileResponse response = result.url;

      _files.add(result);
      setFiles(_files);
    } else {
      LeadConnection.handleError(context, AppLocalizations.text(LangKey.server_error));
    }
  }

  removeFile(String model){
    _files.remove(model);
    setFiles(_files);
  }
}
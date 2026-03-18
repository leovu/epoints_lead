import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/presentation/network/repository.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

abstract class BaseBloc{

  Repository get repository => _repository;
  Repository _repository = Repository();

  BuildContext? _context;

  setContext(BuildContext context) => _context = context;
  BuildContext? get context => _context;

  set(BehaviorSubject<dynamic> stream, dynamic event){
    if(!stream.isClosed) stream.sink.add(event);
  }

  setError(BehaviorSubject<dynamic> stream, dynamic event){
    if(!stream.isClosed) stream.sink.addError(event);
  }

  @protected
  @mustCallSuper
  void dispose(){

  }
}

extension BehaviorSubjectExtension<T> on BehaviorSubject<T> {
  set(T event, {Function? function}){
    function?.call();
    if(!this.isClosed) this.sink.add(event);
  }

  setError(String event, {Function? function}){
    function?.call();
    if(!this.isClosed) this.sink.addError(event);
  }

  ValueStream<T> get output => this.stream;
}
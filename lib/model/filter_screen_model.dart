import 'package:lead_plugin_epoint/model/request/list_customer_lead_model_request.dart';

class FilterScreenModel {
  ListCustomLeadModelRequest? filterModel;

  DateTime? fromDate_created_at;
  DateTime? toDate_created_at;
  String? id_created_at;

  DateTime? fromDate_allocation_date;
  DateTime? toDate_allocation_date;
  String? id_allocation_date;

  DateTime? fromDate_history_care_date;
  DateTime? toDate_history_care_date;
  String? id_history_care_date;

  DateTime? fromDate_work_schedule_date;
  DateTime? toDate_work_schedule_date;
  String? id_work_schedule_date;



  FilterScreenModel({this.filterModel, this.fromDate_created_at, this.toDate_created_at, this.id_created_at,this.fromDate_allocation_date,this.toDate_allocation_date,
   this.id_allocation_date, this.fromDate_history_care_date,this.toDate_history_care_date,this.id_history_care_date,this.fromDate_work_schedule_date,this.toDate_work_schedule_date,this.id_work_schedule_date});

  factory FilterScreenModel.fromJson(Map<String, dynamic> parsedJson) {
    return FilterScreenModel(
        filterModel: parsedJson['filterModel'],

        fromDate_created_at: parsedJson['fromDate_created_at'],
        toDate_created_at: parsedJson['toDate_created_at'],
        id_created_at: parsedJson['id_created_at'],

        fromDate_allocation_date: parsedJson['fromDate_allocation_date'],
        toDate_allocation_date: parsedJson['toDate_allocation_date'],
        id_allocation_date: parsedJson['id_allocation_date'],

        fromDate_history_care_date: parsedJson['fromDate_history_care_date'],
        toDate_history_care_date: parsedJson['toDate_history_care_date'],
        id_history_care_date: parsedJson['id_history_care_date'],

        fromDate_work_schedule_date: parsedJson['fromDate_work_schedule_date'],
        toDate_work_schedule_date: parsedJson['toDate_work_schedule_date'],
        id_work_schedule_date: parsedJson['id_work_schedule_date'],

        );
  }
}
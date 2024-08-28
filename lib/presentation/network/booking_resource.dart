import 'package:flutter/widgets.dart';
import 'package:lead_plugin_epoint/model/request/district_model_request.dart';
import 'package:lead_plugin_epoint/presentation/network/api.dart';
import 'package:lead_plugin_epoint/presentation/network/interaction.dart';

class BookingResource{
  provinceFull(BuildContext? context) => Interaction(
      context: context,
      url: API.provinceFull()
  ).post();

  district(BuildContext? context, DistrictRequestModel model) => Interaction(
      context: context,
      url: API.district(),
      param: model.toJson()
  ).post();

  ward(BuildContext? context, WardRequestModel model) => Interaction(
      context: context,
      url: API.ward(),
      param: model.toJson()
  ).post();
}
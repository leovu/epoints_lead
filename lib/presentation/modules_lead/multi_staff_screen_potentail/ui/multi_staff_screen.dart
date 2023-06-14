import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/multi_staff_screen_potentail/bloc/multi_staff_lead_bloc.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar_with_url.dart';
import 'package:lead_plugin_epoint/widget/custom_bottom.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';
import 'package:lead_plugin_epoint/widget/custom_dropdown.dart';
import 'package:lead_plugin_epoint/widget/custom_line.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_shimer.dart';
import 'package:lead_plugin_epoint/widget/custom_skeleton.dart';
import 'package:lead_plugin_epoint/widget/custom_textfield.dart';

class MultipleStaffScreenLead extends StatefulWidget {

  final List<WorkListStaffModel>? models;
  final List<WorkListStaffModel>? modelsSelectedCustomerCare;
  final List<WorkListStaffModel>? staffs;
  final int? projectId;
  MultipleStaffScreenLead({this.models,this.modelsSelectedCustomerCare, this.staffs,this.projectId});

  @override
  MultipleStaffScreenLeadState createState() => MultipleStaffScreenLeadState();
}

class MultipleStaffScreenLeadState extends State<MultipleStaffScreenLead> {

  FocusNode _focusSearch = FocusNode();
  TextEditingController _controllerSearch = TextEditingController();

  late MultipleStaffBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = MultipleStaffBloc(context, widget.models, widget.staffs);

    _controllerSearch.addListener(_listener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _onRefresh());
  }

  @override
  void dispose() {

    _controllerSearch.removeListener(_listener);
    _bloc.dispose();
    super.dispose();
  }

  Future _onRefresh(){
    final group = <Future>[];
    if(widget.staffs == null){
      group.add(_bloc.workListStaff(widget.models, _controllerSearch.text, widget.projectId));
    }
    group.add(_bloc.workListBranch());
    group.add(_bloc.workListDepartment());
    return Future.wait(group);
  }

  _listener(){
    _bloc.search(_controllerSearch.text);
  }

  Widget _buildSearch(List<WorkListStaffModel>? models){
    return Container(
      padding: EdgeInsets.only(
          top: 20.0,
          left: 20.0,
          right: 20.0
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: CustomTextField(
                focusNode: _focusSearch,
                controller: _controllerSearch,
                hintText: AppLocalizations.text(LangKey.inputSearch),
                backgroundColor: Colors.transparent,
                borderColor: AppColors.borderColor,
              )),
              SizedBox(width: 10.0,),
              CustomButton(
                text: AppLocalizations.text(LangKey.select_all),
                isExpand: false,
                onTap: () => _bloc.selectAll(models),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.text(LangKey.agency)!,
                  style: AppTextStyles.style14BlackBold,
                ),
                SizedBox(height: 10.0,),
                Row(
                  children: [
                    Expanded(child: StreamBuilder(
                        stream: _bloc.outputBranchModels,
                        initialData: null,
                        builder: (_, snapshot){
                          List<CustomDropdownModel>? menus = snapshot.data as List<CustomDropdownModel>?;
                          return StreamBuilder(
                              stream: _bloc.outputBranchModel,
                              initialData: null,
                              builder: (_, snapshot){
                                return CustomDropdown(
                                  value: snapshot.data as CustomDropdownModel,
                                  menus: menus,
                                  hint: AppLocalizations.text(LangKey.agency),
                                  onChanged: (event) {
                                    _bloc.branchModel = event;
                                    _bloc.setBranchModel(event);
                                    _bloc.search(_controllerSearch.text);
                                  },
                                );
                              }
                          );
                        }
                    )),
                    SizedBox(width: 10.0,),
                    Expanded(child: StreamBuilder(
                        stream: _bloc.outputDepartmentModels,
                        initialData: null,
                        builder: (_, snapshot){
                          List<CustomDropdownModel>? menus = snapshot.data as List<CustomDropdownModel>?;
                          return StreamBuilder(
                              stream: _bloc.outputDepartmentModel,
                              initialData: null,
                              builder: (_, snapshot){
                                return CustomDropdown(
                                  value: snapshot.data as CustomDropdownModel,
                                  menus: menus,
                                  hint: AppLocalizations.text(LangKey.department),
                                  onChanged: (event) {
                                    _bloc.departmentModel = event;
                                    _bloc.setDepartmentModel(event);
                                    _bloc.search(_controllerSearch.text);
                                  },
                                );
                              }
                          );
                        }
                    )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(List<WorkListStaffModel>? models, WorkListStaffModel? model){
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0
        ),
        alignment: Alignment.centerLeft,
        child: model == null?CustomShimmer(
          child: CustomSkeleton(width: MediaQuery.of(context).size.width / 2,),
        ):Row(
          children: [
            CustomAvatarWithURL(
              url: model.staffAvatar,
              name: model.staffName,
              size: 50.0,
            ),
            Container(width: 10.0,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.staffName ?? "",
                  style: TextStyle(
      fontSize: 16.0,
      color: AppColors.black,
      fontWeight: FontWeight.normal),
                ),
                Text(
                  model.departmentName!,
                  style: TextStyle(
      fontSize: 14.0,
      color: Color(0XFF8E8E8E),
      fontWeight: FontWeight.normal),
                )
              ],
            )),
            (model.isSelected ?? false) ?
              Container(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(
                  Icons.check_box,
                  color: AppColors.primaryColor,
                ),
              ) : Container(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(
                  Icons.check_box_outline_blank,
                  color: Color.fromARGB(255, 108, 102, 94),
                ),
              )
          ],
        ),
      ),
      onTap: model == null?null:() => _bloc.selected(models, model),
    );
  }

  Widget _buildContent(List<WorkListStaffModel>? models){
    return CustomListView(
      padding: EdgeInsets.zero,
      physics: AlwaysScrollableScrollPhysics(),
      separator: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: CustomLine(),
      ),
      children: models == null
          ? List.generate(4, (index) => _buildItem(models, null)).toList()
          : models.map((e) => _buildItem(models, e)).toList(),
      onRefresh: widget.staffs != null? null: _onRefresh,
    );
  }

  Widget _buildBottom(List<WorkListStaffModel>? models){
    return CustomBottom(
      text: AppLocalizations.text(LangKey.apply),
      onTap: () => _bloc.confirm(models!),
      subText: AppLocalizations.text(LangKey.delete),
      onSubTap: () => _bloc.delete(_controllerSearch.text),
    );
  }

  Widget _buildBody(){
    return StreamBuilder(
      stream: _bloc.outputModels,
      initialData: null,
      builder: (_, snapshot){
        List<WorkListStaffModel>? models = snapshot.data as List<WorkListStaffModel>?;
        return Column(
          children: [
            _buildSearch(models),
            Expanded(child: _buildContent(models)),
            _buildBottom(models),
            SizedBox(height: 15.0,)
            
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF0067AC),
          title: Text(
            AppLocalizations.text(LangKey.staff)!,
            style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          // leadingWidth: 20.0,
        ),
      body: _buildBody(),
    );
  }
}

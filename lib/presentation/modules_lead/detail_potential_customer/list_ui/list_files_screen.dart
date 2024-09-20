import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/note_file_req_res_model.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/bloc/detail_potential_customer_bloc.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/note_module/ui/list_note_screen.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:lead_plugin_epoint/widget/custom_scaffold.dart';
import 'package:lead_plugin_epoint/widget/custom_skeleton.dart';
import 'package:lead_plugin_epoint/widget/widget.dart';

class ListFileScreen extends StatefulWidget {
  final DetailPotentialCustomerBloc bloc;

  const ListFileScreen({super.key, required this.bloc});

  @override
  ListFileScreenState createState() => ListFileScreenState();
}

class ListFileScreenState extends State<ListFileScreen> {

  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.bloc.getListFile(context));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.bloc.dispose();
    super.dispose();
  }
  Widget _buildSkeleton() {
    return LoadingWidget(
        padding: EdgeInsets.zero,
        child: CustomListView(
          children: List.generate(
              10,
              (index) => CustomSkeleton(
                    height: 100,
                    radius: 4.0,
                  )),
        ));
  }

  _buildCustomerType() {
    return RichText(
              text: TextSpan(
                  text: widget.bloc.detail?.customerType == "personal"
                      ? "${AppLocalizations.text(LangKey.personal)} - "
                      : "${AppLocalizations.text(LangKey.business)} - ",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                  children: [
                TextSpan(
                    text: widget.bloc.detail?.fullName,
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold))
              ]));
  }

   Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.vGap10,
          _buildCustomerType(),
          Gaps.vGap10,
          Text(
            textAlign: TextAlign.start,
            AppLocalizations.text(LangKey.list)!,
            style: AppTextStyles.style16PrimaryBold),
          Gaps.vGap10,
          Expanded(
              child: _buildContent())
        ],
      ),
    );
  }

  Widget _buildContent() {
    return StreamBuilder(
      stream: widget.bloc.outputDealsFile,
      initialData: null,
      builder: (_, snapshot){
        List<LeadFilesModel>? models = snapshot.data as List<LeadFilesModel>?;
        return (models != null && models.isNotEmpty) ? CustomListView(
          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
          
          children: models
              .map((e) => _fileItem(e, models.indexOf(e)))
              .toList(),
        ) : _buildSkeleton();
      }
    );
  }

  Widget _fileItem(LeadFilesModel model, int index) {
    String? name, date;

    if (model.createdBy != null) {
      name = model.createdBy ?? "";
      date = model.createdAt ?? "";
    }
    return GestureDetector(
      onTap: () {
        widget.bloc.onOpenFile(model.fileName ?? "", model.path);
      },
      child: CustomContainerList(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.minPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          pathToImage(model.path!)!,
                          width: 24,
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Container(
                          child: AutoSizeText(
                            model.fileName!,
                            style: AppTextStyles.style14BlackNormal,
                            minFontSize: 1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Text(
                model.content ?? "",
                style: AppTextStyles.style14BlackWeight600,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: CustomListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      Text(
                        name ?? "",
                        style: AppTextStyles.style14HintNormal,
                      ),
                      Text(
                        parseAndFormatDate(date,
                            format: AppFormat.formatDateTime),
                        style: AppTextStyles.style14HintNormal,
                      ),
                    ],
                  )),
                  SizedBox(
                    width: AppSizes.minPadding,
                  ),
                  CustomIndex(index: index)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: AppLocalizations.text(LangKey.file),
      body: _buildBody(),
      onWillPop: () => CustomNavigator.pop(context, object: false),
    );
  }
}
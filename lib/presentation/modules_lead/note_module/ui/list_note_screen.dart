
import 'package:flutter/cupertino.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/note_file_req_res_model.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/detail_potential_customer/bloc/detail_potential_customer_bloc.dart';
import 'package:lead_plugin_epoint/utils/ultility.dart';
import 'package:lead_plugin_epoint/widget/container_data_builder.dart';
import 'package:lead_plugin_epoint/widget/custom_appbar.dart';
import 'package:lead_plugin_epoint/widget/custom_empty.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_navigation.dart';
import 'package:lead_plugin_epoint/widget/custom_scaffold.dart';
import 'package:lead_plugin_epoint/widget/custom_skeleton.dart';
import 'package:lead_plugin_epoint/widget/widget.dart';

class ListNoteScreen extends StatefulWidget {
  final DetailPotentialCustomerBloc bloc;
  final DetailPotentialData model;

  const ListNoteScreen({super.key, required this.bloc, required this.model});

  @override
  ListNoteScreenState createState() => ListNoteScreenState();
}

class ListNoteScreenState extends State<ListNoteScreen> {
  late List<CustomOptionAppBar> _options;

  @override
  void initState() {
    super.initState();
    _options = [
      CustomOptionAppBar(
          icon: Assets.iconPlus,
          ontap:() {
             widget.bloc.onAddNote(() {
            widget.bloc.getListNote(context);
          });
          })
    ];

    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.bloc.getListNote(context));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.bloc.dispose();
    super.dispose();
  }

  Widget _buildContainer(List<Widget> children) {
    return CustomListView(
      padding: EdgeInsets.all(AppSizes.minPadding),
      separator: SizedBox(height: AppSizes.minPadding),
      children: children,
    );
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

  Widget _buildContent() {
    return StreamBuilder(
        stream: widget.bloc.outputListNote,
        initialData: null,
        builder: (_, snapshot) {
          List<NoteData>? models = snapshot.data as List<NoteData>?;
          return ContainerDataBuilder(
              data: models,
              skeletonBuilder: _buildSkeleton(),
              emptyBuilder: CustomEmpty(
                title: AppLocalizations.text(LangKey.data_empty),
              ),
              bodyBuilder: () => _buildContainer(models!
                  .map((e) => noteItem(
                        e,
                        models.indexOf(e),
                      ))
                  .toList()));
        });
  }

  Widget noteItem(NoteData model, int index) {
    String? name, date;

    if (model.createdByName != null) {
      name = model.createdByName ?? "";
      date = model.createdAt ?? "";
    }
    return CustomContainerList(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.minPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      parseAndFormatDate(date, format: AppFormat.formatDateTime),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      options: _options,
      title: AppLocalizations.text(LangKey.care_list),
      body: _buildContent(),
      onWillPop: () => CustomNavigator.pop(context, object: false),
    );
  }
}

class CustomIndex extends StatelessWidget {
  final int index;
  const CustomIndex({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4.0)
      ),
      padding: EdgeInsets.all(4.0),
      child: Row(
        children: [
          CustomDot(),
          SizedBox(width: 2.0,),
          Text(
            (index + 1).toString(),
            style: AppTextStyles.style12PrimaryBold,
          )
        ],
      ),
    );
  }
}

class CustomDot extends StatelessWidget {

  final double size;
  final Color? color;

  const CustomDot({Key? key, this.size = 6.0, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? AppColors.primaryColor
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/model/request/work_create_comment_request_model.dart';
import 'package:lead_plugin_epoint/model/request/work_list_comment_request_model.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/work_list_comment_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/comment_screen/bloc/comment_bloc.dart';
import 'package:lead_plugin_epoint/utils/custom_image_picker.dart';
import 'package:lead_plugin_epoint/widget/container_data_builder.dart';
import 'package:lead_plugin_epoint/widget/custom_avatar_with_url.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';
import 'package:lead_plugin_epoint/widget/custom_empty.dart';
import 'package:lead_plugin_epoint/widget/custom_file_view.dart';
import 'package:lead_plugin_epoint/widget/custom_html.dart';
import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_shimer.dart';
import 'package:lead_plugin_epoint/widget/custom_skeleton.dart';
import 'package:lead_plugin_epoint/widget/custom_textfield.dart';

class ChatScreen extends StatefulWidget {
  final DetailPotentialData? detail;
  const ChatScreen({super.key, required this.detail});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late CommentBloc _bloc;
  // DetailPotentialData? detail;
  WorkListCommentModel? _callbackModel;
  FocusNode _focusComment = FocusNode();
  TextEditingController _controllerComment = TextEditingController();
  final double _fileSize = AppSizes.maxWidth! * 0.2;
  String? _file;
  final double _imageRadius = 20.0;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _bloc = CommentBloc(context);
    _bloc.workListComment(
        WorkListCommentRequestModel(customerLeadID: widget.detail!.customerLeadId));
  }

  _send() {
    if (_controllerComment.text.isEmpty && _file == null) {
      return;
    }
    _bloc.workCreatedComment(
        WorkCreateCommentRequestModel(
            customerLeadId: widget.detail!.customerLeadId,
            customerLeadParentCommentId:
                (_callbackModel?.customerLeadParentCommentId) ??
                    (_callbackModel?.customerLeadCommentId),
            message: _controllerComment.text,
            path: _file),
        _controllerComment,
        (val) {});
  }

  Future _onRefresh() {
    return _bloc.workListComment(
        WorkListCommentRequestModel(customerLeadID: widget.detail!.customerLeadId));
  }

  _showOption() {
    CustomImagePicker.showPicker(context, (file) {
      _bloc.workUploadFile(file);
    });
  }

  openFile(BuildContext context, String? name, String? path) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => CustomFileView(path, name)));
  }

  Widget _buildComment(WorkListCommentModel? model) {
    if (model == null) {
      return CustomShimmer(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSkeleton(
              width: AppSizes.sizeOnTap,
              height: AppSizes.sizeOnTap,
              radius: AppSizes.sizeOnTap,
            ),
            Container(
              width: AppSizes.minPadding,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5.0,
                ),
                CustomSkeleton(
                  width: AppSizes.maxWidth! / 3,
                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: CustomSkeleton(),
                ),
              ],
            ))
          ],
        ),
      );
    }

    double? avatarSize =
        model.isSubComment ? AppSizes.sizeOnTap! / 2 : AppSizes.sizeOnTap;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomAvatar(
          size: avatarSize,
          url: model.staffAvatar,
          name: model.staffName,
        ),
        Container(
          width: AppSizes.minPadding,
        ),
        Expanded(
            child: CustomListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          separatorPadding: 5.0,
          children: [
            Container(),
            Text(
              model.staffName ?? "",
              style: AppTextStyles.style12BlackBold,
            ),
            if ((model.message ?? "").isNotEmpty)
              CustomHtml(
                model.message,
                physics: NeverScrollableScrollPhysics(),
              ),
            if ((model.path ?? "").isNotEmpty)
              Container(
                constraints:
                    BoxConstraints(maxHeight: AppSizes.maxHeight * 0.2),
                child: Row(
                  children: [
                    Flexible(
                        child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderColor),
                          borderRadius: BorderRadius.circular(_imageRadius)),
                      child: InkWell(
                        child: CustomNetworkImage(
                            url: model.path,
                            fit: BoxFit.contain,
                            radius: _imageRadius),
                        onTap: () => openFile(context,
                            AppLocalizations.text(LangKey.image), model.path),
                      ),
                    ))
                  ],
                ),
              ),
            Row(
              children: [
                Text(
                  model.timeText ?? "",
                  style: AppTextStyles.style12grey500Normal,
                ),
                Container(
                  width: AppSizes.maxPadding,
                ),
                InkWell(
                  child: Text(
                    AppLocalizations.text(LangKey.callback)!,
                    style: AppTextStyles.style12grey500Bold,
                  ),
                  onTap: () => _bloc.setCallback(model),
                )
              ],
            ),
            if ((model.listObject?.length ?? 0) != 0)
              CustomListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                separatorPadding: 5.0,
                children:
                    model.listObject!.map((e) => _buildComment(e)).toList(),
              )
          ],
        ))
      ],
    );
  }

  Widget _buildContainer(List<WorkListCommentModel>? models) {
    return Container(
      child: CustomListView(
        padding: EdgeInsets.symmetric(
            vertical: AppSizes.minPadding!, horizontal: AppSizes.maxPadding!),
        children: models == null
            ? List.generate(4, (index) => _buildComment(null))
            : models.map((e) => _buildComment(e)).toList(),
      ),
    );
  }

  Widget _buildEmpty() {
    return CustomEmpty(
      title: AppLocalizations.text(LangKey.comment_empty),
    );
  }

  Widget _buildComments() {
    return StreamBuilder(
        stream: _bloc.outputModels,
        initialData: null,
        builder: (_, snapshot) {
          List<WorkListCommentModel>? models =
              snapshot.data as List<WorkListCommentModel>?;
          return ContainerDataBuilder(
            data: models,
            emptyBuilder: _buildEmpty(),
            skeletonBuilder: _buildContainer(null),
            bodyBuilder: () => _buildContainer(models),
            onRefresh: () => _onRefresh(),
          );
        });
  }

  Widget _buildChatBox() {
    return Container(
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: Colors.grey))),
      padding:
          EdgeInsets.symmetric(horizontal: AppSizes.maxPadding, vertical: 5.0),
      child: Column(
        children: [
          StreamBuilder(
              stream: _bloc.outputCallback,
              initialData: null,
              builder: (_, snapshot) {
                _callbackModel = snapshot.data as WorkListCommentModel?;
                if (_callbackModel == null) {
                  return Container();
                }
                return Container(
                  padding: EdgeInsets.only(bottom: AppSizes.minPadding!),
                  child: InkWell(
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                              text: AppLocalizations.text(LangKey.answering)! +
                                  " ",
                              style: AppTextStyles.style12grey200Normal,
                              children: [
                                TextSpan(
                                    text: _callbackModel!.staffName ?? "",
                                    style: AppTextStyles.style12BlackBold)
                              ]),
                        ),
                        Container(
                          width: AppSizes.minPadding,
                        ),
                        Icon(
                          Icons.close,
                          color: AppColors.grey200Color,
                          size: 12.0,
                        )
                      ],
                    ),
                    onTap: () => _bloc.setCallback(null),
                  ),
                );
              }),
          StreamBuilder(
              stream: _bloc.outputFile,
              initialData: null,
              builder: (_, snapshot) {
                _file = snapshot.data as String?;

                if (_file == null) {
                  return Container();
                }

                return Container(
                  padding: EdgeInsets.only(bottom: AppSizes.minPadding!),
                  child: Row(
                    children: [
                      InkWell(
                        child: CustomNetworkImage(
                          radius: 10.0,
                          width: _fileSize,
                          url: _file,
                        ),
                        onTap: () => openFile(context,
                            AppLocalizations.text(LangKey.image), _file),
                      ),
                      Container(
                        width: AppSizes.minPadding,
                      ),
                      CustomButton(
                        text: AppLocalizations.text(LangKey.delete),
                        backgroundColor: Colors.transparent,
                        borderColor: AppColors.primaryColor,
                        style: AppTextStyles.style14PrimaryBold,
                        isExpand: false,
                        ontap: () => _bloc.setFile(null),
                      )
                    ],
                  ),
                );
              }),
          Row(
            children: [
              InkWell(
                child: CustomImageIcon(
                  icon: Assets.iconCamera,
                  color: AppColors.primaryColor,
                  size: 30.0,
                ),
                onTap: _showOption,
              ),
              Container(
                width: AppSizes.minPadding,
              ),
              Expanded(
                  child: CustomTextField(
                focusNode: _focusComment,
                controller: _controllerComment,
                backgroundColor: Colors.transparent,
                borderColor: AppColors.borderColor,
                hintText: AppLocalizations.text(LangKey.enter_comment),
              )),
              Container(
                width: AppSizes.minPadding,
              ),
              InkWell(
                child: Icon(
                  Icons.send,
                  color: AppColors.primaryColor,
                  size: 30.0,
                ),
                onTap: _send,
              ),
            ],
          ),
          Container(
            height: 10.0,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          // actionsIconTheme: Navigator.of(context).pop(true),
          backgroundColor: AppColors.primaryColor,
          title: Text(
            AppLocalizations.text(LangKey.discuss)!,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      body: Column(
        children: [
          Expanded(
            child: Container(
                width: AppSizes.maxWidth,
                child: _buildComments()),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: _buildChatBox(),
          )
        ],
      ),
    );
  }
}

import 'package:draggable_expandable_fab/draggable_expandable_fab.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lead_plugin_epoint/common/assets.dart';
import 'package:lead_plugin_epoint/common/lang_key.dart';
import 'package:lead_plugin_epoint/common/localization/app_localizations.dart';
import 'package:lead_plugin_epoint/common/theme.dart';
import 'package:lead_plugin_epoint/connection/http_connection.dart';
import 'package:lead_plugin_epoint/connection/lead_connection.dart';
import 'package:lead_plugin_epoint/model/request/work_create_comment_request_model.dart';
import 'package:lead_plugin_epoint/model/request/work_list_comment_request_model.dart';
import 'package:lead_plugin_epoint/model/response/contact_list_model_response.dart';
import 'package:lead_plugin_epoint/model/response/description_model_response.dart';
import 'package:lead_plugin_epoint/model/response/detail_potential_model_response.dart';
import 'package:lead_plugin_epoint/model/response/get_list_staff_responese_model.dart';
import 'package:lead_plugin_epoint/model/response/work_list_comment_model_response.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/comment_screen/bloc/comment_bloc.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/comment_screen/ui/comment_screen.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/customer_care_potential/customer_care_potential.dart';
import 'package:lead_plugin_epoint/presentation/modules_lead/edit_potential_customer/edit_potential_customer.dart';
import 'package:lead_plugin_epoint/utils/custom_image_picker.dart';
import 'package:lead_plugin_epoint/utils/global.dart';
import 'package:lead_plugin_epoint/widget/container_data_builder.dart';

import 'package:lead_plugin_epoint/widget/custom_avatar_with_url.dart';
import 'package:lead_plugin_epoint/widget/custom_button.dart';
import 'package:lead_plugin_epoint/widget/custom_data_not_found.dart';
import 'package:lead_plugin_epoint/widget/custom_empty.dart';
import 'package:lead_plugin_epoint/widget/custom_file_view.dart';
import 'package:lead_plugin_epoint/widget/custom_html.dart';
import 'package:lead_plugin_epoint/widget/custom_image_icon.dart';
import 'package:lead_plugin_epoint/widget/custom_listview.dart';
import 'package:lead_plugin_epoint/widget/custom_shimer.dart';
import 'package:lead_plugin_epoint/widget/custom_skeleton.dart';
import 'package:lead_plugin_epoint/widget/custom_textfield.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPotentialCustomer extends StatefulWidget {
  final String customer_lead_code;
  final int indexTab;
  bool customerCare;
  int id;
  Function(int) onCallback;
  DetailPotentialCustomer(
      {Key key, this.customer_lead_code, this.indexTab, this.customerCare, this.id, this.onCallback})
      : super(key: key);

  @override
  _DetailPotentialCustomerState createState() =>
      _DetailPotentialCustomerState();
}

class _DetailPotentialCustomerState extends State<DetailPotentialCustomer> {
  final ScrollController _controller = ScrollController();
  List<WorkListStaffModel> models = [];
  List<ContactListData> contactListData;
  DetailPotentialData detail;
  WorkListCommentModel _callbackModel;

   List<DetailPotentialTabModel> tabPotentials = [
    DetailPotentialTabModel(
        typeName: AppLocalizations.text(LangKey.generalInfomation),
        typeID: 0,
        selected: true),
    DetailPotentialTabModel(
        typeName: AppLocalizations.text(LangKey.deal),
        typeID: 1,
        selected: false),
    DetailPotentialTabModel(
        typeName: AppLocalizations.text(LangKey.customerCare),
        typeID: 2,
        selected: false),
    DetailPotentialTabModel(
        typeName: AppLocalizations.text(LangKey.discuss),
        typeID: 3,
        selected: false),
    DetailPotentialTabModel(
        typeName: AppLocalizations.text(LangKey.contactPerson),
        typeID: 4,
        selected: false)
  ];


  FocusNode _focusComment = FocusNode();
  TextEditingController _controllerComment = TextEditingController();

  final double _fileSize = AppSizes.maxWidth * 0.2;
  final double _imageRadius = 20.0;

  String _file;
  int index = 0;
  bool allowPop = false;
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',
    decimalDigits: 0,
    symbol: '',
  );

  CommentBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = CommentBloc(context);

    index = widget.indexTab;
    for (int i = 0; i < tabPotentials.length; i++) {
      if (index == tabPotentials[i].typeID) {
        tabPotentials[i].selected = true;
      } else {
        tabPotentials[i].selected = false;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getData();
    });
  }
    @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }


  _send(){
    if(_controllerComment.text.isEmpty && _file == null){
      return;
    }
    _bloc.workCreatedComment(WorkCreateCommentRequestModel(
      customerLeadId: detail.customerLeadId,
      customerLeadParentCommentId: (_callbackModel?.customerLeadParentCommentId) ?? (_callbackModel?.customerLeadCommentId),
      message: _controllerComment.text,
      path: _file
    ), _controllerComment, widget.onCallback);
  }

    Future _onRefresh(){
    return _bloc.workListComment(WorkListCommentRequestModel(
      customerLeadID: detail.customerLeadId
    ));
  }

    _showOption(){
    CustomImagePicker.showPicker(context, (file) {
      _bloc.workUploadFile(MultipartFileModel(
          name: "link",
          file: file
      ));
    });
  }

    openFile(BuildContext context, String name, String path){
    Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => CustomFileView(path, name)));
  // CustomNavigator.push(context, CustomFileView(path, name));
}

  

  void getData() async {
    var dataDetail = await LeadConnection.getdetailPotential(
        context, widget.customer_lead_code);
    // var dataDetail = await LeadConnection.getdetailPotential( context, "LEAD_08112022190");
    if (dataDetail != null) {
      if (dataDetail.errorCode == 0) {
        detail = dataDetail.data;
        setState(() {});
      } else {
        await LeadConnection.showMyDialog(context, dataDetail.errorDescription);
        Navigator.of(context).pop();
      }
    }

    var contactList =
        await LeadConnection.getContactList(context, widget.customer_lead_code);
    // var dataDetail = await LeadConnection.getdetailPotential( context, "LEAD_08112022190");
    if (contactList != null) {
      if (contactList.errorCode == 0) {
        contactListData = contactList.data;
        setState(() {});
      }
    }

    _bloc.workListComment(WorkListCommentRequestModel(
      customerLeadID: detail.customerLeadId
    ));
  }

  Future<bool> _openLink(String link) async {
    return await launch(link);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.customerCare != null) {
          Navigator.of(context)
            // ..pop()
            ..pop(true);
        }

        if (allowPop) {
          Navigator.of(context).pop(allowPop);
        } else {
          Navigator.of(context).pop();
        }
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          // actionsIconTheme: Navigator.of(context).pop(true),
          backgroundColor: AppColors.primaryColor,
          title: Text(
            AppLocalizations.text(LangKey.detailPotential),
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
            decoration: BoxDecoration(color: AppColors.white),
            child: buildBody()),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        floatingActionButton: ExpandableDraggableFab(
          initialDraggableOffset:
              Offset(12, MediaQuery.of(context).size.height * 11 / 14),
          initialOpen: false,
          curveAnimation: Curves.easeOutSine,
          childrenBoxDecoration: BoxDecoration(
              color: Colors.black.withOpacity(0.45),
              borderRadius: BorderRadius.circular(10.0)),
          childrenCount:3,
          distance: 10,
          childrenType: ChildrenType.columnChildren,
          childrenAlignment: Alignment.centerRight,
          childrenInnerMargin: EdgeInsets.all(20.0),
          openWidget: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black.withOpacity(0.3),
                    )
                  ],
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 105, 136, 156)),
              width: 60,
              height: 60,
              child: Image.asset(
                Assets.iconFABMenu,
                scale: 2.5,
              )),
          closeWidget: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.3),
                )
              ], shape: BoxShape.circle, color: Color(0xFF5F5F5F)),
              width: 60,
              height: 60,
              child: Icon(
                Icons.clear,
                size: 35,
                color: Colors.white,
              )),
          children: [
                        // }),
            Column(
              children: [
                FloatingActionButton(
                    backgroundColor: Color(0xFF41AC8D),
                    heroTag: "btn1",
                    onPressed: () async {
                                            bool result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerCarePotential(detail: detail)));

                          if (result != null && result) {
                            getData();
                            selectedTab(2);
                          }
                    },
                    child: Image.asset(
                      Assets.iconCustomerCare,
                      scale: 2.5,
                    )),
                SizedBox(
                  height: 5.0,
                ),
                Text(AppLocalizations.text(LangKey.createJobs),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400))
              ],
            ),
            // Column(
            //   children: [
            //     FloatingActionButton(
            //         backgroundColor: Color(0xFFCD6000),
            //         heroTag: "btn2",
            //         onPressed: () async {
            //           if (Global.createJob != null) {
            //             await Global.createJob();
            //           }
            //           print("iconTask");
            //         },
            //         child: Image.asset(
            //           Assets.iconTask,
            //           scale: 2.5,
            //         )),
            //     SizedBox(
            //       height: 5.0,
            //     ),
            //     Text(AppLocalizations.text(LangKey.createJobs),
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 14.0,
            //             fontWeight: FontWeight.w400))
            //   ],
            // ),
            Column(
              children: [
                FloatingActionButton(
                    backgroundColor: Color(0xFFDD2C00),
                    heroTag: "btn3",
                    onPressed: () async {
                      LeadConnection.showMyDialogWithFunction(context,
                          AppLocalizations.text(LangKey.warningDeleteLead),
                          ontap: () async {
                        DescriptionModelResponse result =
                            await LeadConnection.deleteLead(
                                context, detail.customerLeadCode);

                        Navigator.of(context).pop();

                        if (result != null) {
                          if (result.errorCode == 0) {
                            allowPop = true;
                            print(result.errorDescription);

                            await LeadConnection.showMyDialog(
                                context, result.errorDescription);

                            Navigator.of(context).pop(true);
                          } else {
                            LeadConnection.showMyDialog(
                                context, result.errorDescription);
                          }
                        }
                      });
                      print("iconDelete");
                    },
                    child: Image.asset(
                      Assets.iconDelete,
                      scale: 2.5,
                    )),
                SizedBox(
                  height: 5.0,
                ),
                Text(AppLocalizations.text(LangKey.delete),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400))
              ],
            ),
            Column(
              children: [
                FloatingActionButton(
                  heroTag: "btn4",
                  onPressed: () async {
                    bool result =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditPotentialCustomer(
                                  detailPotential: detail,
                                )));

                    if (result != null) {
                      if (result) {
                        allowPop = true;
                        getData();
                        ;
                      }
                    }

                    print("iconEdit");
                  },
                  backgroundColor: Color(0xFF00BE85),
                  child: Image.asset(
                    Assets.iconEdit,
                    scale: 2.5,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(AppLocalizations.text(LangKey.edit),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return (detail == null)
        ? Container()
        : Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      child: ListView(
                    padding: EdgeInsets.zero,
                    physics: (index == 3) ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                    controller: _controller,
                    children: buildInfomation(),
                  )),
                  Container(
                    height: 20.0,
                  )
                ],
              ),

              (index == 3) ?  Positioned(
                  bottom: 0,
                  // left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white
                    ),
                    width: AppSizes.maxWidth,
                    child: _buildChatBox())) : Container()
              // Positioned(
              //     bottom: 30,
              //     left: 10,
              //     child: Column(
              //       children: [
              //         buildButtonConvert(
              //             AppLocalizations.text(LangKey.convertCustomers), () {
              //           print("chuyen doi khach hang");
              //         }),
              //         buildButtonConvert(
              //             AppLocalizations.text(
              //                 LangKey.convertCustomersWithDeal), () {
              //           print("chuyen doi khach hang co tao deal");
              //         }),
              //       ],
              //     ))
            ],
          );
  }

  List<Widget> buildInfomation() {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.all(11.0),
              margin: EdgeInsets.only(top: 70),
              child: potentialInformationV2()),


          SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: buildListOption(),
        ),

         Container(
          height: 15,
        ),
        (index == 0)
            ? generalInfomationV2()
            : (index == 1)
                ? Center(child: dealInfomationV2())
                : (index == 2)
                    ? customerCare()
                    : (index == 3)
                        ? Column(
                          children: [
                            Container(
                              width: AppSizes.maxWidth,
                              height: AppSizes.maxHeight - 310,
                              child: _buildComments()),

                              // Container(height: 80,)
                          ],
                        )
                        : contactList(),

        // (index == 3) ? 
        // _buildChatBox() : Container(),

        ],
      )
    ];
  }

   Widget buildListOption() {
    return Row(
      children: [
        option(tabPotentials[0].typeName, tabPotentials[0].selected, 100, () {
          index = 0;
          selectedTab(0);
        }),
        option(tabPotentials[1].typeName, tabPotentials[1].selected, 100, () {
          index = 1;
          selectedTab(1);
        }),
        option(tabPotentials[2].typeName, tabPotentials[2].selected, 150, () {
          index = 2;
          selectedTab(2);
        }),
        option(tabPotentials[3].typeName, tabPotentials[3].selected, 60, () {
          index = 3;
          selectedTab(3);
        }),
        option(tabPotentials[4].typeName, tabPotentials[4].selected, 100, () {
          index = 4;
          selectedTab(4);
        })
      ],
    );
  }

    Widget option(String title, bool show, double width, Function ontap) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15.0 / 1.5),
          height: 40,
          child: InkWell(
            onTap: ontap,
            child: Center(
              child: Text(
                title,
                style: show
                    ? TextStyle(
                        fontSize: AppTextSizes.size16,
                        color: AppColors.blueColor,
                        fontWeight: FontWeight.bold)
                    : TextStyle(
                        fontSize: AppTextSizes.size16,
                        color: AppColors.colorTabUnselected,
                        fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
          ),
        ),
        show
            ? Container(
                decoration: const BoxDecoration(color: AppColors.blueColor),
                width: width,
                height: 3.0,
              )
            : Container()
      ],
    );
  }

  selectedTab(int index) async {
    List<DetailPotentialTabModel> models = tabPotentials;
    for (int i = 0; i < models.length; i++) {
      models[i].selected = false;
    }
    models[index].selected = true;

    setState(() {});
  }

    Widget _buildComment(WorkListCommentModel model){

    if(model == null){
      return CustomShimmer(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSkeleton(
              width: AppSizes.sizeOnTap,
              height: AppSizes.sizeOnTap,
              radius: AppSizes.sizeOnTap,
            ),
            Container(width: AppSizes.minPadding,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 5.0,),
                CustomSkeleton(width: AppSizes.maxWidth / 3,),
                Container(
                  padding:  EdgeInsets.only(top: 5.0),
                  child: CustomSkeleton(),
                ),
              ],
            ))
          ],
        ),
      );
    }

    double avatarSize = model.isSubComment?AppSizes.sizeOnTap / 2:AppSizes.sizeOnTap;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomAvatar(
          size: avatarSize,
          url: model.staffAvatar,
          name: model.staffName,
        ),
        Container(width: AppSizes.minPadding,),
        Expanded(child: CustomListView(
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
            if((model.message ?? "").isNotEmpty)
              CustomHtml(
                model.message,
                physics: NeverScrollableScrollPhysics(),
              ),
            if((model.path ?? "").isNotEmpty)
              Container(
                constraints: BoxConstraints(
                  maxHeight: AppSizes.maxHeight * 0.2
                ),
                child: Row(
                  children: [
                    Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.borderColor),
                              borderRadius: BorderRadius.circular(_imageRadius)
                          ),
                          child: InkWell(
                            child: CustomNetworkImage(
                                url: model.path,
                                fit: BoxFit.contain,
                                radius: _imageRadius
                            ),
                            onTap: () => openFile(context, AppLocalizations.text(LangKey.image), model.path),
                          ),
                        )
                    )
                  ],
                ),
              ),
            Row(
              children: [
                Text(
                  model.timeText ?? "",
                  style: AppTextStyles.style12grey500Normal,
                ),
                Container(width: AppSizes.maxPadding,),
                InkWell(
                  child: Text(
                    AppLocalizations.text(LangKey.callback),
                    style: AppTextStyles.style12grey500Bold,
                  ),
                  onTap: () => _bloc.setCallback(model),
                )
              ],
            ),
            if((model.listObject?.length ?? 0) != 0)
              CustomListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                separatorPadding: 5.0,
                children: model.listObject.map((e) => _buildComment(e)).toList(),
              )
          ],
        ))
      ],
    );
  }

  Widget _buildContainer(List<WorkListCommentModel> models){
    // print(MediaQuery.of(context).padding.bottom);
    return Container(
      padding: EdgeInsets.only(bottom: 60),
      // margin: EdgeInsets.only(bottom: 100),
      child: CustomListView(
        // physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
            vertical: AppSizes.minPadding,
            horizontal: AppSizes.maxPadding
        ),
        children: models == null
            ? List.generate(4, (index) => _buildComment(null))
            : models.map((e) => _buildComment(e)).toList(),
      ),
    );
  }

  Widget _buildEmpty(){
    return CustomEmpty(
      title: AppLocalizations.text(LangKey.comment_empty),
    );
  }

  Widget _buildComments(){
    return StreamBuilder(
      stream: _bloc.outputModels,
      initialData: null,
      builder: (_, snapshot){
        List<WorkListCommentModel> models = snapshot.data;
        return ContainerDataBuilder(
          data: models,
          emptyBuilder: _buildEmpty(),
          skeletonBuilder: _buildContainer(null),
          bodyBuilder: () => _buildContainer(models),
          onRefresh: () => _onRefresh(),
        );
      }
    );
  }

  Widget _buildChatBox(){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey)
        )
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.maxPadding,
        vertical: 5.0
      ),
      child: Column(
        children: [
          StreamBuilder(
            stream: _bloc.outputCallback,
            initialData: null,
            builder: (_, snapshot){
              _callbackModel = snapshot.data;
              if(_callbackModel == null){
                return Container();
              }
              return Container(
                padding: EdgeInsets.only(bottom: AppSizes.minPadding),
                child: InkWell(
                  child: Row(
                    children: [
                      Flexible(child: RichText(
                        text: TextSpan(
                            text: AppLocalizations.text(LangKey.answering) + " ",
                            style: AppTextStyles.style12grey200Normal,
                            children: [
                              TextSpan(
                                  text: _callbackModel.staffName ?? "",
                                  style: AppTextStyles.style12BlackBold
                              )
                            ]
                        ),
                      )),
                      Container(width: AppSizes.minPadding,),
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
            }
          ),
          StreamBuilder(
            stream: _bloc.outputFile,
            initialData: null,
            builder: (_, snapshot){
              _file = snapshot.data;

              if(_file == null){
                return Container();
              }

              return Container(
                padding: EdgeInsets.only(bottom: AppSizes.minPadding),
                child: Row(
                  children: [
                    InkWell(
                      child: CustomNetworkImage(
                        radius: 10.0,
                        width: _fileSize,
                        url: _file,
                      ),
                      onTap: () => openFile(context, AppLocalizations.text(LangKey.image), _file),
                    ),
                    Container(width: AppSizes.minPadding,),
                    CustomButton(
                      text: AppLocalizations.text(LangKey.delete),
                      backgroundColor: Colors.transparent,
                      borderColor: AppColors.primaryColor,
                      style: AppTextStyles.style14PrimaryBold,
                      isExpand: false,
                      onTap: () => _bloc.setFile(null),
                    )
                  ],
                ),
              );
            }
          ),
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
              Container(width: AppSizes.minPadding,),
              Expanded(child: CustomTextField(
                focusNode: _focusComment,
                controller: _controllerComment,
                backgroundColor: Colors.transparent,
                borderColor: AppColors.borderColor,
                hintText: AppLocalizations.text(LangKey.enter_comment),
              )),
              Container(width: AppSizes.minPadding,),
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
          Container(height: 15.0,)
        ],
      ),
    );
  }

   Widget generalInfomationV2() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: EdgeInsets.only(left: 11, right: 11, bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Color(0xFFC3C8D3))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _infoItemV2(
                    Assets.iconSex,
                    (detail.gender == "male")
                        ? AppLocalizations.text(LangKey.male)
                        : (detail.gender == "female")
                            ? AppLocalizations.text(LangKey.female)
                            : (detail.gender == "other" ||
                                    detail.gender == "other")
                                ? AppLocalizations.text(LangKey.other)
                                : "N/A"),
                SizedBox(height: 5.0),
                _infoItemV2(Assets.iconEmail, detail.email ?? "N/A"),
                SizedBox(height: 5.0),
                _infoItemV2(Assets.iconAddress, detail.address ?? "N/A"),
                SizedBox(height: 5.0),
                _infoItemV2(
                    Assets.iconWards, detail.businessClueName ?? "N/A")
              ],
            ),
          ),
          Column(
            children: [
              (detail.fanpage != null && detail.fanpage != "")
                  ? InkWell(
                      onTap: () async {
                        _openLink(detail.zalo);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                        height: 45.0,
                        width: 45.0,
                        child: Image.asset(Assets.iconMessenger),
                      ),
                    )
                  : Container(),
               (detail.zalo != null && detail.zalo != "")
                  ? InkWell(
                      onTap: () {
                         _openLink(detail.fanpage);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                        height: 57.0,
                        width: 57.0,
                        child: Image.asset(Assets.iconZalo),
                      ),
                    )
                  : Container()
            ],
          )
        ],
      ),
    );
  }

   Widget _infoItemV2(String icon, String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8.0),
      margin: EdgeInsets.only(left: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            height: 15.0,
            width: 15.0,
            child: Image.asset(icon),
          ),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal),
              // maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }


  Widget potentialInformationV2() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          // margin: EdgeInsets.only(bottom: 32.0),
          // padding: EdgeInsets.only(bot),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: (index != 3) ?  Border.all(width: 1, color: Color(0xFFC3C8D3)) : null
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.only(right: 8.0, top: 8.0),
                    margin: EdgeInsets.only(top: 25.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 4.0,
                        ),
                       (index != 3) ?  Column(
                          children: [
                            RichText(
                            text: TextSpan(
                                text: detail.customerSourceName ?? "",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                                children: [
                              TextSpan(
                                  text: (detail.customerSourceName != "" &&
                                          detail.customerSourceName != null)
                                      ? (" - " + detail?.fullName ?? "")
                                      : ("" + detail?.fullName ?? ""),
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))
                            ])),
                        SizedBox(height: 5),

                         Container(
                                margin: EdgeInsets.only(left: 8.0,top: 5.0,bottom: 5.0),
                                decoration: BoxDecoration(
                                    color: Color(0xFF3AEDB6),
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(detail?.journeyName ?? "",
                                    textAlign: TextAlign.center,
                                        style: TextStyle(
                                          
                                            color: Color(0xFF11B482),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal)),
                                  ),
                                ),
                              ),

                        Text(detail?.phone ?? "",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.normal)),
                        SizedBox(height: 5),
                        (detail.customerType == "business")
                            ? Text(
                                detail.fullName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    overflow: TextOverflow.visible,
                                    fontSize: 16.0,
                                    color: Color(0xFF8E8E8E),
                                    fontWeight: FontWeight.normal),
                              )
                            : Container()
                          ],
                        ) : Container()
                      ],
                    ),
                  ),
                ),
               (index != 3) ?  Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    Container(
                  padding: EdgeInsets.only(right: 8.0),
                  margin: EdgeInsets.only(right: 8.0, top: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          // width: MediaQuery.of(context).size.width / 2 - 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // infoItem(Assets.iconName, item?.staffFullName ?? "", true),
                              // infoItem(Assets.iconInteraction, item?.journeyName ?? "", true),

                              infoItem(Assets.iconName, detail.saleName ?? ""),
                              infoItem(Assets.iconInteraction, "${detail.dateLastCare ?? ""} (${detail.diffDay ?? ""} ng??y)"),

                                  Container(
                                    margin: EdgeInsets.only(left: 33),
                                    child: Text(detail?.pipelineName ?? "",
                                      textAlign: TextAlign.center,
                                          style: TextStyle(
                                            
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal)),
                                  ),

                              // Container(
                              //   margin: EdgeInsets.only(left: 8.0),
                              //   decoration: BoxDecoration(
                              //       color: Color(0xFF3AEDB6),
                              //       borderRadius: BorderRadius.circular(4.0)),
                              //   child: Flexible(
                              //     child: Padding(
                              //       padding: EdgeInsets.all(8.0),
                              //       child: Text(detail?.journeyName ?? "",
                              //       textAlign: TextAlign.center,
                              //           style: TextStyle(
                                          
                              //               color: Color(0xFF11B482),
                              //               fontSize: 14,
                              //               fontWeight: FontWeight.normal)),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              print(detail.phone);
                              await callPhone(detail?.phone ?? "");
                            },
                            child: Container(
                              padding: EdgeInsets.all(20.0 / 2),
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: Color(0xFF06A605),
                                borderRadius: BorderRadius.circular(50),
                                // border:  Border.all(color: AppColors.white,)
                              ),
                              child: Center(
                                  child: Image.asset(
                                Assets.iconCall,
                                color: AppColors.white,
                              )),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _actionItem(
                                  Assets.iconCalendar, Color(0xFF26A7AD),
                                  show: true,
                                  number: detail.relatedWork ?? 0, ontap: () {
                                print("1");
                              }),
                              _actionItem(Assets.iconOutdate, Color(0xFFDD2C00),
                                  show: true,
                                  number: detail.appointment ?? 0, ontap: () {
                                print("2");
                              }),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ) ,
                SizedBox(height: 14.0),
                (detail.tag != null && detail.tag.length > 0)
                    ? Container(
                        padding: EdgeInsets.only(bottom: 8.0),
                        margin: EdgeInsets.only(left: 8.0),
                        child: Wrap(
                          children: List.generate(detail.tag.length,
                              (index) => _optionItem(detail.tag[index])),
                          spacing: 10,
                          runSpacing: 10,
                        ),
                      )
                    : Container(),
                 ],
               ) : Container()
              ],
            ),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 60.5,
          top: -60,
          child: _buildAvatar(detail?.fullName ?? ""),
        ),
      ],
    );
  }

   Widget dealInfomationV2() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child:
          (detail.infoDeal != null && detail.infoDeal.length > 0)
              ? Column(
                  children: detail.infoDeal
                      .map((e) => dealInfomationItem(e))
                      .toList())
              : CustomDataNotFound(),
    );
  }

    Widget dealInfomationItem(InfoDeal item) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      margin: EdgeInsets.only(left: 11, right: 11, bottom: 8.0),
      decoration: BoxDecoration(
          // color: Color.fromARGB(255, 37, 16, 16),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Color(0xFFC3C8D3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 5.0, right: 5.0, bottom: 5.0),
            margin: EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  height: 20.0,
                  width: 20.0,
                  child: Image.asset(Assets.iconDeal),
                ),
                Expanded(
                  child: Text(
                    item.dealName,
                    // "Deal cua Kiet Quach",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500),
                    // maxLines: 1,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 4.0, right: 4.0),
                  height: 24,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text(item.journeyName ?? "N/A",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600)),
                  ),
                )
              ],
            ),
          ),
          _infoItemV2(
            Assets.iconTime,
            item.createdAt,
          ),
          _infoItemV2(Assets.iconName, item.staffName ?? ""),
          _infoItemV2(Assets.iconInteraction, item.dateLastCare ?? ""),
          Container(
            padding: const EdgeInsets.only(left: 6.0, bottom: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  height: 15.0,
                  width: 15.0,
                  child: Image.asset(Assets.iconTag),
                ),
                Expanded(
                  child: Text(
                    "${NumberFormat("#,###", "vi-VN").format(item.amount)} VN??",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                    // maxLines: 1,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget infoItem(String icon, String title) {
    return Container(
      padding: const EdgeInsets.only(left: 8, bottom: 8.0),
      margin: EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            height: 15.0,
            width: 15.0,
            child: Image.asset(icon),
          ),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal),
              // maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  

  Widget _actionItem(String icon, Color color,
      {num number, bool show = false, Function ontap}) {
    return InkWell(
      onTap: ontap,
      child: Container(
          margin: EdgeInsets.only(left: 17),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(1000.0)),
                child: Center(
                  child: Image.asset(
                    icon,
                    scale: 2.5,
                  ),
                ),
              ),
              show
                  ? Positioned(
                      left: 30,
                      bottom: 30,
                      child: Container(
                        width: (number > 99)
                            ? 30
                            : (number > 9)
                                ? 25
                                : 22,
                        height: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFFF45E38)),
                        child: Center(
                            child: Text("${number ?? 0}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600))),
                      ))
                  : Container()
            ],
          )),
    );
  }

  Widget _optionItem(Tag item) {
    return Container(
      padding: EdgeInsets.only(left: 4.0, right: 4.0),
      height: 24,
      decoration: BoxDecoration(
          color: Color(0x420067AC), borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              height: 8.0,
              width: 8.0,
              margin: EdgeInsets.only(right: 5.0),
              decoration: BoxDecoration(
                  color: Color(0x790067AC),
                  borderRadius: BorderRadius.circular(1000.0))),
          Text(item.tagName,
              style: TextStyle(
                  color: Color(0xFF0067AC),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600))
        ],
      ),
    );
  }

  Widget customerCare() {
    // return Container(
    //   margin: EdgeInsets.only(bottom: 120.0),
    //   child: Column(
    //     children: [customerCareItem(), customerCareItem(), customerCareItem()],
    //   ),
    // );

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: (detail.customerCare != null && detail.customerCare.length > 0 )
                        ? Column(
                            children:
                                detail.customerCare.map((e) => customerCareItem(e)).toList())
                        : Center(child: CustomDataNotFound()),
    );

    // return Column(
    //   children: [
    //     customerCareItem(),
    //     customerCareItem(),
    //     customerCareItem(),
    //     Container(
    //       height: 20.0,
    //     )
    //   ],
    // );
  }

   Widget customerCareItem(CustomerCare item) {

         final createTime = DateTime.parse(item.createdAt ?? "");

    print(createTime.year);
    print(createTime.month);
    print(createTime.day);
    print(createTime.hour);
    print(createTime.minute);

    return InkWell(
      onTap: () async {

        var result = await Global.editJob(item.manageWorkId);
          if (result != null && result) {
            await getData();
            selectedTab(2);
          } 
      },
      child: Container(
        child: Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          // height: 300,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Container(
                child: SizedBox(
                  //C??i n??y l?? b??n tr??i
                  width: MediaQuery.of(context).size.width / 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:  [
                      Text(
                        "${createTime.hour}:${createTime.minute}",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '${createTime.day},\nth??ng ${createTime.month},\nn??m ${createTime.year}',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                //Cai n??y l?? b??n ph???i
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 10.0),
                  decoration: BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //C??i n??y l?? d??ng ti??u ?????
                      Container(
                        padding:  EdgeInsets.only(right: 10.0),
                        child: Row(
                          children:  [
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  text:
                                      "[${item.manageWorkCode}] ${item.manageWorkTitle}",
                                  style: TextStyle(
                                    color: Color(0xFF0067AC),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: ' ',
                                    ),
                                    WidgetSpan(
                                        child: Icon(
                                      Icons.check_circle_outline_sharp,
                                      color: Colors.green,
                                      size: 16,
                                    )),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      InkWell(
                        child: Container(
                          // height: 30,
                          // width: 100,
                          margin: EdgeInsets.only(top: 10.0),
                          // padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black.withOpacity(0.3),
                            )
                          ], color: Colors.white),
                          child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text(
                              item.manageTypeWorkName ?? "N/A",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500),
                              // maxLines: 1,
                            ),
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                 "${item.countFile}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                  // maxLines: 1,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Image.asset(
                                  Assets.iconFiles,
                                  scale: 3.0,
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Row(
                              children: [
                                Text(
                                 "${item.countComment}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                  // maxLines: 1,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Image.asset(
                                  Assets.iconComment,
                                  scale: 3.0,
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  "${item.daysLate}",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                  // maxLines: 1,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Image.asset(
                                  Assets.iconTimeDetail,
                                  scale: 3.0,
                                )
                              ],
                            )
                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            CustomAvatarWithURL(
                              name: item.staffFullName ?? "N/A",
                              url: item.staffAvatar ?? "",
                              size: 50.0,
                            ),
                            Container(
                              width: 10.0,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.staffFullName ?? "N/A",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),

                      (item.listTag != null && item.listTag.length > 0) ? Container(
                        child: Wrap(
                          children: List.generate(item.listTag.length, (index) => _tagItem(item.listTag[index])),
                          spacing: 10,
                          runSpacing: 10,
                        ),
                      ) : Container()

                      //c??i n??y l?? button g???i ??i???n
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   Widget _tagItem(ListTagDetail item) {
    return Container(
      height: 30,
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 2,
          color: Colors.black.withOpacity(0.3),
        )
      ], color: Colors.white),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Assets.iconTag,
            scale: 3.0,
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            item.tagName,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500),
            // maxLines: 1,
          )
        ],
      ),
    );
  }

   Widget contactList() {
    return Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(bottom: 20),
        child: (contactListData != null &&
                contactListData.length > 0)
            ? Column(
                children: contactListData
                    .map((e) => contactListItem(e))
                    .toList())
            : Center(child: CustomDataNotFound()));
  }

    Widget contactListItem(ContactListData item) {
    return (contactListData != null && contactListData.length > 0)
        ? Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Color(0xFFC3C8D3))),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomAvatarWithURL(
                      name: item.fullName ?? "",
                      size: 50.0,
                    ),
                    Container(
                      width: 10.0,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.fullName ?? "",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                        (item.positon != null && item.positon != "")
                            ? Container(
                                margin: EdgeInsets.only(top: 5.0),
                                child: Text(
                                  item.positon ?? "",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0XFF8E8E8E),
                                      fontWeight: FontWeight.normal),
                                ),
                              )
                            : Container()
                      ],
                    )),
                    (item.phone != null && item.phone != "")
                        ? InkWell(
                            onTap: () async {
                              print(item.phone ?? "");
                              await callPhone(item?.phone ?? "");
                            },
                            child: Container(
                              padding: EdgeInsets.all(20.0 / 2),
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: Color(0xFF06A605),
                                borderRadius: BorderRadius.circular(50),
                                // border:  Border.all(color: AppColors.white,)
                              ),
                              child: Center(
                                  child: Image.asset(
                                Assets.iconCall,
                                color: AppColors.white,
                              )),
                            ),
                          )
                        : Container(),
                  ],
                ),
                (item.phone != null && item.phone != "")
                    ? Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                            ),
                            Text(
                              item.phone ?? "",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                (item.email != null && item.email != "")
                    ? Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                            ),
                            Text(
                              item.email ?? "",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                (item.address != null && item.address != "")
                    ? Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                            ),
                            Text(
                              item.address ?? "",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          )
        : CustomDataNotFound();
  }


  Widget _infoItem(String title, String content,
      {TextStyle style, String icon, String icon2}) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      margin: EdgeInsets.only(left: 15.0 / 2),
      child: Row(
        children: [
          Container(
            width: (MediaQuery.of(context).size.width) / 1.9,
            child: Row(
              children: [
                if (icon != null)
                  Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    height: 15.0,
                    width: 15.0,
                    child: Image.asset(icon),
                  ),
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    title,
                    style: AppTextStyles.style15BlackNormal,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Text(
            content,
            style: style ?? AppTextStyles.style15BlackNormal,
            // maxLines: 1,
          )),
          if (icon2 != null)
            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0),
              height: 30.0,
              width: 30.0,
              child: Image.asset(icon2),
            ),
        ],
      ),
    );
  }

  Future<bool> callPhone(String phone) async {
    final regSpace = RegExp(r"\s+");
    // return await launchUrl(Uri.parse("tel:" + phone.replaceAll(regSpace, "")));
    return await launch("tel:" + phone.replaceAll(regSpace, ""));
  }

  Widget _buildAvatar(String name) {
    return Container(
      width: 87.0,
      height: 87.0,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
          color: AppColors.primaryColor,
        ),
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10000.0),
        child: CustomAvatarDetail(
          color: Color(0xFFEEB132),
          name: name,
          textSize: 36.0,
        ),
      ),
    );
  }

  Widget buildButtonConvert(String title, Function ontap) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      height: 41,
      width: MediaQuery.of(context).size.width - 20,
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: ontap,
        child: Center(
          child: Text(
            // AppLocalizations.text(LangKey.convertCustomers),
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w700),
            maxLines: 1,
          ),
        ),
      ),
    );
  }

 
  
}

class DetailPotentialTabModel {
  String typeName;
  int typeID;
  bool selected;

  DetailPotentialTabModel({this.typeName, this.typeID, this.selected});

  factory DetailPotentialTabModel.fromJson(Map<String, dynamic> parsedJson) {
    return DetailPotentialTabModel(
        typeName: parsedJson['typeName'],
        typeID: parsedJson['typeID'],
        selected: parsedJson['selected']);
  }
}

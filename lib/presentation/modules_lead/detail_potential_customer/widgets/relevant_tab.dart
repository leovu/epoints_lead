part of '../detail_potential_customer.dart';

extension RelevantTabExtension on _DetailPotentialCustomerState {
  Widget _listInfomationRelevant() {
    return Padding(
      padding: EdgeInsets.all(AppSizes.minPadding),
      child: CustomListView(
        separatorPadding: 0,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          RichText(
              text: TextSpan(
                  text: _bloc.detail!.customerType == "personal"
                      ? "${AppLocalizations.text(LangKey.personal)} - "
                      : "${AppLocalizations.text(LangKey.business)} - ",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                  children: [
                TextSpan(
                    text: detail!.fullName,
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold))
              ])),
          CustomRowImageContentWidget(
            paddingBottom: AppSizes.minPadding / 2,
            icon: Assets.iconPerson,
            title: detail!.customerLeadCode ?? NULL_VALUE,
          ),
          CustomRowImageContentWidget(
            paddingBottom: AppSizes.minPadding / 2,
            icon: Assets.iconUserGroup,
            title: detail!.customerGroupName ?? NULL_VALUE,
          ),
          CustomRowImageContentWidget(
              paddingBottom: AppSizes.minPadding / 2,
              icon: Assets.iconCall,
              title: hidePhone(detail?.phone,
                  checkVisibilityKey(VisibilityWidgetName.CM000004))),
          CustomRowImageContentWidget(
            paddingBottom: AppSizes.minPadding / 2,
            icon: Assets.iconInteraction,
            child: RichText(
                text: TextSpan(
                    text: detail!.dateLastCare! + " ",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                    children: [
                  TextSpan(
                      text: "(${detail!.diffDay} ngày)",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal))
                ])),
          ),
          infomationRelevant()
        ],
      ),
    );
  }

  Widget dealInfomationItem(DetailLeadInfoDealData item) {
    return InkWell(
      onTap: () async {
        if (Global.openDetailDeal != null) {
          var result = await Global.openDetailDeal!(item.dealCode!);
          if (result != null) {
            _bloc.allowPop = true;
            await _bloc.getData(widget.customer_lead_code!);
          }
        }
      },
      child: Container(
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
              padding: EdgeInsets.only(top: 5.0, right: 5.0, bottom: 5.0),
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
                      item.dealName!,
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
                      child: Text(item.journeyName ?? NULL_VALUE,
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
              item.createdAt!,
            ),
            _infoItemV2(Assets.iconName, item.staffName ?? ""),
            _infoItemV2(Assets.iconInteraction, item.createdAt ?? ""),
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
                      "${NumberFormat("#,###", "vi-VN").format(item.amount ?? 0)} VNĐ",
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
      ),
    );
  }

  Widget customerCareItem(CareLeadData item) {
    final createTime = DateTime.parse(item.createdAt ?? "");

    return InkWell(
      onTap: () async {
        if (Global.editJob != null) {
          var result = await Global.editJob!(item.manageWorkId ?? 0);
          if (result != null) {
            _bloc.allowPop = true;
            await _bloc.getData(widget.customer_lead_code!);
          }
        }
      },
      child: Container(
        child: Container(
          // margin: EdgeInsets.all(10),
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
                  //Cái này là bên trái
                  width: MediaQuery.of(context).size.width / 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${createTime.hour}:${createTime.minute}",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '${createTime.day},\ntháng ${createTime.month},\nnăm ${createTime.year}',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                //Cai này là bên phải
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
                      //Cái này là dòng tiêu đề
                      Container(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Row(
                          children: [
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

                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black.withValues(alpha: 0.3),
                          )
                        ], color: Colors.white),
                        child: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomNetworkImage(
                                width: 15,
                                height: 15,
                                url: item.manageTypeWorkIcon ??
                                    "https://epoint-bucket.s3.ap-southeast-1.amazonaws.com/0f73a056d6c12b508a05eea29735e8a52022/07/14/3Ujo25165778317714072022.png",
                                fit: BoxFit.fill,
                                backgroundColor: Colors.transparent,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                item.manageTypeWorkName ?? NULL_VALUE,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500),
                                // maxLines: 1,
                              ),
                            ],
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
                              name: item.staffFullName ?? NULL_VALUE,
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
                                  item.staffFullName ?? NULL_VALUE,
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

                      (item.listTag != null && item.listTag!.length > 0)
                          ? Container(
                              child: Wrap(
                                children: List.generate(
                                    item.listTag!.length,
                                    (index) => _tagItemCustomCare(
                                        item.listTag![index])),
                                spacing: 10,
                                runSpacing: 10,
                              ),
                            )
                          : Container()

                      //cái này là button gọi điện
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

  Widget _tagItemCustomCare(ListTagCareLead item) {
    return Container(
      height: 30,
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 2,
          color: Colors.black.withValues(alpha: 0.3),
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
            item.tagName!,
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

  Widget contactListItem(ContactListData item) {
    return Container(
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
                        await _callPhone(item.phone ?? "");
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
                        item.phone ?? '',
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
    );
  }

  Widget infomationRelevant() {
    return StreamBuilder(
        stream: _bloc.outputModel,
        initialData: null,
        builder: (_, snapshot) {
          DetailPotentialData? model = snapshot.data as DetailPotentialData?;
          return (model != null)
              ? ContainerDataBuilder(
                  data: model,
                  skeletonBuilder: _buildSkeleton(),
                  bodyBuilder: () {
                    if (_bloc.children == null && model.tabConfigs != null) {
                      _bloc.children = [];
                      for (var e in model.tabConfigs!) {
                        switch (e.code) {
                          case leadConfigDeal:
                            _bloc.children!.add(_buildListDeal(e));
                            _bloc.children!
                                .add(SizedBox(height: AppSizes.minPadding / 2));
                            break;
                          case leadConfigCustomerCare:
                            _bloc.children!.add(_buildListCustomerCare(e));
                            _bloc.children!
                                .add(SizedBox(height: AppSizes.minPadding / 2));
                            break;
                          case leadConfigContact:
                            _bloc.children!
                                .add(SizedBox(height: AppSizes.minPadding / 2));
                            _bloc.children!.add(_buildListContact(e));
                            break;
                          case leadConfigNote:
                            _bloc.children!
                                .add(SizedBox(height: AppSizes.minPadding / 2));
                            _bloc.children!.add(_buildLisNote(e));
                            break;
                          case leadConfigFile:
                            _bloc.children!
                                .add(SizedBox(height: AppSizes.minPadding / 2));
                            _bloc.children!.add(_buildListFile(e));
                            break;
                        }
                      }
                    }
                    return Column(
                      children: [
                        if (_bloc.children != null) ..._bloc.children!,
                      ],
                    );
                  },
                )
              : SizedBox();
        });
  }

  Widget _buildListDeal(CustomerDetailConfigModel e) {
    return StreamBuilder(
        stream: _bloc.outputExpandDeal,
        initialData: _bloc.expandDeal,
        builder: (_, snapshot) {
          _bloc.expandDeal = snapshot.data as bool;
          return StreamBuilder(
              stream: _bloc.outputLeadInfoDeal,
              initialData: _bloc.listDealFromLead,
              builder: (context, snapshot) {
                _bloc.listDealFromLead =
                    snapshot.data as List<DetailLeadInfoDealData>;
                return CustomComboBox(
                  onChanged: (event) =>
                      _bloc.onSetExpand(() => _bloc.expandDeal = event),
                  onTapPlus: () async {
                    if (Global.createDeal != null) {
                      var result = await Global.createDeal!(detail!.toJson());
                      if (result != null) {
                        _bloc.allowPop = true;
                        _bloc.getData(widget.customer_lead_code!);
                      }
                    }
                  },
                  onTapList: () {
                    _bloc.onTapListDeal();
                  },
                  title: e.tabNameVi ?? "",
                  isExpand: _bloc.expandDeal,
                  quantity: _bloc.listDealFromLead.length,
                  child: CustomListView(
                    padding: EdgeInsets.only(
                        top: AppSizes.minPadding, bottom: AppSizes.minPadding),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: _bloc.listDealFromLead
                        .map((e) => dealInfomationItem(e))
                        .toList(),
                  ),
                );
              });
        });
  }

  Widget _buildListCustomerCare(CustomerDetailConfigModel e) {
    return StreamBuilder(
        stream: _bloc.outputExpandCustomerCare,
        initialData: _bloc.expandCare,
        builder: (_, snapshot) {
          _bloc.expandCare = snapshot.data as bool;
          return StreamBuilder(
              stream: _bloc.outputCareLead,
              initialData: _bloc.listCareLead,
              builder: (context, snapshot) {
                _bloc.listCareLead = snapshot.data as List<CareLeadData>;
                return CustomComboBox(
                  onChanged: (event) =>
                      _bloc.onSetExpand(() => _bloc.expandCare = event),
                  onTapPlus: () async {
                    if (Global.createCare != null) {
                      var result =
                          await Global.createCare!(_bloc.detail!.toJson());
                      if (result != null) {
                        _bloc.allowPop = true;
                        _bloc.getData(widget.customer_lead_code!);
                      }
                    }
                  },
                  onTapList: () {
                    _bloc.onTapListCustomerCare();
                  },
                  title: e.tabNameVi ?? "Chăm sóc khách hàng",
                  isExpand: _bloc.expandCare,
                  quantity: _bloc.listCareLead.length,
                  child: CustomListView(
                    padding: EdgeInsets.only(
                        top: AppSizes.minPadding, bottom: AppSizes.minPadding),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: _bloc.listCareLead
                        .map((e) => customerCareItem(e))
                        .toList(),
                  ),
                );
              });
        });
  }

  Widget _buildLisNote(CustomerDetailConfigModel e) {
    return StreamBuilder(
        stream: _bloc.outputExpandListNote,
        initialData: _bloc.expandListNote,
        builder: (_, snapshot) {
          _bloc.expandListNote = snapshot.data as bool;
          return StreamBuilder(
              stream: _bloc.outputListNote,
              initialData: _bloc.listNoteData,
              builder: (context, snapshot) {
                _bloc.listNoteData = snapshot.data as List<NoteData>;
                return CustomComboBox(
                  onChanged: (event) =>
                      _bloc.onSetExpand(() => _bloc.expandListNote = event),
                  onTapList: () {
                    _bloc.onTapListNote();
                  },
                  onTapPlus: () {
                    _bloc.onAddNote(() {
                      _bloc.getListNote(context);
                    });
                  },
                  title: e.tabNameVi ?? "Ghi chú",
                  isExpand: _bloc.expandListNote,
                  quantity: _bloc.listNoteData.length,
                  child: CustomListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.minPadding / 2,
                        vertical: AppSizes.minPadding / 2),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(
                        _bloc.listNoteData.length,
                        (index) => noteItem(
                              _bloc.listNoteData[index],
                              index,
                            )).toList(),
                  ),
                );
              });
        });
  }

  Widget _buildListFile(CustomerDetailConfigModel e) {
    return StreamBuilder(
        stream: _bloc.outputExpandListFile,
        initialData: _bloc.expandListFile,
        builder: (_, snapshot) {
          _bloc.expandListFile = snapshot.data as bool;
          return StreamBuilder(
              stream: _bloc.outputDealsFile,
              initialData: _bloc.listLeadsFiles,
              builder: (context, snapshot) {
                _bloc.listLeadsFiles = snapshot.data as List<LeadFilesModel>;
                return CustomComboBox(
                  onChanged: (event) =>
                      _bloc.onSetExpand(() => _bloc.expandListFile = event),
                  onTapPlus: () {
                    _bloc.onAddFile();
                  },
                  onTapList: () {
                    _bloc.onTapListFile();
                  },
                  title: e.tabNameVi ?? "Tập tin",
                  isExpand: _bloc.expandListFile,
                  quantity: _bloc.listLeadsFiles.length,
                  child: CustomListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.minPadding / 2,
                        vertical: AppSizes.minPadding / 2),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: _bloc.listLeadsFiles
                        .map((e) =>
                            _fileItem(e, _bloc.listLeadsFiles.indexOf(e)))
                        .toList(),
                  ),
                );
              });
        });
  }

  Widget _buildListContact(CustomerDetailConfigModel e) {
    return StreamBuilder(
        stream: _bloc.outputExpandListContact,
        initialData: _bloc.expandListContact,
        builder: (_, snapshot) {
          _bloc.expandListContact = snapshot.data as bool;
          return StreamBuilder(
              stream: _bloc.outputContactList,
              initialData: _bloc.listContact,
              builder: (context, snapshot) {
                _bloc.listContact = snapshot.data as List<ContactListData>;
                return CustomComboBox(
                  onChanged: (event) =>
                      _bloc.onSetExpand(() => _bloc.expandListContact = event),
                  title: e.tabNameVi ?? "",
                  isExpand: _bloc.expandListContact,
                  onTapPlus: () {
                    _bloc.onAddContact();
                  },
                  onTapList: () {
                    _bloc.onTapListContact();
                  },
                  quantity: _bloc.listContact.length,
                  child: CustomListView(
                    padding: EdgeInsets.only(
                        top: AppSizes.minPadding, bottom: AppSizes.minPadding),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: _bloc.listContact
                        .map((e) => contactListItem(e))
                        .toList(),
                  ),
                );
              });
        });
  }

  Widget noteItem(NoteData model, int index) {
    String? name, date;

    if (model.createdBy != null) {
      name = model.createdBy ?? "";
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
        _bloc.onOpenFile(model.fileName ?? "", model.path);
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
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
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

  Widget _listButtonRelevant() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.minPadding),
          child: Row(
            children: [
              Flexible(
                child: CustomButton(
                  style: AppTextStyles.style15WhiteNormal
                      .copyWith(fontWeight: FontWeight.bold),
                  heightButton: AppSizes.sizeOnTap,
                  text: "Chỉnh sửa",
                  ontap: () async {
                    bool? result =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditPotentialCustomer(
                                  detailPotential: detail,
                                )));

                    if (result != null) {
                      _bloc.allowPop = true;
                      _bloc.getData(widget.customer_lead_code!);
                    }
                  },
                ),
              ),
              SizedBox(
                width: AppSizes.minPadding,
              ),
              Flexible(
                child: CustomButton(
                  style: AppTextStyles.style15WhiteNormal
                      .copyWith(fontWeight: FontWeight.bold),
                  heightButton: AppSizes.sizeOnTap,
                  text: AppLocalizations.text(LangKey.discuss),
                  ontap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatScreen(
                              detail: detail,
                            )));
                  },
                ),
              ),
              if (checkVisibilityKey(VisibilityWidgetName.CM000008)) ...[
                SizedBox(
                  width: AppSizes.minPadding,
                ),
                Flexible(
                  child: CustomButton(
                    style: AppTextStyles.style15WhiteNormal
                        .copyWith(fontWeight: FontWeight.bold),
                    heightButton: AppSizes.sizeOnTap,
                    text: "Liên hệ",
                    ontap: () {
                      if (detail?.phone != null && detail?.phone != "") {
                        if (Global.callHotline != null) {
                          Global.callHotline!({
                            "id": detail?.customerLeadId,
                            "code": detail?.customerLeadCode,
                            "avatar": detail?.avatar,
                            "name": detail?.fullName,
                            "phone": detail?.phone,
                            "type": detail?.customerType,
                          });
                        } else {
                          LeadConnection.showMyDialog(
                              context, "Không có thông tin số điện thoại");
                        }
                      }
                    },
                  ),
                ),
              ]
            ],
          ),
        ),
        Positioned(top: 0, left: 0, right: 0, child: Gaps.line(1))
      ],
    );
  }

  Widget _listButtonInfo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.minPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: CustomButton(
                        style: AppTextStyles.style15WhiteNormal
                            .copyWith(fontWeight: FontWeight.bold),
                        heightButton: AppSizes.sizeOnTap,
                        backgroundColor: AppColors.redColor,
                        text: "XÓA LEAD",
                        ontap: () {
                          LeadConnection.showMyDialogWithFunction(context,
                              AppLocalizations.text(LangKey.warningDeleteLead),
                              ontap: () async {
                            DescriptionModelResponse? result =
                                await LeadConnection.deleteLead(
                                    context, detail!.customerLeadCode);
                            Navigator.of(context).pop();
                            if (result != null) {
                              if (result.errorCode == 0) {
                                _bloc.allowPop = true;
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
                        },
                      ),
                    ),
                    SizedBox(
                      width: AppSizes.minPadding,
                    ),
                    Flexible(
                      child: CustomButton(
                        style: AppTextStyles.style15WhiteNormal
                            .copyWith(fontWeight: FontWeight.bold),
                        heightButton: AppSizes.sizeOnTap,
                        text: "CHUYỂN ĐỔI KH",
                        ontap: () async {
                          await _bloc
                              .convertLead(_bloc.detail!.customerLeadId ?? 0)
                              .then((value) {
                            if (value) {
                              CustomNavigator.pop(context, object: true);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSizes.minPadding,
                ),
                Row(
                  children: [
                    Flexible(
                      child: CustomButton(
                        style: AppTextStyles.style15WhiteNormal
                            .copyWith(fontWeight: FontWeight.bold),
                        heightButton: AppSizes.sizeOnTap,
                        text: "THÊM DEAL",
                        ontap: () async {
                          if (Global.createDeal != null) {
                            bool? result =
                                await Global.createDeal!(detail!.toJson());
                            if (result != null) {
                              _bloc.allowPop = true;
                              _bloc.getData(widget.customer_lead_code!);
                            }
                          }
                          //
                        },
                      ),
                    ),
                    SizedBox(
                      width: AppSizes.minPadding,
                    ),
                    Flexible(
                      child: CustomButton(
                        style: AppTextStyles.style15WhiteNormal
                            .copyWith(fontWeight: FontWeight.bold),
                        heightButton: AppSizes.sizeOnTap,
                        text: (_bloc.detail?.saleId != null &&
                                _bloc.detail?.saleId != 0)
                            ? "THU HỒI"
                            : "PHÂN CÔNG",
                        ontap: () async {
                          if (detail?.saleId != null && detail?.saleId != 0) {
                            await _bloc
                                .assignRevokeLead(AssignRevokeLeadRequestModel(
                                    customerLeadCode: detail?.customerLeadCode,
                                    saleId: detail?.saleId ?? 0,
                                    timeRevokeLead: detail?.timeRevokeLead ?? 0,
                                    type: "revoke"))
                                .then((value) {
                              if (value) {
                                _bloc.allowPop = true;
                                _bloc.getData(detail?.customerLeadCode ?? "");
                              }
                            });
                          } else {
                            List<WorkListStaffModel>? models =
                                await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PickOneStaffScreen()));
                            if (models != null && models.length > 0) {
                              await _bloc
                                  .assignRevokeLead(
                                      AssignRevokeLeadRequestModel(
                                          customerLeadCode:
                                              detail?.customerLeadCode,
                                          saleId: models[0].staffId,
                                          timeRevokeLead:
                                              detail?.timeRevokeLead ?? 0,
                                          type: "assign"))
                                  .then((value) {
                                if (value) {
                                  _bloc.allowPop = true;
                                  _bloc.getData(detail?.customerLeadCode ?? "");
                                }
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )),
        Positioned(top: 0, left: 0, right: 0, child: Gaps.line(1))
      ],
    );
  }
}

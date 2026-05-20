part of 'create_potential_customer.dart';

extension CreatePotentialCustomerHandlers on _CreatePotentialCustomerState {
  Future<void> initData() async {
    LeadConnection.showLoading(context);
    try {
      await _bloc.onGetBranch(context, showLoading: false);

      var sources = await _bloc.getCustomerSources(context);
      if (sources.isNotEmpty) {
        sourceSelected = sources.first;
        detailPotential.customerSource = sourceSelected.customerSourceId;
      }

      var pipelines = await _bloc.getPipelines(context);
      if (pipelines.isNotEmpty) {
        PipelineData defaultPipeline;
        try {
          defaultPipeline =
              pipelines.firstWhere((p) => (p.isDefault ?? 0) == 1);
        } catch (_) {
          defaultPipeline = pipelines.first;
        }
        pipelineSelected = defaultPipeline;
        detailPotential.pipelineCode = pipelineSelected.pipelineCode;

        var journeys =
            await _bloc.getJourneys(context, pipelineSelected.pipelineCode);
        if (journeys.isNotEmpty) {
          journeySelected = journeys.first;
          detailPotential.journeyCode = journeySelected!.journeyCode;
        }
      }

      await loadAllocatorAndAutoSelect();
    } finally {
      Navigator.of(context).pop();
    }
    refresh();
  }

  Future<void> loadAllocatorAndAutoSelect({bool showLoading = false}) async {
    final branchId = _bloc.branchSelected?.branchId;
    if (branchId == null) return;
    var res = await _bloc.getAllocatorByBranchLegacy(context, branchId,
        showLoading: showLoading);
    final staffs = res?.data ?? [];
    if (staffs.isEmpty || Global.staffId == null) return;
    try {
      allocatorSelected = staffs.firstWhere((a) => a.staffId == Global.staffId);
      detailPotential.saleId = allocatorSelected!.staffId;
    } catch (_) {
      // không match → để trống cho user chọn
    }
  }

  Future<void> onPickCustomerSource() async {
    FocusScope.of(context).unfocus();
    if (_bloc.listCustomerSource.isEmpty) {
      LeadConnection.showLoading(context);
      await _bloc.getCustomerSources(context);
      Navigator.of(context).pop();
    }
    CustomerOptionSource? source = await CustomNavigator.showCustomBottomDialog(
      context,
      CustomerSourceModal(sources: _bloc.listCustomerSource),
    );
    if (source != null) {
      sourceSelected = source;
      detailPotential.customerSource = sourceSelected.customerSourceId;
      refresh();
    }
  }

  Future<void> onPickPipeline() async {
    FocusScope.of(context).unfocus();
    if (_bloc.listPipeline.isEmpty) {
      LeadConnection.showLoading(context);
      await _bloc.getPipelines(context);
      Navigator.of(context).pop();
    }
    PipelineData? pipeline = await CustomNavigator.showCustomBottomDialog(
      context,
      PipelineModal(pipeLineData: _bloc.listPipeline),
    );
    if (pipeline == null) return;

    final pipelineChanged =
        pipelineSelected.pipelineCode != pipeline.pipelineCode;
    pipelineSelected = pipeline;
    detailPotential.pipelineCode = pipelineSelected.pipelineCode;

    LeadConnection.showLoading(context);
    var journeys =
        await _bloc.getJourneys(context, pipelineSelected.pipelineCode);
    Navigator.of(context).pop();

    if (pipelineChanged) {
      journeySelected = null;
      detailPotential.journeyCode = "";
    }
    refresh();

    if (journeys.isEmpty) return;
    JourneyData? journey = await CustomNavigator.showCustomBottomDialog(
      context,
      JourneyModal(journeys: journeys),
    );
    if (journey != null) {
      journeySelected = journey;
      detailPotential.journeyCode = journeySelected!.journeyCode;
      refresh();
    }
  }

  Future<void> onPickJourney() async {
    FocusScope.of(context).unfocus();
    if (_bloc.listJourney.isEmpty &&
        (pipelineSelected.pipelineCode ?? "").isNotEmpty) {
      LeadConnection.showLoading(context);
      await _bloc.getJourneys(context, pipelineSelected.pipelineCode);
      Navigator.of(context).pop();
    }
    JourneyData? journey = await CustomNavigator.showCustomBottomDialog(
      context,
      JourneyModal(journeys: _bloc.listJourney),
    );
    if (journey != null) {
      journeySelected = journey;
      detailPotential.journeyCode = journeySelected!.journeyCode;
      refresh();
    }
  }

  Future<void> onPickAllocator() async {
    FocusScope.of(context).unfocus();
    final branchId = _bloc.branchSelected?.branchId;
    if (branchId == null) {
      LeadConnection.showMyDialog(context, "Vui lòng chọn chi nhánh trước",
          warning: true);
      return;
    }
    final staffs = _bloc.listAllocator?.data ?? [];
    if (staffs.isEmpty) {
      await _bloc.getAllocatorByBranchLegacy(context, branchId);
    }
    WorkListStaffModel? data = await CustomNavigator.showCustomBottomDialog(
      context,
      StaffPickModal(
          staffs: _bloc.listAllocator?.data, selected: allocatorSelected),
    );
    if (data != null) {
      allocatorSelected = data;
      detailPotential.saleId = allocatorSelected!.staffId;
      refresh();
    }
  }

  Future<void> onPickBranch() async {
    FocusScope.of(context).unfocus();
    final branches = await _bloc.getBranch(context);
    if (branches == null) return;
    BranchData? data = await CustomNavigator.showCustomBottomDialog(
      context,
      BranchModal(datas: _bloc.listBranch),
    );
    if (data == null) return;

    final changed = _bloc.branchSelected?.branchId != data.branchId;
    _bloc.branchSelected = data;

    if (changed) {
      allocatorSelected = null;
      detailPotential.saleId = 0;
      _bloc.listAllocator = null;
      await loadAllocatorAndAutoSelect(showLoading: true);
    }
    refresh();
  }

  Future<void> onPickCustomerGroup() async {
    FocusScope.of(context).unfocus();
    final groups = await _bloc.getCustomerGroup(context);
    if (groups == null) return;
    CustomerGroupData? data = await CustomNavigator.showCustomBottomDialog(
      context,
      GroupCustomerModal(datas: _bloc.listCustomerGroupData),
    );
    if (data != null) {
      _bloc.customerGroupSelected = data;
      refresh();
    }
  }

  Future<void> onPickTags() async {
    FocusScope.of(context).unfocus();
    if (tagsData == null || tagsData!.isEmpty) {
      LeadConnection.showLoading(context);
      var tags = await LeadConnection.getTag(context);
      Navigator.of(context).pop();
      if (tags != null) tagsData = tags.data;
    }
    var listTagsSelected = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TagsModal(tagsData: tagsData)));
    if (listTagsSelected == null) return;

    tagsString = "";
    tagsData = listTagsSelected;
    List<int?> tagsSeletecd = [];
    for (int i = 0; i < tagsData!.length; i++) {
      if (tagsData![i].selected!) {
        tagsSeletecd.add(tagsData![i].tagId);
        tagsString = tagsString.isEmpty
            ? (tagsData![i].name ?? "")
            : "$tagsString, ${tagsData![i].name}";
      }
    }
    detailPotential.tagId = tagsSeletecd;
    refresh();
  }

  Future<void> onAddPhone() async {
    var result = await showModalBottomSheet(
        isDismissible: true,
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: CreateNewPhoneModal(bloc: _bloc));
        });
    if (result != null && result) refresh();
  }

  Future<void> onSubmit() async {
    if (_fullNameText.text.isEmpty ||
        detailPotential.pipelineCode == "" ||
        detailPotential.journeyCode == "" ||
        (detailPotential.saleId ?? 0) == 0 ||
        _bloc.branchSelected == null) {
      LeadConnection.showMyDialog(
          context, AppLocalizations.text(LangKey.warningChooseAllRequiredInfo),
          warning: true);
      return;
    }

    final phone = _phoneNumberText.text.trim();
    if (phone.isNotEmpty &&
        !Validators().isValidPhone(phone) &&
        !Validators().isNumber(phone)) {
      LeadConnection.showMyDialog(
          context, AppLocalizations.text(LangKey.phoneNumberNotCorrectFormat),
          warning: true);
      return;
    }

    final email = _emailText.text.trim();
    if (email.isNotEmpty && !Validators().isValidEmail(email)) {
      LeadConnection.showMyDialog(context, "Email không đúng định dạng",
          warning: true);
      return;
    }

    if (!selectedPersonal) {
      if (_bloc.contactFullNameController.text.trim().isEmpty) {
        LeadConnection.showMyDialog(
            context, "Vui lòng nhập họ tên người liên hệ",
            warning: true);
        return;
      }
      final contactPhone = _bloc.contactPhoneController.text.trim();
      if (contactPhone.isEmpty) {
        LeadConnection.showMyDialog(
            context, "Vui lòng nhập số điện thoại người liên hệ",
            warning: true);
        return;
      }
      if (!Validators().isValidPhone(contactPhone) &&
          !Validators().isNumber(contactPhone)) {
        LeadConnection.showMyDialog(
            context, "Số điện thoại người liên hệ không đúng định dạng",
            warning: true);
        return;
      }
      final contactEmail = _bloc.contactEmailController.text.trim();
      if (contactEmail.isNotEmpty && !Validators().isValidEmail(contactEmail)) {
        LeadConnection.showMyDialog(
            context, "Email người liên hệ không đúng định dạng",
            warning: true);
        return;
      }
    }

    if (_bloc.images.isNotEmpty) {
      await _bloc.uploadFileAWS(_bloc.images[0]).then((value) {
        if (value != "") _bloc.imgAvatar = value;
        addPotential(customerTypeSelected.customerTypeID ?? 0);
      });
    } else {
      await addPotential(customerTypeSelected.customerTypeID ?? 0);
    }
  }

  Future<void> addPotential(int customerTypeID) async {
    bool typePersonnal = customerTypeID == 1;
    LeadConnection.showLoading(context);
    AddLeadModelResponse? result = await LeadConnection.addLead(
        context,
        AddLeadModelRequest(
          avatar: _bloc.imgAvatar ?? "",
          customerType: typePersonnal ? "personal" : "business",
          customerSource: detailPotential.customerSource,
          fullName: _fullNameText.text,
          taxCode: typePersonnal ? "" : _taxText.text,
          phone: _phoneNumberText.text,
          email: _emailText.text,
          representative:
              typePersonnal ? "" : _bloc.representativeController.text,
          pipelineCode: detailPotential.pipelineCode,
          journeyCode: detailPotential.journeyCode,
          saleId:
              //  (detailPotential.saleId ?? 0) != 0
              //     ? detailPotential.saleId
              //     :
              Global.saleId ?? detailPotential.saleId,
          tagId: detailPotential.tagId,
          gender: detailPotential.gender,
          birthday: detailPotential.birthday,
          bussinessId: typePersonnal ? 0 : detailPotential.bussinessId,
          employees: typePersonnal ? 0 : detailPotential.employees,
          address: "${_bloc.addressModel?.street ?? ""} ",
          provinceId: _bloc.addressModel?.provinceModel?.provinceid ?? 0,
          districtId: _bloc.addressModel?.districtModel?.districtid ?? 0,
          wardId: _bloc.addressModel?.wardModel?.wardId ?? 0,
          businessClue: detailPotential.businessClue,
          zalo: detailPotential.zalo ?? "",
          fanpage: detailPotential.fanpage ?? "",
          contactAddress: typePersonnal ? "" : detailPotential.contactAddress,
          contactEmail: typePersonnal ? "" : detailPotential.contactEmail,
          contactFullName: typePersonnal ? "" : detailPotential.contactFullName,
          contactPhone: typePersonnal ? "" : detailPotential.contactPhone,
          position: typePersonnal ? "" : detailPotential.position,
          customerGroupId: _bloc.customerGroupSelected?.customerGroupId ?? 0,
          branchId: _bloc.branchSelected?.branchId ?? 0,
          note: _bloc.noteController.text,
          customerLeadReferId: _bloc.presenterModel?.customerId ?? 0,
          arrPhoneAttack: _bloc.listPhone,
          website: _bloc.websiteController.text,
        ));
    Navigator.of(context).pop();
    if (result == null) return;
    if (result.errorCode == 0) {
      await LeadConnection.showMyDialog(context, result.errorDescription);
      if (result.data != null) {
        modelResponse = ObjectPopDetailModel(
            customer_lead_code: "",
            customer_lead_id: result.data!.customerLeadId,
            status: true);
      }
      Navigator.of(context).pop(modelResponse.toJson());
    } else {
      LeadConnection.showMyDialog(context, result.errorDescription);
    }
  }
}

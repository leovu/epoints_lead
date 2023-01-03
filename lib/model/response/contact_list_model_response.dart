class ContactListModelResponse {
  int errorCode;
  String errorDescription;
  List<ContactListData> data;

  ContactListModelResponse({this.errorCode, this.errorDescription, this.data});

  ContactListModelResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorDescription = json['ErrorDescription'];
    if (json['Data'] != null) {
      data = <ContactListData>[];
      json['Data'].forEach((v) {
        data.add(new ContactListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorDescription'] = this.errorDescription;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContactListData {
  int customerContactId;
  String customerLeadCode;
  String fullName;
  String positon;
  String phone;
  String email;
  String address;
  Null customerContactTilteId;
  String customerContactType;
  Null customerContactTilteNameVi;
  Null customerContactTilteNameEn;
  String customerContactTypeName;

  ContactListData(
      {this.customerContactId,
      this.customerLeadCode,
      this.fullName,
      this.positon,
      this.phone,
      this.email,
      this.address,
      this.customerContactTilteId,
      this.customerContactType,
      this.customerContactTilteNameVi,
      this.customerContactTilteNameEn,
      this.customerContactTypeName});

  ContactListData.fromJson(Map<String, dynamic> json) {
    customerContactId = json['customer_contact_id'];
    customerLeadCode = json['customer_lead_code'];
    fullName = json['full_name'];
    positon = json['positon'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    customerContactTilteId = json['customer_contact_tilte_id'];
    customerContactType = json['customer_contact_type'];
    customerContactTilteNameVi = json['customer_contact_tilte_name_vi'];
    customerContactTilteNameEn = json['customer_contact_tilte_name_en'];
    customerContactTypeName = json['customer_contact_type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_contact_id'] = this.customerContactId;
    data['customer_lead_code'] = this.customerLeadCode;
    data['full_name'] = this.fullName;
    data['positon'] = this.positon;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address'] = this.address;
    data['customer_contact_tilte_id'] = this.customerContactTilteId;
    data['customer_contact_type'] = this.customerContactType;
    data['customer_contact_tilte_name_vi'] = this.customerContactTilteNameVi;
    data['customer_contact_tilte_name_en'] = this.customerContactTilteNameEn;
    data['customer_contact_type_name'] = this.customerContactTypeName;
    return data;
  }
}

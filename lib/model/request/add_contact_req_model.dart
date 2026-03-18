class AddContactRequest {
  String? customerLeadCode;
  String? fullName;
  String? phone;
  String? email;
  String? position;
  String? address;

  AddContactRequest(
      {this.customerLeadCode,
      this.fullName,
      this.phone,
      this.email,
      this.position,
      this.address});

  AddContactRequest.fromJson(Map<String, dynamic> json) {
    customerLeadCode = json['customer_lead_code'];
    fullName = json['full_name'];
    phone = json['phone'];
    email = json['email'];
    position = json['position'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_lead_code'] = this.customerLeadCode;
    data['full_name'] = this.fullName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['position'] = this.position;
    data['address'] = this.address;
    return data;
  }
}

import 'package:lead_plugin_epoint/utils/global.dart';

class API {

    static String? get server => Global.domain;
  static int get successCode => 0;
  static int get noDataCode => 1;

// Booking
  static provinceFull() => "/booking/province-full";
  static district() => "/booking/district";
  static ward() => "/booking/ward";
// Lead
  static getBranch() => "/customer-lead/customer-lead/get-branch";
  static getCustomerGroup() => "/customer-lead/get-customer-group";
  static getCareLead() => "/customer-lead/customer-lead/care-lead";
  static getContactList() => "/customer-lead/customer-lead/contact-list";
  static getDetailLeadInfoDeal() => "/customer-lead/customer-lead/detail-lead-info-deal";
  static addContact() => "/customer-lead/customer-lead/add-contact";

   static getListNote() => "/customer-lead/customer-lead/list-note";
  static addNote() => "/customer-lead/customer-lead/add-note";
  static getListFile() => "/customer-lead/customer-lead/list-file";
  static addFile() => "/customer-lead/customer-lead/add-file";
  static getCustomer() => "/customer/get-customer";

}
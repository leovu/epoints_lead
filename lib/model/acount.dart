class Account {
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  User? user;

  Account({accessToken, tokenType, expiresIn, user});

  Account.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? accessKey;
  Staff? staff;

  User({accessKey, staff});

  User.fromJson(Map<String, dynamic> json) {
    accessKey = json['access_key'];
    staff = json['staff'] != null ? Staff.fromJson(json['staff']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_key'] = accessKey;
    if (staff != null) {
      data['staff'] = staff!.toJson();
    }
    return data;
  }
}

class Staff {
  int? staffId;
  String? userName;
  String? fullName;
  String? phone;
  String? email;
  String? staffAvatar;
  Department? department;

  Staff(
      {staffId,
        userName,
        fullName,
        phone,
        email,
        staffAvatar,
        department});

  Staff.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id'];
    userName = json['user_name'];
    fullName = json['full_name'];
    phone = json['phone'];
    email = json['email'];
    staffAvatar = json['staff_avatar'];
    department = json['department'] != null
        ? Department.fromJson(json['department'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['staff_id'] = staffId;
    data['user_name'] = userName;
    data['full_name'] = fullName;
    data['phone'] = phone;
    data['email'] = email;
    data['staff_avatar'] = staffAvatar;
    if (department != null) {
      data['department'] = department!.toJson();
    }
    return data;
  }
}

class Department {
  int? departmentId;
  String? departmentName;

  Department({departmentId, departmentName});

  Department.fromJson(Map<String, dynamic> json) {
    departmentId = json['department_id'];
    departmentName = json['department_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['department_id'] = departmentId;
    data['department_name'] = departmentName;
    return data;
  }
}
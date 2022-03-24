class CompanyInfoModel {
  int id;
  String shopName;
  String mobile;
  String contractName;
  String contractMobile;
  String contractEmail;
  String processUserName;
  String processTime;
  String contractNo;
  String contractStart;
  String contractEnd;
  String contractAttach;
  String companyName;
  String registerAddress;
  String businessAddress;
  String businessStart;
  String businessEnd;
  String businessPhoto;
  String businessPerson;
  String taxType;
  String taxBank;
  String taxNumber;
  String taxAccount;
  String taxPhoto;
  String taxProve;
  String createdAt;
  String applyUserName;
  int state;
  String stateStr;
  int status;
  String statusStr;
  String log;
  int count;
  String password;
  num tax;

  CompanyInfoModel(
      {this.id,
        this.shopName,
        this.mobile,
        this.contractName,
        this.contractMobile,
        this.contractEmail,
        this.processUserName,
        this.processTime,
        this.contractNo,
        this.contractStart,
        this.contractEnd,
        this.contractAttach,
        this.companyName,
        this.registerAddress,
        this.businessAddress,
        this.businessStart,
        this.businessEnd,
        this.businessPhoto,
        this.businessPerson,
        this.taxType,
        this.taxBank,
        this.taxNumber,
        this.taxAccount,
        this.taxPhoto,
        this.taxProve,
        this.createdAt,
        this.applyUserName,
        this.state,
        this.stateStr,
        this.status,
        this.statusStr,
        this.log,
        this.count,
        this.password,
        this.tax});

  CompanyInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopName = json['shop_name'];
    mobile = json['mobile'];
    contractName = json['contract_name'];
    contractMobile = json['contract_mobile'];
    contractEmail = json['contract_email'];
    processUserName = json['process_user_name'];
    processTime = json['process_time'];
    contractNo = json['contract_no'];
    contractStart = json['contract_start'];
    contractEnd = json['contract_end'];
    contractAttach = json['contract_attach'];
    companyName = json['company_name'];
    registerAddress = json['register_address'];
    businessAddress = json['business_address'];
    businessStart = json['business_start'];
    businessEnd = json['business_end'];
    businessPhoto = json['business_photo'];
    businessPerson = json['business_person'];
    taxType = json['tax_type'];
    taxBank = json['tax_bank'];
    taxNumber = json['tax_number'];
    taxAccount = json['tax_account'];
    taxPhoto = json['tax_photo'];
    taxProve = json['tax_prove'];
    createdAt = json['created_at'];
    applyUserName = json['apply_user_name'];
    state = json['state'];
    stateStr = json['state_str'];
    status = json['status'];
    statusStr = json['status_str'];
    log = json['log'];
    count = json['count'];
    password = json['password'];
    tax = json['tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_name'] = this.shopName;
    data['mobile'] = this.mobile;
    data['contract_name'] = this.contractName;
    data['contract_mobile'] = this.contractMobile;
    data['contract_email'] = this.contractEmail;
    data['process_user_name'] = this.processUserName;
    data['process_time'] = this.processTime;
    data['contract_no'] = this.contractNo;
    data['contract_start'] = this.contractStart;
    data['contract_end'] = this.contractEnd;
    data['contract_attach'] = this.contractAttach;
    data['company_name'] = this.companyName;
    data['register_address'] = this.registerAddress;
    data['business_address'] = this.businessAddress;
    data['business_start'] = this.businessStart;
    data['business_end'] = this.businessEnd;
    data['business_photo'] = this.businessPhoto;
    data['business_person'] = this.businessPerson;
    data['tax_type'] = this.taxType;
    data['tax_bank'] = this.taxBank;
    data['tax_number'] = this.taxNumber;
    data['tax_account'] = this.taxAccount;
    data['tax_photo'] = this.taxPhoto;
    data['tax_prove'] = this.taxProve;
    data['created_at'] = this.createdAt;
    data['apply_user_name'] = this.applyUserName;
    data['state'] = this.state;
    data['state_str'] = this.stateStr;
    data['status'] = this.status;
    data['status_str'] = this.statusStr;
    data['log'] = this.log;
    data['count'] = this.count;
    data['password'] = this.password;
    data['tax'] = this.tax;
    return data;
  }
}
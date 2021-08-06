class AirLineModel {
  AirlinesListResponse airlinesListResponse;

  AirLineModel({this.airlinesListResponse});

  AirLineModel.fromJson(Map<String, dynamic> json) {
    airlinesListResponse = json['airlines_list_response'] != null
        ? new AirlinesListResponse.fromJson(json['airlines_list_response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.airlinesListResponse != null) {
      data['airlines_list_response'] = this.airlinesListResponse.toJson();
    }
    return data;
  }
}

class AirlinesListResponse {
  Airlines airlines;

  AirlinesListResponse({this.airlines});

  AirlinesListResponse.fromJson(Map<String, dynamic> json) {
    airlines = json['airlines'] != null
        ? new Airlines.fromJson(json['airlines'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.airlines != null) {
      data['airlines'] = this.airlines.toJson();
    }
    return data;
  }
}

class Airlines {
  List<Airline> airline;

  Airlines({this.airline});

  Airlines.fromJson(Map<String, dynamic> json) {
    if (json['airline'] != null) {
      airline = new List<Airline>();
      json['airline'].forEach((v) {
        airline.add(new Airline.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.airline != null) {
      data['airline'] = this.airline.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Airline {
  String flightCompanyName;
  String flightCompanyCode;
  String flightNo;
  String planeType;
  num adultAirportTax;
  num adultFuelTax;
  String depTime;
  String arriTime;
  String orgCity;
  String orgCityName;
  String dstCity;
  String dstCityName;
  num basePrice;
  num minimum;
  AirSeats airSeats;

  Airline(
      {this.flightCompanyName,
      this.flightCompanyCode,
      this.flightNo,
      this.planeType,
      this.adultAirportTax,
      this.adultFuelTax,
      this.depTime,
      this.arriTime,
      this.orgCity,
      this.orgCityName,
      this.dstCity,
      this.dstCityName,
      this.basePrice,
      this.airSeats});

  Airline.fromJson(Map<String, dynamic> json) {
    flightCompanyName = json['flightCompanyName'];
    flightCompanyCode = json['flightCompanyCode'];
    flightNo = json['flightNo'];
    planeType = json['planeType'];
    adultAirportTax = json['adultAirportTax'];
    adultFuelTax = json['adultFuelTax'];
    depTime = json['depTime'];
    arriTime = json['arriTime'];
    orgCity = json['orgCity'];
    orgCityName = json['orgCityName'];
    dstCity = json['dstCity'];
    dstCityName = json['dstCityName'];
    basePrice = json['basePrice'];
    airSeats = json['airSeats'] != null
        ? new AirSeats.fromJson(json['airSeats'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flightCompanyName'] = this.flightCompanyName;
    data['flightCompanyCode'] = this.flightCompanyCode;
    data['flightNo'] = this.flightNo;
    data['planeType'] = this.planeType;
    data['adultAirportTax'] = this.adultAirportTax;
    data['adultFuelTax'] = this.adultFuelTax;
    data['depTime'] = this.depTime;
    data['arriTime'] = this.arriTime;
    data['orgCity'] = this.orgCity;
    data['orgCityName'] = this.orgCityName;
    data['dstCity'] = this.dstCity;
    data['dstCityName'] = this.dstCityName;
    data['basePrice'] = this.basePrice;
    if (this.airSeats != null) {
      data['airSeats'] = this.airSeats.toJson();
    }
    return data;
  }
}

class AirSeats {
  List<AirSeat> airSeat;

  AirSeats({this.airSeat});

  AirSeats.fromJson(Map<String, dynamic> json) {
    if (json['airSeat'] != null) {
      airSeat = new List<AirSeat>();
      json['airSeat'].forEach((v) {
        airSeat.add(new AirSeat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.airSeat != null) {
      data['airSeat'] = this.airSeat.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AirSeat {
  String airlineCode;
  String seatCode;
  String seatMsg;
  String seatStatus;
  Null serviceLevel;
  num settlePrice;
  Null changePercentAfter;
  Null changePercentBefore;
  Null changeStipulate;
  Null changeTimePoint;
  num commisionMoney;
  String commisionPoint;
  num discount;
  bool hasQueryedStipulate;
  num parPrice;
  num policyId;
  Null refundPercentBefore;
  Null refundPercentAfter;
  String refundStipulate;
  Null refundTimePoint;
  String workTime;
  String vtWorkTime;
  Null verifyKey;

  AirSeat(
      {this.airlineCode,
      this.seatCode,
      this.seatMsg,
      this.seatStatus,
      this.serviceLevel,
      this.settlePrice,
      this.changePercentAfter,
      this.changePercentBefore,
      this.changeStipulate,
      this.changeTimePoint,
      this.commisionMoney,
      this.commisionPoint,
      this.discount,
      this.hasQueryedStipulate,
      this.parPrice,
      this.policyId,
      this.refundPercentBefore,
      this.refundPercentAfter,
      this.refundStipulate,
      this.refundTimePoint,
      this.workTime,
      this.vtWorkTime,
      this.verifyKey});

  AirSeat.fromJson(Map<String, dynamic> json) {
    airlineCode = json['airlineCode'];
    seatCode = json['seatCode'];
    seatMsg = json['seatMsg'];
    seatStatus = json['seatStatus'];
    serviceLevel = json['serviceLevel'];
    settlePrice = json['settlePrice'];
    changePercentAfter = json['changePercentAfter'];
    changePercentBefore = json['changePercentBefore'];
    changeStipulate = json['changeStipulate'];
    changeTimePoint = json['changeTimePoint'];
    commisionMoney = json['commisionMoney'];
    commisionPoint = json['commisionPoint'];
    discount = json['discount'];
    hasQueryedStipulate = json['hasQueryedStipulate'];
    parPrice = json['parPrice'];
    policyId = json['policyId'];
    refundPercentBefore = json['refundPercentBefore'];
    refundPercentAfter = json['refundPercentAfter'];
    refundStipulate = json['refundStipulate'];
    refundTimePoint = json['refundTimePoint'];
    workTime = json['workTime'];
    vtWorkTime = json['vtWorkTime'];
    verifyKey = json['verifyKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['airlineCode'] = this.airlineCode;
    data['seatCode'] = this.seatCode;
    data['seatMsg'] = this.seatMsg;
    data['seatStatus'] = this.seatStatus;
    data['serviceLevel'] = this.serviceLevel;
    data['settlePrice'] = this.settlePrice;
    data['changePercentAfter'] = this.changePercentAfter;
    data['changePercentBefore'] = this.changePercentBefore;
    data['changeStipulate'] = this.changeStipulate;
    data['changeTimePoint'] = this.changeTimePoint;
    data['commisionMoney'] = this.commisionMoney;
    data['commisionPoint'] = this.commisionPoint;
    data['discount'] = this.discount;
    data['hasQueryedStipulate'] = this.hasQueryedStipulate;
    data['parPrice'] = this.parPrice;
    data['policyId'] = this.policyId;
    data['refundPercentBefore'] = this.refundPercentBefore;
    data['refundPercentAfter'] = this.refundPercentAfter;
    data['refundStipulate'] = this.refundStipulate;
    data['refundTimePoint'] = this.refundTimePoint;
    data['workTime'] = this.workTime;
    data['vtWorkTime'] = this.vtWorkTime;
    data['verifyKey'] = this.verifyKey;
    return data;
  }
}

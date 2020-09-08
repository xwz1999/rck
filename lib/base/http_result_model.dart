/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-14  10:25 
 * remark    : 
 * ====================================================
 */

// import 'package:flutter/material.dart';

class HttpResultModel<T> {
  String code;
  T data;
  String msg;
  bool result;

  HttpResultModel(this.code, this.data, this.msg,this.result);
}
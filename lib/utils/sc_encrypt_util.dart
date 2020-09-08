/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-22  13:34 
 * remark    : 
 * ====================================================
 */

import 'package:encrypt/encrypt.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:recook/utils/print_util.dart';

class SCEncryptUtil {
  static final String _serverRSAPublicKey = "assets/keys/server_rsa_public_key.pem";
  static final String _appRSAPrivateKey = "assets/keys/app_rsa_private_key.pem";

  test() async {
//    int timestamp = DateTime.now().second;
//
//    var content = new Utf8Encoder().convert(timestamp.toString());
//    String MD5Str = md5.convert(content).toString().toUpperCase();
//
////  // 时间戳的MD5
////  final key = Key.Key.fromUtf8(digest.toString().toUpperCase());
//
//    Map data = {"userId": 111, "timestamp": timestamp};
//    final paramsJson = json.encode(data);
//    final iv = IV.fromLength(32);
//    final aesKey = Key.fromUtf8(MD5Str);
//    // 使用aes-ecb-256，PKCS7Padding 加密参数
//    final encrypter = Encrypter(AES(aesKey, mode: AESMode.ecb));
//    final paramsEncrypted = encrypter.encrypt(paramsJson, iv: iv);
//
////  final publicKey = await parseKeyFromFile<RSAPublicKey>('test/public.pem');
//    // RSA 加密key
//    String publicKeyString = await rootBundle.loadString('assets/keys/rsa_public_key.pem');
//    RSAPublicKey publicKey = parser.parse(publicKeyString);
//    final rsaEncrypter = Key.Encrypter(Key.RSA(publicKey: publicKey));
//    final rsaEncrypted = rsaEncrypter.encrypt(MD5Str);
//
//    print("rsaPublic ---------- $publicKeyString");
////  final decrypted = encrypter.decrypt(encrypted, iv: iv);
//
//    print("md5key ------ $MD5Str");
////  print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
//    print("RSA 加密 MD5 rsaStr ------ ${rsaEncrypted.base64}"); // R4PxiU
//    print("参数 encrypted ------ ${paramsEncrypted.base64}"); // R4PxiU
//
//    Map param = {"body": paramsEncrypted.base64, "key": rsaEncrypted.base64};
//
//    print("finalParams ---- ${json.encode(param)}");
//    return;
  }

  static String md5Encrypt(String string, {bool log = false}) {
    var content = new Utf8Encoder().convert(string);
    String md5Str = md5.convert(content).toString().toUpperCase();
    if (log) {
      DPrint.printf("AES 加密 ---- $md5Str}");
    }
    return md5Str;
  }

  static Future<String> aesEncrypt({String key, String encryptString,bool log= false}) async {
    final iv = IV.fromLength(32);
    final aesKey = Key.fromUtf8(key);
    // 使用aes-ecb-256，PKCS7Padding 加密参数
    final encrypter = Encrypter(AES(aesKey, mode: AESMode.ecb));
    final paramsEncrypted = encrypter.encrypt(encryptString, iv: iv);
    if (log) {
      DPrint.printf("AES 加密 ---- ${paramsEncrypted.base64}");
    }
    return paramsEncrypted.base64;
  }


  static Future<String> aesDecrypt({String key,String decryptString,bool log = false}) async {
    final iv = IV.fromLength(32);
    final aesKey = Key.fromUtf8(key);
    // 使用aes-ecb-256，PKCS7Padding 加密参数
    final encrypter = Encrypter(AES(aesKey, mode: AESMode.ecb));
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(decryptString), iv: iv);
    if (log) {
      DPrint.printf("AES 解密 ---- $decrypted");
    }
    return decrypted;
  }


  static Future<String> rsaEncrypt({String encryptString,bool log =false}) async {
    final parser = RSAKeyParser();
    String publicKeyString = await rootBundle.loadString(_serverRSAPublicKey);
    RSAPublicKey publicKey = parser.parse(publicKeyString);
    final rsaEncrypter = Encrypter(RSA(publicKey: publicKey));
    final rsaEncrypted = rsaEncrypter.encrypt(encryptString);
    if (log) {
//      DPrint.printf("RSA 公钥 ---- $publicKeyString");
      DPrint.printf("RSA 加密 ---- ${rsaEncrypted.base64}");
    }
    return rsaEncrypted.base64;
  }
  
  static Future<String> rsaDecrypt({String decryptString,bool log = false}) async {
    final parser = RSAKeyParser();
    String privateKeyString = await rootBundle.loadString(_appRSAPrivateKey);
    RSAPrivateKey private = parser.parse(privateKeyString);
    final rsaDecrypter = Encrypter(RSA(privateKey: private));
    final rsaEncrypted = rsaDecrypter.decrypt(Encrypted.fromBase64(decryptString));
    if (log) {
//      DPrint.printf("RSA 私钥 ---- $privateKeyString");
      DPrint.printf("RSA 解密 ---- $rsaEncrypted");
    }
    return rsaEncrypted;
  }
}

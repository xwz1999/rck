/*
 * ====================================================
 * package   : 
 * author    : Created by nansi.
 * time      : 2019-08-22  13:34 
 * remark    : 
 * ====================================================
 */

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:jingyaoyun/utils/print_util.dart';
import 'package:pointycastle/asymmetric/api.dart';

class SCEncryptUtil {
  static final String _serverRSAPublicKey = '''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzNWyjYe3qt4YRTDwANxD
PNLAJ9TZBuHsSqSjJM5B35fABwN3gwm5Q/SCz/6kgKTqeSgCVPFYhO/zOD6G8K7E
JLgx95ZIeAB9EkW+xrhFDDthUZAkA03zHJO6SkFKOciLFVi94BdCdGlNFlnaBBqA
+8XvCpD1V8DFc/9cpb5icZvngu8vEkwkbYceCXKUMNxoXY/E2cFe8f2tVFR5pRkQ
gRLbM70jt4yBGOD8pbuk6fcnD7ghGWgzMq/845N3wISSTp/gAQg8403Fk+8AoL+F
KgxUkjUOpPI2XrcpQm0EphuAX4J0Xvo3Hu6TEPZYyqULEXGT2Jukmh0NSkNO0F39
xwIDAQAB
-----END PUBLIC KEY-----
''';
  static final String _appRSAPrivateKey = '''-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAwJwF6sTXsaenWVz75n991FaIYO06ArFMDRl4g3SgzegHIP3c
3o9QJ+msH90Resowk1On6E1zrVoey55sIiEMnMqxlBrLkYhMZy0hK7eDL53qZ80C
hAxANtmTWV0gPOgaaPb0xrAdDfVgVZepyBTdP8D5t7t6+0BbpHUJeqVyYfZgmLzt
FM2QFDRJ9cWcTJOGe7WVQ483i2J67VYR5hgKMdBWGYJ++6UXzA4EcwkJ/p+yngcl
p5NXZT+Spv7cni/VffmAcp1K+6P4IbRWLpoXQyWc5e9+09q1Djf9Updz2DpJ88fh
RaICRxTteZmoCpqHS2Hr1oKVRe46QlEBEwK3CwIDAQABAoIBABY668Po7Cwo+Xuq
67fyxwcW5a6qMqPU6r4oTmx9rYGWYhxAsJlPWSUCJ0eWMEpHw8t9QEfjiJJdcGh3
5Gsb/WSrUEuTvCMT5B2Ua9ur1oxMYZ2RX9T1xQOPoR4TTYE6GLI8rouwD+pog7Hd
S084eUC+eRPno44UI3+bsnhhWA5OOhXr5JCIr0orYHoAGZTwu/zTRhnNkoCedCS2
4WPhI2meTeP3O7wYNLhkQ94kdupDXnEOIa1XXAxB6gMeDAEq9XIcokARA48Dc1b3
il59W+y4qqbUk5jOXTOim8uxRXIaXl8l5a5oHRYc89PdhJOyifF5KNXFForxUf+u
06K1wiECgYEA5e4M+vgFRd9GITiB1KRAYNfxa1EPjJ7WxLMxi1DUhzJ+HssCJZmc
Gr2LgmDG9iIGcfxqSrcfQcUkfnSfIkqq+Mp7fO89AhzbJL0ix5OJMAb2yQpfncBO
qkupiPMabjagW30MLBmRHKWLmR6srT1OLJreXkT6XsGFoCbd4rnGvdUCgYEA1nK1
jCiEm1ZHSKRV70nAovJyKTvie7z+5I35iiUVxyJ2G5zY5YWkPVdPU44eKqX2xl7a
FstTI/0LTFgBzh43EQ5lXNbLPvyZ58DMiWSEkeBgZa1J8SO53gR99SzSIuTj955B
KZZG7hWfMfEDtU/VKn6W+CW0veTwFWcZHXv6sV8CgYAcoc0p/3KgpdIU1vWL5jxC
EwH0LC70gt8ZtXrI73LXtxjverY0unEu/0V9IdIE2m3VCequjSkuRn9p49nhKk0q
GATSpPQC7Fb5tze6hIvD2Eoo9Mq9WTIykKN281bqPJExc1vtre1dFNxSX/h+xjCS
62IfeRV4cT7Tl6Nv1VSDVQKBgQDBtlzIftFKgGVj+Q6nWLfqeZcmKDIuFEsrqhP/
9f/2IesOhmBm9JGn13aQw4/8dm60Qno+nOw9Vhcen2ECD8kuXxKxClYOT5+2+THJ
6kLWgxiQwDhK2zrKksQ09IfdfWVwCERUjKsF5gIn2s6+uZ6VBETbYzQhVOyKaNcH
CzcpgQKBgCtcw+QtR+YKGBC62AabzOz+KZ+uUYH60R1Q3nbbYx4KuBVbTZPp5/yP
NDL7HaaKOvh1rUrnKh0q0yU6OJuVOw6c9Av6zph9hmfyAiovSEvyEIK6o6w34az/
+4zt/BhRXo24dgnaYZ8a3EEpS0KnlIrgexAWhvTuMAXSeXJXy9B6
-----END RSA PRIVATE KEY-----
''';

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

  static Future<String> aesEncrypt(
      {String key, String encryptString, bool log = false}) async {
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

  static Future<String> aesDecrypt(
      {String key, String decryptString, bool log = false}) async {
    final iv = IV.fromLength(32);
    final aesKey = Key.fromUtf8(key);
    // 使用aes-ecb-256，PKCS7Padding 加密参数
    final encrypter = Encrypter(AES(aesKey, mode: AESMode.ecb));
    final decrypted =
        encrypter.decrypt(Encrypted.fromBase64(decryptString), iv: iv);
    if (log) {
      DPrint.printf("AES 解密 ---- $decrypted");
    }
    return decrypted;
  }

  static Future<String> rsaEncrypt(
      {String encryptString, bool log = false}) async {
    final parser = RSAKeyParser();
    String publicKeyString = _serverRSAPublicKey;
    RSAPublicKey publicKey = parser.parse(publicKeyString);
    final rsaEncrypter = Encrypter(RSA(publicKey: publicKey));
    final rsaEncrypted = rsaEncrypter.encrypt(encryptString);
    if (log) {
//      DPrint.printf("RSA 公钥 ---- $publicKeyString");
      DPrint.printf("RSA 加密 ---- ${rsaEncrypted.base64}");
    }
    return rsaEncrypted.base64;
  }

  static Future<String> rsaDecrypt(
      {String decryptString, bool log = false}) async {
    final parser = RSAKeyParser();
    String privateKeyString = _appRSAPrivateKey;
    RSAPrivateKey private = parser.parse(privateKeyString);
    final rsaDecrypter = Encrypter(RSA(privateKey: private));
    final rsaEncrypted =
        rsaDecrypter.decrypt(Encrypted.fromBase64(decryptString));
    if (log) {
//      DPrint.printf("RSA 私钥 ---- $privateKeyString");
      DPrint.printf("RSA 解密 ---- $rsaEncrypted");
    }
    return rsaEncrypted;
  }
}

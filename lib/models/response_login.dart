import 'package:http/http.dart' as http;
class ResponseLogin {
 late String? accessToken;
  late String? accessTokenExpirationTime;
  late String? refreshToken;
  late String? name ;
  late String? capitalizationName;
  late bool isActive;
  late String? createDated;
  late String? userPassword;
  late String? expiryDate;
  late String? refreshTokens;
  late String? settingUsers;
  late String? representativeInvoices;
  late String? id;
  late String? userName;
  late String? normalizedUserName;
  late String? email;
  late String? normalizedEmail;
  late bool emailConfirmed;
  late String? passwordHash;
  late String? securityStamp;
  late String? concurrencyStamp;
  late String? phoneNumber;
  late bool phoneNumberConfirmed;
  late bool twoFactorEnabled;
  late String? lockoutEnd;
  late bool lockoutEnabled;
  late int accessFailedCount;

 ResponseLogin(
  this.accessToken,
  this.accessTokenExpirationTime,
  this.refreshToken,
  this.name,
 this.capitalizationName,
 this.isActive,
 this.createDated,
 this.userPassword,
 this.expiryDate,
 this.refreshTokens,
 this.settingUsers,
 this.representativeInvoices,
 this.id,
 this.userName,
 this.normalizedUserName,
 this.email,
 this.normalizedEmail,
 this.emailConfirmed,
 this.passwordHash,
 this.securityStamp,
 this.concurrencyStamp,
 this.phoneNumber,
 this.phoneNumberConfirmed,
 this.twoFactorEnabled,
 this.lockoutEnd,
 this.lockoutEnabled,
 this.accessFailedCount);

 ResponseLogin.fromJson(Map<String, dynamic> json)
 {
  accessToken = json['accessToken'];
  accessTokenExpirationTime = json['accessTokenExpirationTime'];
  refreshToken = json['refreshToken'];
  name = json['name'];
  capitalizationName = json['capitalizationName'];
  isActive = json['isActive'];
  createDated = json['createDated'];
  userPassword = json['userPassword'];
  expiryDate = json['expiryDate'];
  refreshTokens = json['refreshTokens'];
  settingUsers = json['settingUsers'];
  representativeInvoices = json['representativeInvoices'];
  id = json['id'];
  userName = json['userName'];
  normalizedUserName = json['normalizedUserName'];
  email = json['email'];
  normalizedEmail = json['normalizedEmail'];
  emailConfirmed = json['emailConfirmed'];
  passwordHash = json['passwordHash'];
  securityStamp = json['securityStamp'];
  concurrencyStamp = json['concurrencyStamp'];
  phoneNumber = json['phoneNumber'];
  phoneNumberConfirmed = json['phoneNumberConfirmed'];
  twoFactorEnabled = json['twoFactorEnabled'];
  lockoutEnd = json['lockoutEnd'];
  lockoutEnabled = json['lockoutEnabled'];
  accessFailedCount = json['accessFailedCount'];


}


}
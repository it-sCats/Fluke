// import 'dart:convert';
// import 'package:googleapis/fcm/v1.dart';
// import 'package:flutter/services.dart';
// import 'package:googleapis/oauth2/v2.dart';
// import 'package:googleapis/apigee/v1.dart';
// import 'package:googleapis/iamcredentials/v1.dart';
// import 'package:googleapis/shared.dart';
// import 'package:oauth2/oauth2.dart';
//
// Future<void> getAccessToken() async {
//   final String response = await rootBundle
//       .loadString('images/fluke-db-firebase-adminsdk-b5tjy-15157f1bf0.json');
//   final data = await json.decode(response);
//   final clientId=data['client_id'];
//   final clientSecret=data['private_key_id'];
// final scopes = [
//   "https://www.googleapis.com/auth/firebase.messaging",
//
// ];
//   handleAuthRespons(AuthorizationCodeGrant grant,Map<String,String> queryPAaams)async{
//     return await grant.handleAuthorizationResponse(queryPAaams);
//   }
// final authEndPoint=Uri.parse(data['auth_uri'] );
// final tokenEndpoint=Uri.parse(data['token_uri']) ;
// final redircturi=Uri.parse('http://localhost:3000/callback');
//   FirebaseCloudMessagingApi();
//   final token = GenerateAccessTokenRequest(
//       lifetime: '5000',
//       delegates: ['./fluke-db-firebase-adminsdk-b5tjy-15157f1bf0.json']);
//   print(token);
// // FirebaseCloudMessagingApi(servicePath: )  print(data['type']);
//   AuthorizationCodeGrant createGrant(){
//     handleAuthRespons(AuthorizationCodeGrant(clientId, authEndPoint, tokenEndpoint,secret: clientSecret),)
//     return AuthorizationCodeGrant(clientId, authEndPoint, tokenEndpoint,secret: clientSecret);
//   }
//   Uri getAuthUri(AuthorizationCodeGrant grant){
//
//     return grant.getAuthorizationUrl(redircturi,scopes: scopes);
//   }
//
//   // ...
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/Model/HttpE.dart';
class auth with ChangeNotifier{
String _token;
DateTime _expiyDate;
String _userId;

 bool get isAuth{
 return token != null;
}

String get token{
  if(_expiyDate != null && _expiyDate.isAfter(DateTime.now())&& _token !=null){
    return _token;
  }
  return null;
}

String get  userId{
   return _userId;
}


Future<void> authentication(String email,String password,String urlSegment) async{
  final ur='https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyD1KvrlDwsRDCJRfFvP3a1u9Y3B434DTQ4';
  try{
    final response = await http.post(ur, body:json.encode({
      'email' :email,
      'password': password,
      'returnSecureToken': true,
    }));
    final responseData=json.decode(response.body);
    if(responseData['error'] !=null) {
      throw HttpExeption(responseData['error']['message']);
    }
//    }
    _token = responseData['ID_TOKEN'];
    _userId =responseData['localId'];
    _expiyDate =DateTime.now().add(Duration( seconds: int.parse(responseData['expiresIn'])));
    notifyListeners();
  }catch(error){
    throw error;
  }

//  print(json.encode(response.body));
}

Future<void> signup(String email,String password) async{
 return authentication(email, password, 'signUp');
}

Future<void> login(String email,String password) async{
return  authentication(email, password,'signInWithPassword');
}

void logout(){
   _userId=null;
   _expiyDate=null;
   _token=null;
   notifyListeners();
}

}






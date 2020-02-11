import 'package:flutter/foundation.dart';

class CultivationType{
  CultivationType({@required this.id,@required this.name,});
  final String id;
  final String name;

  factory CultivationType.fromMap(Map<String, dynamic> data, String documentId){
    if(data==null){
      return null;
    }
    final String name=data['name'];
    return CultivationType(
      id: documentId,
      name: name,

    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name':name,
    };
  }
}

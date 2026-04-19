import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel{
  String? id;
  String? title;
  String? description;
  DateTime? dateTime;

  TaskModel({this.id, this.title, this.description, this.dateTime});

  TaskModel.fromJson(Map<String, dynamic> json){
    title = json['title'];
    description = json['description'];
    dateTime = (json['dateTime'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['dateTime'] = dateTime;
    return data;
  }

}
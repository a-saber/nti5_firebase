class TaskModel{
  String? id;
  String? title;
  String? description;
  DateTime? dateTime;

  TaskModel({this.id, this.title, this.description, this.dateTime});

  TaskModel.fromJson(Map<String, dynamic> json){
    title = json['title'];
    description = json['description'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'description': description,
      'dateTime': dateTime
    };
  }

}
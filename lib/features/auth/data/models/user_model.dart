class UserModel{
  String? id;
  String? name;
  String? phone;
  String? email;

  UserModel({this.id, this.name, this.phone, this.email});

  UserModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    return data;
  }
}
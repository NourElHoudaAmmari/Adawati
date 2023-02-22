class LoginRequestModel{
  LoginRequestModel({
    required this.name,
    required this.password,
  });
  late final String name;
  late final String password;

  LoginRequestModel.fromJson(Map<String, dynamic> json){
    name =json['username'];
    password =json['password'];
  }
  Map<String, dynamic> toJson(){
    final _data =<String, dynamic>{};
    _data['name']=name;
    _data['password']=password;
    return _data;
  }
}
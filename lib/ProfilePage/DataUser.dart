class DataUser {
  //String searchKey;
  String Email;
  String Name;
  String password;
  String phoneNumber;
  String url; //thumbnailUrl
  String uid;
  bool enter;

  DataUser(
      {
        this.enter,
        this.uid,
        this.Email,
        this.Name,
        this.password,
        this.phoneNumber,
        this.url,
      });

  DataUser.fromJson(Map<String, dynamic> json)
  {
    //String upperCaseTitle,lowerCaseTitle,newTitle;
    Email= json['email'];
    Name= json['name'];
    password=json['password'];
    phoneNumber=json['phoneNumber'];
    url= json['url'];
    uid=json['uid'];
    enter=json['enter'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.Email;
    data['name']=this.Name;
    data['password']=this.password;
    data['phoneNumber']=this.phoneNumber;
    data['url'] = this.url;
    data['uid']=this.uid;
    data['enter']=this.enter;
    return data;
  }
}

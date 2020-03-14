class LoginData {
  String password;
  String publicName;
  List<int> chapterTops;
  String icon;
  String nickname;
  bool admin;
  List<int> collectIds;
  int id;
  int type;
  String email;
  String token;
  String username;

  LoginData.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    publicName = json['publicName'];
    chapterTops = json['chapterTops']?.cast<int>();
    icon = json['icon'];
    nickname = json['nickname'];
    admin = json['admin'];
    collectIds = json['collectIds']?.cast<int>();
    id = json['id'];
    type = json['type'];
    email = json['email'];
    token = json['token'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    data['publicName'] = this.publicName;
    data['chapterTops'] = this.chapterTops;
    data['icon'] = this.icon;
    data['nickname'] = this.nickname;
    data['admin'] = this.admin;
    data['collectIds'] = this.collectIds;
    data['id'] = this.id;
    data['type'] = this.type;
    data['email'] = this.email;
    data['token'] = this.token;
    data['username'] = this.username;
    return data;
  }
}

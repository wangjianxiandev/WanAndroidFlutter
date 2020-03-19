class TodoData {
  int completeDate;
  String completeDateStr;
  String content;
  int date;
  String dateStr;
  int id;
  int priority;
  int status;
  String title;
  int type;
  int userId;

  TodoData.fromJson(Map<String, dynamic> json) {
    completeDate = json["completeDate"];
    completeDateStr = json["completeDateStr"];
    content = json["content"];
    date = json["date"];
    dateStr = json["dateStr"];
    id = json["id"];
    priority = json["priority"];
    status = json["status"];
    title = json["title"];
    type = json["type"];
    userId = json["userId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["completeDate"] = this.completeDate;
    data["completeDateStr"] = this.completeDateStr;
    data["content"] = this.content;
    data["date"] = this.date;
    data["dateStr"] = this.dateStr;
    data["id"] = this.id;
    data["prority"] = this.priority;
    data["status"] = this.status;
    data["title"] = this.title;
    data["type"] = this.type;
    data["userId"] = this.userId;
  }
}

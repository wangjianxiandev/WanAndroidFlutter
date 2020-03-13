class BaseResponse {
  Object data;
  int errorCode;
  String errorMessage;

  BaseResponse.fromJson(Map<String, dynamic> json) {
    data = json["data"];
    errorCode = json["errorCode"];
    errorMessage = json["errorMessage"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["data"] = this.data;
    data["errorCode"] = this.errorCode;
    data["errorMessage"] = this.errorMessage;
    return data;
  }
}

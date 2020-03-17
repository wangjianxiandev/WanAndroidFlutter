class CoinData {
  int rank;
  int userId;
  int level;
  String username;
  int coinCount;

  CoinData.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    userId = json['userId'];
    level = json['level'];
    coinCount = json['coinCount'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank'] = this.rank;
    data['userId'] = this.userId;
    data['level'] = this.level;
    data['coinCount'] = this.coinCount;
    data['username'] = this.username;
    return data;
  }
}

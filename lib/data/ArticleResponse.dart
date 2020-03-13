class ArticleResponse {
  int curPage;
  int offset;
  int pageCount;
  int size;
  int total;
  bool over;
  var datas;

  ArticleResponse.fromJson(Map<String, dynamic> json)
      : curPage = json["curPage"],
        offset = json["offset"],
        size = json["size"],
        total = json["total"],
        over = json["over"],
        pageCount = json["pageCount"],
        datas = json["datas"];

  Map<String, dynamic> toJson() => {
    "curPage": curPage,
    "offset": offset,
    "size": size,
    "total": total,
    "over": over,
    "pageCount": pageCount,
    "datas": datas,
  };

  @override
  String toString() {
    return 'ArticleResponse{curPage: $curPage, offset: $offset, pageCount: $pageCount, size: $size, total: $total, over: $over, datas: $datas}';
  }

  bool get hasNoMore => curPage == pageCount;
}

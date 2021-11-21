/*
"status": "ok",
"totalResults": 9812,
-"articles": [
-{
-"source": {
"id": null,
"name": "Hindustan Times"
},
"author": "HT Tech",
"title": "10 viruses that affected",
"description": "10 viruses that attacked company IT systems recently: Trickbot, XMRig, nanocore, Agent Tesla, and more.",
"url": "https://tech.hindustantimes.com/tech/news/10-viruses-that-attacked-companies-recently-trickbot-xmrig-etc-71637121865258.html",
"urlToImage": "https://images.hindustantimes.com/tech/img/2021/11/17/1600x900/computer-background-internet-digital-working-cyberspace-concept_aaae1e22-9991-11e9-823a-db6d52757f3f_1637124345044.jpg",
"publishedAt": "2021-11-17T13:16:00Z",
"content": "10 viruses that attacked companies recently: Cyberattacks are only increasing every day and wreak havoc on the infrastructure. There's a vast amount of phishing attacks and malware distributed across… [+2712 chars]"
},
]
*/
class NewsModel {
  Map<String, dynamic>? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;
  // const NewsModel(this.source, this.author, this.title, this.description,
  //     this.url, this.urlToImage, this.publishedAt, this.content);
  NewsModel.fromJson(Map<String, dynamic> json) {
    this.source = json['source'];
    this.title = json['title'];
    this.description = json['description'];
    this.url = json['url'];
    this.urlToImage = json['urlToImage'];
    this.publishedAt = json['publishedAt'];
    this.content = json['content'];
  }

  Map<String, dynamic> toJson(NewsModel model) {
    Map<String, dynamic> map = {};
    map['source'] = this.source;
    map['title'] = this.title;
    map['description'] = this.description;
    map['url'] = this.url;
    map['urlToImage'] = this.urlToImage;
    map['publishedAt'] = this.publishedAt;
    map['content'] = this.content;

    return map;
  }
}

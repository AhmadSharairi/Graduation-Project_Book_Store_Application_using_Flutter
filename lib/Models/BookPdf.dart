
class BookPdf {
  //String searchKey;
  String pdfUrl;
  String name;
  String urlPicture;
  String uid;
  String publisher;



  BookPdf(
      {
        this.publisher,
        this.uid,
        this.urlPicture,
        this.pdfUrl,
        this.name,

      });

  BookPdf.fromJson(Map<String, dynamic> json)
  {
    //String upperCaseTitle,lowerCaseTitle,newTitle;
    pdfUrl = json['urlPdf'];
    name=json['name'];
    urlPicture=json['urlPicture'];
    uid=json['uid'];
    publisher=json['publisher'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['urlPdf']=this.pdfUrl;
    data['name']=this.name;
    data['urlPicture']=this.urlPicture;
    data['uid']=this.uid;
    data['publisher']=this.publisher;

    return data;
  }
}



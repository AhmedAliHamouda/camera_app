class ImageModel {
  List<String>? files;
  String? folderName;

  ImageModel({required this.files, required this.folderName});

  ImageModel.fromJson(Map<String, dynamic> json) {
    files = json['files'].cast<String>();
    folderName = json['folderName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['files'] = this.files;
    data['folderName'] = this.folderName;
    return data;
  }
}
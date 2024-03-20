class apidata {
  final int id;
  final String name;
  final String imagePath;

  apidata(
      {required this.id, required this.name, required this.imagePath});

  factory apidata.fromJson(Map<String, dynamic> json) {
    return apidata(
      id: json['id'],
      name: json['name'],
      imagePath: json['image_path'],
    );
  }
}
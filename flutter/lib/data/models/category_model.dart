class CategoryModel {
  final int id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: int.parse(json['id'].toString()),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'name': name,
      };
}

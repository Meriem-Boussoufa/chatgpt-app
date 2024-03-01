class Model {
  final String id;
  final int created;
  final String root;

  Model({
    required this.id,
    required this.created,
    required this.root,
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        id: json['id'],
        created: json['created'],
        root: json['root'],
      );

  static List<Model> modelsFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((e) => Model.fromJson(e)).toList();
  }
}

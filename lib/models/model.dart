class Model {
  final String id;
  final int created;
  final String object;
  final String ownedBy;
  Model({
    required this.id,
    required this.created,
    required this.object,
    required this.ownedBy,
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        id: json['id'],
        created: json['created'],
        object: json['object'],
        ownedBy: json['owned_by'],
      );

  static List<Model> modelsFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((e) => Model.fromJson(e)).toList();
  }
}

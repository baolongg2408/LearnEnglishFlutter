class Location {
  final String _id;
  final String _name;

  Location({required String id,required String name}):_id = id, _name = name;

  String get name => _name;

  String get id => _id;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json['id'],
    name: json['name'],
  );

}

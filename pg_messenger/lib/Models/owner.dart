class Owner {
  final String _id;
  final String? _name;

  String get id => _id;
  String? get name => _name;

  const Owner(this._id, this._name);

  Map<String, dynamic> toJson() => {'id': id};

  Owner.fromJson(Map<String, dynamic> json)
      : _id = json["id"],
        _name = json["name"];
}

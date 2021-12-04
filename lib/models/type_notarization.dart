class TypeNotarization {
  String name;
  String id;

  TypeNotarization({this.name, this.id});

  TypeNotarization.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'];

  @override
  String toString() {
    return 'TypeDocument{name: $name, id: $id}';
  }
}

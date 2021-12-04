class Font {
  String id;
  String fontFamily;

  Font();

  Font.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fontFamily = json['fontFamily'];

  @override
  String toString() {
    return 'Font{id: $id, fontFamily: $fontFamily}';
  }
}

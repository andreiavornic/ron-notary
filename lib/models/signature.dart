class Signature {
  String id;
  String textFont;
  bool isChecked;

  Signature(
    this.id,
    this.textFont,
    this.isChecked,
  );

  @override
  String toString() {
    return 'Signature{id: $id, textFont: $textFont, isChecked: $isChecked}';
  }
}

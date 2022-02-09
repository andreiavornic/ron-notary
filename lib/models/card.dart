class Card {
  String id;
  int expMonth;
  int expYear;
  String lastFour;
  String brand;
  String name;
  bool defaultCard;
  bool selected;

  Card({
    this.id,
    this.expMonth,
    this.expYear,
    this.lastFour,
    this.brand,
    this.name,
    this.defaultCard,
    this.selected,
  });

  Card.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        expMonth = json['expMonth'],
        expYear = json['expYear'],
        lastFour = json['lastFour'],
        brand = json['brand'],
        name = json['name'],
        defaultCard = json['defaultCard'],
        selected = false;

  @override
  String toString() {
    return 'Card{id: $id, expMonth: $expMonth, expYear: $expYear, lastFour: $lastFour, brand: $brand, name: $name, defaultCard: $defaultCard, selected: $selected}';
  }
}

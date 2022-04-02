class Transactions {
  int purchaseDate;
  String title;
  String status;
  int price;

  Transactions.fromJson(Map<String, dynamic> json)
      : purchaseDate = json['purchaseDate'],
        title = json['title'],
        status = json['status'],
        price = json['price'];

  @override
  String toString() {
    return 'Transactions{purchaseDate: $purchaseDate, title: $title, status: $status, price: $price}';
  }
}

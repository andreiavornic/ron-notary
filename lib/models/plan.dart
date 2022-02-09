class Plan {
  String id;
  String title;
  String description;
  int price;
  int ronAmount;
  double perSession;
  String planIdAppStore;

  Plan({
    this.id,
    this.title,
    this.description,
    this.price,
    this.perSession,
    this.ronAmount,
    this.planIdAppStore,
  });

  Plan.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        price = json['price'],
        ronAmount = json['ronAmount'],
        planIdAppStore = json['planIdAppStore'],
        perSession = (json['price'] / json['ronAmount']).toDouble();

  @override
  String toString() {
    return 'Plan{id: $id, title: $title, description: $description, price: $price, ronAmount: $ronAmount, perSession: $perSession, planIdAppStore: $planIdAppStore}';
  }
}

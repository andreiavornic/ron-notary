class Notary {
  String id;
  String title;
  String company;
  String ronLicense;
  DateTime ronExpire;
  String address;
  String addressSecond;
  String city;
  String state;
  String zip;
  String companyPhone;
  String companyEmail;

  Notary({
    this.id,
    this.title,
    this.company,
    this.ronLicense,
    this.ronExpire,
    this.address,
    this.addressSecond,
    this.city,
    this.state,
    this.zip,
    this.companyPhone,
    this.companyEmail,
  });

  Notary.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        company = json['company'],
        ronLicense = json['ronLicense'],
        ronExpire = DateTime.parse(json['ronExpire']).toLocal(),
        address = json['address'],
        addressSecond = json['addressSecond'],
        city = json['city'],
        state = json['state'],
        zip = json['zip'],
        companyPhone = json['companyPhone'],
        companyEmail = json['companyEmail'];

  @override
  String toString() {
    return 'Notary{id: $id, title: $title, company: $company, ronLicense: $ronLicense, ronExpire: $ronExpire, address: $address, addressSecond: $addressSecond, city: $city, state: $state, zip: $zip, companyPhone: $companyPhone, companyEmail: $companyEmail}';
  }
}

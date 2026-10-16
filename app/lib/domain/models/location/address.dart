final class Address {
  const Address({
    this.flatNumber,
    this.buildingName,
    this.buildingNumber,
    this.street,
    this.district,
    this.townOrCity,
    this.county,
    this.postcode,
    this.country,
  }) : // Building cannot have a name and a number
       assert(!(buildingName != null && buildingNumber != null));

  final String? flatNumber;

  final String? buildingName;

  final int? buildingNumber;

  final String? street;

  final String? district;

  final String? townOrCity;

  final String? county;

  final String? postcode;

  final String? country;
}

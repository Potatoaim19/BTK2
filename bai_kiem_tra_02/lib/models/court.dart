class Court {
  final int id;
  final String name;
  final double pricePerHour;
  final bool isActive;

  Court({
    required this.id,
    required this.name,
    required this.pricePerHour,
    required this.isActive,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json['id'],
      name: json['name'],
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      isActive: json['isActive'],
    );
  }
}

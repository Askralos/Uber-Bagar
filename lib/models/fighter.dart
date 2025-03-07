class Fighter {
  final int? id;
  String firstName;
  String lastName;
  String image;
  double? rating;
  double? height;
  double? weight;
  int wins;
  String sex;
  int fights;
  int? pricing;
  String description;
  String style;
  double? longitude;
  double? latitude;
  String category;

  Fighter({
    this.id,
    this.firstName = '',
    this.lastName = '',
    this.image = '',
    this.rating = 0,
    this.height,
    this.weight,
    this.wins = 0,
    this.sex = '',
    this.fights = 0,
    this.pricing,
    this.description = '',
    this.style = '',
    this.longitude,
    this.latitude,
    this.category = '',
  });

  // Factory method de conversion depuis un JSON
  factory Fighter.fromJson(Map<String, dynamic> json) {
    return Fighter(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      image: json['image'] ?? 'https://example.com/default-image.png',
      rating: json['rating']?.toDouble(),
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      wins: json['wins'],
      sex: json['sex'] ?? '',
      fights: json['fights'],
      pricing: json['pricing'] != null ? json['pricing'].toInt() : null,
      description: json['description'] ?? '',
      style: json['style'] ?? '',
      longitude: json['longitude']?.toDouble(),
      latitude: json['latitude']?.toDouble(),
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
      'rating': rating,
      'height': height,
      'weight': weight,
      'wins': wins,
      'sex': sex,
      'fights': fights,
      'pricing': pricing,
      'description': description,
      'style': style,
      'Longitude': longitude,
      'Latitude': latitude,
      'category': category,
    };
  }
}

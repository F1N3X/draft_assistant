class Champions {

  final String id;
  final String key;
  final String name;
  final String imageUrl;

  const Champions({
    required this.id,
    required this.key,
    required this.name,
    required this.imageUrl,
  });

  factory Champions.fromJson(Map<String, dynamic> json) {
    final image = json['image'] as Map<String, dynamic>?;
    final imageName = image?['full'] as String?;

    return Champions(
      id: json['id'] as String,
      key: json['key'] as String,
      name: json['name'] as String,
      imageUrl:
          imageName != null && imageName.isNotEmpty
              ? 'https://ddragon.leagueoflegends.com/cdn/13.1.1/img/champion/$imageName'
              : '',
    );
  }
}

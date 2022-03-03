class Profile {
  final String name;
  final String image;

  Profile.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        image = map['image'];

  @override
  String toString() => "Profile<$name>";
}
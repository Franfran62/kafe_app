
class Player {
  final String uid;
  final String name;
  final String firstname;
  final String email;
  final String? avatarUrl;

  Player({
    required this.uid,
    required this.name,
    required this.firstname,
    required this.email,
    this.avatarUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'firstname': firstname,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      uid: map['uid'],
      name: map['name'],
      firstname: map['firstname'],
      email: map['email'],
      avatarUrl: map['avatarUrl'],
    );
  }

   Player copyWith({
    String? uid,
    String? name,
    String? firstname,
    String? email,
    int? deevee,
    int? gold,
    String? avatarUrl,
  }) {
    return Player(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      firstname: firstname ?? this.firstname,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

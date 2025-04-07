
class Player {
  final String uid;
  final String name;
  final String firstname;
  final String email;
  final int deevee;
  final int gold;

  Player({
    required this.uid,
    required this.name,
    required this.firstname,
    required this.email,
    this.deevee = 10,
    this.gold = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'firstname': firstname,
      'email': email,
      'deevee': deevee,
      'gold': gold,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      uid: map['uid'],
      name: map['name'],
      firstname: map['firstname'],
      email: map['email'],
      deevee: map['deevee'],
      gold: map['gold'],
    );
  }
}

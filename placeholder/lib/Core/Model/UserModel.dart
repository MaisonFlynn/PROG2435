class UserModel {
  final String namae;
  final int xp;
  final int rank;
  final int hp;
  final int streak;
  final String? active;
  final String? goal;

  UserModel({
    required this.namae,
    required this.xp,
    required this.rank,
    required this.hp,
    required this.streak,
    this.active,
    this.goal,
  });

  factory UserModel.Deserialize(Map<String, dynamic> map) {
    return UserModel(
      namae: map['Namae'],
      xp: (map['XP'] ?? 0).toInt(),
      rank: (map['Ranku'] ?? 1).toInt(),
      hp: (map['HP'] ?? 10).toInt(),
      streak: (map['Streak'] ?? 0).toInt(),
      active: map['Active'],
      goal: map['Goru'],
    );
  }

  Map<String, dynamic> Serialize() {
    return {
      'Namae': namae,
      'XP': xp,
      'Ranku': rank,
      'HP': hp,
      'Streak': streak,
      'Active': active,
      'Goru': goal,
    };
  }
}

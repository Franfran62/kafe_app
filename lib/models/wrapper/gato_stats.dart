class GatoStats {
  final double gout;
  final double amertume;
  final double teneur;
  final double odorat;

  const GatoStats({
    required this.gout,
    required this.amertume,
    required this.teneur,
    required this.odorat,
  });

  Map<String, dynamic> toMap() => {
    'gout': gout,
    'amertume': amertume,
    'teneur': teneur,
    'odorat': odorat,
  };

  factory GatoStats.fromMap(Map<String, dynamic> map) => GatoStats(
    gout: (map['gout'] as num).toDouble(),
    amertume: (map['amertume'] as num).toDouble(),
    teneur: (map['teneur'] as num).toDouble(),
    odorat: (map['odorat'] as num).toDouble(),
  );

  double get average => (gout + amertume + teneur + odorat) / 4;
}
extension CleanDouble on double {
  String toCleanString() {
    return this % 1 == 0 ? toInt().toString() : toStringAsFixed(1);
  }
}

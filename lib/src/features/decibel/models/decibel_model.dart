class DecibelModel {
  double currentValue;
  final List<double> history;

  DecibelModel({
    this.currentValue = 0.0,
    this.history = const [],
  });

  DecibelModel addToHistory(double value) {
    return DecibelModel(
      currentValue: value,
      history: [...history, value],
    );
  }
}

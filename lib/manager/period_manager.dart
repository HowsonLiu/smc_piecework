import '../model/period.dart';

class PeriodManager {
  PeriodManager._privateConstructor();
  static final PeriodManager _instance =
      PeriodManager._privateConstructor();
  static PeriodManager get instance => _instance;

  List<Period> _periods = [];
  List<Period> get periods => _periods; 
  Period? _curPeriod = null;
  Period? get curPeriod => _curPeriod;
}

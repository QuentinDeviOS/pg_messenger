import 'package:intl/intl.dart';

class Timestamp {
  final String _day;
  final String _time;

  String get day => _day;
  String get time => _time;

  const Timestamp(this._day, this._time);

  Timestamp.fromDateTime(DateTime dateTime)
      : this._day = DateFormat("d MMM").format(dateTime).toString(),
        this._time = DateFormat("Hm").format(dateTime).toString();
}

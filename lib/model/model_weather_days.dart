class Model_Weather_Days{
  var _temp;
  var _time;
  String _desxrption;

  Model_Weather_Days(this._temp,this._time,this._desxrption);

  get temp => _temp;
  get time => _time;
  get desxrption => _desxrption;
}
class modelWeather {
  var _lon;
  var _lat;
  String _main;
  String _description;
  var _temp;
  var _temp_min;
  var _temp_max;
  var _humidity;
  var _speed;
  var _dt;

  modelWeather(
    this._lon,
    this._lat,
    this._main,
    this._description,
    this._temp,
    this._temp_min,
    this._temp_max,
    this._humidity,
    this._speed,
    this._dt,
  );

  get dt => _dt;

  get speed => _speed;

  get humidity => _humidity;

  get temp_max => _temp_max;

  get temp_min => _temp_min;

  get temp => _temp;

  String get description => _description;

  String get main => _main;

  get lat => _lat;

  get lon => _lon;
}

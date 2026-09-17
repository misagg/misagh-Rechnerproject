class ModelData6Days{
  var _dt_txt;
  String _descrption;
  var _temp_min;
  var _temp_max;

  ModelData6Days(this._dt_txt,this._descrption,this._temp_min,this._temp_max);

  get dtTxt => _dt_txt;
  get descrption => _descrption;
  get temp_min => _temp_min;
  get temp_max => _temp_max;
}
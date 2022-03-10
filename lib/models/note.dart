class Note {
  String _title="";
  String _description = "";
  String _date="";
  int _id=0;
  int _priority=0;

  Note(this._title , this._date,this._priority, [this._description = ""]);
  Note.withId(this._id,this._title , this._date,this._priority, [this._description = ""]);

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get description => _description;

  int get priority => _priority;

  set priority(int value) {
    _priority = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  set description(String value) {
    _description = value;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    if (id != null){
      map["id"] = _id;
    }
    map["title"] = _title;
    map["description"] = _description;
    map["priority"] = _priority;
    map["date"] = _date;
    return map;

  }

  // ------- Extract the node object from map object -------

  Note.fromMapToObject(Map<String, dynamic> map){
    this._id = map["id"];
    this._title = map["title"];
    this._description = map["description"];
    this._priority = map["priority"];
    this._date = map["date"];
  }
}
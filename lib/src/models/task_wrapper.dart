/// id : ""
/// title : ""
/// desc : ""
/// due_date : ""
/// status : false

class TaskWrapper {
  TaskWrapper({
    String? id,
    String? title,
    String? desc,
    String? dueDate,
    int? status,
  }) {
    _id = id;
    _title = title;
    _desc = desc;
    _dueDate = dueDate;
    _status = status;
  }

  TaskWrapper.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _desc = json['desc'];
    _dueDate = json['due_date'];
    _status = json['status'];
  }

  String? _id;
  String? _title;
  String? _desc;
  String? _dueDate;
  int? _status;

  TaskWrapper copyWith({
    String? id,
    String? title,
    String? desc,
    String? dueDate,
    int? status,
  }) =>
      TaskWrapper(
        id: id ?? _id,
        title: title ?? _title,
        desc: desc ?? _desc,
        dueDate: dueDate ?? _dueDate,
        status: status ?? _status,
      );

  String? get id => _id;

  String? get title => _title;

  String? get desc => _desc;

  String? get dueDate => _dueDate;

  int? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['desc'] = _desc;
    map['due_date'] = _dueDate;
    map['status'] = _status;
    return map;
  }
}

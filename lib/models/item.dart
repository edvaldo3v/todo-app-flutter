class Item {
  String title;
  bool done;

  Item({required this.title, required this.done});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      title: json['title'],
      done: json['done'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['done'] = this.done;
    return data;
  }
}

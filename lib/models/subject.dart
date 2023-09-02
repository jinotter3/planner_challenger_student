enum SubjectEnum {
  MATH,
  PHYSICS,
  CHEMISTRY,
  BIOLOGY,
  ENGLISH,
  HISTORY,
}

class Subject {
  final SubjectEnum subject;
  final String name;
  final String description;
  final String image;
  final String icon;
  final String color;
  final String textColor;

  Subject({
    required this.subject,
    required this.name,
    required this.description,
    required this.image,
    required this.icon,
    required this.color,
    required this.textColor,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subject: SubjectEnum.values[json['subject']],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      icon: json['icon'],
      color: json['color'],
      textColor: json['textColor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject.index,
      'name': name,
      'description': description,
      'image': image,
      'icon': icon,
      'color': color,
      'textColor': textColor,
    };
  }
}

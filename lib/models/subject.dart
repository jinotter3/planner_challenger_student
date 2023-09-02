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
  final String icon;
  final String color;
  final String textColor;

  Subject({
    required this.subject,
    required this.name,
    required this.icon,
    required this.color,
    required this.textColor,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subject: SubjectEnum.values[json['subject']],
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
      textColor: json['textColor'],
    );
  }

  factory Subject.fromString(String subjectString) {
    switch (subjectString) {
      case 'MATH':
        return Subject(
          subject: SubjectEnum.MATH,
          name: '수학',
          icon: 'math',
          color: '#FFCDD2',
          textColor: '#F44336',
        );
      case 'PHYSICS':
        return Subject(
          subject: SubjectEnum.PHYSICS,
          name: '물리',
          icon: 'physics',
          color: '#BBDEFB',
          textColor: '#2196F3',
        );
      case 'CHEMISTRY':
        return Subject(
          subject: SubjectEnum.CHEMISTRY,
          name: '화학',
          icon: 'chemistry',
          color: '#C8E6C9',
          textColor: '#4CAF50',
        );
      case 'BIOLOGY':
        return Subject(
          subject: SubjectEnum.BIOLOGY,
          name: '생명과학',
          icon: 'biology',
          color: '#F0F4C3',
          textColor: '#CDDC39',
        );
      case 'ENGLISH':
        return Subject(
          subject: SubjectEnum.ENGLISH,
          name: '영어',
          icon: 'english',
          color: '#FFECB3',
          textColor: '#FFC107',
        );
      case 'HISTORY':
        return Subject(
          subject: SubjectEnum.HISTORY,
          name: '한국사',
          icon: 'history',
          color: '#E1BEE7',
          textColor: '#9C27B0',
        );
      default:
        return Subject(
          subject: SubjectEnum.MATH,
          name: '수학',
          icon: 'math',
          color: '#FFCDD2',
          textColor: '#F44336',
        );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject.index,
      'name': name,
      'icon': icon,
      'color': color,
      'textColor': textColor,
    };
  }
}

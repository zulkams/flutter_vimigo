final String tableName = 'contacts';

class ContactFields {
  static final List<String> values = [
    /// Add all fields
    id, user, phone, checkIn
  ];

  static final String id = 'id';
  static final String user = 'user';
  static final String phone = 'phone';
  static final String checkIn = 'checkIn';
}

class Contact {
  final int? id;
  final String? user, phone, checkIn;

  const Contact({
    this.id,
    required this.user,
    required this.phone,
    required this.checkIn,
  });

  Contact copy({
    int? id,
    String? user,
    String? phone,
    String? checkIn,
  }) =>
      Contact(
        id: id,
        user: user,
        phone: phone,
        checkIn: checkIn,
      );

  static Contact fromJson(Map<String, Object?> json) => Contact(
        id: json[ContactFields.id] as int?,
        user: json[ContactFields.user] as String,
        phone: json[ContactFields.phone] as String,
        checkIn: json[ContactFields.checkIn] as String,
      );

  Map<String, Object?> toJson() => {
        ContactFields.id: id,
        ContactFields.user: user,
        ContactFields.phone: phone,
        ContactFields.checkIn: checkIn,
      };
}

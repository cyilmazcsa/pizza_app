enum ConsentType { email, push, sms, analytics }

class Consent {
  Consent({
    required this.type,
    required this.granted,
    required this.updatedAt,
  });

  final ConsentType type;
  final bool granted;
  final DateTime updatedAt;

  Consent copyWith({bool? granted, DateTime? updatedAt}) {
    return Consent(
      type: type,
      granted: granted ?? this.granted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserProfile {
  UserProfile({
    required this.id,
    required this.email,
    this.phone,
    this.phoneVerified = false,
    this.isStudent = false,
    required this.createdAt,
    this.lastOrderAt,
    Map<ConsentType, Consent>? consents,
  }) : consents = consents ?? createDefaultConsents();

  final String id;
  final String email;
  final String? phone;
  final bool phoneVerified;
  final bool isStudent;
  final DateTime createdAt;
  final DateTime? lastOrderAt;
  final Map<ConsentType, Consent> consents;

  UserProfile copyWith({
    String? email,
    String? phone,
    bool? phoneVerified,
    bool? isStudent,
    DateTime? lastOrderAt,
    Map<ConsentType, Consent>? consents,
  }) {
    return UserProfile(
      id: id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      isStudent: isStudent ?? this.isStudent,
      createdAt: createdAt,
      lastOrderAt: lastOrderAt ?? this.lastOrderAt,
      consents: consents ?? this.consents,
    );
  }

  static Map<ConsentType, Consent> createDefaultConsents() {
    final now = DateTime.now();
    return {
      for (final type in ConsentType.values)
        type: Consent(type: type, granted: false, updatedAt: now),
    };
  }
}

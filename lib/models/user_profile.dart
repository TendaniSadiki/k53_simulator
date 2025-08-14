class UserProfile {
  final String uid;
  final String learnersLicenseNumber;
  final String preferredLanguage; // 'en', 'af', 'zu'
  final String vehicleType; // 'motorcycle', 'light', 'heavy'
  final DateTime? testDate;
  final List<TestResult> testHistory;
  final Set<String> weakAreas;
  final Set<String> completedModules;
  final bool darkModeEnabled;
  final bool notificationsEnabled;
  final bool cloudSyncEnabled;
  final bool termsAccepted;
  final bool ageVerified;

  UserProfile({
    required this.uid,
    required this.learnersLicenseNumber,
    required this.preferredLanguage,
    required this.vehicleType,
    this.testDate,
    this.testHistory = const [],
    this.weakAreas = const {},
    this.completedModules = const {},
    this.darkModeEnabled = false,
    this.notificationsEnabled = true,
    this.cloudSyncEnabled = true,
    this.termsAccepted = false,
    this.ageVerified = false,
  });

  UserProfile copyWith({
    String? uid,
    String? learnersLicenseNumber,
    String? preferredLanguage,
    String? vehicleType,
    DateTime? testDate,
    List<TestResult>? testHistory,
    Set<String>? weakAreas,
    Set<String>? completedModules,
    bool? darkModeEnabled,
    bool? notificationsEnabled,
    bool? cloudSyncEnabled,
    bool? termsAccepted,
    bool? ageVerified,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      learnersLicenseNumber: learnersLicenseNumber ?? this.learnersLicenseNumber,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      vehicleType: vehicleType ?? this.vehicleType,
      testDate: testDate ?? this.testDate,
      testHistory: testHistory ?? this.testHistory,
      weakAreas: weakAreas ?? this.weakAreas,
      completedModules: completedModules ?? this.completedModules,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      cloudSyncEnabled: cloudSyncEnabled ?? this.cloudSyncEnabled,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      ageVerified: ageVerified ?? this.ageVerified,
    );
  }

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      learnersLicenseNumber: data['learnersLicenseNumber'] ?? '',
      preferredLanguage: data['preferredLanguage'] ?? 'en',
      vehicleType: data['vehicleType'] ?? 'light',
      testDate: data['testDate'] != null ? DateTime.parse(data['testDate']) : null,
      testHistory: (data['testHistory'] as List? ?? [])
          .map((e) => TestResult.fromMap(e))
          .toList(),
      weakAreas: Set<String>.from(data['weakAreas'] ?? []),
      completedModules: Set<String>.from(data['completedModules'] ?? []),
      darkModeEnabled: data['darkModeEnabled'] ?? false,
      notificationsEnabled: data['notificationsEnabled'] ?? true,
      cloudSyncEnabled: data['cloudSyncEnabled'] ?? true,
      termsAccepted: data['termsAccepted'] ?? false,
      ageVerified: data['ageVerified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'learnersLicenseNumber': learnersLicenseNumber,
      'preferredLanguage': preferredLanguage,
      'vehicleType': vehicleType,
      'testDate': testDate?.toIso8601String(),
      'testHistory': testHistory.map((e) => e.toMap()).toList(),
      'weakAreas': weakAreas.toList(),
      'completedModules': completedModules.toList(),
      'darkModeEnabled': darkModeEnabled,
      'notificationsEnabled': notificationsEnabled,
      'cloudSyncEnabled': cloudSyncEnabled,
      'termsAccepted': termsAccepted,
      'ageVerified': ageVerified,
    };
  }
}

class TestResult {
  final DateTime date;
  final int score;
  final String testType;

  TestResult({
    required this.date,
    required this.score,
    required this.testType,
  });

  factory TestResult.fromMap(Map<String, dynamic> data) {
    return TestResult(
      date: DateTime.parse(data['date']),
      score: data['score'],
      testType: data['testType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'score': score,
      'testType': testType,
    };
  }
}
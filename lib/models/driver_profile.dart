class DriverProfile {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String licenseNumber;
  final String truckId;
  final String imageUrl;
  final DateTime joinDate;
  final List<String> certifications;
  final Map<String, dynamic> stats;

  DriverProfile({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.licenseNumber,
    required this.truckId,
    required this.imageUrl,
    required this.joinDate,
    required this.certifications,
    required this.stats,
  });
}

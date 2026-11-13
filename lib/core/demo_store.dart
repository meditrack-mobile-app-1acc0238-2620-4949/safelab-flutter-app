import 'dart:convert';

import 'package:flutter/services.dart';

/// Sanitized, fictional fixtures from SafeLab Android v2.5.2.
/// Deliberately contains no passwords, credentials or network endpoints.
class DemoStore {
  DemoStore._(this._data);

  final Map<String, dynamic> _data;

  static Future<DemoStore> load() async {
    final data = await rootBundle.loadString('assets/data/demo.json');
    return DemoStore._(jsonDecode(data) as Map<String, dynamic>);
  }

  List<Map<String, dynamic>> records(String key) =>
      ((_data[key] as List<dynamic>?) ?? <dynamic>[])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList(growable: false);

  List<Map<String, dynamic>> get users => records('users');
  List<Map<String, dynamic>> get organizations => records('organizations');
  List<Map<String, dynamic>> get sensors => records('sensors');
  List<Map<String, dynamic>> get assets => records('assets');
  List<Map<String, dynamic>> get alerts => records('alerts');
  List<Map<String, dynamic>> get incidents => records('incidents');
  List<Map<String, dynamic>> get subscriptions => records('subscriptions');
  List<Map<String, dynamic>> get auditLogs => records('auditLogs');

  List<Map<String, dynamic>> forOrganization(
      String key, String? organizationId) {
    final items = records(key);
    if (organizationId == null) return items;
    return items.where((e) => e['organizationId'] == organizationId).toList();
  }

  Map<String, dynamic>? byId(String key, String? id) {
    if (id == null) return null;
    for (final record in records(key)) {
      if (record['id'] == id) return record;
    }
    return null;
  }

  Map<String, dynamic>? findAccount(String identifier) {
    final value = identifier.trim().toLowerCase();
    for (final user in users) {
      final mail = (user['email'] ?? '').toString().toLowerCase();
      final username = (user['username'] ?? '').toString().toLowerCase();
      if (mail == value || username == value) return user;
    }
    return null;
  }
}

String field(Map<String, dynamic> item, String key, [String fallback = '—']) {
  final value = item[key];
  if (value == null || value.toString().isEmpty) return fallback;
  return value.toString();
}

String personName(Map<String, dynamic> user) {
  final name = '${field(user, 'firstName', '')} ${field(user, 'lastName', '')}'.trim();
  return name.isEmpty ? field(user, 'email') : name;
}

String roleName(String role) {
  const roles = <String, String>{
    'platformAdmin': 'Platform Administrator',
    'organizationAdmin': 'General Manager',
    'bioclinicalCoordinator': 'Bioclinical Coordinator',
    'labTechnician': 'Laboratory Technician',
    'complianceOfficer': 'Quality Officer',
    'maintenanceOperator': 'Maintenance Technician',
    'pharmaTechnician': 'Pharmaceutical Technician',
    'pharmaOperationsCoordinator': 'Operations Coordinator',
  };
  return roles[role] ?? role;
}

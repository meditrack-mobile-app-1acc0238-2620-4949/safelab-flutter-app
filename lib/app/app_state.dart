import 'package:flutter/foundation.dart';

import '../core/demo_store.dart';

class SafeLabState extends ChangeNotifier {
  SafeLabState(this.store);

  final DemoStore store;
  Map<String, dynamic>? _currentUser;
  bool darkMode = true;
  bool spanish = false;

  Map<String, dynamic>? get user => _currentUser;
  bool get signedIn => _currentUser != null;
  bool get isPlatform => _currentUser?['role'] == 'platformAdmin';
  String? get organizationId => _currentUser?['organizationId'] as String?;
  String get organizationName => field(_currentUser ?? {}, 'organization', 'SafeLab');

  String t(String en, String es) => spanish ? es : en;

  /// This is intentionally NOT authentication. The offline prototype simply
  /// selects one fictional record; any nonempty password is accepted.
  bool signIn(String identifier, String password) {
    if (password.isEmpty) return false;
    final account = store.findAccount(identifier);
    if (account == null) return false;
    _currentUser = Map<String, dynamic>.from(account);
    notifyListeners();
    return true;
  }

  void signOut() {
    _currentUser = null;
    notifyListeners();
  }

  void toggleTheme() {
    darkMode = !darkMode;
    notifyListeners();
  }

  void toggleLanguage() {
    spanish = !spanish;
    notifyListeners();
  }

  void updateProfile({required String firstName, required String lastName, required String phone}) {
    if (_currentUser == null) return;
    _currentUser = {..._currentUser!,
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'fullName': '${firstName.trim()} ${lastName.trim()}'.trim(),
      'phone': phone.trim(),
      'initials': '${firstName.trim().isNotEmpty ? firstName.trim()[0] : ''}${lastName.trim().isNotEmpty ? lastName.trim()[0] : ''}'.toUpperCase(),
    };
    notifyListeners();
  }
}

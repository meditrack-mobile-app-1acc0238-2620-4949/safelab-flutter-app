import 'package:flutter/material.dart';

import '../core/demo_store.dart';
import '../features/auth/login_screen.dart';
import '../features/home/overview_screens.dart';
import '../features/operations/operations_screens.dart';
import '../features/organizations/organizations_screens.dart';
import '../features/profile/profile_screen.dart';
import '../features/users/users_screens.dart';
import '../shared/widgets/safelab_widgets.dart';
import 'app_state.dart';
import 'app_theme.dart';

class SafeLabApp extends StatefulWidget {
  const SafeLabApp({super.key, required this.store});
  final DemoStore store;

  @override
  State<SafeLabApp> createState() => _SafeLabAppState();
}

class _SafeLabAppState extends State<SafeLabApp> {
  late final SafeLabState state;

  @override
  void initState() {
    super.initState();
    state = SafeLabState(widget.store);
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: state,
    builder: (context, _) => MaterialApp(
      title: 'SafeLab Flutter',
      debugShowCheckedModeBanner: false,
      theme: safeLabTheme(state.darkMode),
      // Keep a phone-sized canvas when presenting the mobile prototype in a
      // desktop browser. On Android phones the layout remains full-width.
      builder: (context, child) {
        if (MediaQuery.sizeOf(context).width < 600) {
          return child ?? const SizedBox.shrink();
        }
        return ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ClipRect(child: child ?? const SizedBox.shrink()),
            ),
          ),
        );
      },
      home: state.signedIn ? SafeLabShell(state: state) : LoginScreen(state: state),
    ),
  );
}

class SafeLabShell extends StatefulWidget {
  const SafeLabShell({super.key, required this.state});
  final SafeLabState state;

  @override
  State<SafeLabShell> createState() => _SafeLabShellState();
}

class _SafeLabShellState extends State<SafeLabShell> {
  String page = 'overview';
  String? recordId;
  final List<(String, String?)> history = [];

  void navigate(String destination, {String? id}) {
    if (destination == page && id == recordId) return;
    setState(() {
      history.add((page, recordId));
      page = destination;
      recordId = id;
    });
  }

  void goBack() {
    if (history.isEmpty) {
      selectPage('overview');
      return;
    }
    final previous = history.removeLast();
    setState(() { page = previous.$1; recordId = previous.$2; });
  }

  void selectPage(String destination) {
    setState(() {
      history.clear();
      page = destination;
      recordId = null;
    });
  }

  String get sectionTitle => switch (page) {
    'overview' => widget.state.isPlatform ? widget.state.t('Overview', 'Resumen') : widget.state.t('Home', 'Inicio'),
    'organizations' || 'organizationDetail' => widget.state.t('Organizations', 'Organizaciones'),
    'users' || 'userDetail' => widget.state.t('Users & permissions', 'Usuarios y permisos'),
    'sensors' => widget.state.t('Sensors', 'Sensores'),
    'alerts' => widget.state.t('Alerts & incidents', 'Alertas e incidentes'),
    'equipment' => widget.state.t('Equipment', 'Equipos'),
    'activity' => widget.state.t('Activity & audit', 'Actividad y auditoría'),
    'subscriptions' => widget.state.t('Subscriptions', 'Suscripciones'),
    'profile' => widget.state.t('My profile', 'Mi perfil'),
    'more' => widget.state.t('More', 'Más'),
    _ => widget.state.t('All records', 'Todos los registros'),
  };

  Widget get body {
    final state = widget.state;
    return switch (page) {
      'overview' => OverviewScreen(state: state, onNavigate: navigate),
      'organizations' => OrganizationsScreen(state: state, onNavigate: navigate),
      'organizationDetail' => OrganizationDetailScreen(state: state, organizationId: recordId, onNavigate: navigate),
      'users' => UsersScreen(state: state, onNavigate: navigate),
      'userDetail' => UserDetailScreen(state: state, userId: recordId),
      'profile' => ProfileScreen(state: state),
      'more' => MoreScreen(state: state, onNavigate: navigate),
      'sensors' || 'alerts' || 'equipment' || 'activity' || 'subscriptions' => OperationsScreen(state: state, kind: page, onNavigate: navigate),
      _ when page.startsWith('recordDetail:') => OperationDetailScreen(state: state, kind: page.substring('recordDetail:'.length), recordId: recordId),
      _ => OverviewScreen(state: state, onNavigate: navigate),
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isPlatform = state.isPlatform;
    final destinations = isPlatform
        ? <(String, String, IconData)>[
            ('overview', state.t('Overview', 'Resumen'), Icons.grid_view_rounded),
            ('organizations', state.t('Organizations', 'Empresas'), Icons.business_outlined),
            ('activity', state.t('Activity', 'Actividad'), Icons.history_rounded),
            ('more', state.t('More', 'Más'), Icons.apps_rounded),
          ]
        : <(String, String, IconData)>[
            ('overview', state.t('Home', 'Inicio'), Icons.home_rounded),
            ('sensors', state.t('Sensors', 'Sensores'), Icons.sensors_rounded),
            ('alerts', state.t('Alerts', 'Alertas'), Icons.notifications_outlined),
            ('equipment', state.t('Equipment', 'Equipos'), Icons.settings_outlined),
            ('more', state.t('More', 'Más'), Icons.apps_rounded),
          ];
    final active = destinations.indexWhere((e) => e.$1 == page);
    final selected = active >= 0 ? active : destinations.indexWhere((e) => e.$1 == 'more');

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        leadingWidth: 62,
        leading: history.isNotEmpty
            ? IconButton(onPressed: goBack, icon: const Icon(Icons.arrow_back, color: SafeLabPalette.primary), tooltip: 'Back')
            : Padding(padding: const EdgeInsets.only(left: 15, top: 12, bottom: 12), child: const BrandLogo(size: 42)),
        titleSpacing: 6,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('SafeLab', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19)),
          Text(sectionTitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: mutedColor(context), fontWeight: FontWeight.w500)),
        ]),
        actions: [
          IconButton(onPressed: state.toggleTheme, icon: Icon(state.darkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined), tooltip: 'Theme'),
          InkWell(onTap: state.toggleLanguage, borderRadius: BorderRadius.circular(50), child: CircleAvatar(radius: 21, backgroundColor: SafeLabPalette.primary, child: Text(state.spanish ? 'ES' : 'EN', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)))),
          const SizedBox(width: 7),
          InkWell(onTap: () => navigate('profile'), borderRadius: BorderRadius.circular(50), child: CircleAvatar(radius: 21, backgroundColor: SafeLabPalette.blue, child: Text(field(state.user ?? {}, 'initials', 'SL'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)))),
          const SizedBox(width: 13),
        ],
      ),
      body: body,
      bottomNavigationBar: NavigationBar(
        backgroundColor: panelColor(context),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorColor: state.darkMode ? const Color(0xFFE4DFFF) : const Color(0xFFEDE9FE),
        selectedIndex: selected < 0 ? 0 : selected,
        onDestinationSelected: (index) => selectPage(destinations[index].$1),
        destinations: destinations.map((item) => NavigationDestination(
          icon: Icon(item.$3, color: mutedColor(context)),
          selectedIcon: Icon(item.$3, color: SafeLabPalette.primary),
          label: item.$2,
        )).toList(),
      ),
    );
  }
}

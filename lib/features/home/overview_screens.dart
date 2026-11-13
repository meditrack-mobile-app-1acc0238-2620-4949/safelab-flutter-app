import 'package:flutter/material.dart';

import '../../app/app_state.dart';
import '../../app/app_theme.dart';
import '../../core/demo_store.dart';
import '../../shared/widgets/safelab_widgets.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key, required this.state, required this.onNavigate});
  final SafeLabState state;
  final NavigateTo onNavigate;

  @override
  Widget build(BuildContext context) => state.isPlatform
      ? _platform(context) : _tenant(context);

  Widget _platform(BuildContext context) {
    final repo = state.store;
    final alertCount = repo.alerts.where((e) => field(e, 'status') == 'active').length;
    return ScreenBody(children: [
      HeroPanel(title: state.t('Platform overview', 'Resumen de plataforma'), subtitle: state.t('Companies, subscriptions and operations.', 'Empresas, suscripciones y operaciones.')),
      const SizedBox(height: 17),
      MetricGrid(children: [
        MetricCard(title: state.t('Companies', 'Empresas'), value: '${repo.organizations.length}', subtitle: state.t('Registered', 'Registradas'), color: SafeLabPalette.primary, icon: Icons.apartment_rounded, onTap: () => onNavigate('organizations')),
        MetricCard(title: state.t('Active plans', 'Planes activos'), value: '${repo.subscriptions.where((e) => e['status'] == 'active').length}', subtitle: state.t('Subscriptions', 'Suscripciones'), color: SafeLabPalette.success, icon: Icons.credit_card, onTap: () => onNavigate('subscriptions')),
        MetricCard(title: state.t('Users', 'Usuarios'), value: '${repo.users.length}', subtitle: state.t('Accounts', 'Cuentas'), color: SafeLabPalette.primary, icon: Icons.people_alt_outlined, onTap: () => onNavigate('users')),
        MetricCard(title: state.t('Sensors', 'Sensores'), value: '${repo.sensors.length}', subtitle: state.t('Devices', 'Dispositivos'), color: const Color(0xFF0891B2), icon: Icons.sensors, onTap: () => onNavigate('sensors')),
        MetricCard(title: state.t('Open alerts', 'Alertas abiertas'), value: '$alertCount', subtitle: state.t('Requires review', 'Requiere revisión'), color: SafeLabPalette.danger, icon: Icons.notifications_active_outlined, onTap: () => onNavigate('alerts')),
        MetricCard(title: state.t('Receipts', 'Recibos'), value: '${repo.subscriptions.length}', subtitle: state.t('Upcoming', 'Próximos'), color: SafeLabPalette.amber, icon: Icons.receipt_long, onTap: () => onNavigate('subscriptions')),
      ]),
      SectionTitle(state.t('Organizations', 'Organizaciones'), trailing: TextButton(onPressed: () => onNavigate('organizations'), child: Text(state.t('See all', 'Ver todas')))),
      ...repo.organizations.map((organization) => RecordCard(
        title: field(organization, 'name'),
        subtitle: '${field(organization, 'city')} · ${field(organization, 'segment')}',
        onTap: () => onNavigate('organizationDetail', id: field(organization, 'id')),
      )),
    ]);
  }

  Widget _tenant(BuildContext context) {
    final repo = state.store;
    final id = state.organizationId;
    final sensors = repo.forOrganization('sensors', id);
    final assets = repo.forOrganization('assets', id);
    final alerts = repo.forOrganization('alerts', id);
    final incidents = repo.forOrganization('incidents', id);
    final online = sensors.where((e) => field(e, 'connection').toLowerCase() == 'online' || field(e, 'connection').toLowerCase() == 'connected').length;
    return ScreenBody(children: [
      HeroPanel(title: state.t('Dashboard', 'Panel principal'), subtitle: state.organizationName),
      const SizedBox(height: 17),
      MetricGrid(children: [
        MetricCard(title: state.t('Sensors', 'Sensores'), value: '${sensors.length}', subtitle: state.t('Assigned devices', 'Dispositivos asignados'), color: SafeLabPalette.primary, icon: Icons.sensors, onTap: () => onNavigate('sensors')),
        MetricCard(title: state.t('Online', 'En línea'), value: '$online', subtitle: state.t('Connected sensors', 'Sensores conectados'), color: SafeLabPalette.success, icon: Icons.wifi, onTap: () => onNavigate('sensors')),
        MetricCard(title: state.t('Equipment', 'Equipos'), value: '${assets.length}', subtitle: state.t('Tracked assets', 'Activos registrados'), color: const Color(0xFF0891B2), icon: Icons.settings_outlined, onTap: () => onNavigate('equipment')),
        MetricCard(title: state.t('Alerts', 'Alertas'), value: '${alerts.where((e) => e['status'] == 'active').length}', subtitle: state.t('Require attention', 'Requieren atención'), color: SafeLabPalette.danger, icon: Icons.notifications_outlined, onTap: () => onNavigate('alerts')),
      ]),
      const SizedBox(height: 12),
      MetricCard(title: state.t('Incidents', 'Incidentes'), value: '${incidents.where((e) => e['status'] != 'resolved').length}', subtitle: state.t('Open investigations', 'Investigaciones abiertas'), color: SafeLabPalette.amber, icon: Icons.report_problem_outlined, onTap: () => onNavigate('alerts')),
      SectionTitle(state.t('Quick access', 'Accesos rápidos')),
      RecordCard(title: state.t('Sensors', 'Sensores'), subtitle: state.t('Readings and connected devices', 'Lecturas y dispositivos conectados'), onTap: () => onNavigate('sensors')),
      RecordCard(title: state.t('Alerts & incidents', 'Alertas e incidentes'), subtitle: state.t('Review current events', 'Revisar eventos actuales'), onTap: () => onNavigate('alerts')),
      RecordCard(title: state.t('Users & permissions', 'Usuarios y permisos'), subtitle: state.t('Organization staff and accounts', 'Personal y cuentas de la empresa'), onTap: () => onNavigate('users')),
    ]);
  }
}

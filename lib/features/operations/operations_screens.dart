import 'package:flutter/material.dart';

import '../../app/app_state.dart';
import '../../app/app_theme.dart';
import '../../core/demo_store.dart';
import '../../shared/widgets/safelab_widgets.dart';

class OperationsScreen extends StatelessWidget {
  const OperationsScreen({super.key, required this.state, required this.kind, required this.onNavigate});
  final SafeLabState state;
  final String kind;
  final NavigateTo onNavigate;

  String _title() => switch (kind) {
    'sensors' => state.t('Sensors', 'Sensores'),
    'alerts' => state.t('Alerts & incidents', 'Alertas e incidentes'),
    'equipment' => state.t('Equipment', 'Equipos'),
    'activity' => state.t('Activity & audit', 'Actividad y auditoría'),
    'subscriptions' => state.t('Subscriptions', 'Suscripciones'),
    _ => kind,
  };

  String _subtitle() => switch (kind) {
    'sensors' => state.t('Latest device readings and health.', 'Últimas lecturas y estado de dispositivos.'),
    'alerts' => state.t('Review ongoing events and incidents.', 'Revisa eventos e incidentes actuales.'),
    'equipment' => state.t('Tracked cold-chain equipment.', 'Equipamiento de cadena de frío.'),
    'activity' => state.t('Recent sample audit actions.', 'Registro de acciones de demostración.'),
    'subscriptions' => state.t('Current organization plans.', 'Planes de suscripción vigentes.'),
    _ => '',
  };

  @override
  Widget build(BuildContext context) {
    final dataKey = kind == 'equipment' ? 'assets' : kind == 'activity' ? 'auditLogs' : kind;
    final records = state.store.forOrganization(dataKey, state.isPlatform ? null : state.organizationId);
    return ScreenBody(children: [
      HeroPanel(title: _title(), subtitle: _subtitle()),
      SectionTitle(state.t('All records', 'Todos los registros')),
      if (records.isEmpty) EmptyState(message: state.t('No demo records.', 'No hay registros de ejemplo.')),
      ...records.map((item) {
        final title = kind == 'activity' ? field(item, 'action')
            : kind == 'subscriptions' ? field(item, 'plan')
            : field(item, kind == 'alerts' ? 'title' : 'name', field(item, 'code', 'Sample record'));
        final subtitle = kind == 'sensors' ? '${field(item, 'code')} · ${field(item, 'value')} ${field(item, 'unit', '')}'
            : kind == 'alerts' ? field(item, 'message')
            : kind == 'equipment' ? '${field(item, 'category')} · ${field(item, 'location')}'
            : kind == 'subscriptions' ? '${field(item, 'organizationId')} · ${field(item, 'renewalDate')}'
            : '${field(item, 'actor')} · ${field(item, 'module')}';
        return RecordCard(
          title: title,
          subtitle: subtitle,
          status: field(item, kind == 'sensors' ? 'connection' : 'status', ''),
          onTap: () => onNavigate('recordDetail:$dataKey', id: field(item, 'id')),
        );
      }),
      if (kind == 'alerts') ...[
        SectionTitle(state.t('Incidents', 'Incidentes')),
        ...state.store.forOrganization('incidents', state.isPlatform ? null : state.organizationId).map((incident) => RecordCard(
          title: field(incident, 'title'),
          subtitle: field(incident, 'code'),
          status: field(incident, 'status'),
          onTap: () => onNavigate('recordDetail:incidents', id: field(incident, 'id')),
        )),
      ],
    ]);
  }
}

class OperationDetailScreen extends StatelessWidget {
  const OperationDetailScreen({super.key, required this.state, required this.kind, required this.recordId});
  final SafeLabState state;
  final String kind;
  final String? recordId;

  @override
  Widget build(BuildContext context) {
    final record = state.store.byId(kind, recordId);
    if (record == null) return ScreenBody(children: [EmptyState(message: state.t('Record not found.', 'Registro no encontrado.'))]);
    final title = field(record, 'title', field(record, 'name', field(record, 'plan', field(record, 'action'))));
    return ScreenBody(children: [
      HeroPanel(title: title, subtitle: state.t('Detail of sample record', 'Detalle del registro de ejemplo')),
      SectionTitle(state.t('Information', 'Información')),
      SafeLabPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: record.entries.where((e) => e.value != null && e.value is! List && e.value is! Map)
            .map((e) => DataRowItem(label: e.key, value: '${e.value}')).toList(),
      )),
    ]);
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key, required this.state, required this.onNavigate});
  final SafeLabState state;
  final NavigateTo onNavigate;

  @override
  Widget build(BuildContext context) => ScreenBody(children: [
    HeroPanel(title: state.t('More', 'Más opciones'), subtitle: state.t('Your workspace, team and account.', 'Tu espacio, equipo y cuenta.')),
    SectionTitle(state.t('Workspace', 'Espacio de trabajo')),
    RecordCard(title: state.t('My profile', 'Mi perfil'), subtitle: state.t('Personal information', 'Información personal'), onTap: () => onNavigate('profile')),
    RecordCard(title: state.t('Users & Permissions', 'Usuarios y permisos'), subtitle: state.t('Accounts, roles and invitations', 'Cuentas, roles e invitaciones'), onTap: () => onNavigate('users')),
    RecordCard(title: state.t('Organizations', 'Organizaciones'), subtitle: state.t('Companies and their facilities', 'Empresas e instalaciones'), onTap: () => onNavigate('organizations')),
    RecordCard(title: state.t('Subscriptions', 'Suscripciones'), subtitle: state.t('Plans and payment cycles', 'Planes y ciclos de pago'), onTap: () => onNavigate('subscriptions')),
    RecordCard(title: state.t('Activity & audit', 'Actividad y auditoría'), subtitle: state.t('Traceability records', 'Registros de trazabilidad'), onTap: () => onNavigate('activity')),
    SectionTitle(state.t('Session', 'Sesión')),
    SafeLabPanel(onTap: state.signOut, child: Row(children: [
      const Icon(Icons.logout, color: SafeLabPalette.danger),
      const SizedBox(width: 12),
      Text(state.t('Sign out', 'Cerrar sesión'), style: const TextStyle(color: SafeLabPalette.danger, fontWeight: FontWeight.w800)),
    ])),
    const SizedBox(height: 20),
    Text(state.t('SafeLab Flutter · AV2 UI prototype · Offline mocks', 'SafeLab Flutter · Prototipo AV2 · Datos locales'), textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: mutedColor(context))),
  ]);
}

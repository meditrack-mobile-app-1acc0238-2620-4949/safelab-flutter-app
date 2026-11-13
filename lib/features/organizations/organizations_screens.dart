import 'package:flutter/material.dart';

import '../../app/app_state.dart';
import '../../app/app_theme.dart';
import '../../core/demo_store.dart';
import '../../shared/widgets/safelab_widgets.dart';

class OrganizationsScreen extends StatelessWidget {
  const OrganizationsScreen({super.key, required this.state, required this.onNavigate});
  final SafeLabState state;
  final NavigateTo onNavigate;

  @override
  Widget build(BuildContext context) {
    final orgs = state.isPlatform ? state.store.organizations
        : state.store.organizations.where((o) => o['id'] == state.organizationId).toList();
    return ScreenBody(children: [
      HeroPanel(title: state.t('Organizations', 'Organizaciones'), subtitle: state.t('Browse registered companies and their facilities.', 'Consulta las empresas registradas y sus instalaciones.')),
      SectionTitle(state.t('Registered companies', 'Empresas registradas')),
      ...orgs.map((org) => RecordCard(
        title: field(org, 'name'),
        subtitle: '${field(org, 'city')} · ${field(org, 'segment')}',
        status: field(org, 'status'),
        onTap: () => onNavigate('organizationDetail', id: field(org, 'id')),
      )),
    ]);
  }
}

class OrganizationDetailScreen extends StatelessWidget {
  const OrganizationDetailScreen({super.key, required this.state, required this.organizationId, required this.onNavigate});
  final SafeLabState state;
  final String? organizationId;
  final NavigateTo onNavigate;

  @override
  Widget build(BuildContext context) {
    final org = state.store.byId('organizations', organizationId);
    if (org == null) return ScreenBody(children: [EmptyState(message: state.t('Organization not found.', 'Organización no encontrada.'))]);
    final id = field(org, 'id');
    final users = state.store.forOrganization('users', id);
    final sensors = state.store.forOrganization('sensors', id);
    final subscription = state.store.forOrganization('subscriptions', id);
    return ScreenBody(children: [
      HeroPanel(title: field(org, 'name'), subtitle: '${field(org, 'city')} · ${field(org, 'segment')}', child: Align(alignment: Alignment.centerLeft, child: StatusPill(field(org, 'status')))),
      SectionTitle(state.t('Company information', 'Datos de la empresa')),
      SafeLabPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DataRowItem(label: 'RUC', value: field(org, 'ruc')),
        DataRowItem(label: state.t('Email', 'Correo'), value: field(org, 'corporateEmail')),
        DataRowItem(label: state.t('City', 'Ciudad'), value: field(org, 'city')),
        DataRowItem(label: state.t('Organization ID', 'ID de empresa'), value: id),
      ])),
      SectionTitle(state.t('Activity', 'Actividad')),
      MetricGrid(children: [
        MetricCard(title: state.t('Users', 'Usuarios'), value: '${users.length}', subtitle: state.t('Members', 'Miembros'), color: SafeLabPalette.primary, icon: Icons.people_outline, onTap: () => onNavigate('users')),
        MetricCard(title: state.t('Sensors', 'Sensores'), value: '${sensors.length}', subtitle: state.t('Devices', 'Dispositivos'), color: SafeLabPalette.teal, icon: Icons.sensors, onTap: () => onNavigate('sensors')),
      ]),
      SectionTitle(state.t('Subscription', 'Suscripción')),
      if (subscription.isEmpty) EmptyState(message: state.t('No sample subscription.', 'Sin suscripción de ejemplo.'))
      else RecordCard(title: field(subscription.first, 'plan'), subtitle: state.t('Monthly plan · Sample data', 'Plan mensual · Datos de ejemplo'), status: field(subscription.first, 'status'), onTap: () => onNavigate('subscriptions')),
      SectionTitle(state.t('Team', 'Equipo')),
      ...users.take(4).map((user) => RecordCard(title: personName(user), subtitle: roleName(field(user, 'role')), onTap: () => onNavigate('userDetail', id: field(user, 'id')))),
    ]);
  }
}

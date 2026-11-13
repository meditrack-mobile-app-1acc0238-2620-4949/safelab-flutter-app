import 'package:flutter/material.dart';

import '../../app/app_state.dart';
import '../../app/app_theme.dart';
import '../../core/demo_store.dart';
import '../../shared/widgets/safelab_widgets.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key, required this.state, required this.onNavigate});
  final SafeLabState state;
  final NavigateTo onNavigate;

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final members = state.isPlatform ? state.store.users : state.store.forOrganization('users', state.organizationId);
    final employees = members.where((u) => u['role'] != 'organizationAdmin' && u['role'] != 'platformAdmin').toList();
    final active = employees.where((u) => u['status'] == 'active').length;
    return ScreenBody(children: [
      HeroPanel(title: state.t('Users & Permissions', 'Usuarios y permisos'), subtitle: state.t('Manage your organization’s staff, invitations, permissions and assignments.', 'Consulta el personal, las invitaciones, permisos y asignaciones.')),
      const SizedBox(height: 16),
      MetricGrid(children: [
        MetricCard(title: state.t('Active employees', 'Empleados activos'), value: '$active', subtitle: state.t('Current staff', 'Personal actual'), color: SafeLabPalette.success, icon: Icons.people_outline),
        MetricCard(title: state.t('Accounts', 'Cuentas'), value: '${members.length}', subtitle: state.t('Available records', 'Registros disponibles'), color: SafeLabPalette.primary, icon: Icons.badge_outlined),
      ]),
      const SizedBox(height: 18),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: List.generate(3, (i) {
        final labels = [state.t('Employees', 'Empleados'), state.t('Invitations', 'Invitaciones'), state.t('Permissions', 'Permisos')];
        return Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(
          selected: tab == i,
          showCheckmark: false,
          label: Text(labels[i]),
          selectedColor: SafeLabPalette.primary,
          labelStyle: TextStyle(color: tab == i ? Colors.white : SafeLabPalette.primary, fontWeight: FontWeight.w600),
          onSelected: (_) => setState(() => tab = i),
        ));
      }))),
      if (tab == 0) ...[
        SectionTitle(state.t('Employees in your organization', 'Empleados de la organización')),
        ...members.map((user) => RecordCard(
          title: personName(user),
          subtitle: '${roleName(field(user, 'role'))} · ${field(user, 'email')}',
          status: field(user, 'status'),
          onTap: () => widget.onNavigate('userDetail', id: field(user, 'id')),
        )),
      ] else if (tab == 1) ...[
        SectionTitle(state.t('Invitations', 'Invitaciones')),
        EmptyState(message: state.t('This demo has no pending invitations. Invitation sending requires the full backend.', 'No hay invitaciones pendientes en este prototipo. El envío requiere el backend completo.')),
      ] else ...[
        SectionTitle(state.t('Roles & access', 'Roles y acceso')),
        ...members.map((user) => RecordCard(title: personName(user), subtitle: roleName(field(user, 'role')), status: field(user, 'status'), onTap: () => widget.onNavigate('userDetail', id: field(user, 'id')))),
      ],
    ]);
  }
}

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.state, required this.userId});
  final SafeLabState state;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final user = state.store.byId('users', userId);
    if (user == null) return ScreenBody(children: [EmptyState(message: state.t('User not found.', 'Usuario no encontrado.'))]);
    return ScreenBody(children: [
      HeroPanel(title: personName(user), subtitle: roleName(field(user, 'role')), child: Align(alignment: Alignment.centerLeft, child: StatusPill(field(user, 'status')))),
      SectionTitle(state.t('Account information', 'Información de la cuenta')),
      SafeLabPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DataRowItem(label: state.t('First names', 'Nombres'), value: field(user, 'firstName')),
        DataRowItem(label: state.t('Last names', 'Apellidos'), value: field(user, 'lastName')),
        DataRowItem(label: state.t('Email', 'Correo'), value: field(user, 'email')),
        DataRowItem(label: state.t('Username', 'Usuario'), value: field(user, 'username')),
        DataRowItem(label: state.t('Phone', 'Teléfono'), value: field(user, 'phone')),
        DataRowItem(label: state.t('Organization', 'Organización'), value: field(user, 'organization')),
        DataRowItem(label: state.t('Role', 'Rol'), value: roleName(field(user, 'role'))),
      ])),
    ]);
  }
}

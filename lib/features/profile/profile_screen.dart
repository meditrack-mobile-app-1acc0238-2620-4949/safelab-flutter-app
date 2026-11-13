import 'package:flutter/material.dart';

import '../../app/app_state.dart';
import '../../app/app_theme.dart';
import '../../core/demo_store.dart';
import '../../shared/widgets/safelab_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.state});
  final SafeLabState state;

  Future<void> _edit(BuildContext context) async {
    final first = TextEditingController(text: field(state.user ?? {}, 'firstName', ''));
    final last = TextEditingController(text: field(state.user ?? {}, 'lastName', ''));
    final phone = TextEditingController(text: field(state.user ?? {}, 'phone', ''));
    final save = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
      title: Text(state.t('Edit profile (local only)', 'Editar perfil (solo local)')),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: first, decoration: InputDecoration(labelText: state.t('First names', 'Nombres'))),
        const SizedBox(height: 12),
        TextField(controller: last, decoration: InputDecoration(labelText: state.t('Last names', 'Apellidos'))),
        const SizedBox(height: 12),
        TextField(controller: phone, decoration: InputDecoration(labelText: state.t('Phone', 'Teléfono'))),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(state.t('Cancel', 'Cancelar'))),
        TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(state.t('Save', 'Guardar'))),
      ],
    ));
    if (save == true && first.text.trim().isNotEmpty && last.text.trim().isNotEmpty) {
      state.updateProfile(firstName: first.text, lastName: last.text, phone: phone.text);
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.t('Saved in memory (demo)', 'Guardado temporalmente (demo)'))));
    }
    // Do not dispose input controllers while the alert route is still animating.
  }

  @override
  Widget build(BuildContext context) {
    final user = state.user ?? {};
    final name = personName(user);
    final initials = field(user, 'initials', 'SL');
    return ScreenBody(children: [
      SafeLabPanel(gradient: true, padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(state.t('My profile', 'Mi perfil'), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(state.t('View and update your personal information.', 'Consulta y modifica tu información personal.'), style: TextStyle(color: mutedColor(context), fontSize: 15)),
        const SizedBox(height: 22),
        Row(children: [
          CircleAvatar(radius: 38, backgroundColor: SafeLabPalette.primary, child: Text(initials, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
            Text('@${field(user, 'username')}', style: TextStyle(color: mutedColor(context))),
          ])),
        ]),
      ])),
      SectionTitle(state.t('Personal information', 'Información personal'), trailing: OutlinedButton.icon(onPressed: () => _edit(context), icon: const Icon(Icons.edit_outlined, size: 17), label: Text(state.t('Edit', 'Editar')))),
      SafeLabPanel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DataRowItem(label: state.t('First names', 'Nombres'), value: field(user, 'firstName')),
        DataRowItem(label: state.t('Last names', 'Apellidos'), value: field(user, 'lastName')),
        DataRowItem(label: state.t('Username', 'Usuario'), value: field(user, 'username')),
        DataRowItem(label: state.t('Email', 'Correo'), value: field(user, 'email')),
        DataRowItem(label: state.t('Mobile phone', 'Celular'), value: field(user, 'phone')),
        DataRowItem(label: state.t('Role', 'Rol'), value: roleName(field(user, 'role'))),
        DataRowItem(label: state.t('Organization', 'Organización'), value: field(user, 'organization')),
      ])),
      const SizedBox(height: 17),
      EmptyState(message: state.t('This screen stores profile changes only in memory. It does not modify Neon or the production API.', 'Los cambios del perfil solo permanecen en memoria. No se modifica Neon ni la API pública.')),
    ]);
  }
}

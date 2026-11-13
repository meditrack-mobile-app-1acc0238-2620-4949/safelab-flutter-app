import 'package:flutter/material.dart';

import '../../app/app_state.dart';
import '../../app/app_theme.dart';
import '../../shared/widgets/safelab_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.state});
  final SafeLabState state;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool obscure = true;
  String? error;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void submit() {
    FocusScope.of(context).unfocus();
    if (!widget.state.signIn(email.text, password.text)) {
      setState(() => error = widget.state.t(
          'Select a demo account and enter a nonempty password.',
          'Selecciona una cuenta de prueba y escribe cualquier contraseña no vacía.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final dark = state.darkMode;
    return Scaffold(
      body: Stack(children: [
        Positioned(top: -130, right: -55, child: Container(width: 350, height: 350, decoration: BoxDecoration(shape: BoxShape.circle, color: SafeLabPalette.primary.withOpacity(dark ? .12 : .09)))),
        Positioned(top: 190, left: -80, child: Icon(Icons.science_outlined, size: 420, color: SafeLabPalette.primary.withOpacity(.075))),
        SafeArea(child: LayoutBuilder(builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(constraints: BoxConstraints(minHeight: constraints.maxHeight), child: Column(children: [
            Padding(padding: const EdgeInsets.only(top: 7, right: 18), child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(icon: Icon(dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined), onPressed: state.toggleTheme, tooltip: 'Toggle theme'),
              const SizedBox(width: 4),
              CircleAvatar(backgroundColor: SafeLabPalette.primary, radius: 26, child: TextButton(onPressed: state.toggleLanguage, child: Text(state.spanish ? 'ES' : 'EN', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
            ])),
            const SizedBox(height: 24),
            const BrandLogo(size: 112),
            const SizedBox(height: 20),
            const Text('SafeLab', style: TextStyle(fontSize: 41, fontWeight: FontWeight.w900, letterSpacing: -.7)),
            const SizedBox(height: 5),
            Text(state.t('Clinical cold chain monitoring', 'Monitoreo de cadena de frío clínica'), textAlign: TextAlign.center, style: TextStyle(color: mutedColor(context), fontSize: 16)),
            const SizedBox(height: 36),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: SafeLabPanel(
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 25),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text(state.t('Sign in', 'Iniciar sesión'), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                const SizedBox(height: 23),
                TextField(key: const Key('loginIdentifier'), controller: email, decoration: InputDecoration(labelText: state.t('Email or username', 'Correo o usuario'), prefixIcon: const Icon(Icons.person_outline)), keyboardType: TextInputType.emailAddress, autocorrect: false),
                const SizedBox(height: 16),
                TextField(key: const Key('loginPassword'), controller: password, obscureText: obscure, onSubmitted: (_) => submit(), decoration: InputDecoration(labelText: state.t('Password', 'Contraseña'), prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined), onPressed: () => setState(() => obscure = !obscure))),),
                if (error != null) ...[
                  const SizedBox(height: 12),
                  Text(error!, style: const TextStyle(color: SafeLabPalette.danger)),
                ],
                const SizedBox(height: 19),
                FilledButton(key: const Key('signInButton'), onPressed: submit, child: Text(state.t('Sign in', 'Ingresar'))),
                const SizedBox(height: 12),
                Center(child: TextButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.t('Demo mode: password recovery is not connected.', 'Modo demo: recuperación no conectada.')))), child: Text(state.t('Forgot password?', '¿Olvidaste tu contraseña?')))),
                const SizedBox(height: 4),
                Text(state.t('OFFLINE UI DEMO · No real authentication', 'DEMO SIN CONEXIÓN · Sin autenticación real'), textAlign: TextAlign.center, style: TextStyle(color: mutedColor(context), fontSize: 11.5, fontWeight: FontWeight.w700)),
              ]),
            )),
            const SizedBox(height: 12),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 23), child: Column(children: [
              Text(state.t('Demo identities', 'Cuentas ficticias'), style: TextStyle(color: mutedColor(context), fontSize: 12, fontWeight: FontWeight.w700)),
              Wrap(alignment: WrapAlignment.center, spacing: 5, runSpacing: 0, children: [
                TextButton(onPressed: () => email.text = 'admin@safelab.test', child: Text(state.t('Platform admin', 'Admin plataforma'))),
                TextButton(onPressed: () => email.text = 'gerente.andes@safelab.test', child: Text(state.t('Manager', 'Gerente'))),
                TextButton(onPressed: () => email.text = 'lab-technician2.andes@safelab.test', child: Text(state.t('Employee', 'Empleado'))),
              ]),
              Text(state.t('Use any nonempty password to enter this isolated UI prototype.', 'Utiliza cualquier contraseña no vacía para entrar en este prototipo aislado.'), textAlign: TextAlign.center, style: TextStyle(color: mutedColor(context), fontSize: 11)),
            ])),
            const SizedBox(height: 22),
          ])),
        )))
      ]),
    );
  }
}

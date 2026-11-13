import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/demo_store.dart';

typedef NavigateTo = void Function(String destination, {String? id});

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 48});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .1),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(size * .24)),
      child: Image.asset('assets/images/safelab_shield.png', fit: BoxFit.contain));
}

class SafeLabPanel extends StatelessWidget {
  const SafeLabPanel({super.key, required this.child, this.padding = const EdgeInsets.all(18), this.gradient = false, this.onTap});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: padding,
          decoration: BoxDecoration(
            color: gradient ? null : panelColor(context),
            gradient: gradient ? safeLabGradient(context) : null,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(.06)),
          ),
          child: child,
        ),
      ));
}

class HeroPanel extends StatelessWidget {
  const HeroPanel({super.key, required this.title, required this.subtitle, this.child});
  final String title;
  final String subtitle;
  final Widget? child;

  @override
  Widget build(BuildContext context) => SafeLabPanel(
    gradient: true,
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w800, height: 1.12)),
      const SizedBox(height: 12),
      Text(subtitle, style: TextStyle(fontSize: 16, height: 1.45, color: mutedColor(context))),
      if (child != null) ...[const SizedBox(height: 20), child!],
    ]),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 18, bottom: 10),
    child: Row(children: [
      Expanded(child: Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
      if (trailing != null) trailing!,
    ]),
  );
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.value, {super.key});
  final String value;
  @override
  Widget build(BuildContext context) {
    final normalized = value.toLowerCase();
    final positive = ['active', 'online', 'normal', 'connected', 'compliant', 'resolved', 'ready', 'paid'].contains(normalized);
    final dangerous = ['open', 'critical', 'error', 'offline', 'violation', 'inactive'].contains(normalized);
    final tint = positive ? SafeLabPalette.success : dangerous ? SafeLabPalette.danger : SafeLabPalette.amber;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(color: tint.withOpacity(.13), borderRadius: BorderRadius.circular(99)),
      child: Text(value.isEmpty ? '—' : '${value[0].toUpperCase()}${value.substring(1)}', style: TextStyle(color: tint, fontWeight: FontWeight.w800, fontSize: 12)),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({super.key, required this.title, required this.value, required this.subtitle, required this.color, required this.icon, this.onTap});
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SafeLabPanel(
    onTap: onTap,
    padding: const EdgeInsets.all(15),
    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(width: 39, height: 50, alignment: Alignment.center, decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: color, size: 22)),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(title.toUpperCase(), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: mutedColor(context), fontSize: 11.5, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value, maxLines: 1, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: mutedColor(context))),
      ])),
    ]),
  );
}

class MetricGrid extends StatelessWidget {
  const MetricGrid({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, size) {
    final narrow = size.maxWidth < 350;
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: narrow ? .99 : 1.20,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: children,
    );
  });
}

class RecordCard extends StatelessWidget {
  const RecordCard({super.key, required this.title, this.subtitle = '', this.status, this.icon = Icons.chevron_right_rounded, this.onTap});
  final String title;
  final String subtitle;
  final String? status;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: SafeLabPanel(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 17),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17.5, fontWeight: FontWeight.w800)),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(subtitle, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.5, color: mutedColor(context), height: 1.4)),
          ],
        ])),
        const SizedBox(width: 8),
        if (status != null) StatusPill(status!),
        if (onTap != null) Icon(icon, color: SafeLabPalette.primary, size: 24),
      ]),
    ),
  );
}

class DataRowItem extends StatelessWidget {
  const DataRowItem({super.key, required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(color: mutedColor(context), fontSize: 12.5, fontWeight: FontWeight.w600)),
      const SizedBox(height: 3),
      Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    ]),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => SafeLabPanel(child: Row(children: [
    const Icon(Icons.info_outline_rounded, color: SafeLabPalette.primary),
    const SizedBox(width: 12),
    Expanded(child: Text(message, style: TextStyle(color: mutedColor(context)))),
  ]));
}

class ScreenBody extends StatelessWidget {
  const ScreenBody({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => ListView(
      padding: const EdgeInsets.fromLTRB(17, 20, 17, 28),
      children: children,
  );
}

String firstLetter(String text) => text.isEmpty ? '?' : text[0].toUpperCase();

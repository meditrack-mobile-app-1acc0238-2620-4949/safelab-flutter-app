# SafeLab · Flutter Cross-Platform Prototype

**AV2 v0.3.2 — Interface and navigation prototype (estimated 30% scope).**

SafeLab is a laboratory cold-chain monitoring interface. This repository contains a **Flutter/Dart reimplementation of selected Android UI flows**, based on the original SafeLab Mobile `av2-v2.5.2` reference. It is separate from the Kotlin/Jetpack Compose application.

## Implemented UI

- Bilingual (English/Spanish), light/dark sign-in experience with selectable fictional users.
- Role-aware overview for platform administrator or organization members.
- Organization list and detail, organization users and user detail.
- Sensors, alerts and equipment navigation with item details.
- Users & permissions tabs, profile viewing and local profile editing.
- Bottom navigation, quick-access links, activity records and sample subscriptions.
- Phone-width layout on desktop-browser previews; native Android layouts remain unchanged.

## Architecture

```
lib/
  app/                # Shell, application state and visual theme
  core/               # Sanitized local fixture repository
  features/           # Authentication, home, organizations, users, profile, operations
  shared/widgets/     # Reusable SafeLab visual components
assets/               # Original SafeLab logo and sanitized mock data
android/              # Android Flutter embedding / Gradle platform files
web/                  # Web entrypoint for optional previews
```

## Scope and limitations

This is an **offline frontend prototype** with mock data bundled in `assets/data/demo.json`. **No Spring Boot / Neon integration, network login, session tokens, persistence or backend CRUD** are implemented. The sign-in screen selects a known mock identity when a nonempty password is entered; this is **not an authentication mechanism**. Profile edits are temporary in-memory UI changes until the app is restarted.

The provided fixture was derived from the Android repository but **removes all password fields**. Only fictional demonstration records are included. The Android application remains the primary fully integrated product.

## Reference

Original project: `meditrack-mobile-app-1acc0238-2620-4949/safelab-mobile-app` · tag `av2-v2.5.2`.

## Licensing

Coursework prototype derived from the SafeLab interface assets. See `LICENSE`.

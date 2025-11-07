# Customizza

Customizza ist eine moderne Flutter-Anwendung zum Zusammenstellen und Bestellen individueller Pizzen über Web, Android und iOS.

## Schnellstart

```bash
flutter create . # falls die Plattform-Ordner fehlen
flutter pub get
flutter run -d chrome
```

Für Android oder iOS entsprechend `flutter run -d android` bzw. `flutter run -d ios` verwenden.

## Features
- Visueller Pizza-Designer mit animierter Pizza, Größen- und Topping-Auswahl
- Vorgefertigte Pizzen, Salate und Getränke mit Bildern
- Warenkorb mit Rabattlogik und Angebotsregeln
- Checkout mit Liefer- oder Abholoption, Abholrabatt und Vorbestellung
- Admin-Bereich zur Steuerung von Angeboten, Events und Vorbestell-Einstellungen
- Registrierung/Anmeldung mit DSGVO-Einwilligungen
- Lokalisierung vorbereitet (de-DE Standard), dunkles und helles Thema

## Designentscheidungen
- Material 3 mit warmem Seed-Color `#FF7A00`
- Provider-State-Management mit sauber getrennten Domänenschichten
- Modulstruktur nach Core/Domain/Data/State/UI für klare Verantwortlichkeiten
- Mock-Repositories für Demo-Betrieb, austauschbar durch echte Backends
- Platzhalter-Grafiken werden als Base64-codierte PNGs im Code eingebettet, sodass keine Binärdateien versioniert werden müssen.

## Admin-Einstellungen anpassen
Die Demo verwendet `AdminSettings` aus `lib/data/mock_repos.dart`. Dort können Standardwerte wie Abholrabatt sowie Vorbestellintervalle, Event-Tags und weitere Parameter angepasst werden. Änderungen im Admin-Tab werden über den `AppState` verwaltet und gelten sofort.

## Tests
Minimale Unit-Tests befinden sich in `test/app_state_test.dart` und prüfen Preisberechnung und Angebotslogik.

## TODO Phase 2
- Zahlungen (Stripe, Apple Pay, Google Pay)
- Küchen-Druck/Dispatch
- Fahrer-App/Routing und Live-ETA

Die notwendigen Interfaces und Platzhalter sind bereits im Code vorhanden und mit TODO-Kommentaren gekennzeichnet.
=======
# Pizza App

This repository contains a simple pizza ordering application.

# Crewmeister Absence Manager (Flutter)

At **Crewmeister**, we like to work closely with our clients, listening to their demands and developing solutions for their problems. One of the most requested features is a way for company owners to manage sickness and vacations of employees.

We decided to implement this feature and are calling it **Absence Manager**.

## ✅ Features Implemented

- List of absences including names of employees.
- Pagination: loads first 10 absences and supports load more.
- Total number of absences displayed.
- Each absence includes:
  - Member name
  - Type of absence
  - Period
  - Member note (if available)
  - Status: *Requested*, *Confirmed*, or *Rejected*
  - Admitter note (if available)
- Filter absences by **type**.
- Filter absences by **date range**.
- Displays:
  - Loading state
  - Error state (when API/data fails)
  - Empty state (no results)
- Bonus: Export all absences as **iCal** file and share via email/apps.

---

## 🛠️ Tech Stack

- **Flutter Version**: `3.27.1`
- **Architecture**: Clean Architecture (Domain → Data → Presentation)
- **State Management**: `Cubit` with `flutter_bloc`
---


## 🚀 Getting Started

1. Run `flutter pub get`
2. Use `flutter run` to build and run the app
3. To generate routes or mocks, use:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs

## 📦 Dependencies

| Package               | Usage Description                            |
|-----------------------|----------------------------------------------|
| cupertino_icons       | iOS-style icons                              |
| google_fonts          | Use custom fonts easily                      |
| auto_route            | Declarative navigation & route generation    |
| equatable             | Simplify equality comparisons in classes     |
| flutter_bloc / bloc   | State management using Cubit/Bloc pattern    |
| dartz                 | Functional programming tools (Either, etc.)  |
| get_it                | Service locator (DI pattern)                 |
| shimmer               | Shimmer loading effect                       |
| intl                  | Date formatting                              |
| flutter_spinkit       | Loading spinners                             |
| share_plus            | Native share functionality                   |
| path_provider         | Access to device storage                     |

### Dev Dependencies

| Package                  | Usage                                 |
|--------------------------|---------------------------------------|
| flutter_test             | Unit/widget testing                   |
| test                     | Dart testing framework                |
| flutter_lints            | Recommended lints                     |
| auto_route_generator     | Code generation for auto_route        |
| build_runner             | Code generation CLI                   |
| mocktail                 | Mocking framework for tests           |
| bloc_test                | Bloc/cubit-specific test utils        |

---

## 📁 Folder Structure

```bash
lib/
├── core/
│   ├── api/
│   │   └── api.dart
│   ├── di/
│   │   └── injection_container.dart
│   ├── error/
│   │   └── failure.dart
│   ├── services/
│   │   └── share_service_impl.dart
│   ├── shared/
│   │   ├── ical/
│   │   │   └── ical_generator.dart
│   │   ├── app_router.dart
│   │   └── app_router.gr.dart
│   └── utils/
├── data/
│   ├── mappers/
│   │   └── absence_mapper.dart
│   ├── models/
│   │   ├── absence_model.dart
│   │   ├── member_model.dart
│   │   └── paged_absence_result.dart
│   └── repositories/
│       └── absence_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── absence.dart
│   │   └── member.dart
│   ├── repositories/
│   │   └── absence_repository.dart
│   ├── services/
│   │   └── share_service.dart
│   └── usecases/
│       ├── filter_absences.dart
│       ├── generate_and_share_ical.dart
│       ├── get_absence_count.dart
│       └── get_absences.dart
├── presentation/
│   ├── cubit/
│   │   ├── absence_cubit.dart
│   │   └── absence_state.dart
│   ├── pages/
│   │   └── absence_list_page.dart
│   └── widgets/
│       ├── absence_card.dart
│       ├── absence_listview.dart
│       ├── absence_sliver_list.dart
│       └── error_state_widget.dart
└── main.dart



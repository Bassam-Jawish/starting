# Starting

A Flutter starter project built with **Clean Architecture** and a **feature-first** folder layout. Each feature is organized into three layers — **Presentation**, **Domain**, and **Data** — so UI, business logic, and external data stay separated and testable.

## Tech Stack

| Concern | Package |
|---|---|
| State management | `flutter_bloc` |
| Dependency injection | `get_it` |
| HTTP / API | `dio`, `retrofit` |
| Routing | `go_router` |
| Functional helpers | `dartz`, `equatable` |

---

## Project Structure

```
lib/
├── main.dart                  # App entry point
├── injection_container.dart   # Service locator (GetIt) setup
│
├── config/                    # App-wide configuration
│   ├── routes/                # GoRouter definitions
│   └── theme/                 # Colors, styles, themes
│
├── core/                      # Shared code used across features
│   ├── error/                 # Exceptions & failures
│   ├── network/               # Network connectivity
│   ├── resources/             # DataState wrapper (success / failure)
│   ├── usecases/              # Base UseCase contract
│   ├── utils/                 # Helpers, cache, interceptors
│   └── widgets/               # Reusable UI components
│
├── l10n/                      # Localization (ARB files)
│
└── features/                  # Feature modules
    ├── authentication/        # Full 3-layer example
    ├── onboarding/
    ├── splash/
    └── base/
```

Features that only need UI (splash, onboarding) may contain a **presentation** layer alone. Features with backend interaction follow the full three-layer pattern shown below.

---

## Layer Overview

Dependencies flow **inward**: Presentation → Domain ← Data.

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION                         │
│  Pages · Widgets · Bloc (events / states)               │
└──────────────────────────┬──────────────────────────────┘
                           │ calls
                           ▼
┌─────────────────────────────────────────────────────────┐
│                      DOMAIN                             │
│  Entities · Repository contracts · Use cases            │
└──────────────────────────▲──────────────────────────────┘
                           │ implements
                           │
┌──────────────────────────┴──────────────────────────────┐
│                       DATA                              │
│  Models · Remote / local sources · Repository impl      │
└─────────────────────────────────────────────────────────┘
```

---

## Feature Module Layout

Every data-driven feature follows the same internal structure:

```
features/<feature_name>/
├── presentation/
│   ├── bloc/          # State management (events, states, bloc)
│   ├── pages/         # Screens
│   └── widgets/       # Feature-specific UI pieces
│
├── domain/
│   ├── entities/      # Pure business objects (no JSON, no Flutter)
│   ├── repository/    # Abstract repository interface
│   └── usecases/      # Single-responsibility business actions
│
└── data/
    ├── models/        # DTOs with fromJson / toJson
    ├── data_sources/
    │   ├── remote/    # API services (Retrofit)
    │   └── local/     # Cache / secure storage
    └── repository/    # Concrete repository implementation
```

### Example: `authentication`

| Layer | Responsibility | Key files |
|---|---|---|
| **Presentation** | UI and user interaction | `login_page.dart`, `auth_bloc.dart` |
| **Domain** | Business rules, no framework deps | `user.dart`, `auth_repo.dart`, `login_usecase.dart` |
| **Data** | Fetching and mapping external data | `user_model.dart`, `auth_api_service.dart`, `auth_repo_impl.dart` |

---

## Layer Details

### Presentation

The outermost layer. It knows about Flutter widgets and Bloc, but **never** talks to APIs or parses JSON directly.

- **Pages** — full screens wired to routing (`config/routes/app_router.dart`)
- **Widgets** — smaller, composable UI for a feature
- **Bloc** — receives user actions as **events**, calls **use cases**, and emits **states** that drive the UI

```dart
// Presentation calls a use case, not the repository or API
final result = await _loginUseCase(params: LoginParams(...));
```

### Domain

The core of the app. It has **zero** dependencies on Flutter, Dio, or any data source. This layer defines *what* the app does.

- **Entities** — plain Dart classes representing business concepts (`UserEntity`, `UserInfoEntity`)
- **Repository (abstract)** — contract that data layer must fulfill (`AuthRepository`)
- **Use cases** — one action per class (`LoginUseCase`, `LogoutUseCase`, …), each delegating to the repository

The base contract lives in `core/usecases/usecase.dart`:

```dart
abstract class UseCase<Type, Params> {
  Future<Type> call({Params params});
}
```

### Data

The layer closest to the outside world. It implements domain contracts and handles all I/O.

- **Models** — extend or map to entities; handle serialization (`UserInfoModel`)
- **Remote data sources** — Retrofit API services (`AuthApiService`)
- **Local data sources** — secure storage, shared preferences
- **Repository implementation** — converts API responses into `DataState<T>` results the domain understands (`AuthRepositoryImpl`)

Results are wrapped in `core/resources/data_state.dart`:

```dart
DataSuccess(data)  // operation succeeded
DataFailed(error)  // operation failed (DioException)
```

---

## Shared `core/` Layer

Code in `core/` is feature-agnostic and reused everywhere:

| Folder | Purpose |
|---|---|
| `error/` | `Failure`, custom exceptions |
| `network/` | `NetworkInfo` connectivity checks |
| `resources/` | `DataState`, `DataSuccess`, `DataFailed` |
| `usecases/` | Base `UseCase` interface |
| `utils/` | Cache helper, auth interceptor, validators |
| `widgets/` | Buttons, text fields, loaders, app bar |

---

## Dependency Injection

All dependencies are registered in `injection_container.dart` using **GetIt** (`sl`):

1. Register external services (Dio, secure storage)
2. Register data sources and repository implementations
3. Register use cases
4. Register Blocs

Presentation layers receive use cases through constructor injection; use cases receive repository abstractions, not concrete implementations.

---

## Adding a New Feature

1. Create `features/<name>/` with `presentation/`, `domain/`, and `data/` folders.
2. **Domain first** — define entities, the repository interface, and use cases.
3. **Data** — add models, API/local sources, and implement the repository.
4. **Presentation** — build Bloc, pages, and widgets that call use cases.
5. Register dependencies in `injection_container.dart`.
6. Add routes in `config/routes/app_router.dart`.

---

## Getting Started

```bash
# Install dependencies
flutter pub get

# Generate Retrofit / build_runner code
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

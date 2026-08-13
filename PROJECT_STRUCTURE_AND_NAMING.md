# DineFlow — Project Architecture & File Naming Conventions

This document defines the folder structure, architectural boundaries, and naming conventions used across the **DineFlow** Flutter codebase for consistency and scalable feature development.

---

## 📁 Directory Structure

```text
lib/
├── core/
│   ├── di/                        # Dependency Injection (GetIt + Injectable)
│   │   ├── servise_locator.dart   # Main locator setup & configuration
│   │   ├── servise_locator.config.dart # Generated DI bindings
│   │   └── firebase_module.dart   # Third-party modules (@module)
│   ├── error/                     # Error handling
│   │   ├── exception.dart         # Data-layer exceptions (AppException, ServerException, AuthException)
│   │   └── failure.dart           # Domain-layer failures (Failure, AuthFailure, ServerFailure)
│   ├── usecases/                  # Base UseCase contracts & return types
│   │   ├── usecase.dart           # UseCase<Type, Params> base interface
│   │   ├── no_params.dart         # NoParams class
│   │   └── result.dart            # Sealed Result<T> (Success<T>, FailureResult<T>)
│   ├── router/                    # GoRouter routing & guards
│   ├── theme/                     # App styling, typography, and palette
│   └── widgets/                   # App-wide reusable UI components
│
└── features/
    └── <feature_name>/            # e.g., auth, menu, order, customer
        ├── data/
        │   ├── data_source/       # Remote & Local data sources
        │   │   ├── <feature>_<type>_data_source_interface.dart
        │   │   └── <feature>_<type>_data_source_impl.dart
        │   ├── models/            # Data models (fromJson, toJson, toEntity, fromEntity)
        │   │   └── <entity>_model.dart
        │   └── repo/              # Repository implementations
        │       └── <feature>_repository_impl.dart
        │
        ├── domain/
        │   ├── entity/            # Pure domain entities & enums
        │   │   └── <entity>_entity.dart
        │   ├── repo/              # Abstract repository interfaces
        │   │   └── <feature>_repository_interface.dart
        │   └── usecase/           # Feature-specific use cases
        │       ├── <action>_usecase.dart
        │       └── ...
        │
        └── presentation/
            ├── bloc/ / cubit/     # State management (BLoC/Cubit)
            ├── screens/           # Feature screens/pages
            └── widgets/           # Feature-specific UI widgets
```

---

## 🏷️ Naming & File Conventions

### 1. Domain Layer

| Component | File Naming Convention | Class Naming Convention | Example |
| :--- | :--- | :--- | :--- |
| **Entity** | `<entity>_entity.dart` | `<Entity>Entity` | `user_entity.dart` → `UserEntity` |
| **Enum** | Defined in entity file or `<enum_name>.dart` | `<EnumName>` | `UserRole` (`customer`, `waiter`, `kitchen`) |
| **Repository Interface** | `<feature>_repository_interface.dart` | `<Feature>RepositoryInterface` | `profile_repository_interface.dart` → `ProfileRepositoryInterface` |
| **Use Case** | `<action>_usecase.dart` | `<Action>UseCase` | `login_usecase.dart` → `LoginUseCase` |
| **Use Case Params** | Defined inside the use case file | `<Action>Params` | `LoginParams({required email, required password})` |

### 2. Data Layer

| Component | File Naming Convention | Class Naming Convention | Example |
| :--- | :--- | :--- | :--- |
| **Data Model** | `<entity>_model.dart` | `<Entity>Model` | `user_model.dart` → `UserModel` |
| **Data Source Interface** | `<feature>_<type>_data_source_interface.dart` | `<Feature><Type>DataSourceInterface` | `profile_remote_data_source_interface.dart` → `ProfileRemoteDataSourceInterface` |
| **Data Source Implementation**| `<feature>_<type>_data_source_impl.dart` | `<Feature><Type>DataSourceImpl` | `profile_remote_data_source_impl.dart` → `ProfileRemoteDataSourceImpl` |
| **Repository Implementation** | `<feature>_repository_impl.dart` | `<Feature>RepositoryImpl` | `profile_repository_impl.dart` → `ProfileRepositoryImpl` |

---

## ⚡ Clean Architecture Data Flow

1. **`Data Source`**: Handles low-level API/Firebase operations and returns `UserModel`.
2. **`RepositoryImpl`**: Calls Data Source, converts `UserModel.toEntity()` to `UserEntity`, catches exceptions and returns `Result<UserEntity>` (`Success` or `FailureResult`).
3. **`UseCase`**: Takes `<Action>Params` or `NoParams`, calls `RepositoryInterface`, and returns `Future<Result<T>>`.
4. **`BLoC / Cubit`**: Executes `UseCase`, inspects `Result` (`Success` vs `FailureResult`), and updates UI states accordingly.

---

## 🔌 Interface Naming Rule

All abstract contracts **must** end with the `Interface` suffix:

| Layer | Interface class | Implementation class |
| :--- | :--- | :--- |
| **Data source** | `ProfileRemoteDataSourceInterface` | `ProfileRemoteDataSourceImpl` |
| **Repository** | `ProfileRepositoryInterface` | `ProfileRepositoryImpl` |

- Interface file: `<name>_interface.dart`
- Implementation file: `<name>_impl.dart`
- DI binding: `@LazySingleton(as: ProfileRemoteDataSourceInterface)`

---

## 💉 Dependency Injection Conventions (GetIt + Injectable)

- Implementation classes register as `@LazySingleton(as: InterfaceName)`.
- UseCases register with `@lazySingleton`.
- External packages (`FirebaseAuth`, `FirebaseFirestore`) are provided via a `@module` class in `lib/core/di/`.
- Code generation command:
  ```bash
  dart run build_runner build
  ```

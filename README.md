# 🍽️ DineFlow

<p align="center">
  <img src="screenshots/banner.png" alt="DineFlow" width="900"/>
</p>

<p align="center">
  <strong>Restaurant Ordering & Management Mobile Application</strong>
</p>

<p align="center">
  Built with Flutter & Dart
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.44.6-02569B?logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-3.12.2-0175C2?logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Architecture-Clean%20Architecture-blue"/>
  <img src="https://img.shields.io/badge/State%20Management-BLoC%2FCubit-purple"/>
</p>

---

## 📱 About

**DineFlow** is a modern restaurant ordering mobile application built with Flutter.

The application provides a complete digital ordering experience for customers while supporting restaurant staff through dedicated workflows.

### 👥 User Roles

| Role              | Description                                                |
| ----------------- | ---------------------------------------------------------- |
| 👤 **Customer**   | Browse menu, search products, manage cart and place orders |
| 🧑‍💼 **Waiter**  | Handle customer requests and restaurant orders             |
| 👨‍🍳 **Kitchen** | Manage incoming orders and preparation status              |

---

## ✨ Features

<div align="center">

| 🔐 Authentication |        🍽️ Menu       |   🔎 Search   |
| :---------------: | :-------------------: | :-----------: |
|  Register & Login | Categories & Products | Find Products |

|  🥘 Product Details |   🛒 Cart   |   📦 Orders  |
| :-----------------: | :---------: | :----------: |
| Product information | Manage Cart | Track Orders |

|   🪑 Dine-in   |   🥡 Takeaway   |   👨‍🍳 Kitchen  |
| :------------: | :-------------: | :--------------: |
| Table ordering | Takeaway orders | Order management |

</div>

---

# 📸 Previews

# Demo 

https://github.com/user-attachments/assets/b4a10db9-56dd-4ca9-9d66-4aed0c547713

------

<p align="center">
   <img width="4666" height="1198" alt="DineFlow_preview_all" src="https://github.com/user-attachments/assets/bf7fa8d1-8225-4671-94cb-cb0f68bb5b4c" />

</p>

<p align="center">
    <img width="2082" height="1018" alt="DineFlow_preview_customer" src="https://github.com/user-attachments/assets/fdd3cdea-72c2-4db7-b452-9ab2f552e7f7" />
   <img width="1690" height="1018" alt="DineFlow_preview_waiter" src="https://github.com/user-attachments/assets/d061d161-60c3-4350-8597-78e46b0f9f52" />
    <img width="1298" height="1018" alt="DineFlow_preview_kitchen" src="https://github.com/user-attachments/assets/4f928d97-7bbe-4fdc-9248-cd01197bbe33" />
</p>


---

# 🛠️ Tech Stack

| Technology          | Purpose                            |
| ------------------- | ---------------------------------- |
| Flutter             | Cross-platform mobile development  |
| Dart                | Programming language               |
| Flutter BLoC / Cubit | State management                  |
| Dio                 | REST API communication             |
| GoRouter            | Navigation & route management      |
| GetIt               | Dependency injection               |
| Freezed             | Immutable models & states          |
| JSON Serializable   | JSON serialization                 |

---

# 🏗️ Architecture

DineFlow follows **Clean Architecture** with a **feature-first** structure.

```text
┌───────────────────────────────────────────┐
│               Presentation                │
│                                           │
│   Screens • Widgets • Cubits • BLoCs      │
└─────────────────────┬─────────────────────┘
                      │
                      ▼
┌───────────────────────────────────────────┐
│                  Domain                   │
│                                           │
│      Entities • Use Cases • Repos         │
└─────────────────────┬─────────────────────┘
                      │
                      ▼
┌───────────────────────────────────────────┐
│                   Data                    │
│                                           │
│  Models • API • Data Sources • Repos      │
└───────────────────────────────────────────┘
```

### Core Principles

* Separation of concerns
* Dependency inversion
* Repository pattern
* Use-case driven business logic
* Feature-first organization
* Dependency injection
* Immutable state management

---

# 📂 Project Structure

```text
lib/
│
├── core/
│   ├── constants/
│   ├── di/
│   ├── errors/
│   ├── network/
│   ├── router/
│   ├── services/
│   └── widgets/
│
├── features/
│   ├── auth/
│   ├── home/
│   ├── search/
│   ├── cart/
│   ├── orders/
│   ├── notifications/
│   ├── profile/
│   ├── waiter/
│   └── kitchen/
│
├── injection/
│
├── main_dev.dart
└── main_prod.dart
```

Each feature follows:

```text
feature/
├── data/
├── domain/
└── presentation/
```

---

# 🔐 Authentication & Authorization

DineFlow uses token-based authentication with role-based navigation.

```text
                     Authentication
                            │
          ┌─────────────────┼─────────────────┐
          ▼                 ▼                 ▼
      Customer            Waiter            Kitchen
          │                 │                 │
          ▼                 ▼                 ▼
   Customer Routes    Waiter Routes    Kitchen Routes
```

Flutter handles navigation and route protection, while the backend remains responsible for authorization.

---

# ⚙️ Getting Started

## Prerequisites

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android Emulator or physical device
* Running DineFlow backend

## Installation

```bash
git clone  (https://github.com/Abdo-mohamed727/DineFlow.git)

cd dineflow

flutter pub get
```

## Run Development

```bash
flutter run -t lib/main_dev.dart
```

---

# 🌍 Environment Configuration

DineFlow supports multiple environments:

```text
Development
Staging
Production
```

Each environment can have its own API base URL and configuration.

Development entry point:

```text
lib/main_dev.dart
```

> Never commit API keys, tokens, or sensitive credentials to the repository.

---

# 🔌 API Integration

The Flutter application communicates with the DineFlow REST API using **Dio**.

The API layer handles:

* Authentication
* User data
* Products
* Categories
* Cart
* Orders
* Tables
* Waiter requests

Authenticated requests include the user's access token through the network layer.

---

# 🧪 Testing

Run Flutter tests:

```bash
flutter test
```

The project can be extended with:

* Unit tests
* Widget tests
* Integration tests

---

# 📚 Documentation

Additional technical documentation covers:

* Architecture
* Authentication flow
* API integration
* Navigation & route protection
* State management
* Environment configuration

---

# 🚀 Roadmap

- [x] Push notifications
- [x] Enhanced order tracking
- [ ] Offline support
- [ ] Expanded test coverage
- [ ] Performance optimization
- [ ] Localization
- [ ] Payment integration

---


# 👨‍💻 Authors

<p align="center">
  <strong>Abdelrahman Mohamed & Mohamed Waleed</strong><br/>
  Flutter Developers
</p>


---

<p align="center">
  Built with ❤️ using Flutter
</p>

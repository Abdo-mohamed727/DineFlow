# DineFlow — Real-Time Restaurant Management System
### Product Plan, Technical Plan & MVP Definition

---

## PART 1 — Product Overview

**DineFlow** is a real-time restaurant management system that connects three roles — **Customer**, **Waiter**, and **Kitchen Staff** — around a single source of truth: the order.

**Problem it solves:** In a typical small-to-mid restaurant, orders travel through paper tickets, shouted updates, or a POS the customer never sees. This causes delays, lost orders, and no visibility for the customer once they've ordered. DineFlow replaces that with a real-time, role-based digital workflow: a customer orders from their phone, the kitchen sees it the instant it's placed, and the waiter is notified the instant it's ready — with no refreshing and no shouting across the restaurant.

**Who uses it:**
- **Customers** — order dine-in or takeaway, track status live, call the waiter, request the bill.
- **Waiters** — see live table status, receive customer requests instantly, know exactly when to serve.
- **Kitchen staff** — work off a real-time Kitchen Display System (KDS) instead of paper tickets.

**Why it's useful / business value:** Faster table turnover, fewer miscommunicated orders, less staff running back and forth to check status, and a modern ordering experience for the customer. As a portfolio project, it's valuable because it is a **multi-role, real-time, production-shaped system** — not a CRUD app — and it forces real architectural decisions (Clean Architecture, Streams vs Futures, Firestore transactions, security rules) that a generic to-do app never does.

There is **no Admin role in this scope.** No inventory, no delivery, no payment gateway, no multi-branch. Those live in Future Scope (Part 20).

---

## PART 2 — Business Requirements

1. The system must support two order types: `DINE_IN` and `TAKEAWAY`.
2. Dine-in orders require a table; takeaway orders do not.
3. If no table is available, the customer must be offered Takeaway or (optionally) a Waiting List.
4. Orders must move through a clearly defined status lifecycle, and every status change must be visible to the relevant role in real time, without a manual refresh.
5. A customer must be able to call a waiter and request the bill without leaving the app.
6. Kitchen staff must operate a dedicated real-time queue (KDS) distinguishing dine-in from takeaway.
7. Waiters must know the moment an order is ready and the moment a customer needs them.
8. All role-sensitive actions (status changes, bill handling) must be enforced server-side via Firestore Security Rules — never trusted from the client alone.
9. The system must degrade gracefully on connection loss and recover without data corruption or duplicate orders.

---

## PART 3 — User Personas

**Customer — "Sara, 27, office worker"**
Orders lunch on her break. Wants to know if a table is free before walking over, wants to see her order is actually being made, and wants to flag the waiter without waving her arm across the room.

**Waiter — "Karim, 22, part-time server"**
Runs multiple tables at once. Needs to know instantly when food is ready so it doesn't go cold, and needs to know instantly when a table wants something — without a customer having to catch his eye.

**Kitchen Staff — "Mona, 30, line cook"**
Works in a loud, fast-moving kitchen. Cannot read a phone screen closely while cooking — needs a glanceable, high-contrast queue that clearly separates "needs to start," "in progress," and "done," and clearly flags dine-in vs. takeaway so plating differs correctly.

---

## PART 4 — User Stories (selected, by feature)

**Auth**
- As a customer, I want to register with email/password, so that I can place and track orders.
- As a customer, I want to log in and stay logged in, so that I don't re-authenticate every visit.
- As any user, I want to be routed to my role's home screen automatically after login, so that I never see another role's UI.

**Menu**
- As a customer, I want to browse categories and products, so that I can decide what to order.
- As a customer, I want to search products by name, so that I can find something specific quickly.

**Cart & Ordering**
- As a customer, I want to add products to a cart and adjust quantities, so that I can build my order before committing.
- As a customer, I want to choose dine-in or takeaway before checkout, so that the kitchen prepares it correctly.
- As a customer, I want to pick an available table for dine-in, so that the waiter knows where to bring my food.
- As a customer, if no table is available, I want to be offered takeaway or a waiting list, so that I'm not stuck.

**Order Tracking**
- As a customer, I want to see my order's status update live, so that I know when to expect my food without asking.
- As a customer, I want to call the waiter from the app, so that I don't have to flag someone down physically.
- As a customer, I want to request the bill from the app, so that I can pay and leave without waiting to be noticed.

**Kitchen**
- As kitchen staff, I want new orders to appear on my screen instantly, so that I never miss one.
- As kitchen staff, I want to accept, start preparing, and mark an order ready with one tap each, so that status stays accurate with minimal friction.
- As kitchen staff, I want dine-in and takeaway orders visually distinguished, so that I know how to plate and route them.

**Waiter**
- As a waiter, I want to see which tables are occupied, available, or reserved in real time, so that I can seat and serve efficiently.
- As a waiter, I want to be notified the moment an order is ready, so that food doesn't sit under the heat lamp.
- As a waiter, I want to see and resolve call-waiter and bill requests in one inbox, so that I never miss a table's request.

*(Full story set for every task is embedded in each task's Task Detail — see the Notion backlog.)*

---

## PART 5 — User Flows

**Registration:** Open app → Register → enter name/email/password → Firestore user doc created with `role: customer` → auto-login → Menu screen.

**Login:** Open app → Login → credentials validated → role read from Firestore → redirected to Customer / Waiter / Kitchen home via go_router guard.

**Dine-in ordering:** Menu → Add items → Cart → Checkout → select "Dine-in" → Table Selection (live availability) → select table → Place Order → transaction locks table as occupied + creates order → Order Tracking screen (live).

**Takeaway ordering:** Menu → Add items → Cart → Checkout → select "Takeaway" → Place Order (no table step) → Order Tracking screen (live, pickup-oriented labels).

**No available table:** Table Selection screen shows zero available tables → "No tables available" state → choose "Order Takeaway" (re-routes into takeaway checkout) or "Join Waiting List" (if in MVP scope).

**Kitchen workflow:** New order lands in "New" column via stream → tap Accept → moves to "Preparing" (also tap Start if separated) → tap Ready → order disappears from KDS active queue, customer + waiter notified via stream/FCM.

**Waiter workflow:** Waiter dashboard shows active orders + table grid, both live. Ready orders surface in a "Ready to serve" list → tap Served.

**Call waiter:** Customer taps "Call Waiter" on Order Tracking → `waiter_requests` doc created → all waiters' request inbox updates live → waiter taps Resolve.

**Request bill:** Customer taps "Request Bill" (dine-in only, enabled once order is Served) → request created → waiter generates bill from order total → waiter marks paid → order status → Paid → Completed → table freed.

**Order cancellation:** Customer or waiter cancels while status is Pending/Accepted only → order status → Cancelled → table freed if dine-in → kitchen queue updates in real time.

**Order modification:** Customer/waiter can add/remove items only before kitchen starts Preparing → order doc updated → kitchen sees the change highlighted.

**Order completion:** Dine-in: Served → Payment Pending → Paid → Completed → table freed. Takeaway: Ready for Pickup → Picked Up → Completed.

---

## PART 6 — MVP Scope

**In scope (MVP):**
- Auth (register/login/logout, role-based routing)
- Menu browsing + search
- Cart
- Table selection with real-time availability + no-table fallback to takeaway
- Order placement for both Dine-in and Takeaway
- Full order status lifecycle for both types, all real-time
- Kitchen Display System (KDS)
- Waiter dashboard: table overview, ready-to-serve, request inbox
- Call Waiter + Request Bill
- Manual bill generation and "mark as paid" (no payment gateway)
- Firestore Security Rules enforcing role permissions
- Core unit/bloc/widget tests + one end-to-end integration test per order type

**Evaluated but kept minimal:** Waiting List — included as a lightweight collection + join/leave flow (see `TABLE-010`), but it is intentionally the first thing to cut if Sprint capacity runs tight, since the core MVP narrative (dine-in + takeaway working end-to-end) does not depend on it.

**Explicitly out of MVP** (see Part 20 — Future Scope): Admin dashboard, inventory, supplier management, multi-branch, delivery, loyalty, advanced analytics, advanced employee management, real payment gateway, AI features.

**First milestone (the vertical slice that proves the whole product works):**
```
Customer places an order → Kitchen receives it live → Kitchen updates status → Customer sees the update live
```
Everything else is built around getting this slice working first, end-to-end, before polishing secondary screens.

---

## PART 7 — Technical Architecture

- **Client:** Flutter, Dart, `flutter_bloc` (Cubits used almost everywhere; full Bloc reserved only if a feature genuinely needs event-driven transformation), `go_router` for declarative + guarded navigation, `get_it` + `injectable` for DI, `freezed` for immutable entities/states, `json_serializable` for models.
- **Backend:** Firebase Auth, Cloud Firestore (primary data + real-time layer), Firebase Cloud Messaging (push notifications), Firebase Storage (images), Cloud Functions used **only** for the two things a client can't safely do itself: sending FCM pushes on order/request changes, and any place where trusting the client would be a security hole.
- **Pattern:** Clean Architecture (presentation / domain / data) inside a feature-first folder structure, Repository Pattern abstracting Firestore behind domain interfaces, DI wiring everything together.

No GraphQL layer, no separate backend server, no state-management library beyond Bloc/Cubit, no microservices — Firestore + Cloud Functions is the entire backend. This is a deliberate decision: it's the stack that best demonstrates Flutter + Firebase real-time engineering without inventing infrastructure the project doesn't need.

---

## PART 8 — Database Design

### `users`
| Field | Type | Required | Notes |
|---|---|---|---|
| id | string (doc id = auth uid) | yes | |
| name | string | yes | |
| email | string | yes | |
| role | string enum (`customer`,`waiter`,`kitchen`) | yes | immutable after creation, enforced by rules |
| phone | string | no | |
| photoUrl | string | no | |
| fcmToken | string | no | updated on login/refresh |
| createdAt | timestamp | yes | |

### `categories`
`id`, `name` (string, required), `imageUrl` (optional), `sortOrder` (number).

### `products`
`id`, `categoryId` (ref, required), `name`, `description`, `price` (number, required), `imageUrl`, `isAvailable` (bool, default true), `sortOrder`.
Indexes: composite on `(categoryId, isAvailable)` for menu queries.

### `tables`
`id`, `number` (int, required), `capacity` (int), `status` enum (`available`,`occupied`,`reserved`, required). Updated only via the order-creation transaction and the bill-completion transaction — never freely writable by clients (enforced by Security Rules).

### `orders` (the central document — detailed below)
### `notifications`
`id`, `targetUserId` or `targetRole`, `type`, `payload` (map), `read` (bool), `createdAt`.

### `waiter_requests`
`id`, `type` enum (`call_waiter`,`request_bill`), `tableId`, `orderId`, `customerId`, `status` enum (`pending`,`resolved`), `createdAt`, `resolvedBy`, `resolvedAt`.

### `bills`
`id`, `orderId` (required), `subtotal`, `tax`, `discount`, `total`, `status` enum (`pending`,`paid`), `createdAt`, `paidAt`.

### `reviews`
`id`, `orderId`, `customerId`, `rating` (1–5), `comment` (optional), `createdAt`.

### `waiting_list` (only if included in MVP)
`id`, `customerId`, `partySize`, `status` enum (`waiting`,`seated`,`cancelled`), `createdAt`.

### `orders` in detail
```
id            string
customerId    string, required
waiterId      string, optional (assigned when a waiter takes an action)
tableId       string, required if orderType=DINE_IN, null if TAKEAWAY
orderType     enum: DINE_IN | TAKEAWAY
items         array<OrderItem>  (see below)
subtotal      number
tax           number
discount      number, default 0
total         number
status        enum, see Part 9 lifecycle
notes         string, optional
createdAt     timestamp
updatedAt     timestamp
```
`OrderItem` (embedded): `productId`, `name`, `price`, `quantity`, `notes`.

**Should `items` be embedded or referenced?** **Embedded**, as a plain array on the order document. Reasoning: order items are never queried independently of their order, are always read/written together with the order (one screen shows the whole order, one transaction places the whole order), the list is small and bounded (a few to a few dozen items — nowhere near Firestore's 1MB document limit), and embedding avoids N+1 reads on every order-tracking screen, which matters a lot for a real-time UI that's re-rendering on every snapshot. A subcollection would only make sense if items needed independent querying, permissions, or pagination at scale — none of which apply here.

**Security considerations:** customers can only read their own orders; kitchen/waiter can read all active orders but only kitchen can move Pending→Ready, only waiter can move Ready→Served and later. `tables` and the `occupied` transition are never client-writable outside the guarded transaction path. Full rules are specified under Security (Part 12) and implemented in `SECURITY-001`–`SECURITY-008`.

---

## PART 9 — Real-Time Architecture

### Order Lifecycle — Dine-in
```
Pending → Accepted → Preparing → Ready → Served → Payment Pending → Paid → Completed
```
| Status | Who changes it | Who's notified | Stream triggered | Notification |
|---|---|---|---|---|
| Pending | System, on order creation | Kitchen | Kitchen's "watch incoming orders" stream | FCM to kitchen role |
| Accepted | Kitchen | Customer | Order-tracking stream | in-app only |
| Preparing | Kitchen | Customer | Order-tracking stream | in-app only |
| Ready | Kitchen | Customer, Waiter | Order-tracking stream + Waiter "ready to serve" stream | FCM to assigned waiter(s) |
| Served | Waiter | Customer | Order-tracking stream | in-app only |
| Payment Pending | System, on Request Bill | Waiter | Waiter requests inbox stream | FCM to waiter |
| Paid | Waiter | Customer | Order-tracking stream | in-app only |
| Completed | System, after Paid | — | Table freed, table-status stream updates | — |

### Order Lifecycle — Takeaway
```
Pending → Accepted → Preparing → Ready for Pickup → Picked Up → Completed
```
Same pattern, except there's no table, no Served/Bill step — "Ready for Pickup" pushes to the customer, and the customer (or a waiter managing the pickup counter) marks Picked Up, which auto-completes the order.

**Cancellation:** allowed only while `Pending`/`Accepted`. Cancelling frees the table (dine-in) via the same transaction pattern used to occupy it, and pushes a "cancelled" event down the kitchen and customer streams so both UIs remove/flag the order immediately.

**Modification:** allowed only before `Preparing` starts. The order doc's `items`/`total` are updated in place; `updatedAt` changes, which is what the kitchen's stream reducer keys off of to show a "modified" highlight (see `KITCHEN-009`).

**Connection loss:** the customer's `OrderTrackingCubit` keeps the last known state, shows a "reconnecting" indicator (`REALTIME-003`/`004`) rather than clearing the screen, and Firestore's SDK automatically resumes the snapshot listener and delivers the latest state on reconnect — no manual polling needed.

### Future vs Stream — usage matrix
Use **`Stream<T>`** wherever a screen or role needs to react to *someone else's* changes in real time:
- Kitchen's incoming/active order queue
- Customer's order-tracking screen
- Waiter's ready-to-serve list and request inbox
- Table availability grid
- In-app notifications list

Use **`Future<T>`** wherever the operation is a one-shot action the current user initiates and only needs a single result:
- Login/Register/Logout
- Placing an order (the write itself)
- Fetching menu categories/products (read once, cached in the Cubit; product *availability* toggling could later become a stream, but isn't needed for MVP)
- Order history / order details (paginated, one-shot fetch)
- Generating and marking a bill paid
- Uploading a profile photo

---

## PART 10 — Flutter Architecture

```
lib/
  core/
    di/                 -> GetIt/Injectable setup
    error/               -> Failure classes, exception → failure mapping
    theme/                -> colors, text styles, ThemeData
    usecase/             -> base UseCase<Type, Params>
    utils/                -> formatters, validators
    widgets/             -> shared buttons, fields, states, badges
    router/               -> go_router config + guards
  features/
    auth/
      data/       -> models, datasources, repository impl
      domain/     -> entities, repository interface, use cases
      presentation/  -> cubit, screens, widgets
    menu/          (same 3-layer split)
    cart/
    tables/
    orders/
    kitchen/
    waiter/
    requests/
    notifications/
    billing/
    profile/
  main.dart
```

**Layer responsibilities:**
- **`domain/`** — pure Dart, no Flutter/Firebase imports. Entities, repository *interfaces*, use cases. This is the layer that defines business rules and is what unit tests target directly.
- **`data/`** — implements the domain repository interfaces. Contains models (`fromJson`/`toJson`), remote data sources (the only place `cloud_firestore`/`firebase_auth` APIs are called), and repository implementations that map Firestore data ↔ domain entities and translate exceptions into `Failure`s.
- **`presentation/`** — Cubits/Blocs (call use cases, expose state), screens, and widgets. No direct Firestore or repository access from widgets — everything goes through a Cubit.

Each feature only depends on `core/` and its own three layers — never reaches into another feature's `data/` directly. Cross-feature needs go through domain interfaces injected via GetIt.

---

## PART 11 — Bloc/Cubit Plan

| Cubit | Responsibility | Key states | Depends on | Future or Stream |
|---|---|---|---|---|
| `AuthCubit` | Login/register/logout, current-user/role awareness | initial, loading, authenticated(user), unauthenticated, error | AuthRepository | Both — actions are Future, current-user awareness is Stream |
| `MenuCubit` | Load categories/products, filter by category, search | loading, loaded(categories, products, filtered), error | MenuRepository | Future (menu is fetched once + cached; not expected to change mid-session) |
| `CartCubit` | Add/remove/update items, compute totals | cartState(items, subtotal, tax, total) | none (pure local state) | Neither — in-memory |
| `TableCubit` | Watch live table availability | loading, loaded(tables), noneAvailable | TableRepository | Stream |
| `OrderCubit` | Place an order from the current cart | initial, placing, placed(orderId), error | OrderRepository, CartCubit | Future |
| `OrderTrackingCubit` | Watch a single order's live status | loading, tracking(order), reconnecting, error | OrderRepository | Stream |
| `KitchenCubit` | Live queue of incoming/active kitchen orders, status actions | loading, queue(newOrders, preparing, ready), error | KitchenRepository | Stream (queue) + Future (status actions) |
| `WaiterCubit` | Live active orders, ready-to-serve list, table overview | loading, dashboard(activeOrders, readyOrders, tables), error | WaiterRepository, TableRepository | Stream + Future (serve action) |
| `RequestCubit` | Create requests (customer side) / watch + resolve requests (waiter side) | idle, sent, inbox(pendingRequests), error | RequestRepository | Stream (waiter inbox) + Future (create/resolve) |
| `NotificationCubit` | In-app notification list/badge | loading, loaded(notifications, unreadCount) | NotificationRepository | Stream |
| `BillingCubit` | Generate bill, mark paid | idle, generating, generated(bill), paid, error | BillingRepository | Future |
| `ProfileCubit` | View/update profile, favorites | loading, loaded(profile), updating, error | ProfileRepository | Future |

No `OrderModifyCubit` or similarly narrow one-off cubits — modification actions are exposed as additional methods on `OrderCubit`/`WaiterCubit` rather than spinning up new state holders for a single action, per the "don't create Cubits just for the sake of it" rule.

---

## PART 12 — Navigation

```
                Splash / Auth check
                       ↓
              Authenticated? ──No──→ Login / Register
                       │Yes
                       ↓
                Read role from Firestore
                       ↓
        ┌──────────────┼──────────────┐
        ↓               ↓               ↓
  Customer shell   Waiter shell    Kitchen shell
  (Menu, Cart,     (Dashboard,     (KDS, Order
   Tables, Order    Tables,         Details)
   Tracking,        Requests)
   Requests,
   Profile)
```

**Route guards (go_router `redirect`):**
- Unauthenticated user hitting any protected route → redirected to `/login`.
- Authenticated user hitting `/login` or `/register` → redirected to their role's home.
- Authenticated `customer` hitting a `/waiter/*` or `/kitchen/*` route → redirected to their own home (403-style redirect, not a visible error screen).
- Same rule mirrored for `waiter`/`kitchen` roles against each other's and the customer's routes.

Role is read once at auth-state-change time and cached in `AuthCubit`'s state, which the router's `refreshListenable` listens to — so a role change (shouldn't normally happen, but e.g. an admin reassigning staff later) re-evaluates guards without requiring a full app restart.

This guard is a **UX convenience only** — it is not the security boundary. The real boundary is Firestore Security Rules (Part 12/17 below), since a modified client could bypass client-side routing entirely.

---

## PART 13 — Security

- **Firestore rules are the actual authorization layer.** Every rule below is enforced server-side, never assumed from UI state.
- `users/{uid}`: readable/writable only by that uid (plus role field immutable after creation — checked via `resource.data.role == request.resource.data.role` on update, or simply disallowing `role` in update payloads).
- `orders/{id}`: create — only by an authenticated customer, `customerId` must equal `request.auth.uid`. Read — the owning customer, or any authenticated waiter/kitchen. Update — restricted by role and by an explicit allow-list of legal status transitions (kitchen may only move Pending→Accepted→Preparing→Ready or takeaway's equivalent; waiter may only move Ready→Served and Payment Pending→Paid; nobody may skip states).
- `tables/{id}`: no direct client write to `status`. The only path to `occupied` is the order-creation transaction (which itself is a Cloud Function or a tightly-scoped transaction rule); freeing a table only happens via the order-completion/cancellation path.
- `waiter_requests/{id}`: create — the owning customer only. Read/resolve — waiter role only.
- Input validation happens client-side for UX (immediate feedback) **and** is re-checked by rules/Functions for anything that affects money, status, or ownership — never trusted from the client alone.
- File uploads (`SECURITY-007`): Storage rules require auth, restrict path to the uploading user's own folder, and cap file size/type.
- FCM tokens are stored per-user, refreshed on token-refresh events, and never exposed to other users.

---

## PART 14 — Testing Strategy

- **Unit tests:** entities, use cases, cart/total calculation, order status transition rules — pure Dart, no mocking of Flutter widgets needed.
- **Bloc tests** (`bloc_test` package): `AuthCubit`, `CartCubit`, `OrderCubit`, `OrderTrackingCubit`, `KitchenCubit`, `WaiterCubit` — verifying state sequences given mocked repository Futures/Streams.
- **Widget tests:** Login screen, Product card, Cart screen, Checkout, Order tracking timeline, Kitchen order card.
- **Integration tests:** one full Dine-in flow (login → table → add product → place order → kitchen accepts/prepares/ready → customer sees ready → request bill → waiter resolves), and one full Takeaway flow, both run against the Firebase emulator suite so they're fast and don't touch prod data.
- **Firestore Rules tests:** using `@firebase/rules-unit-testing` to assert the permission matrix in Part 13 actually holds (e.g., a kitchen-role client *cannot* write `Served`, a customer *cannot* read another customer's order).

---

## PART 15 — Sprint Plan (2-week sprints, vertical-slice first)

**Sprint 1 — Foundation + Auth + Menu + Cart (skateboard, not yet ordering)**
Goal: app boots, a user can register/login and land on the right role home, browse the menu, and build a cart.
Tasks: `SETUP-*`, `DESIGN-001..005`, `FIREBASE-001..006`, `AUTH-001..018` (minus 17), `MENU-001..010`, `CART-001..007`, `TEST-001,002`.
Deliverable: customer can log in, browse, and have a working cart (no order placement yet).
DoD: `flutter analyze` clean, app runs on device/emulator, login → menu → cart works manually.

**Sprint 2 — The vertical slice: place an order, kitchen sees it, status updates live**
Goal: `Customer places order → Kitchen receives live → Kitchen updates status → Customer sees update live` — the single most important milestone in the whole project.
Tasks: `TABLE-001..008`, `ORDER-001..014,017`, `KITCHEN-001..008,011`, `REALTIME-001,002`, `SECURITY-001`, `DEPLOY-005`, `TEST-003,007`.
Deliverable: a real, working dine-in and takeaway order can be placed, prepared, and tracked live end to end.
DoD: manual run-through of both flows works with zero refreshes; core rules deployed to emulator.

**Sprint 3 — Waiter, requests, cancellation, and locking down permissions**
Goal: waiter has a working dashboard and can serve orders; call-waiter/request-bill work; illegal actions are blocked by rules, not just UI.
Tasks: `TABLE-009`, `ORDER-015,016,018`, `KITCHEN-009,010,012`, `WAITER-001..006,010`, `REQUEST-001..008`, `SECURITY-002..004,008`, `TEST-004,005,006`.
Deliverable: waiter role fully functional; requests flow works live; security rules enforce role boundaries.

**Sprint 4 — Billing, reliability, table-locking edge cases**
Goal: a dine-in order can be paid and completed; the table-locking transaction is solid; the app tolerates flaky connections.
Tasks: `TABLE-010` (waiting list, if kept), `BILL-001..007`, `REALTIME-003..007`, `SECURITY-005`, `WAITER-008`, `TEST-008`.
Deliverable: full dine-in order lifecycle including payment; offline/reconnect handled gracefully.

**Sprint 5 — Notifications, profile, order history**
Goal: push notifications work for order-ready and requests; customers can manage their profile and see past orders.
Tasks: `FIREBASE-007,008`, `NOTIFY-001..008`, `CUSTOMER-001..005`, `ORDER-013,014`, `WAITER-009`.
Deliverable: FCM pushes arrive on order-ready and new requests; profile and order history usable.

**Sprint 6 — Favorites, reviews, waiter-created orders, full integration tests**
Goal: secondary customer features complete; waiter can also create an order (walk-in support); both end-to-end integration tests pass.
Tasks: `CUSTOMER-006..010`, `WAITER-007`, `DESIGN-008`, `NOTIFY-008`, `TEST-009,010`.
Deliverable: both integration tests green on the emulator suite.

**Sprint 7 — Security tests, deployment, documentation, portfolio polish**
Goal: ship it and package it for a CV.
Tasks: `DEPLOY-001..004,006`, `REALTIME-008`, `DOCS-001..008`.
Deliverable: signed build, deployed rules/functions, complete README with diagrams, screenshots, and demo video.

---

## PART 16 — Critical Path

```
Firebase Setup
   ↓
Auth
   ↓
User Roles / Routing
   ↓
Menu ──────────────┐
   ↓                 │ (Cart can start once Menu entities exist,
Cart                 │  doesn't need Menu UI finished)
   ↓                 │
Table Management ←───┘
   ↓
Orders (create + transaction lock)
   ↓
Kitchen (KDS)
   ↓
Real-Time Streams (formalized once Orders+Kitchen exist)
   ↓
Waiter
   ↓
Customer Requests (needs Waiter inbox to be meaningful)
   ↓
Billing (needs Requests' "request bill" trigger)
   ↓
Notifications (can layer on top of any of the above once it exists)
```

**Can run in parallel:**
- `DESIGN-*` (theme/shared widgets) alongside `SETUP-*`/`FIREBASE-*` — no dependency.
- `MENU-*` and `TABLE-*` can be built in parallel once `SETUP-008`/Firebase are done — they don't depend on each other.
- `SECURITY-*` rules can be written in parallel with the feature they protect, but should land in the *same* sprint as that feature (rules for orders belong in Sprint 2/3, not deferred to Sprint 7).
- `TEST-*` for a feature should be written the sprint after that feature ships, not batched entirely at the end — Sprint 7 only holds the two big integration tests and anything that slipped.
- `DOCS-*` and `DEPLOY-*` are back-loaded to Sprint 7 by design — there's nothing to document or ship until the product is functionally complete.

---

## Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Table double-booking under concurrent selection | Two dine-in orders assigned to one table | Firestore transaction for order-create + table-occupy (`ORDER-005`/`TABLE-008`), not a plain write |
| Firestore rules drift from client logic (client assumes a transition the rules block) | Confusing "permission denied" errors | Rules unit tests (`SECURITY-008`) run in CI against the same transition table used in `ORDER-017` |
| Stream listeners not cancelled → memory leaks / stale state bleeding across screens | Wrong data shown, performance issues | `REALTIME-002` — standardized subscription lifecycle in every Cubit's `close()` |
| Scope creep into Admin/Inventory/Delivery mid-project | MVP never finishes, portfolio value drops | Part 6 scope lock; Future Scope items get zero implementation tasks |
| Cloud Functions overused as a crutch for logic that belongs client-side | Unnecessary complexity, harder to demo/debug | Functions restricted to FCM triggers only (Part 7) |

---

## PART 19 — Portfolio / CV Plan

Final deliverable package (`DOCS-001..008`, `DEPLOY-006`):
- `README.md` — Problem, Solution, Features, Architecture, Tech Stack, Real-Time Architecture, Database, Screenshots, Demo link, Installation, Testing, Future Improvements.
- Architecture diagram (Clean Architecture layers + feature-first tree).
- Database ERD (Firestore collections + relationships).
- User flow diagrams (dine-in, takeaway, no-table).
- Screenshots from all three role UIs.
- A short demo video showing the vertical slice live (order → kitchen → ready → served/picked up) — this is the single most convincing artifact for a CV reviewer, since it's the thing a static screenshot can't show.
- Setup guide, testing docs, and a short "Technical Decisions" write-up (why embedded order items, why Clean Architecture at this scale, Future vs Stream rationale) — this is what signals *engineering judgment*, not just "I can build screens."

---

## PART 20 — Future Scope (documented only, not implemented)

- Admin Dashboard (staff management, menu management UI, reporting)
- Multi-branch restaurant support
- Delivery order type + driver role
- Inventory management (stock levels tied to product availability)
- Supplier management
- Advanced analytics (sales dashboards, peak-hour insights)
- Loyalty / rewards system
- Real payment gateway integration (Stripe/Paymob/etc.) replacing the manual "mark as paid" flow
- AI-based recommendations ("customers who ordered X also liked Y")

None of these have implementation tasks in the backlog — they exist only as forward-looking notes for the README's "Future Improvements" section.

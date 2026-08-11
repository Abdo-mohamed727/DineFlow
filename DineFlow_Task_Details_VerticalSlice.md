# DineFlow — Detailed Task Descriptions (Critical-Path / Vertical-Slice Set)

These are the fully expanded task cards — in the Task Detail Template format — for the tasks on the critical path that prove the core product loop:

```
Customer places order → Kitchen receives it live → Kitchen updates status → Customer sees update live
→ Waiter serves → Customer requests bill
```

Every task in this file also exists as a row in `DineFlow_Notion_Backlog.csv`. The remaining ~165 tasks in the CSV (secondary screens, notifications, billing polish, docs, etc.) follow the exact same template — ask and I'll expand any specific one(s) to this level of detail on demand, rather than front-loading all 185 here.

---

## AUTH-001 — Create User Entity

**Task ID:** AUTH-001
**Objective:** Define the pure-Dart `User` domain entity representing any authenticated person, with a `role` field distinguishing customer/waiter/kitchen.
**Business Context:** Every feature in DineFlow branches on role. Getting this entity right early avoids reshaping auth logic later.
**User Story:** As a developer, I want a single canonical User entity, so that role-based logic has one source of truth across the app.
**Scope:** `id`, `name`, `email`, `role` (enum), `phone`, `photoUrl` fields; `Equatable`/`freezed` value equality.
**Out of Scope:** Persistence, Firestore mapping (that's `AUTH-002`).
**Technical Approach:** `freezed` class in `features/auth/domain/entities/user.dart`; `role` as a Dart enum (`customer`, `waiter`, `kitchen`), not a raw string, so illegal roles fail to compile/parse rather than silently passing through.
**Files / Layers:** Entity only — `domain/entities/user.dart`, `domain/entities/user_role.dart`.
**Dependencies:** SETUP-008 (base architecture conventions in place).
**Acceptance Criteria:** Entity compiles with `freezed`; equality works (two Users with identical fields are `==`); `role` cannot be an arbitrary string.
**Edge Cases:** Missing/optional fields (`phone`, `photoUrl`) must not be required.
**Error Handling:** N/A at entity level — validation happens at the data-mapping boundary.
**Testing:** Unit test asserting value equality and that constructing with an invalid role string (at the mapping layer) is rejected once `AUTH-002` exists.
**Definition of Done:** File created, compiles, unit test for equality passes, reviewed against naming conventions.
**Estimated Effort:** 1 hour
**Complexity:** XS
**Priority:** P0

---

## AUTH-006 — Implement LoginUseCase

**Task ID:** AUTH-006
**Objective:** Encapsulate "log a user in with email/password" as a single-responsibility use case the presentation layer calls.
**Business Context:** Keeps `AuthCubit` thin and testable — the Cubit shouldn't know *how* login works, only that it can call `LoginUseCase(params)`.
**User Story:** As a customer/waiter/kitchen user, I want to log in with my email and password, so that I can access my role's features.
**Scope:** Validate params are non-empty, call `AuthRepository.login(email, password)`, return `Either<Failure, User>`.
**Out of Scope:** UI, error message copy (handled in `AUTH-016`), social login (not in scope at all).
**Technical Approach:** Extends `UseCase<User, LoginParams>` from `core/usecase`. No Firebase imports here — only calls the repository interface.
**Files / Layers:** `domain/usecases/login_usecase.dart`.
**Dependencies:** AUTH-005 (AuthRepositoryImpl wired).
**Acceptance Criteria:** Given valid credentials, returns `Right(User)`. Given wrong credentials, returns `Left(Failure)` without throwing. Empty email/password short-circuits with a validation failure before hitting the repository.
**Edge Cases:** Whitespace-only email/password; already-logged-in user calling login again.
**Error Handling:** All repository exceptions caught upstream and mapped to `Failure` subtypes (`AuthFailure.invalidCredentials`, `AuthFailure.network`, etc.) — the use case never lets a raw `FirebaseAuthException` escape.
**Testing:** Unit test with a mocked `AuthRepository` covering success, wrong-password, and network-failure paths.
**Definition of Done:** Use case implemented, registered with GetIt, unit tests green.
**Estimated Effort:** 1 hour
**Complexity:** XS
**Priority:** P0

---

## AUTH-011 — Implement AuthCubit

**Task ID:** AUTH-011
**Objective:** Central state holder for auth status across the whole app: `initial`, `loading`, `authenticated(user)`, `unauthenticated`, `error`.
**Business Context:** This Cubit is what `go_router`'s guards read to decide where every screen sends the user — it's the backbone of role-based navigation.
**User Story:** As any user, I want the app to always know whether I'm logged in and what role I am, so that I land on the correct screen and stay there across app restarts.
**Scope:** Wraps `GetCurrentUserUseCase` (stream) for reactive auth-state, plus exposes `login()`, `register()`, `logout()` methods that call the corresponding use cases and emit loading/error/success states.
**Out of Scope:** The actual redirect logic (that's `AUTH-014`/`AUTH-015`, which *listen* to this Cubit).
**Technical Approach:** Cubit rather than full Bloc — there's no complex event transformation needed, just method calls mapping to state emissions. Subscribes to the auth-state stream in the constructor and cancels it in `close()`.
**Files / Layers:** `presentation/cubit/auth_cubit.dart`, `presentation/cubit/auth_state.dart` (freezed union).
**Dependencies:** AUTH-010 (all auth use cases registered with GetIt).
**Acceptance Criteria:** On app start with a valid existing session, emits `authenticated(user)` without requiring the user to re-enter credentials. On login failure, emits `error` with a mapped failure, and can recover back to `unauthenticated` on retry. On logout, emits `unauthenticated` and the stream subscription is properly disposed.
**Edge Cases:** Rapid login/logout taps (avoid overlapping in-flight calls corrupting state); app resumed after token expiry.
**Error Handling:** Every use case failure is mapped to a specific `AuthState.error(Failure)` variant so the UI can show a precise message.
**Testing:** `bloc_test` covering: cold start → authenticated; login success; login failure; logout.
**Definition of Done:** Cubit implemented, registered with GetIt, bloc tests green, manually verified across app restart.
**Estimated Effort:** 3 hours
**Complexity:** M
**Priority:** P0

---

## AUTH-015 — Configure go_router Route Guards

**Task ID:** AUTH-015
**Objective:** Wire `go_router`'s `redirect` callback to `AuthCubit` so unauthenticated users can't reach protected routes and authenticated users are routed to (and locked into) their own role's shell.
**Business Context:** This is the app-level enforcement of "no Admin, and no role sees another role's screens" from a UX standpoint (the real enforcement is Firestore rules — see SECURITY-*).
**User Story:** As a customer, I should never be able to navigate (even by typing a route) into the Kitchen or Waiter UI, so that the app stays simple and role-correct.
**Scope:** `redirect` logic: unauthenticated + protected route → `/login`; authenticated + `/login`/`/register` → role home; authenticated + wrong-role route → own role home.
**Out of Scope:** Firestore-level authorization (SECURITY-002..004) — this is UX-layer only.
**Technical Approach:** `GoRouter(refreshListenable: GoRouterRefreshStream(authCubit.stream), redirect: ...)`. Route paths are namespaced by role (`/customer/*`, `/waiter/*`, `/kitchen/*`) so the guard is a simple prefix check against `state.user.role`.
**Files / Layers:** `core/router/app_router.dart`, `core/router/route_guard.dart`.
**Dependencies:** AUTH-014 (redirect-target-by-role logic defined).
**Acceptance Criteria:** Deep-linking to a wrong-role route redirects silently to the correct home; logging out from any screen redirects to `/login`; logging in redirects straight to the correct role home, never through an intermediate screen.
**Edge Cases:** Role is `null` momentarily during the auth-state stream's first emission — guard must treat that as "loading," not "unauthenticated," to avoid a login-screen flash.
**Error Handling:** If role is missing/corrupted on the user doc, redirect to a generic error/support screen rather than crashing the guard.
**Testing:** Widget/integration test simulating navigation attempts across roles and asserting the final resolved route.
**Definition of Done:** All three role shells reachable only by their own role; verified manually and via test.
**Estimated Effort:** 3 hours
**Complexity:** M
**Priority:** P0

---

## MENU-001 — Create Category and Product Entities

**Task ID:** MENU-001
**Objective:** Define `Category` and `Product` domain entities.
**Business Context:** The menu is the entry point to the entire ordering flow — every downstream feature (Cart, Order) references `Product` by id.
**User Story:** As a developer, I want clean Category/Product entities, so that menu, cart, and order features share one consistent shape.
**Scope:** `Category(id, name, imageUrl?, sortOrder)`; `Product(id, categoryId, name, description, price, imageUrl?, isAvailable, sortOrder)`.
**Out of Scope:** Firestore mapping, availability-change streaming (not in MVP).
**Technical Approach:** `freezed` entities in `features/menu/domain/entities/`.
**Files / Layers:** `domain/entities/category.dart`, `domain/entities/product.dart`.
**Dependencies:** SETUP-008.
**Acceptance Criteria:** Entities compile, are immutable, support value equality; `price` is a `double`/`num`, never a string.
**Edge Cases:** Product with no `imageUrl` renders a placeholder downstream, not a crash.
**Error Handling:** N/A at entity level.
**Testing:** Equality unit test.
**Definition of Done:** Entities created and reviewed.
**Estimated Effort:** 1 hour
**Complexity:** XS
**Priority:** P0

---

## MENU-009 — Build Menu/Home Screen UI

**Task ID:** MENU-009
**Objective:** The customer's main landing screen after login: category tabs across the top, a scrollable product grid below.
**Business Context:** This is the first real screen a customer interacts with — it has to communicate "order type not chosen yet" isn't a blocker to *browsing*, only to checking out.
**User Story:** As a customer, I want to browse categories and products immediately after logging in, so that I can start building an order without extra steps.
**Scope:** Category tab bar (driven by `MenuCubit`'s loaded categories), product grid filtered by selected category, tap-through to Product Details, loading/empty/error states via shared widgets.
**Out of Scope:** Search bar (MENU-011), favorites toggle (CUSTOMER-008) — both layer on top later without restructuring this screen.
**Technical Approach:** `BlocBuilder<MenuCubit, MenuState>` driving a `TabBar` + `GridView.builder`; product card is a reusable widget so Favorites/Search can reuse it later without duplication.
**Files / Layers:** `presentation/screens/menu_screen.dart`, `presentation/widgets/product_card.dart`, `presentation/widgets/category_tabs.dart`.
**Dependencies:** MENU-008 (MenuCubit), DESIGN-005 (shared loading/empty/error widgets).
**Acceptance Criteria:** Categories load and are tappable; switching category re-filters the grid without a full reload; tapping a product navigates to Product Details with the correct id; empty category shows the shared empty state, not a blank screen.
**Edge Cases:** Category with zero products; very long product names (must not overflow the card); slow network on first load (loading skeleton, not a blank white screen).
**Error Handling:** Firestore fetch failure shows the shared error state with a retry action, not a silent blank screen.
**Testing:** Widget test: category switch updates visible products; product card tap navigates correctly.
**Definition of Done:** Screen implemented, responsive on phone-size viewports, widget tests green, manually verified against real Firestore data.
**Estimated Effort:** 4 hours
**Complexity:** L
**Priority:** P0

---

## CART-003 — Implement CartCubit

**Task ID:** CART-003
**Objective:** In-memory Cubit managing the current order-in-progress: add item, remove item, change quantity, clear cart.
**Business Context:** The cart is the bridge between "browsing" and "committing to an order" — it has to be fast and local; there's no reason to round-trip Firestore before checkout.
**User Story:** As a customer, I want to add, adjust, and remove items from my cart before I commit to an order, so that I can get my order exactly right.
**Scope:** `addItem(product, quantity, notes?)`, `removeItem(productId)`, `updateQuantity(productId, quantity)`, `clear()`; state exposes the item list plus computed totals (delegated to CART-004's pure function).
**Out of Scope:** Persistence across app restarts — MVP treats the cart as session-scoped, which is a deliberate simplification (documented in Technical Decisions), not an oversight.
**Technical Approach:** Plain Cubit over an in-memory `List<CartItem>` — no repository, no Firestore. `close()` has nothing to cancel since there's no subscription.
**Files / Layers:** `presentation/cubit/cart_cubit.dart`, `presentation/cubit/cart_state.dart`.
**Dependencies:** CART-002 (CartItem model), CART-001 (entity).
**Acceptance Criteria:** Adding the same product twice increments quantity rather than duplicating a line item; removing the last unit of an item removes the line entirely; `clear()` empties the cart after a successful order placement.
**Edge Cases:** Quantity dropped to zero via the stepper (should remove the item, not sit at 0); adding a product whose `isAvailable` has flipped false since the menu was loaded (block the add, surface a message).
**Error Handling:** N/A (no I/O) beyond the availability guard above.
**Testing:** `bloc_test` covering add/remove/update/clear and the duplicate-add-increments-quantity behavior specifically.
**Definition of Done:** Cubit implemented, tests green, wired into Product Details' "Add to Cart" and the Cart screen.
**Estimated Effort:** 3 hours
**Complexity:** M
**Priority:** P0

---

## CART-004 — Implement Cart Total/Tax Calculation Logic

**Task ID:** CART-004
**Objective:** A pure, side-effect-free function computing `subtotal`, `tax`, `total` from a list of cart items — the single source of truth reused by Cart, Checkout, Order creation, and Billing.
**Business Context:** Totals must match exactly between what the customer sees in the cart and what the order/bill later record — any drift here is a trust-breaking bug in a real restaurant app.
**User Story:** As a customer, I want the total I see in my cart to exactly match what I'm charged, so that I can trust the app.
**Scope:** `CartTotals calculateTotals(List<CartItem> items, {double taxRate})`; returns subtotal (sum of price*qty), tax (subtotal * rate), total (subtotal + tax - discount).
**Out of Scope:** Discount code logic (not in MVP scope at all — `discount` defaults to 0).
**Technical Approach:** Pure top-level/static function in `core/utils` or `cart/domain`, no Cubit/Firestore dependency, so it's trivially unit-testable and reusable from `BILL-004`/`ORDER-008` without duplicating the formula.
**Files / Layers:** `domain/utils/cart_calculator.dart` (or `core/utils` if shared across features).
**Dependencies:** CART-001.
**Acceptance Criteria:** Empty cart → all zeros. Single item → subtotal = price×qty exactly. Tax rounds consistently (e.g., 2 decimal places) to avoid off-by-a-cent mismatches between cart and bill.
**Edge Cases:** Floating-point rounding on tax; very large quantities; zero-price promotional items (still valid, not a bug).
**Error Handling:** N/A — pure function, invalid input (negative quantity) should be prevented upstream in CartCubit rather than handled here.
**Testing:** Unit tests: empty cart, one item, multiple items, rounding edge case at e.g. $0.005 tax boundary.
**Definition of Done:** Function implemented, 100% branch-covered by unit tests, reused (not reimplemented) in ORDER-008 and BILL-004.
**Estimated Effort:** 2 hours
**Complexity:** S
**Priority:** P0

---

## TABLE-001 — Create Table Entity

**Task ID:** TABLE-001
**Objective:** Define the `Table` domain entity with a status enum.
**Business Context:** Table state is the thing that has to stay perfectly consistent under concurrency — getting the entity/status enum right is the foundation for the transaction logic in TABLE-008.
**User Story:** As a customer, I want to see which tables are actually free, so that I don't pick one that's taken.
**Scope:** `id`, `number`, `capacity`, `status` (`available`/`occupied`/`reserved` enum).
**Out of Scope:** Reservation-ahead-of-time logic (not in MVP — `reserved` exists as a status for future use but nothing sets it yet).
**Technical Approach:** `freezed` entity, enum for status (never a raw string) so an invalid status can't compile through the app.
**Files / Layers:** `domain/entities/restaurant_table.dart` (named to avoid clashing with Flutter's `Table` widget).
**Dependencies:** SETUP-008.
**Acceptance Criteria:** Entity compiles, status enum has exactly three MVP values.
**Edge Cases:** N/A at entity level.
**Error Handling:** N/A.
**Testing:** Equality unit test.
**Definition of Done:** Entity created, naming collision with `Widget Table` confirmed avoided.
**Estimated Effort:** 1 hour
**Complexity:** XS
**Priority:** P0

---

## TABLE-008 — Implement Table Locking on Order Creation

**Task ID:** TABLE-008
**Objective:** Guarantee that two customers can never be assigned the same table at the same time, by making "create order" and "occupy table" one atomic Firestore transaction.
**Business Context:** This is the single highest-risk correctness bug in the whole app — a double-booked table is a visible, embarrassing failure in front of real customers, and it's exactly the kind of race condition a naive "read then write" implementation will hit under any real concurrent load.
**User Story:** As a customer, when I select a table and place my order, I want that table locked to me immediately, so that no one else can be seated there while I'm ordering.
**Scope:** A Firestore transaction that: (1) reads the table doc, (2) aborts with a clear failure if `status != available`, (3) writes the new order doc, (4) sets the table's `status = occupied` — all within one `runTransaction` call, so it either fully succeeds or fully fails with nothing left half-applied.
**Out of Scope:** Freeing the table (that's the completion/cancellation path, `ORDER-015` and the Completed-status handler) — this task is *only* the occupy side.
**Technical Approach:** `FirebaseFirestore.instance.runTransaction((tx) async { ... })`; the table-availability check happens *inside* the transaction (not in the UI beforehand) precisely because the UI's last-known state can be stale between "user taps table" and "user taps place order."
**Files / Layers:** `data/datasources/order_remote_datasource.dart` (transaction lives here, not in the repository or Cubit, since it's Firestore-specific), `domain/usecases/place_order_usecase.dart` (calls it, doesn't know it's a transaction).
**Dependencies:** ORDER-004 (order creation data source), TABLE-002 (table repository interface).
**Acceptance Criteria:** Two clients attempting to select the same table within the same second — one order succeeds, the other fails with a specific "table just became unavailable" error the UI can show (not a generic error). No order is ever created without its table also flipping to occupied in the same write.
**Edge Cases:** Table selected, then the app is backgrounded for a long time before "Place Order" is tapped (transaction re-checks freshness at commit time, not selection time); network drop mid-transaction (Firestore's SDK either fully commits or fully rolls back — never partially).
**Error Handling:** Transaction abort surfaces as a typed `TableNoLongerAvailableFailure`, which `OrderCubit` maps to a specific UI message + a prompt to reselect a table, not a generic "something went wrong."
**Testing:** Integration test against the Firestore emulator firing two near-simultaneous transactions at the same table and asserting exactly one succeeds.
**Definition of Done:** Transaction implemented, race-condition test green on the emulator, manually verified with two devices/simulators.
**Estimated Effort:** 3 hours
**Complexity:** M
**Priority:** P0

---

## ORDER-001 — Create Order and OrderItem Entities

**Task ID:** ORDER-001
**Objective:** Define the `Order` and `OrderItem` domain entities plus `OrderType` and `OrderStatus` enums, matching the schema in the Database Design.
**Business Context:** The Order entity is the load-bearing wall of the entire app — every feature (Kitchen, Waiter, Requests, Billing) reads or writes some slice of it.
**User Story:** As a developer, I want one canonical, strongly-typed Order entity, so that every feature agrees on what an order looks like and illegal states are unrepresentable.
**Scope:** `Order(id, customerId, waiterId?, tableId?, orderType, items, subtotal, tax, discount, total, status, notes?, createdAt, updatedAt)`; `OrderItem(productId, name, price, quantity, notes?)`; `OrderType` enum (`dineIn`, `takeaway`); `OrderStatus` enum covering the union of both lifecycles from Part 9.
**Out of Scope:** Firestore mapping (ORDER-002), transition validation logic (ORDER-017).
**Technical Approach:** `freezed` entity; `tableId` typed as nullable and only meaningful when `orderType == dineIn` — enforced by a factory/validation helper rather than scattered null-checks downstream.
**Files / Layers:** `domain/entities/order.dart`, `domain/entities/order_item.dart`, `domain/entities/order_type.dart`, `domain/entities/order_status.dart`.
**Dependencies:** CART-001, TABLE-001.
**Acceptance Criteria:** Entity compiles; constructing a `dineIn` order without a `tableId` is caught by a factory-level assertion/validation, not left to fail silently downstream.
**Edge Cases:** Takeaway order must not accept a `tableId`.
**Error Handling:** N/A at entity level.
**Testing:** Unit test for the dine-in/table-id invariant.
**Definition of Done:** Entities created, invariant test passes, reviewed against the DB schema in the Product Plan.
**Estimated Effort:** 2 hours
**Complexity:** S
**Priority:** P0

---

## ORDER-008 — Implement PlaceOrderUseCase

**Task ID:** ORDER-008
**Objective:** Orchestrate turning the current cart into a persisted `Order`: validate, build the entity, call the repository, and signal success so the cart can be cleared.
**Business Context:** This is the exact moment a browsing session becomes a real business transaction the kitchen has to act on — it has to be robust, not just "happy path."
**User Story:** As a customer, I want to place my order and know it actually went through, so that I can trust the kitchen received it.
**Scope:** Takes cart items + order type + optional table id, reuses `CART-004`'s totals calculation, builds an `Order`, calls `OrderRepository.createOrder()` (which internally uses the `ORDER-005`/`TABLE-008` transaction for dine-in).
**Out of Scope:** The transaction itself (ORDER-005/TABLE-008) — this use case calls it, doesn't implement it.
**Technical Approach:** `UseCase<Order, PlaceOrderParams>`; validates cart isn't empty and, for dine-in, that a table is selected, *before* touching Firestore, so obviously-invalid attempts never hit the network.
**Files / Layers:** `domain/usecases/place_order_usecase.dart`.
**Dependencies:** ORDER-007, CART-004.
**Acceptance Criteria:** Empty cart → validation failure, no Firestore call made. Valid dine-in order → order created and table occupied atomically. Valid takeaway order → order created with `tableId = null`. On success, returns the new order's id so the tracking screen can subscribe immediately.
**Edge Cases:** Cart contains a product that became unavailable between add-to-cart and place-order (surfaced clearly, order blocked); network failure mid-request (no partial order created, thanks to the underlying transaction).
**Error Handling:** All failures typed and mapped (`EmptyCartFailure`, `TableRequiredFailure`, `TableNoLongerAvailableFailure`, `NetworkFailure`) so `OrderCubit` can show precise messaging.
**Testing:** Unit test with a mocked repository covering empty-cart, missing-table-for-dine-in, and success paths.
**Definition of Done:** Use case implemented, tests green, wired into `OrderCubit`.
**Estimated Effort:** 2 hours
**Complexity:** S
**Priority:** P0

---

## ORDER-011 — Implement OrderTrackingCubit

**Task ID:** ORDER-011
**Objective:** Stream-based Cubit that watches a single order document in real time and exposes its current status/details to the tracking screen.
**Business Context:** This is the customer-facing half of the vertical slice — the whole point of the real-time architecture is that this Cubit's state changes the instant the kitchen or waiter act, with zero manual refresh.
**User Story:** As a customer, I want my order's status to update live on screen, so that I always know what's happening without asking anyone.
**Scope:** Subscribes to `OrderRepository.watchOrder(orderId)`, emits `tracking(order)` on every snapshot, handles the reconnecting state from `REALTIME-004` once that lands.
**Out of Scope:** The bill/request actions available from this screen (those are separate Cubits/buttons layered on top — REQUEST-004..006).
**Technical Approach:** Cubit holding a `StreamSubscription`, cancelled in `close()` — this is the canonical example the `REALTIME-002` standard is modeled on.
**Files / Layers:** `presentation/cubit/order_tracking_cubit.dart`, `presentation/cubit/order_tracking_state.dart`.
**Dependencies:** ORDER-007 (watchOrder implemented on the repository).
**Acceptance Criteria:** Opening the tracking screen immediately shows the current status; a kitchen-side status change (tested by manually flipping the doc in the Firebase console) reflects on screen within the normal Firestore snapshot latency, with no app interaction required.
**Edge Cases:** Order deleted/not found (shouldn't normally happen, but must not crash — show an error state); subscribing to an order the current user doesn't own (blocked by security rules before it ever reaches this Cubit).
**Error Handling:** Stream errors (e.g., permission-denied) map to a typed error state distinct from "loading."
**Testing:** `bloc_test` using a fake stream emitting a sequence of order snapshots, asserting the corresponding state sequence.
**Definition of Done:** Cubit implemented, subscription lifecycle verified (no leak on screen dispose), tests green.
**Estimated Effort:** 3 hours
**Complexity:** M
**Priority:** P0

---

## ORDER-012 — Build Order Tracking Screen

**Task ID:** ORDER-012
**Objective:** The customer-facing live status screen — a visual timeline (Pending → Accepted → Preparing → Ready → Served, or the takeaway equivalent) that updates itself.
**Business Context:** This screen *is* the product's core value proposition made visible — it's what replaces "wondering where your food is."
**User Story:** As a customer, I want to see a clear, live timeline of my order's progress, so that I feel informed rather than left waiting blindly.
**Scope:** Status timeline widget driven by `OrderTrackingCubit`, order summary (items, total, table/pickup info), hooks for the Call Waiter / Request Bill buttons (REQUEST-005/006) to attach to, once those land.
**Out of Scope:** The request buttons' own logic (separate tasks) — this screen just reserves the UI slot for them.
**Technical Approach:** `BlocBuilder<OrderTrackingCubit, OrderTrackingState>` driving a horizontal/vertical stepper built from the shared `StatusBadge`/timeline widget (`DESIGN-006`); different step sets rendered conditionally based on `orderType`.
**Files / Layers:** `presentation/screens/order_tracking_screen.dart`, `presentation/widgets/order_status_timeline.dart`.
**Dependencies:** ORDER-011, DESIGN-006.
**Acceptance Criteria:** Dine-in orders show the 8-step timeline, takeaway shows the 6-step version; the current step is visually distinct from completed/upcoming steps; screen updates without any pull-to-refresh when status changes server-side.
**Edge Cases:** Cancelled order — timeline must clearly show "Cancelled" rather than getting stuck on the last active step.
**Error Handling:** Load failure shows the shared error state with retry.
**Testing:** Widget test verifying the correct step set renders per order type, and that the "current step" highlight moves when the Cubit's state changes.
**Definition of Done:** Screen implemented, manually verified end-to-end against a real kitchen-side status change, widget tests green.
**Estimated Effort:** 4 hours
**Complexity:** L
**Priority:** P0

---

## ORDER-017 — Implement Order Status Transition Validation

**Task ID:** ORDER-017
**Objective:** A single, explicit source of truth for which status transitions are legal, used both client-side (to disable/hide illegal actions) and as the model for the Firestore rules that enforce it server-side.
**Business Context:** Without this, it's easy for a rushed kitchen tap or a bug to skip a status (e.g., Pending straight to Ready) and desync the customer's and waiter's view of reality.
**User Story:** As kitchen/waiter staff, I want the app to only let me perform valid next actions, so that I can't accidentally corrupt an order's state.
**Scope:** A `Map<OrderStatus, Set<OrderStatus>>` (or equivalent) defining legal next-states per current state, separately for dine-in and takeaway; a pure function `canTransition(from, to, orderType) → bool` used everywhere a status change is attempted.
**Out of Scope:** The Firestore rules themselves (SECURITY-003/004) — but they are written to mirror this exact table, so the two never silently drift apart (both reference this same document/task as their spec).
**Technical Approach:** Pure Dart in `domain/`, no Firestore dependency, trivially unit-testable, imported by `KITCHEN-003`'s use cases, `WAITER-003`, and `BILL-004`.
**Files / Layers:** `domain/utils/order_status_transitions.dart`.
**Dependencies:** ORDER-007.
**Acceptance Criteria:** Every transition described in Part 9's lifecycle tables is legal; every transition *not* described (e.g., skipping a step, or a takeaway order attempting a dine-in-only step like "Served") is rejected by `canTransition`.
**Edge Cases:** Cancellation is a legal transition from `Pending`/`Accepted` only, from either lifecycle — modeled as a special-cased allowed target, not a normal forward step.
**Error Handling:** Attempting an illegal transition returns a typed `IllegalStatusTransitionFailure` rather than silently no-op'ing.
**Testing:** Exhaustive unit tests over the full transition matrix for both order types, including the cancellation special case.
**Definition of Done:** Function implemented, full matrix covered by tests, used by all three status-changing use cases (kitchen/waiter/billing), and used as the literal reference doc when writing SECURITY-003/004.
**Estimated Effort:** 3 hours
**Complexity:** M
**Priority:** P0

---

## KITCHEN-001 — Define KitchenRepository Interface

**Task ID:** KITCHEN-001
**Objective:** Domain-layer contract for everything the Kitchen Display System needs: watching the live queue and performing the three kitchen actions.
**Business Context:** Defining this interface first (before the Firestore-specific implementation) keeps `KitchenCubit` and the KDS screen fully mockable and testable, and keeps Firestore query details out of the presentation layer.
**User Story:** As a developer, I want a clear KitchenRepository contract, so that the KDS screen never talks to Firestore directly.
**Scope:** `watchIncomingOrders()`, `watchActiveOrders()` (both `Stream<List<Order>>`), `acceptOrder(id)`, `startPreparing(id)`, `markReady(id)` (all `Future<void>`, internally validated against `ORDER-017`).
**Out of Scope:** The Firestore query implementation (KITCHEN-002).
**Technical Approach:** Abstract class in `domain/repositories/kitchen_repository.dart`.
**Files / Layers:** `domain/repositories/kitchen_repository.dart`.
**Dependencies:** ORDER-007.
**Acceptance Criteria:** Interface compiles; a mock implementation can be trivially created for `KitchenCubit`'s bloc tests before the real Firestore-backed implementation exists.
**Edge Cases:** N/A at interface level.
**Error Handling:** Method signatures return `Future<void>`/throw domain exceptions the implementation must map, not raw Firestore exceptions.
**Testing:** N/A directly (covered via the implementation and Cubit tests).
**Definition of Done:** Interface defined and reviewed.
**Estimated Effort:** 2 hours
**Complexity:** S
**Priority:** P0

---

## KITCHEN-004 — Implement KitchenCubit

**Task ID:** KITCHEN-004
**Objective:** Stream-based Cubit exposing the live, status-grouped order queue to the KDS screen, plus the three action methods.
**Business Context:** This is the kitchen-side half of the vertical slice — new orders must appear the instant they're placed, with zero refresh, in a loud, busy kitchen environment where staff can't be expected to babysit a refresh button.
**User Story:** As kitchen staff, I want new orders to appear on my screen automatically, so that I never miss one while my hands are full.
**Scope:** Subscribes to `watchIncomingOrders()`/`watchActiveOrders()`, groups results by status into `newOrders`/`preparing`/`ready` lists, exposes `accept()`, `startPreparing()`, `markReady()` that call the repository and rely on the stream to reflect the change (no manual local-state mutation needed, avoiding drift).
**Out of Scope:** Sound/visual new-order alerts (KITCHEN-007) — layered on top of this Cubit's state stream later.
**Technical Approach:** Cubit with a managed `StreamSubscription`, following the same lifecycle pattern as `OrderTrackingCubit` (REALTIME-002 standard).
**Files / Layers:** `presentation/cubit/kitchen_cubit.dart`, `presentation/cubit/kitchen_state.dart`.
**Dependencies:** KITCHEN-003 (use cases).
**Acceptance Criteria:** Placing an order from a second device/emulator causes it to appear in the `newOrders` list on the KDS within normal snapshot latency, with no interaction on the kitchen screen. Tapping Accept moves it into `preparing` purely via the stream re-emitting (not a local optimistic patch that could drift from server truth).
**Edge Cases:** Two kitchen devices open simultaneously — both must reflect the same state, since the source of truth is the stream, not local state.
**Error Handling:** Action failures (e.g., illegal transition per ORDER-017) surface as a state the UI can show as a toast, without blowing away the current queue.
**Testing:** `bloc_test` with a fake order stream verifying the new/preparing/ready grouping, plus action-method success/failure.
**Definition of Done:** Cubit implemented, tests green, manually verified across two devices for the true real-time behavior.
**Estimated Effort:** 3 hours
**Complexity:** M
**Priority:** P0

---

## KITCHEN-005 — Build Kitchen Dashboard (KDS) Screen

**Task ID:** KITCHEN-005
**Objective:** The kitchen's main and only real screen — a three-column board (New / Preparing / Ready) built for glanceability from a few feet away.
**Business Context:** This screen has to work for someone with flour on their hands glancing up mid-task — high contrast, large tap targets, minimal text.
**User Story:** As kitchen staff, I want a clear, columnar view of every order's stage, so that I always know what to cook next without reading fine print.
**Scope:** Three-column (or tabbed on narrow screens) layout backed by `KitchenCubit`; each card uses the `KITCHEN-006` order card widget; large one-tap action buttons per card (Accept / Start / Ready, contextual to its column).
**Out of Scope:** The alert sound/flash (KITCHEN-007), the details drill-down (KITCHEN-008) — both attach to this screen without restructuring it.
**Technical Approach:** `BlocBuilder<KitchenCubit, KitchenState>` driving three `ListView`s (or a `Row` of columns on tablet-width kitchen displays, which is the realistic deployment target for a KDS).
**Files / Layers:** `presentation/screens/kitchen_dashboard_screen.dart`.
**Dependencies:** KITCHEN-004, DESIGN-006.
**Acceptance Criteria:** A newly placed order appears in "New" without interaction; tapping its action button moves it to the next column live; dine-in vs takeaway is visually distinguishable at a glance (KITCHEN-011).
**Edge Cases:** Empty columns (clear "no orders" state, not a blank gap); very high order volume (list scrolls, doesn't overflow layout).
**Error Handling:** Action-tap failure shows a brief, non-blocking error (snackbar), the order stays where it was.
**Testing:** Widget test verifying an order appears in the correct column per its status and moves columns when the underlying state changes.
**Definition of Done:** Screen implemented, manually verified as genuinely usable at a glance, widget tests green.
**Estimated Effort:** 4 hours
**Complexity:** L
**Priority:** P0

---

## REQUEST-004 — Implement CallWaiterUseCase and RequestBillUseCase

**Task ID:** REQUEST-004
**Objective:** Two small use cases letting a dine-in customer create a `waiter_requests` document from their tracking screen.
**Business Context:** This directly replaces the physical "wave your hand" or "shout excuse me" moment — it's a small feature with outsized experiential value.
**User Story:** As a customer, I want to call the waiter or request the bill with one tap, so that I don't have to physically flag someone down.
**Scope:** `CallWaiterUseCase(orderId, tableId)`, `RequestBillUseCase(orderId, tableId)` — both create a `WaiterRequest` via `RequestRepository.createRequest()`.
**Out of Scope:** The waiter-side inbox/resolve logic (REQUEST-007/008).
**Technical Approach:** Thin use cases; both guard that the order is dine-in (takeaway has no table to call a waiter to) and, for bill requests specifically, that the order is at least `Served` (no point requesting a bill before food arrives).
**Files / Layers:** `domain/usecases/call_waiter_usecase.dart`, `domain/usecases/request_bill_usecase.dart`.
**Dependencies:** REQUEST-003.
**Acceptance Criteria:** Tapping Call Waiter on a valid dine-in order creates exactly one pending request; a duplicate tap while a request is already pending for that order is a no-op (not a second document), so the waiter inbox doesn't fill with duplicates from an impatient double-tap.
**Edge Cases:** Rapid repeated taps (idempotency guard above); takeaway order attempting to call a waiter (blocked with a clear reason, not silently ignored).
**Error Handling:** Failure returns a typed `RequestFailure` the UI maps to a brief message.
**Testing:** Unit tests covering the duplicate-tap idempotency guard and the takeaway-blocked case.
**Definition of Done:** Use cases implemented, tests green, wired to the tracking screen's buttons.
**Estimated Effort:** 1.5 hours
**Complexity:** S
**Priority:** P0

---

## REQUEST-005 — Build "Call Waiter" Button on Order Tracking Screen

**Task ID:** REQUEST-005
**Objective:** The actual tappable UI entry point for `CallWaiterUseCase`, placed contextually on the Order Tracking screen.
**Business Context:** Needs to be obviously present without cluttering the main status timeline that's the screen's primary job.
**User Story:** As a dine-in customer looking at my order status, I want a clearly visible "Call Waiter" button, so that I can get help without hunting for it.
**Scope:** Button (only rendered for `orderType == dineIn`), tap triggers the use case via a Cubit, shows a brief confirmation ("Waiter notified") and disables itself while a request is already pending for this order.
**Out of Scope:** The bill button (REQUEST-006, built the same sprint but a separate task since it has its own enable/disable condition).
**Technical Approach:** Simple `ElevatedButton`/`OutlinedButton` wired to a lightweight request-Cubit method; disabled state driven by whether a pending request already exists (read from the same order-tracking stream's request-flag, or a small dedicated stream — whichever keeps this screen from needing a second heavy subscription).
**Files / Layers:** `presentation/screens/order_tracking_screen.dart` (extends ORDER-012's screen), `presentation/cubit/request_cubit.dart` (customer-facing slice).
**Dependencies:** REQUEST-004, ORDER-012.
**Acceptance Criteria:** Button visible only for dine-in orders; tapping it creates a request and shows confirmation; button is disabled (not hidden) while a request is pending, so it's clear the tap registered.
**Edge Cases:** Screen reopened after backgrounding the app while a request is still pending — disabled state must reflect that correctly on reopen, not reset.
**Error Handling:** Failed request shows a retry-able error, doesn't silently fail.
**Testing:** Widget test: button hidden for takeaway, tappable→disabled sequence for dine-in.
**Definition of Done:** Button implemented, manually verified against the waiter-side inbox actually receiving it live, widget tests green.
**Estimated Effort:** 2 hours
**Complexity:** S
**Priority:** P0

---

*End of expanded set. Every remaining CSV row (secondary UI, notifications, billing polish, profile/favorites, deployment, documentation, and the full test suite) can be expanded to this same template on request — just name the Task ID(s).*

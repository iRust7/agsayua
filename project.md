<!-- File: 02-full-project-scope.md -->

# E-Commerce Mobile App — Full Project Prompt + Instructions (Flutter + REST API + XAMPP MySQL)

## Prompt
Build a complete e-commerce mobile application with a modern UI/UX, reliable CRUD capabilities, and a scalable architecture.
Implement the mobile client in Flutter and connect it to a local REST API backed by MySQL hosted via XAMPP for development and testing.
Deliver clean engineering, consistent UI behavior, and robust handling of loading, empty, and error states.
The result must be maintainable, testable, and easy to extend.

---

## Instructions

### 1) Scope and Non-Scope
#### In Scope
- Product browsing.
- Product detail.
- Cart management.
- Checkout simulation (no real payment gateway).
- Order creation and status tracking.
- Admin CRUD for products and categories.
- Admin order status update.
- REST API with MySQL database.
- Local environment using XAMPP.

#### Out of Scope (for baseline)
- Real payments.
- Real shipping rate integrations.
- Real push notifications.
- Multi-seller marketplace complexity.
- Live chat.
- Complex promotions engine.

### 2) System Overview
- Mobile client:
- Flutter app.
- Clean UI implementation from design system.
- State management.
- Data layer with repositories.
- Backend:
- REST API running locally.
- CRUD endpoints.
- Validation and error responses.
- Database:
- MySQL in XAMPP.
- Normalized tables.
- Foreign keys.

### 3) Architecture Targets
- Clear separation of concerns:
- Presentation layer.
- Domain layer.
- Data layer.
- Testable code:
- Mockable repositories.
- Minimal side effects.
- Predictable state changes.
- Scalable patterns:
- Feature-based foldering.
- Reusable components.

### 4) Data Model (MySQL)
#### Table: categories
- id (INT, PK, AUTO_INCREMENT).
- name (VARCHAR, UNIQUE).
- created_at (DATETIME).
- updated_at (DATETIME).

#### Table: products
- id (INT, PK, AUTO_INCREMENT).
- category_id (INT, FK).
- name (VARCHAR).
- description (TEXT).
- price (DECIMAL).
- stock (INT).
- image_url (VARCHAR, NULL).
- is_active (TINYINT).
- created_at (DATETIME).
- updated_at (DATETIME).

#### Table: orders
- id (INT, PK, AUTO_INCREMENT).
- order_code (VARCHAR, UNIQUE).
- customer_name (VARCHAR).
- customer_phone (VARCHAR).
- address_line (VARCHAR).
- city (VARCHAR).
- postal_code (VARCHAR).
- subtotal (DECIMAL).
- shipping_fee (DECIMAL).
- total (DECIMAL).
- status (ENUM: pending, paid, shipped, delivered, cancelled).
- created_at (DATETIME).
- updated_at (DATETIME).

#### Table: order_items
- id (INT, PK, AUTO_INCREMENT).
- order_id (INT, FK).
- product_id (INT, FK).
- product_name_snapshot (VARCHAR).
- price_snapshot (DECIMAL).
- qty (INT).
- line_total (DECIMAL).
- created_at (DATETIME).

#### Optional Table: admins (for simple admin auth)
- id.
- username.
- password_hash.
- created_at.

### 5) Database Rules
- Enforce foreign keys.
- Cascade strategy:
- categories → products:
- Prefer restrict delete or soft delete.
- orders → order_items:
- Cascade delete.
- Use indexes:
- products(category_id).
- orders(status).
- order_items(order_id).

### 6) REST API Design
#### Base Principles
- JSON request/response.
- Consistent error format.
- Status codes meaningful:
- 200 OK.
- 201 Created.
- 400 Bad Request.
- 404 Not Found.
- 409 Conflict.
- 500 Server Error.

#### Response Envelope (recommended)
- success (bool).
- data (object/array/null).
- message (string).
- errors (object/null).

### 7) API Endpoints

#### Categories
- GET /categories
- POST /categories
- GET /categories/{id}
- PUT /categories/{id}
- DELETE /categories/{id}

Category Validation
- name required.
- name unique.
- name length constraints.

#### Products
- GET /products
- Supports:
- ?search=
- ?category_id=
- ?sort=price_asc|price_desc|newest
- ?page=
- ?limit=
- GET /products/{id}
- POST /products
- PUT /products/{id}
- DELETE /products/{id}

Product Validation
- name required.
- price numeric > 0.
- stock integer >= 0.
- category_id exists.

#### Orders
- GET /orders
- Supports:
- ?status=
- ?search=order_code
- GET /orders/{id}
- POST /orders
- PUT /orders/{id}/status
- Optional: DELETE /orders/{id} (usually avoid)

Order Creation Input
- customer_name.
- customer_phone.
- address fields.
- items:
- product_id.
- qty.

Backend Order Logic
- Validate stock availability.
- Snapshot product name and price into order_items.
- Reduce stock after order created (or after “paid” if desired).
- Compute subtotal and total server-side.

### 8) Backend Implementation Notes (Local)
- Choose a backend approach that can run locally:
- PHP (common with XAMPP).
- Or another local server stack.
- Ensure CORS enabled for emulator/device.
- Provide seed script:
- Create default categories.
- Create sample products.

### 9) Flutter App Structure (Recommended)
Use feature-first with shared core.

#### /lib
- /core
- /core/network
- api_client.dart
- api_errors.dart
- /core/theme
- colors.dart
- typography.dart
- spacing.dart
- theme.dart
- /core/widgets
- buttons.dart
- text_fields.dart
- empty_state.dart
- shimmer.dart
- /core/utils
- currency_format.dart
- validators.dart
- /features
- /catalog
- /data
- catalog_repository.dart
- catalog_api.dart
- models.dart
- /presentation
- catalog_screen.dart
- product_detail_screen.dart
- widgets/
- /cart
- /data
- cart_repository.dart
- /presentation
- cart_screen.dart
- checkout_screen.dart
- /orders
- /data
- orders_repository.dart
- /presentation
- orders_screen.dart
- order_detail_screen.dart
- /admin
- /presentation
- admin_home.dart
- manage_products.dart
- product_form.dart
- manage_categories.dart
- category_form.dart
- manage_orders.dart
- /state
- providers.dart
- app_router.dart
- main.dart

### 10) State Management
- Choose one approach and apply consistently.
- Requirements:
- Global cart state.
- Catalog list state with pagination.
- Product detail state.
- Orders list state.
- Admin CRUD forms state.
- Preferred patterns:
- Immutable state objects.
- Async state wrappers (loading/success/error).
- Caching strategy:
- Cache categories.
- Cache recent products.

### 11) Networking Layer
- Central API client:
- Base URL.
- Timeouts.
- Logging (dev only).
- Interceptors:
- Error mapping.
- Token injection (optional).
- Handle:
- Network failures.
- Server errors.
- Invalid JSON.

### 12) Environment Configuration
- Support dev configuration:
- Base API URL for emulator.
- Base API URL for real device (LAN IP).
- Avoid hardcoding:
- Use environment constants.

### 13) UI Implementation Requirements
- Use the design system tokens:
- Colors.
- Typography.
- Spacing.
- Radius.
- Use consistent components.
- Implement states everywhere:
- Loading shimmer.
- Empty state.
- Error with retry.
- Confirmation dialogs for destructive actions.
- Disable buttons during async operations.
- Provide toasts/snackbars for success/failure.

### 14) Feature Requirements (Client)

#### Catalog
- Product grid/list.
- Category chips.
- Search bar.
- Filter and sort.
- Pull-to-refresh.
- Pagination or “load more”.

#### Product Detail
- Image carousel.
- Price and stock.
- Description.
- Add to cart CTA.
- Quantity selection optional.

#### Cart
- Adjust quantity.
- Remove item.
- Auto total.
- Proceed to checkout.

#### Checkout
- Address form with validation.
- Order summary.
- Place order:
- Creates order via API.
- Show confirmation.

#### Orders
- List orders.
- Filter by status.
- Order detail.
- Status badge.

#### Admin
- Products CRUD.
- Categories CRUD.
- Orders status update.

### 15) Validation Rules (Client-Side)
- Product:
- name non-empty.
- price valid numeric.
- stock non-negative.
- category selected.
- Category:
- name non-empty.
- Checkout:
- name non-empty.
- phone format basic.
- address non-empty.
- Items not empty.

### 16) Error Handling and UX Rules
- 404:
- Show not found state.
- 409:
- Show conflict message (e.g., category name exists).
- 400:
- Show inline validation errors.
- 500:
- Show generic error + retry.
- Network offline:
- Show offline banner + cached content if available.

### 17) Security (Baseline)
- Input sanitization server-side.
- Parameterized queries to prevent SQL injection.
- CORS restricted to dev origins where possible.
- Admin route protection:
- At minimum:
- simple shared secret token in headers (dev).
- Or basic login with stored admin credentials.

### 18) Performance Targets
- Catalog screen scroll at 60fps target.
- Image loading:
- Placeholder and caching.
- Avoid rebuild storms:
- Use memoization where needed.
- Use pagination to avoid huge lists.

### 19) Testing Strategy
#### Unit Tests
- Currency formatting.
- Validators.
- Repository mapping logic.
- State transitions.

#### Widget Tests
- Product card renders properly.
- Cart total updates.
- Empty state appears.

#### Integration Tests (Optional)
- Add product → visible in list.
- Add to cart → checkout → order created.

### 20) Seed Data and Demo Content
- Provide at least:
- 5 categories.
- 20 products.
- Mix of prices and stock.
- Use realistic names and descriptions.

### 21) Backend Setup Notes (XAMPP)
- Create database:
- ecom_app.
- Run migration SQL:
- create tables.
- add indexes.
- Seed script:
- insert categories.
- insert products.
- Ensure API is reachable:
- emulator uses special host mapping if needed.
- real device uses machine LAN IP.

### 22) API Documentation
- Provide API spec markdown:
- endpoints.
- request bodies.
- response examples.
- error examples.
- Provide Postman collection (optional).

### 23) Dev Workflow
- Step 1:
- Start MySQL in XAMPP.
- Step 2:
- Start backend server.
- Step 3:
- Run Flutter app on emulator/device.
- Step 4:
- Verify base URL connectivity.
- Step 5:
- Test CRUD flows end-to-end.

### 24) Acceptance Criteria
- CRUD works for products and categories via API.
- Orders can be created and listed.
- Admin can update order status.
- UI matches design system.
- App handles loading/empty/error states.
- Input validation works client and server side.
- No crashes in common flows.
- Codebase is organized and extendable.

### 25) Optional Enhancements (If Time)
- Favorites/wishlist.
- Product ratings (static or basic CRUD).
- Address book.
- Order cancellation rules.
- Dark mode.
- Image upload instead of URL (local-only or server).

---

## Reference Checklists

### A) CRUD Checklist (Products)
- Create product.
- Validate.
- Save success feedback.
- Update product.
- Delete confirmation.
- Refresh list.

### B) CRUD Checklist (Categories)
- Create category.
- Prevent duplicates.
- Edit category.
- Delete restriction if used.

### C) Order Checklist
- Cart to order.
- Server computes totals.
- Stock checks.
- Status updates.

### D) UI States Checklist
- Loading state exists.
- Empty state exists.
- Error state exists.
- Success feedback exists.

---

## Final Delivery Bundle
- Flutter project source.
- Backend source.
- SQL schema + seeds.
- API documentation markdown.
- UI assets exported.
- Short setup guide:
- how to run DB.
- how to run API.
- how to run app.

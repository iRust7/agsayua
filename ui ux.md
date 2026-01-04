<!-- File: 01-ui-ux-design.md -->

# E-Commerce Mobile App — UI/UX Design Prompt + Instructions (High Fidelity)

## Prompt
Design a modern, clean, and professional e-commerce mobile application UI/UX that feels commercially viable, trustworthy, and easy to use.
The design must prioritize clarity, speed of decision-making, and frictionless shopping.
Deliver a complete, consistent, and accessible UI system with high-fidelity screens and interaction specs.
The output should be ready to hand off to engineering without ambiguity.

---

## Instructions

### 1) Product Definition
- Define the product goal in 1–2 sentences.
- Define success metrics (example: conversion, add-to-cart rate, checkout completion).
- Define the target market scope (single store vs multi-vendor).
- Define product constraints (local dev backend, limited feature set, tight timeline).
- Define supported platforms (Android first, iOS optional).
- Define connectivity expectations (offline-first optional, online-first acceptable).
- Define primary device sizes (small phone, regular phone, large phone).

### 2) Users and Jobs-To-Be-Done
- Primary user persona (Buyer).
- Secondary persona (Admin/Manager).
- Optional persona (Guest user).
- List user motivations.
- List user anxieties (trust, price, delivery, quality).
- List user jobs:
- Discover products quickly.
- Compare products confidently.
- Understand price and variants clearly.
- Add/remove items from cart easily.
- Checkout with minimal friction.
- Track orders after purchase.
- Admin updates products without confusion.

### 3) Information Architecture
- Define the app navigation model:
- Bottom navigation (Home, Search, Cart, Orders, Account).
- Admin entry point (Account → Admin Tools).
- Define screen hierarchy and deep links:
- Home → Product Detail.
- Search → Product Detail.
- Category → Product Detail.
- Cart → Checkout.
- Orders → Order Detail.
- Admin → Products → Product Form.
- Admin → Categories → Category Form.
- Admin → Orders → Status Update.

### 4) Core User Flows
#### Flow A — Browse & Discover
- Entry: Home.
- Browse categories.
- Scroll product grid/list.
- Open product detail.
- Return to list preserving scroll.
- Use quick filters.

#### Flow B — Search & Filter
- Entry: Search.
- Type query.
- Show suggestions and recent searches.
- Apply filters (category, price range, rating optional).
- Apply sorting (popular, newest, price low→high).

#### Flow C — Product Evaluation
- Open product detail.
- View images.
- Read key info (price, stock, delivery estimate).
- Select variant (optional).
- Read description.
- Read reviews (optional, can be placeholder).
- Add to cart.
- Confirmation feedback.

#### Flow D — Cart Management
- View cart items.
- Adjust quantity.
- Remove item.
- See subtotal and estimated total.
- Proceed to checkout.
- Handle empty cart states.

#### Flow E — Checkout
- Confirm items.
- Select address (simple form).
- Select delivery method (simple).
- Select payment method (dummy).
- Place order.
- Show order confirmation.
- Navigate to order detail.

#### Flow F — Order Tracking
- Orders list by status.
- Order detail showing timeline.
- Reorder action (optional).
- Cancel order (optional, depends on status).

#### Flow G — Admin Management
- Admin product list.
- Create product.
- Edit product.
- Delete product with confirmation.
- Category CRUD.
- Update order status.

### 5) Content Strategy (Microcopy)
- Define voice and tone:
- Friendly.
- Clear.
- Non-technical.
- Error messages:
- Explain what happened.
- Explain how to fix.
- Avoid blame.
- Buttons:
- Use action verbs.
- Keep consistent casing.
- Empty states:
- Provide explanation.
- Provide primary action.
- Confirmation dialogs:
- Name the object being removed.
- Provide cancel-safe default.

### 6) Visual Design Principles
- Clean layout with generous whitespace.
- Strong visual hierarchy:
- Primary info first.
- Secondary info collapsed or below fold.
- Consistency:
- Same component behavior across screens.
- Accessibility:
- Legible text sizes.
- Clear contrast.
- Tap targets >= 44px.
- Feedback:
- Every action returns a visible response.

### 7) Design System Foundations
#### Color
- Define neutral background scale (e.g., 50–900).
- Define primary brand color.
- Define accent color for highlights.
- Define semantic colors:
- Success.
- Warning.
- Error.
- Info.
- Define disabled and divider colors.

#### Typography
- Choose one font family.
- Define type scale:
- Display.
- H1.
- H2.
- H3.
- Body.
- Caption.
- Define font weights:
- Regular.
- Medium.
- Semi-bold.
- Bold.
- Define line heights for readability.

#### Spacing
- Define base spacing unit (e.g., 4 or 8).
- Define layout padding.
- Define card padding.
- Define vertical rhythm rules.

#### Grid & Layout
- Define column grid for mobile (e.g., 4 or 6 columns).
- Define gutters.
- Define safe areas.
- Define max content width rules for large devices.

#### Radius, Shadow, Elevation
- Define corner radius set:
- Small.
- Medium.
- Large.
- Define shadow levels for:
- Cards.
- Floating buttons.
- Modal sheets.

#### Iconography
- Choose consistent icon style.
- Define icon sizes:
- 16.
- 20.
- 24.
- 32.
- Define stroke/filled usage.

#### Motion
- Define default transition durations:
- 120ms.
- 200ms.
- 280ms.
- Define easing:
- Standard.
- Emphasized.
- Define motion rules:
- Avoid excessive bounce.
- Use subtle fades and slides.
- Confirm actions with micro-animations.

### 8) Component Library (Reusable)
Create a reusable component list with behavior rules.

#### Buttons
- Primary button.
- Secondary button.
- Tertiary button.
- Destructive button.
- Disabled states.
- Loading state with spinner.

#### Inputs
- Text field.
- Search field with clear icon.
- Dropdown select.
- Stepper for quantity.
- Price range slider (optional).
- Validation states:
- Default.
- Focus.
- Error.
- Success.
- Disabled.

#### Cards
- Product card:
- Image.
- Name.
- Price.
- Badge.
- Add-to-cart quick action (optional).
- Category chip.
- Cart item card.
- Order card.

#### Navigation
- Bottom navigation.
- Top app bar.
- Back behavior rules.
- Floating action button (admin add product).
- Tabs for Orders status (optional).

#### Feedback
- Toast/snackbar.
- Inline error banner.
- Loading skeleton/shimmer.
- Empty state illustration placeholder.
- Modal confirm dialog.
- Success sheet after checkout.

#### Media
- Image placeholder.
- Image carousel indicators.
- Zoom view (optional).

### 9) Screen List (High-Fidelity Deliverables)
Create high-fidelity screens with specs.

#### Public / Buyer Screens
- Splash (optional).
- Home (featured + categories + product list).
- Category results.
- Search (with recent + suggestions).
- Filter & sort sheet.
- Product detail (with gallery).
- Cart.
- Checkout.
- Order confirmation.
- Orders list.
- Order detail.
- Account (basic).
- Settings (theme optional).

#### Admin Screens
- Admin dashboard (optional).
- Product management list.
- Product create/edit form.
- Category management list.
- Category create/edit.
- Order management list.
- Order status update.

### 10) Per-Screen Requirements (What to Specify)
For each screen, provide:
- Screen purpose.
- Primary action.
- Secondary actions.
- Layout structure.
- Scroll behavior.
- Empty states.
- Loading states.
- Error states.
- Accessibility notes.
- Edge cases.

### 11) Detailed Screen Specs

#### Home
- Top area:
- Greeting or brand header.
- Search bar.
- Category chips horizontal.
- Main area:
- Product grid 2 columns.
- Product cards consistent height.
- Pull to refresh optional.
- Floating cart indicator optional.
- States:
- Loading shimmer.
- Empty when no products.
- Error with retry.

#### Product Listing (Category)
- Header with category title.
- Sorting control.
- Filter chips summary.
- Infinite scroll or pagination indicator.
- Preserve state on back.

#### Search
- Focus on keyboard UX.
- Recent searches list.
- Suggestions (optional).
- Results update on submit.
- Clear search button.

#### Product Detail
- Image carousel with pagination dots.
- Product title.
- Price and discount (optional).
- Stock availability.
- Short highlights (bullet list).
- Variant selection (optional).
- Quantity selector (optional).
- CTA area fixed:
- Add to cart.
- Buy now (optional).
- Description section.
- Review preview (optional).
- Policies (shipping, returns) collapsed.

#### Cart
- List cart items.
- Each item:
- Thumbnail.
- Name.
- Variant (if any).
- Price.
- Quantity stepper.
- Remove action.
- Summary:
- Subtotal.
- Shipping estimate.
- Total.
- CTA:
- Checkout.
- Empty:
- Message + browse button.

#### Checkout
- Sections:
- Delivery address.
- Delivery option.
- Payment method (dummy).
- Order summary.
- Place order button.
- Validation:
- Required address fields.
- Confirmation:
- Success screen.

#### Orders List
- Tabs:
- All.
- Pending.
- Shipped.
- Completed.
- Each order card:
- Order ID short.
- Date.
- Total.
- Status badge.
- Tap → detail.

#### Order Detail
- Timeline (pending → shipped → delivered).
- Items list.
- Address summary.
- Total breakdown.
- Support CTA (optional).

#### Admin Product List
- Search products.
- Filter by category.
- Product rows/cards:
- Name.
- Price.
- Stock.
- Quick edit.
- FAB: add product.
- Empty:
- Create first product CTA.

#### Admin Product Form
- Fields:
- Name.
- Category.
- Price.
- Stock.
- Description.
- Image URL (optional).
- Validation:
- Price numeric.
- Stock integer.
- Save button with loading.
- Cancel/back confirmation if unsaved.

#### Admin Category Management
- List categories.
- Add category.
- Edit category.
- Delete with warning:
- Impact note (products using this category).

#### Admin Order Management
- List orders.
- Filter by status.
- Order detail with status update control.
- Status update confirmation.

### 12) Interaction Patterns
- Tap product card opens detail with hero transition (optional).
- Add to cart shows:
- Snackbar with “View cart”.
- Cart badge increments.
- Delete actions require confirmation.
- Forms show inline validation after submit.
- Disable CTA during processing.
- Maintain scroll position when navigating back.

### 13) Accessibility Checklist
- Minimum font sizes for body text.
- Contrast ratio target.
- Avoid color-only indicators.
- Provide labels for icons.
- Support large text scaling.
- Ensure focus order is logical.
- Provide error text next to fields.

### 14) Localization & Formatting
- Currency formatting.
- Date formatting in orders.
- Number formatting for stock and quantity.
- Avoid hardcoded strings.
- Plan for multi-language keys (optional).

### 15) UI Quality Bar (Professional Finish)
- Consistent padding across screens.
- Consistent card radius/shadow.
- Consistent button height and radius.
- Consistent icon sizing.
- Clear alignment.
- No “floating” random elements.
- Proper empty states everywhere.
- No abrupt layout jumps while loading.

### 16) Deliverable Package
- Design system tokens:
- Colors.
- Typography.
- Spacing.
- Radius.
- Shadows.
- Component inventory:
- Buttons.
- Inputs.
- Cards.
- Sheets.
- Dialogs.
- Screen mockups:
- Export at 1x and 2x.
- Interaction notes:
- In comments or spec section.
- Redline specs:
- Spacing.
- Font sizes.
- Component states.

### 17) Acceptance Criteria
- All core user flows are represented.
- All screens are consistent with design system.
- Every screen has loading/empty/error states.
- Interactions are specified clearly.
- Forms include validation states.
- Navigation is intuitive with minimal taps.
- The overall aesthetic is modern and clean.

---

## Appendices

### A) Example Status Badges
- Pending.
- Processing.
- Shipped.
- Delivered.
- Cancelled.

### B) Example Empty State Copy
- “No products yet. Try adjusting filters.”
- “Your cart is empty. Start browsing products.”
- “No orders found. Place your first order.”

### C) Example Error Copy
- “Something went wrong. Please try again.”
- “Couldn’t load products. Check your connection and retry.”
- “Please enter a valid price.”

### D) Example Confirmation Dialog Copy
- Title: “Remove item?”
- Body: “This item will be removed from your cart.”
- Buttons: “Cancel” / “Remove”

---

## UI/UX Handoff Checklist (One-Line Items)
- Home screen finalized.
- Search screen finalized.
- Listing states defined.
- Detail screen finalized.
- Cart states defined.
- Checkout steps defined.
- Orders list and detail defined.
- Admin screens included.
- Components documented.
- Tokens exported.
- Copy reviewed.
- Accessibility reviewed.
- Interaction notes added.
- Redlines completed.
- Assets exported.
- Final review pass done.

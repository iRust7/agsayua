# 🚨 CRITICAL BUG FIX PLAN
**Priority:** URGENT - Data Leaking Between Users  
**Date:** January 5, 2026

---

## 🔴 CRITICAL BUGS IDENTIFIED

### Bug #1: Profile Data Not Bound to User
**Severity:** HIGH  
**Impact:** Profile name and photo persist across different user accounts

**Root Cause:**
- `didChangeDependencies` menggunakan `context.watch()` yang menyebabkan infinite loop
- Widget state tidak di-reset dengan benar saat user berubah
- SharedPreferences menggunakan user_id tetapi widget tidak refresh properly

**Current Code Issue:**
```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  final auth = context.watch<AuthState>(); // ❌ WRONG - causes rebuild loop
  final currentUserId = auth.user?.id;
  
  if (currentUserId != _lastUserId) {
    _lastUserId = currentUserId;
    _loadProfileData();
  }
}
```

**Fix Required:**
1. Remove `didChangeDependencies` approach
2. Use `initState` with proper listener
3. Clear state on user change
4. Force widget rebuild on user change

---

### Bug #2: Orders Not Bound to User (MORE CRITICAL!)
**Severity:** CRITICAL  
**Impact:** ALL users see ALL orders from ANY user - major privacy/security issue!

**Root Cause:**
- `OrderState` is global singleton shared across all users
- No `userId` field in Order model
- No filtering by userId in orders list
- Orders stored in memory without user association

**Current Code:**
```dart
// ❌ WRONG - Global list without user filtering
class OrderState extends ChangeNotifier {
  final List<Order> _orders = [];
  List<Order> get orders => List.unmodifiable(_orders);
  
  String createOrder({...}) {
    _orders.insert(0, order); // ❌ No userId!
    notifyListeners();
    return orderId;
  }
}
```

**Impact:**
- User A creates order → saved to global _orders
- User B logs in → sees User A's orders
- Major privacy violation!

**Fix Required:**
1. Add `userId` field to Order model
2. Filter orders by current user in OrderState
3. Clear orders on logout
4. Store orders with user association

---

## ✅ SOLUTION PLAN

### Phase 1: Fix Profile Binding (30 min)

**Step 1:** Remove broken `didChangeDependencies`
**Step 2:** Add proper auth listener in `initState`
**Step 3:** Clear profile state when user changes
**Step 4:** Force reload profile data on auth change

**Files to Modify:**
- `lib/features/admin/presentation/account_screen.dart`
- `lib/features/admin/presentation/edit_profile_screen.dart`

### Phase 2: Fix Order Binding (45 min)

**Step 1:** Add `userId` field to Order model
```dart
class Order {
  final String id;
  final String userId; // ✅ NEW
  final List<OrderItem> items;
  // ... rest
}
```

**Step 2:** Modify OrderState to filter by userId
```dart
class OrderState extends ChangeNotifier {
  final List<Order> _orders = [];
  String? _currentUserId;
  
  // ✅ Filter by current user
  List<Order> get orders => _orders.where((o) => o.userId == _currentUserId).toList();
  
  void setCurrentUser(String? userId) {
    _currentUserId = userId;
    notifyListeners();
  }
  
  String createOrder({
    required String userId, // ✅ NEW parameter
    // ... rest
  }) {
    final order = Order(
      userId: userId, // ✅ Store userId
      // ... rest
    );
    _orders.insert(0, order);
    notifyListeners();
  }
}
```

**Step 3:** Update checkout to pass userId
**Step 4:** Update main.dart to set current user on auth change
**Step 5:** Clear orders on logout

**Files to Modify:**
- `lib/core/state/order_state.dart`
- `lib/features/checkout/presentation/checkout_screen.dart`
- `lib/main.dart` (add auth listener to update OrderState)

### Phase 3: Testing (15 min)

**Test Case 1: Profile Isolation**
1. Login as user1@example.com
2. Set profile name to "User One" and add photo
3. Logout
4. Login as user2@example.com
5. ✅ Verify: Profile should be empty/default name

**Test Case 2: Order Isolation**
1. Login as user1@example.com
2. Place order for "Celana Abu"
3. Logout
4. Login as user2@example.com
5. ✅ Verify: Orders screen should be EMPTY
6. Place order for "Baju Merah"
7. ✅ Verify: Only "Baju Merah" order visible
8. Logout and login as user1 again
9. ✅ Verify: Only "Celana Abu" order visible

---

## 🔧 IMPLEMENTATION ORDER

### Priority 1: Fix Orders (MOST CRITICAL)
- This is a privacy/security issue
- Users can see other users' orders
- Fix this FIRST

### Priority 2: Fix Profile
- Less critical than orders
- Only affects UI display
- Fix after orders

---

## ⚠️ RISKS & CONSIDERATIONS

1. **Existing Orders:** Current orders in OrderState have no userId
   - Solution: Clear all orders on fix, or add migration logic
   
2. **State Persistence:** Orders currently only in memory
   - Consider: Should orders persist in SharedPreferences?
   - For now: Keep in memory, reset on app restart
   
3. **Multiple Tabs/Windows:** If app runs in multiple instances
   - Current solution: Each instance has own state
   - OK for now, but consider backend sync later

---

## 📝 NOTES

- Both bugs stem from global state without user context
- Need to add user awareness to all state management
- Consider implementing proper backend API calls in future
- Current fix: Local filtering/isolation
- Future: Backend should return user-specific data only

---

**Time Estimate:** 90 minutes total  
**Testing Time:** 15 minutes  
**Total:** ~2 hours

Let's start with Orders fix first since it's most critical!

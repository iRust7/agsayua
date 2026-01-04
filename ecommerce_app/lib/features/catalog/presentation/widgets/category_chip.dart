import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/models/category_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/animations.dart';

/// Enhanced animated category chip with gradient and icon support
class CategoryChip extends StatefulWidget {
  final Category? category;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const CategoryChip({
    super.key,
    this.category,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.buttonPress,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  IconData get _categoryIcon {
    if (widget.icon != null) return widget.icon!;
    if (widget.category == null) return Icons.apps_rounded;
    
    // Map category names to icons for visual interest
    final name = widget.category!.name.toLowerCase();
    if (name.contains('electronic') || name.contains('gadget')) return Icons.devices_rounded;
    if (name.contains('fashion') || name.contains('cloth')) return Icons.checkroom_rounded;
    if (name.contains('food') || name.contains('drink')) return Icons.restaurant_rounded;
    if (name.contains('book')) return Icons.menu_book_rounded;
    if (name.contains('sport')) return Icons.sports_basketball_rounded;
    if (name.contains('beauty') || name.contains('health')) return Icons.spa_rounded;
    if (name.contains('home') || name.contains('furniture')) return Icons.home_rounded;
    if (name.contains('toy') || name.contains('game')) return Icons.toys_rounded;
    return Icons.category_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: AnimatedContainer(
            duration: AppAnimations.normal,
            curve: AppCurves.smooth,
            padding: EdgeInsets.symmetric(
              horizontal: widget.isSelected ? 18 : 14,
              vertical: widget.isSelected ? 10 : 8,
            ),
            decoration: BoxDecoration(
              gradient: widget.isSelected
                  ? const LinearGradient(
                      colors: AppColors.primaryGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        AppColors.neutral100,
                        AppColors.neutral50,
                      ],
                    ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: widget.isSelected
                    ? Colors.transparent
                    : AppColors.border.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: widget.isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryGlow,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon with animation
                AnimatedSwitcher(
                  duration: AppAnimations.fast,
                  child: Icon(
                    _categoryIcon,
                    key: ValueKey(widget.isSelected),
                    size: widget.isSelected ? 18 : 16,
                    color: widget.isSelected
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                // Label
                AnimatedDefaultTextStyle(
                  duration: AppAnimations.fast,
                  style: TextStyle(
                    fontSize: widget.isSelected ? 14 : 13,
                    fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: widget.isSelected
                        ? Colors.white
                        : AppColors.textPrimary,
                    letterSpacing: widget.isSelected ? 0.2 : 0,
                  ),
                  child: Text(widget.category?.name ?? 'Semua'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Category chips horizontal list with staggered animation
class CategoryChipList extends StatelessWidget {
  final List<Category> categories;
  final Category? selectedCategory;
  final Function(Category?) onCategorySelected;

  const CategoryChipList({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        itemCount: categories.length + 1, // +1 for "All" chip
        itemBuilder: (context, index) {
          if (index == 0) {
            return CategoryChip(
              category: null,
              isSelected: selectedCategory == null,
              onTap: () => onCategorySelected(null),
            ).animate().fadeIn(delay: Duration(milliseconds: 50 * index))
              .slideX(begin: 0.2, curve: Curves.easeOut);
          }
          
          final category = categories[index - 1];
          return CategoryChip(
            category: category,
            isSelected: selectedCategory?.id == category.id,
            onTap: () => onCategorySelected(category),
          ).animate().fadeIn(delay: Duration(milliseconds: 50 * index))
            .slideX(begin: 0.2, curve: Curves.easeOut);
        },
      ),
    );
  }
}

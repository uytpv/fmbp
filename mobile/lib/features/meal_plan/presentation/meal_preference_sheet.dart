import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/app_button.dart';

class MealPreferenceSheet extends StatefulWidget {
  final List<String> initialCuisines;
  final String initialComplexity;
  final List<String> initialDietaryTags;
  final void Function(List<String> cuisines, String complexity, List<String> dietaryTags, bool regenerateAI) onApply;

  const MealPreferenceSheet({
    super.key,
    required this.initialCuisines,
    required this.initialComplexity,
    this.initialDietaryTags = const [],
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required List<String> initialCuisines,
    required String initialComplexity,
    List<String> initialDietaryTags = const [],
    required void Function(List<String> cuisines, String complexity, List<String> dietaryTags, bool regenerateAI) onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MealPreferenceSheet(
        initialCuisines: initialCuisines,
        initialComplexity: initialComplexity,
        initialDietaryTags: initialDietaryTags,
        onApply: onApply,
      ),
    );
  }

  @override
  State<MealPreferenceSheet> createState() => _MealPreferenceSheetState();
}

class _MealPreferenceSheetState extends State<MealPreferenceSheet> {
  late Set<String> _selectedCuisines;
  late String _selectedComplexity;
  late Set<String> _selectedDietaryTags;

  final Map<String, String> _cuisineOptions = {
    'VIETNAMESE': '🇻🇳 Món Việt Nam',
    'CHINESE': '🇨🇳 Món Trung Hoa (Dimsum, Xào)',
    'FINNISH': '🇫🇮 Bắc Âu & Phần Lan',
    'EUROPEAN': '🇪🇺 Châu Âu (Ý, Pháp, Pasta)',
    'ASIAN': '🇯🇵🇰🇷 Châu Á (Nhật Bản, Hàn Quốc)',
    'THAI': '🇹🇭 Đông Nam Á (Thái Lan)',
    'MEDITERRANEAN': '🇬🇷 Địa Trung Hải (Olive, Cá)',
    'INDIAN': '🇮🇳 Món Ấn Độ (Curry, Naan)',
    'AMERICAN': '🇺🇸 Món Mỹ & BBQ',
    'HEALTHY': '🥗 Eat Clean / Ít Dầu Mỡ',
    'VEGAN': '🌱 Ăn Chay / Thuần Chay',
  };

  final List<String> _customCuisines = [];

  final List<Map<String, String>> _complexityOptions = [
    {'key': 'FAST_15', 'title': '⚡ Siêu Tốc', 'desc': '< 15 phút'},
    {'key': 'FAST', 'title': '🍳 Nấu Nhanh', 'desc': '< 30 phút'},
    {'key': 'BALANCED', 'title': '🍲 Cân Bằng', 'desc': '30 - 60 phút'},
    {'key': 'ELABORATE', 'title': '👑 Cầu Kỳ', 'desc': '> 60 phút'},
  ];

  final Map<String, String> _dietaryOptions = {
    'STANDARD': '🍖 Đầy đủ dinh dưỡng',
    'CLEAN_EAT': '🥗 Eat Clean / Ít calo',
    'HIGH_PROTEIN': '💪 Giàu Protein (Tập gym)',
    'LOW_CARB': '🥑 Ít tinh bột (Low-carb / Keto)',
    'KIDS_FRIENDLY': '👶 Thân thiện với trẻ nhỏ',
    'NO_SPICY': '🌿 Không ăn cay',
  };

  @override
  void initState() {
    super.initState();
    _selectedCuisines = Set<String>.from(
      widget.initialCuisines.isNotEmpty ? widget.initialCuisines : ['VIETNAMESE'],
    );
    _selectedComplexity = widget.initialComplexity;
    _selectedDietaryTags = Set<String>.from(widget.initialDietaryTags);
    _loadCustomCuisines();
  }

  Future<void> _loadCustomCuisines() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final custom = prefs.getStringList('custom_cuisines');
      if (custom != null && custom.isNotEmpty && mounted) {
        setState(() {
          _customCuisines.clear();
          _customCuisines.addAll(custom);
        });
      }
    } catch (_) {}
  }

  Future<void> _saveToLocalPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('selected_cuisines', _selectedCuisines.toList());
      await prefs.setString('selected_complexity', _selectedComplexity);
      await prefs.setStringList('selected_dietary_tags', _selectedDietaryTags.toList());
      await prefs.setStringList('custom_cuisines', _customCuisines);
    } catch (_) {}
  }

  void _showAddCustomCuisineDialog() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thêm Phong Cách Ẩm Thực'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nhập tên quốc gia, vùng miền hoặc phong cách bạn muốn (Ví dụ: Ẩm thực Tứ Xuyên, Món Mexico, Món Huế...):',
              style: TextStyle(fontSize: 12.5),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Tên phong cách ẩm thực',
                prefixIcon: Icon(Icons.restaurant_menu_rounded, size: 20),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = textController.text.trim();
              if (val.isNotEmpty) {
                setState(() {
                  if (!_customCuisines.contains(val)) {
                    _customCuisines.add(val);
                  }
                  _selectedCuisines.add(val);
                });
                _saveToLocalPreferences();
                Navigator.pop(ctx);
              }
            },
            child: const Text('Thêm & Chọn'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDark : AppColors.bgLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.disabledColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tùy Chỉnh Tiêu Chí Thực Đơn',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Cá nhân hóa khẩu vị & thói quen nấu nướng của gia đình',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor, fontSize: 11),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(height: 20),

          // Scrollable Content
          Expanded(
            child: ListView(
              children: [
                // 1. Cuisines
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1. Phong cách ẩm thực (${_selectedCuisines.length} đã chọn):',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Chọn nhiều phong cách',
                      style: TextStyle(fontSize: 11, color: theme.disabledColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._cuisineOptions.entries.map((entry) {
                      final isSelected = _selectedCuisines.contains(entry.key);
                      return FilterChip(
                        selected: isSelected,
                        label: Text(entry.value),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? (isDark ? Colors.white : AppColors.primary)
                              : (isDark ? Colors.white70 : Colors.black87),
                        ),
                        selectedColor: AppColors.primary.withOpacity(isDark ? 0.3 : 0.15),
                        checkmarkColor: AppColors.primary,
                        backgroundColor: isDark ? AppColors.bgCardDark : Colors.grey.shade100,
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 1.2,
                        ),
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _selectedCuisines.add(entry.key);
                            } else {
                              if (_selectedCuisines.length > 1) {
                                _selectedCuisines.remove(entry.key);
                              }
                            }
                          });
                        },
                      );
                    }),
                    // Custom user-added cuisines
                    ..._customCuisines.map((customName) {
                      final isSelected = _selectedCuisines.contains(customName);
                      return FilterChip(
                        selected: isSelected,
                        label: Text('✨ $customName'),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? (isDark ? Colors.white : AppColors.primary)
                              : (isDark ? Colors.white70 : Colors.black87),
                        ),
                        selectedColor: AppColors.primary.withOpacity(isDark ? 0.3 : 0.15),
                        checkmarkColor: AppColors.primary,
                        backgroundColor: isDark ? AppColors.bgCardDark : Colors.grey.shade100,
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 1.2,
                        ),
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _selectedCuisines.add(customName);
                            } else {
                              if (_selectedCuisines.length > 1) {
                                _selectedCuisines.remove(customName);
                              }
                            }
                          });
                        },
                      );
                    }),
                    // Add Custom Cuisine Button
                    ActionChip(
                      avatar: const Icon(Icons.add_rounded, size: 16, color: AppColors.primary),
                      label: const Text('Thêm ẩm thực khác', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
                      backgroundColor: AppColors.primary.withOpacity(0.08),
                      side: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 1.2),
                      onPressed: _showAddCustomCuisineDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 2. Cooking Complexity
                Text(
                  '2. Mức độ nấu nướng & Thời gian chuẩn bị:',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: _complexityOptions.map((opt) {
                    final isSelected = _selectedComplexity == opt['key'];
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: InkWell(
                          onTap: () => setState(() => _selectedComplexity = opt['key']!),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(isDark ? 0.25 : 0.12)
                                  : (isDark ? AppColors.bgCardDark : Colors.white),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : (isDark ? Colors.white12 : Colors.black12),
                                width: isSelected ? 1.8 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  opt['title']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? AppColors.primary : (isDark ? Colors.white : Colors.black87),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  opt['desc']!,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: isSelected
                                        ? AppColors.primary
                                        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // 3. Dietary & Health preferences
                Text(
                  '3. Chế độ ăn kiêng & Khẩu vị đặc biệt:',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _dietaryOptions.entries.map((entry) {
                    final isSelected = _selectedDietaryTags.contains(entry.key);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(entry.value),
                      labelStyle: TextStyle(
                        fontSize: 11.5,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? (isDark ? Colors.white : AppColors.primary)
                            : (isDark ? Colors.white70 : Colors.black87),
                      ),
                      selectedColor: AppColors.primary.withOpacity(isDark ? 0.3 : 0.15),
                      checkmarkColor: AppColors.primary,
                      backgroundColor: isDark ? AppColors.bgCardDark : Colors.grey.shade100,
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        width: 1.2,
                      ),
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _selectedDietaryTags.add(entry.key);
                          } else {
                            _selectedDietaryTags.remove(entry.key);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Actions
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    await _saveToLocalPreferences();
                    if (mounted) {
                      Navigator.pop(context);
                      widget.onApply(
                        _selectedCuisines.toList(),
                        _selectedComplexity,
                        _selectedDietaryTags.toList(),
                        false, // Do not regenerate full week
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                  ),
                  child: const Text('Lưu Cấu Hình'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: AppButton(
                  text: 'Lưu & Sinh Lại Thực Đơn AI',
                  onPressed: () async {
                    await _saveToLocalPreferences();
                    if (mounted) {
                      Navigator.pop(context);
                      widget.onApply(
                        _selectedCuisines.toList(),
                        _selectedComplexity,
                        _selectedDietaryTags.toList(),
                        true, // Trigger full week regeneration
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

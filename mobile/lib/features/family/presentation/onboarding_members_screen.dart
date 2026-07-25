import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fmbp_models/fmbp_models.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'onboarding_provider.dart';

class OnboardingMembersScreen extends ConsumerStatefulWidget {
  final String? familyId;

  const OnboardingMembersScreen({super.key, this.familyId});

  @override
  ConsumerState<OnboardingMembersScreen> createState() => _OnboardingMembersScreenState();
}

class _OnboardingMembersScreenState extends ConsumerState<OnboardingMembersScreen> {

  void _addOrEditMemberDialog(String familyId, [FamilyMember? existing]) {
    final dialogFormKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final birthYearCtrl = TextEditingController(text: existing != null ? '${existing.birthYear}' : '1985');
    final prefCtrl = TextEditingController(text: existing?.dietaryPreferences.join(', ') ?? '');

    String relationship = existing?.relationship ?? 'Bố';
    String gender = existing?.gender ?? 'MALE';
    bool isSaving = false;

    final relationships = ['Bố', 'Mẹ', 'Con trai', 'Con gái', 'Ông', 'Bà', 'Khác'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Thêm Thành Viên Gia Đình' : 'Chỉnh Sửa Thành Viên'),
          content: SingleChildScrollView(
            child: Form(
              key: dialogFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: nameCtrl,
                    labelText: 'Tên thành viên',
                    hintText: 'VD: Ba, Mẹ, Anh Hai, Bé Bún...',
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Vui lòng nhập tên thành viên';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Quan hệ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.borderLight),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: relationship,
                                  isExpanded: true,
                                  items: relationships.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                                  onChanged: (val) {
                                    if (val != null) setDialogState(() => relationship = val);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppTextField(
                          controller: birthYearCtrl,
                          labelText: 'Năm sinh',
                          keyboardType: TextInputType.number,
                          hintText: 'VD: 1981, 2008...',
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Vui lòng nhập năm sinh';
                            }
                            final year = int.tryParse(val.trim());
                            final currentYear = DateTime.now().year;
                            if (year == null || year < 1900 || year > currentYear) {
                              return 'Năm sinh từ 1900 - $currentYear';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  const Text('Giới tính', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          showCheckmark: false,
                          label: const Text('👨 Nam', style: TextStyle(fontSize: 12)),
                          selected: gender == 'MALE',
                          selectedColor: AppColors.primary,
                          onSelected: (sel) {
                            if (sel) setDialogState(() => gender = 'MALE');
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          showCheckmark: false,
                          label: const Text('👩 Nữ', style: TextStyle(fontSize: 12)),
                          selected: gender == 'FEMALE',
                          selectedColor: AppColors.primary,
                          onSelected: (sel) {
                            if (sel) setDialogState(() => gender = 'FEMALE');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  AppTextField(
                    controller: prefCtrl,
                    labelText: 'Khẩu vị & Dị ứng / Hạn chế',
                    hintText: 'VD: Không ăn thịt mỡ, Thích ăn chay, Nhiều rau',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      if (!dialogFormKey.currentState!.validate()) {
                        return;
                      }

                      final name = nameCtrl.text.trim();
                      final birthYear = int.tryParse(birthYearCtrl.text.trim()) ?? 1990;
                      final prefsStr = prefCtrl.text.trim();
                      final prefs = prefsStr.isEmpty
                          ? <String>[]
                          : prefsStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

                      setDialogState(() => isSaving = true);
                      try {
                        final firestore = ref.read(firestoreServiceProvider);

                        final member = FamilyMember(
                          id: existing?.id ?? const Uuid().v4(),
                          familyId: familyId,
                          name: name,
                          relationship: relationship,
                          gender: gender,
                          birthYear: birthYear,
                          dietaryPreferences: prefs,
                        );

                        await firestore.saveFamilyMember(familyId, member);

                        if (mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã lưu thành viên "$name"!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      } catch (e) {
                        setDialogState(() => isSaving = false);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lỗi khi lưu thành viên: $e'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      }
                    },
              child: isSaving
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  String? _getFamilyId() {
    if (widget.familyId != null && widget.familyId!.isNotEmpty) {
      return widget.familyId;
    }
    final user = ref.watch(firebaseAuthServiceProvider).currentUser;
    if (user != null) {
      final userDoc = ref.watch(userStreamProvider(user.uid)).value;
      return userDoc?.familyId;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentFamilyId = _getFamilyId();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkGradient : null,
          color: isDark ? null : AppColors.bgLight,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header Progress Bar
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    children: const [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.primary,
                        child: Text('2', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 8),
                      Text('Bước 2/2: Khai Báo Nhân Khẩu Gia Đình', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                Center(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.people_alt_rounded,
                      size: 44,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                Text(
                  '👨‍👩‍👧‍👦 Khai Báo Nhân Khẩu Gia Đình',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),

                Text(
                  'Thêm các thành viên trong nhà (năm sinh, khẩu vị, dị ứng) giúp AI lên thực đơn chuẩn vị & tiết kiệm nhất.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                if (currentFamilyId == null || currentFamilyId.isEmpty) ...[
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ] else ...[
                  Consumer(
                    builder: (context, ref, child) {
                      final membersAsync = ref.watch(familyMembersStreamProvider(currentFamilyId));

                      return AppCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Thành Viên Gia Đình',
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _addOrEditMemberDialog(currentFamilyId),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.add, size: 18, color: Colors.white),
                                        SizedBox(width: 4),
                                        Text(
                                          'Thêm Thành Viên',
                                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20),

                            membersAsync.when(
                              loading: () => const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(AppSpacing.lg),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              error: (err, stack) => Text('Có lỗi xảy ra: $err', style: const TextStyle(color: AppColors.error)),
                              data: (members) {
                                if (members.isEmpty) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        const Icon(Icons.group_add_outlined, size: 48, color: Colors.grey),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Chưa có thông tin thành viên gia đình.',
                                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
                                        ),
                                        const SizedBox(height: 12),
                                        InkWell(
                                          onTap: () => _addOrEditMemberDialog(currentFamilyId),
                                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: AppColors.primary),
                                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Icon(Icons.person_add_outlined, size: 18, color: AppColors.primary),
                                                SizedBox(width: 6),
                                                Text(
                                                  'Thêm thành viên (Ví dụ: Bố, Mẹ, Con...)',
                                                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Column(
                                  children: [
                                    for (int idx = 0; idx < members.length; idx++) ...[
                                      if (idx > 0) const SizedBox(height: 8),
                                      Builder(
                                        builder: (context) {
                                          final m = members[idx];
                                          final isMale = m.gender == 'MALE';
                                          return Container(
                                            padding: const EdgeInsets.all(AppSpacing.sm),
                                            decoration: BoxDecoration(
                                              color: isDark ? AppColors.bgCardDark : AppColors.bgLight,
                                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                              border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: (isMale ? Colors.blue : Colors.pink).withOpacity(0.12),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Text(
                                                    isMale ? '👨' : '👩',
                                                    style: const TextStyle(fontSize: 20),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            m.name,
                                                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                                          ),
                                                          const SizedBox(width: 6),
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                            decoration: BoxDecoration(
                                                              color: AppColors.primary.withOpacity(0.1),
                                                              borderRadius: BorderRadius.circular(4),
                                                            ),
                                                            child: Text(
                                                              '${m.relationship} • ${m.age} tuổi',
                                                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 2),
                                                      if (m.dietaryPreferences.isNotEmpty)
                                                        Wrap(
                                                          spacing: 4,
                                                          runSpacing: 4,
                                                          children: m.dietaryPreferences.map((pref) {
                                                            return Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                              decoration: BoxDecoration(
                                                                color: Colors.orange.withOpacity(0.1),
                                                                borderRadius: BorderRadius.circular(4),
                                                                border: Border.all(color: Colors.orange.withOpacity(0.3)),
                                                              ),
                                                              child: Text(
                                                                '🥦 $pref',
                                                                style: const TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.w600),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        )
                                                      else
                                                        Text(
                                                          'Khẩu vị bình thường',
                                                          style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor, fontSize: 11),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                                                  onPressed: () => _addOrEditMemberDialog(currentFamilyId, m),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.grey),
                                                  onPressed: () async {
                                                    final firestore = ref.read(firestoreServiceProvider);
                                                    await firestore.deleteFamilyMember(currentFamilyId, m.id);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),

                AppButton(
                  text: 'Hoàn Tất & Vào Trang Chủ 🚀',
                  onPressed: () {
                    context.go('/dashboard');
                  },
                ),
                const SizedBox(height: AppSpacing.xs),

                Center(
                  child: TextButton(
                    onPressed: () {
                      context.go('/dashboard');
                    },
                    child: const Text('Bỏ qua bước này (có thể khai báo sau ở Trang Chủ)'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final userStreamProvider = StreamProvider.family<User?, String>((ref, uid) {
  return ref.watch(firestoreServiceProvider).watchUser(uid);
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fmbp_models/fmbp_models.dart';
import 'package:uuid/uuid.dart';
import '../../../app/theme.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';

class FamilyMembersSheet extends ConsumerStatefulWidget {
  final String familyId;

  const FamilyMembersSheet({super.key, required this.familyId});

  static void show(BuildContext context, String familyId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FamilyMembersSheet(familyId: familyId),
    );
  }

  @override
  ConsumerState<FamilyMembersSheet> createState() => _FamilyMembersSheetState();
}

class _FamilyMembersSheetState extends ConsumerState<FamilyMembersSheet> {
  void _addOrEditMemberDialog([FamilyMember? existing]) {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: nameCtrl,
                  labelText: 'Tên thành viên',
                  hintText: 'VD: Ba, Mẹ, Anh Hai, Bé Bún...',
                ),
                const SizedBox(height: AppSpacing.md),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Quan hệ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
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
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      final name = nameCtrl.text.trim();
                      final birthYear = int.tryParse(birthYearCtrl.text.trim()) ?? 1990;
                      final prefsStr = prefCtrl.text.trim();
                      final prefs = prefsStr.isEmpty ? <String>[] : prefsStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

                      if (name.isEmpty) return;

                      setDialogState(() => isSaving = true);
                      try {
                        var familyId = widget.familyId;
                        final user = ref.read(firebaseAuthServiceProvider).currentUser;
                        final firestore = ref.read(firestoreServiceProvider);

                        if ((familyId.isEmpty || familyId == 'null') && user != null) {
                          familyId = await firestore.createFamilyGroup('Gia Đình Tôi', user.uid);
                        }

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
                              content: Text('Đã lưu thông tin thành viên "$name"!'),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgCardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      child: FractionallySizedBox(
        heightFactor: 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.disabledColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '👨‍👩‍👧‍👦 Nhân Khẩu Học Gia Đình',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'AI tự động tính tuổi & khẩu vị thành viên',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_rounded, color: AppColors.primary, size: 28),
                  tooltip: 'Thêm thành viên',
                  onPressed: () => _addOrEditMemberDialog(),
                ),
              ],
            ),
            const Divider(height: 24),

            Expanded(
              child: StreamBuilder<List<FamilyMember>>(
                stream: ref.watch(firestoreServiceProvider).watchFamilyMembers(widget.familyId),
                builder: (context, snapshot) {
                  final members = snapshot.data ?? [];

                  if (members.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.people_outline_rounded, size: 56, color: Colors.grey),
                          const SizedBox(height: 12),
                          const Text('Chưa có thông tin thành viên gia đình'),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _addOrEditMemberDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text('Thêm Thành Viên Ngay'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final m = members[index];
                      final isMale = m.gender == 'MALE';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppCard(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: (isMale ? Colors.blue : Colors.pink).withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  isMale ? '👨' : '👩',
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                              const SizedBox(width: 12),

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
                                    const SizedBox(height: 4),

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
                                onPressed: () => _addOrEditMemberDialog(m),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.grey),
                                onPressed: () async {
                                  final firestore = ref.read(firestoreServiceProvider);
                                  await firestore.deleteFamilyMember(widget.familyId, m.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hoàn Tất'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

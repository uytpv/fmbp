import 'package:fmbp_models/fmbp_models.dart';

class ParsedIngredient {
  final String id;
  final String name;
  final double quantityPerPerson;
  final String unit;
  final String aisle;
  final String storageLocation;

  const ParsedIngredient({
    required this.id,
    required this.name,
    required this.quantityPerPerson,
    required this.unit,
    required this.aisle,
    required this.storageLocation,
  });
}

/// Bộ phân tích bóc tách nguyên liệu tự động từ Tên món ăn (Recipe Title)
class RecipeIngredientParser {
  static final List<Map<String, dynamic>> _dictionary = [
    // 🇻🇳 MÓN VIỆT NAM (VIETNAMESE)
    {
      'keywords': ['cơm gà hải nam', 'cơm gà', 'com ga'],
      'ingredients': [
        ParsedIngredient(
          id: 'thit_ga_hai_nam',
          name: 'Thịt gà ta tươi (đùi / ức / cánh)',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'gao_hai_nam',
          name: 'Gạo thơm nấu nước dùng gà & mỡ gà',
          quantityPerPerson: 100.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'sot_gung_toi',
          name: 'Nước chấm gừng tỏi & ớt sa tế',
          quantityPerPerson: 1.0,
          unit: 'bát',
          aisle: 'Gia vị & Đồ khô',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'dua_leo_xa_lach',
          name: 'Dưa leo & Xà lách tươi',
          quantityPerPerson: 1.0,
          unit: 'quả',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['phở bò', 'pho bo', 'phở gà', 'pho ga'],
      'ingredients': [
        ParsedIngredient(
          id: 'thit_bo_pho',
          name: 'Thịt bò tái / nạm / Gà xé tươi',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'banh_pho',
          name: 'Bánh phở tươi / khô',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'gia_vi_pho',
          name: 'Hành tây, gừng & bộ gia vị phở',
          quantityPerPerson: 1.0,
          unit: 'bộ',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['bún bò', 'bun bo hue', 'bún bò huế'],
      'ingredients': [
        ParsedIngredient(
          id: 'bun_soi_to',
          name: 'Bún sợi to Huế',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'nam_bo_cha',
          name: 'Nạm bò & Chả bắp Huế',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'sa_mam_ruoc',
          name: 'Sả củ & Mắm ruốc Huế',
          quantityPerPerson: 1.0,
          unit: 'bộ',
          aisle: 'Gia vị & Đồ khô',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['cháo gà', 'chao ga', 'hạt sen'],
      'ingredients': [
        ParsedIngredient(
          id: 'thit_ga_chao',
          name: 'Thịt gà đùi / ức tươi',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'hat_sen_gao',
          name: 'Hạt sen tươi & Gạo nấu cháo',
          quantityPerPerson: 80.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'hanh_ngo_chao',
          name: 'Hành lá, ngò rí & tiêu hạt',
          quantityPerPerson: 1.0,
          unit: 'bó',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['bún riêu', 'bun rieu'],
      'ingredients': [
        ParsedIngredient(
          id: 'bun_tuoi_rieu',
          name: 'Bún tươi',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'gach_cua',
          name: 'Cua đồng xay / Gạch cua tươi',
          quantityPerPerson: 100.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'dau_phu_ca_chua',
          name: 'Đậu phụ chiên & Cà chua',
          quantityPerPerson: 1.0,
          unit: 'bộ',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['hủ tiếu', 'hu tieu'],
      'ingredients': [
        ParsedIngredient(
          id: 'hu_tieu_soi',
          name: 'Hủ tiếu Nam Vang',
          quantityPerPerson: 125.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'thit_heo_tom',
          name: 'Thịt heo & Tôm tươi',
          quantityPerPerson: 120.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'can_tay_gia',
          name: 'Cần tây, giá đỗ & hẹ tươi',
          quantityPerPerson: 1.0,
          unit: 'bó',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['cháo sườn', 'chao suon', 'quẩy'],
      'ingredients': [
        ParsedIngredient(
          id: 'suon_non_chao',
          name: 'Sườn heo xay ninh cháo',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'quay_gion',
          name: 'Bột gạo xay & Quẩy giòn',
          quantityPerPerson: 1.0,
          unit: 'phần',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['xôi gà', 'xoi ga', 'hành phi'],
      'ingredients': [
        ParsedIngredient(
          id: 'gao_nep',
          name: 'Gạo nếp thơm',
          quantityPerPerson: 120.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'thit_ga_xe',
          name: 'Thịt gà xé phay',
          quantityPerPerson: 100.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'hanh_phi',
          name: 'Hành phi giòn & mỡ hành',
          quantityPerPerson: 1.0,
          unit: 'hũ',
          aisle: 'Gia vị & Đồ khô',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['sườn kho', 'suon kho', 'cơm sườn'],
      'ingredients': [
        ParsedIngredient(
          id: 'suon_heo_kho',
          name: 'Sườn heo tươi ngon',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'trung_ga_kho',
          name: 'Trứng gà tươi',
          quantityPerPerson: 1.0,
          unit: 'quả',
          aisle: 'Trứng & Sữa',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'gao_jasmine',
          name: 'Gạo thơm Jasmine',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['thịt kho tàu', 'thit kho tau', 'thịt kho'],
      'ingredients': [
        ParsedIngredient(
          id: 'thit_ba_chi_tau',
          name: 'Thịt ba chỉ heo',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'trung_ga_vit',
          name: 'Trứng gà luộc',
          quantityPerPerson: 2.0,
          unit: 'quả',
          aisle: 'Trứng & Sữa',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'nuoc_dua_xiem',
          name: 'Nước dừa tươi',
          quantityPerPerson: 100.0,
          unit: 'ml',
          aisle: 'Gia vị & Đồ khô',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['cá kho tộ', 'ca kho to', 'khoai mỡ'],
      'ingredients': [
        ParsedIngredient(
          id: 'khoai_mo_tim',
          name: 'Khoai mỡ tím tươi',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Rau củ quả',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'ca_kho_to',
          name: 'Cá lóc / Cá thu tươi',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'ngo_gai_rau_om',
          name: 'Rau ngò gai & Rau ôm',
          quantityPerPerson: 1.0,
          unit: 'bó',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['canh chua cá hồi', 'canh chua'],
      'ingredients': [
        ParsedIngredient(
          id: 'ca_hoi_canh_chua',
          name: 'Lườn cá hồi tươi (Lohifilee)',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'ca_chua_dua',
          name: 'Cà chua & Thơm / Dứa',
          quantityPerPerson: 1.0,
          unit: 'quả',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'rau_muong_tuoi',
          name: 'Rau muống tươi',
          quantityPerPerson: 1.0,
          unit: 'bó',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['tôm hấp dừa', 'tôm hấp', 'su su'],
      'ingredients': [
        ParsedIngredient(
          id: 'tom_su_tuoi',
          name: 'Tôm tươi ngon',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'su_su_tuoi',
          name: 'Su su tươi',
          quantityPerPerson: 1.0,
          unit: 'củ',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['lẩu thái', 'lau thai'],
      'ingredients': [
        ParsedIngredient(
          id: 'hai_san_lau',
          name: 'Tôm, mực & cá viên hải sản',
          quantityPerPerson: 200.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'nam_kim_cham',
          name: 'Nấm kim châm & Rau muống',
          quantityPerPerson: 1.0,
          unit: 'gói',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'gia_vi_lau_thai',
          name: 'Sốt gia vị Lẩu Thái',
          quantityPerPerson: 1.0,
          unit: 'gói',
          aisle: 'Gia vị & Đồ khô',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['cá lóc hấp bầu', 'cá lóc'],
      'ingredients': [
        ParsedIngredient(
          id: 'ca_loc_tuoi',
          name: 'Cá lóc tươi nguyên con',
          quantityPerPerson: 200.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'bau_tuoi',
          name: 'Bầu trái tươi & Tần dầy lá',
          quantityPerPerson: 1.0,
          unit: 'trái',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },

    // 🇫🇮 MÓN PHẦN LAN & BẮC ÂU (FINNISH / NORDIC)
    {
      'keywords': ['lohikeitto', 'súp cá hồi', 'sup ca hoi'],
      'ingredients': [
        ParsedIngredient(
          id: 'ca_hoi_finland',
          name: 'Lườn cá hồi tươi (Lohifilee)',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'kem_tuoi_cream',
          name: 'Kem tươi Cooking Cream (Ruokakerma)',
          quantityPerPerson: 100.0,
          unit: 'ml',
          aisle: 'Trứng & Sữa',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'khoai_tay_finland',
          name: 'Khoai tây củ nhỏ (Peruna)',
          quantityPerPerson: 2.0,
          unit: 'củ',
          aisle: 'Rau củ quả',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'thi_la_tuoi',
          name: 'Thì là tươi & Hành tỏi',
          quantityPerPerson: 1.0,
          unit: 'bó',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['lihapullat', 'thịt viên bắc âu', 'thit vien'],
      'ingredients': [
        ParsedIngredient(
          id: 'thit_bam_nordic',
          name: 'Thịt bò & heo băm (Jauheliha)',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'mut_lingonberry',
          name: 'Mứt nam việt quất (Puolukkahillo)',
          quantityPerPerson: 0.5,
          unit: 'hũ',
          aisle: 'Bánh mì & Mứt',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'khoai_tay_nghien',
          name: 'Khoai tây làm nghiền',
          quantityPerPerson: 2.0,
          unit: 'củ',
          aisle: 'Rau củ quả',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['ruisleipä', 'ruisleipa', 'bánh mì đen', 'karjalanpiirakka'],
      'ingredients': [
        ParsedIngredient(
          id: 'banh_mi_den',
          name: 'Bánh mì đen lúa mạch (Ruisleipä)',
          quantityPerPerson: 2.0,
          unit: 'lát',
          aisle: 'Bánh mì & Mứt',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'pho_mai_finland',
          name: 'Phô mai lát Juusto & Bơ lạt',
          quantityPerPerson: 1.0,
          unit: 'hộp',
          aisle: 'Trứng & Sữa',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['kaurapuuro', 'puuro', 'cháo yến mạch'],
      'ingredients': [
        ParsedIngredient(
          id: 'yen_mach_hiutale',
          name: 'Yến mạch cán dẹt (Kaurahiutale)',
          quantityPerPerson: 80.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'sua_tuoi_maito',
          name: 'Sữa tươi (Maito)',
          quantityPerPerson: 200.0,
          unit: 'ml',
          aisle: 'Trứng & Sữa',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'mut_lingonberry_oats',
          name: 'Mứt nam việt quất Lingonberry',
          quantityPerPerson: 0.5,
          unit: 'hũ',
          aisle: 'Bánh mì & Mứt',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['pannukakku', 'kếp phần lan', 'bánh kếp nướng'],
      'ingredients': [
        ParsedIngredient(
          id: 'bot_pan',
          name: 'Bột làm bánh kếp & Yến mạch',
          quantityPerPerson: 1.0,
          unit: 'gói',
          aisle: 'Bánh mì & Mứt',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'trung_ga_pan',
          name: 'Trứng gà tươi',
          quantityPerPerson: 1.0,
          unit: 'quả',
          aisle: 'Trứng & Sữa',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'mut_quat_pan',
          name: 'Mứt việt quất / Nam việt quất',
          quantityPerPerson: 0.5,
          unit: 'hũ',
          aisle: 'Bánh mì & Mứt',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['pyttipannu', 'xúc xích phần lan'],
      'ingredients': [
        ParsedIngredient(
          id: 'xuc_xich_makkara',
          name: 'Xúc xích Phần Lan (Makkara)',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'khoai_tay_pytt',
          name: 'Khoai tây củ',
          quantityPerPerson: 2.0,
          unit: 'củ',
          aisle: 'Rau củ quả',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['karjalanpaisti', 'thịt hầm karelian', 'poronkäristys'],
      'ingredients': [
        ParsedIngredient(
          id: 'thit_bo_heo_ham',
          name: 'Thịt bò & heo nạc hầm',
          quantityPerPerson: 200.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'ca_rot_hanh_tay',
          name: 'Cà rốt & Hành tây củ',
          quantityPerPerson: 1.0,
          unit: 'củ',
          aisle: 'Rau củ quả',
          storageLocation: 'PANTRY',
        ),
      ],
    },

    // 🇪🇺 MÓN CHÂU ÂU (EUROPEAN)
    {
      'keywords': ['spaghetti', 'bolognese', 'mỳ ý'],
      'ingredients': [
        ParsedIngredient(
          id: 'my_y_spaghetti',
          name: 'Mỳ Ý Spaghetti',
          quantityPerPerson: 100.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'thit_bo_bam_y',
          name: 'Thịt bò băm tươi',
          quantityPerPerson: 120.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'sot_ca_chua_y',
          name: 'Sốt cà chua Ý & Phô mai Parmesan',
          quantityPerPerson: 1.0,
          unit: 'hũ',
          aisle: 'Gia vị & Đồ khô',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['steak', 'ribeye', 'bít tết'],
      'ingredients': [
        ParsedIngredient(
          id: 'thit_bo_ribeye',
          name: 'Thịt thăn bò Ribeye tươi',
          quantityPerPerson: 200.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'mang_tay_khoai',
          name: 'Măng tây tươi & Khoai tây chiên',
          quantityPerPerson: 100.0,
          unit: 'g',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },

    // 🇯🇵 MÓN CHÂU Á (ASIAN)
    {
      'keywords': ['teriyaki', 'donburi', 'tonkatsu', 'bibimbap', 'ramen', 'sashimi', 'bulgogi'],
      'ingredients': [
        ParsedIngredient(
          id: 'gao_nhat_han',
          name: 'Gạo dẻo Nhật/Hàn hoặc Sợi mì Ramen/Udon',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'thit_nhat_han',
          name: 'Thịt bò / Gà / Cá hồi tươi',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'sot_kimchi',
          name: 'Sốt Teriyaki / Kimchi / Rong biển',
          quantityPerPerson: 1.0,
          unit: 'hũ',
          aisle: 'Gia vị & Đồ khô',
          storageLocation: 'PANTRY',
        ),
      ],
    },

    // 🥗 MÓN CLEAN / HEALTHY (HEALTHY)
    {
      'keywords': ['salad', 'clean', 'healthy', 'quinoa', 'smoothie'],
      'ingredients': [
        ParsedIngredient(
          id: 'uc_ga_tuoi',
          name: 'Ức gà nạc tươi',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'rau_xa_lach_cabi',
          name: 'Rau xà lách & Cà chua bi tươi',
          quantityPerPerson: 1.0,
          unit: 'hộp',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'sot_caesar',
          name: 'Sốt Caesar / Chanh dây Healthy',
          quantityPerPerson: 1.0,
          unit: 'chai',
          aisle: 'Gia vị & Đồ khô',
          storageLocation: 'PANTRY',
        ),
      ],
    },
  ];

  /// Hàm bóc tách danh sách nguyên liệu tổng hợp từ danh sách Tên món ăn trong Thực Đơn Tuần
  static List<Map<String, dynamic>> parseMealPlanToShoppingList({
    required List<String> recipeTitles,
    required int memberCount,
    required List<PantryItem> pantryItems,
  }) {
    final Map<String, Map<String, dynamic>> aggregatedMap = {};
    final factor = memberCount <= 0 ? 1 : memberCount;

    for (final title in recipeTitles) {
      final titleLower = title.toLowerCase();
      var foundInDict = false;

      for (final entry in _dictionary) {
        final keywords = entry['keywords'] as List<String>;
        final ingredients = entry['ingredients'] as List<ParsedIngredient>;

        final matches = keywords.any((kw) => titleLower.contains(kw));
        if (matches) {
          foundInDict = true;
          for (final ing in ingredients) {
            final totalQty = ing.quantityPerPerson * factor;

            if (aggregatedMap.containsKey(ing.id)) {
              aggregatedMap[ing.id]!['rawQty'] = (aggregatedMap[ing.id]!['rawQty'] as double) + totalQty;
            } else {
              aggregatedMap[ing.id] = {
                'id': ing.id,
                'name': ing.name,
                'rawQty': totalQty,
                'unit': ing.unit,
                'aisle': ing.aisle,
                'storageLocation': ing.storageLocation,
              };
            }
          }
        }
      }

      // Nếu món ăn không có trong từ điển mẫu, tự động lấy Tên món sạch làm 1 nguyên liệu duy nhất
      if (!foundInDict) {
        final cleanTitle = title
            .replaceAll(RegExp(r'[\(\)]'), '')
            .trim();
        final fallbackId = 'fb_${cleanTitle.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '').replaceAll(RegExp(r'\s+'), '_')}';
        
        if (!aggregatedMap.containsKey(fallbackId)) {
          aggregatedMap[fallbackId] = {
            'id': fallbackId,
            'name': 'Nguyên liệu chuẩn bị làm: $cleanTitle',
            'rawQty': 1.0 * factor,
            'unit': 'bộ',
            'aisle': 'Rau củ quả',
            'storageLocation': 'FRIDGE',
          };
        }
      }
    }

    // Định dạng lại chuỗi hiển thị số lượng
    final List<Map<String, dynamic>> resultList = [];

    aggregatedMap.forEach((id, item) {
      final rawQty = item['rawQty'] as double;
      final unit = item['unit'] as String;
      final name = item['name'] as String;

      // Kiểm tra xem nguyên liệu này đã có sẵn trong Tủ lạnh (Pantry) hay chưa
      final bool inPantry = pantryItems.any((p) {
        final pName = p.ingredientId.toLowerCase();
        final searchName = name.toLowerCase();
        return pName.contains(searchName) || searchName.contains(pName);
      });

      String formattedQty;
      if (unit == 'g' || unit == 'ml') {
        formattedQty = rawQty >= 1000 ? '${(rawQty / 1000).toStringAsFixed(1)} kg' : '${rawQty.toInt()} $unit';
      } else {
        formattedQty = rawQty.truncateToDouble() == rawQty ? '${rawQty.toInt()} $unit' : '${rawQty.toStringAsFixed(1)} $unit';
      }

      resultList.add({
        ...item,
        'qty': formattedQty,
        'inPantry': inPantry,
      });
    });

    // Chỉ trả về các nguyên liệu CHƯA CÓ TRONG TỦ LẠNH
    return resultList.where((item) => item['inPantry'] == false).toList();
  }
}

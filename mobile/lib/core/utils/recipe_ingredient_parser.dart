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

/// Bộ phân tích bóc tách nguyên liệu tự động thông minh (Universal Recipe Ingredient Parser)
class RecipeIngredientParser {
  static final List<Map<String, dynamic>> _dictionary = [
    // 🇫🇮 PHẦN LAN / BẮC ÂU (FINNISH / NORDIC)
    {
      'keywords': ['poronkäristys', 'poronkaristys', 'tuần lộc', 'bò xào mứt', 'xào mứt nam việt quất'],
      'ingredients': [
        ParsedIngredient(
          id: 'thit_tuan_loc_bo',
          name: 'Thịt bò / Thịt tuần lộc tươi (Poronkäristys)',
          quantityPerPerson: 180.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'mut_nam_viet_quat_poron',
          name: 'Mứt nam việt quất Phần Lan (Puolukkahillo)',
          quantityPerPerson: 0.5,
          unit: 'hũ',
          aisle: 'Bánh mì & Mứt',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'khoai_tay_bo_lat',
          name: 'Khoai tây củ & Bơ lạt',
          quantityPerPerson: 2.0,
          unit: 'củ',
          aisle: 'Rau củ quả',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['uunilohi', 'cá hồi nướng', 'cá hồi sốt chanh', 'lohi'],
      'ingredients': [
        ParsedIngredient(
          id: 'ca_hoi_uunilohi',
          name: 'Lườn cá hồi tươi (Lohifilee)',
          quantityPerPerson: 180.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'chanh_bo_thi_la',
          name: 'Chanh vàng, Bơ lạt & Thì là tươi',
          quantityPerPerson: 1.0,
          unit: 'bộ',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'khoai_tay_nhat',
          name: 'Khoai tây củ nhỏ (Peruna)',
          quantityPerPerson: 2.0,
          unit: 'củ',
          aisle: 'Rau củ quả',
          storageLocation: 'PANTRY',
        ),
      ],
    },
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
      'keywords': ['karjalanpaisti', 'thịt hầm karelian'],
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

      // Tra cứu từ điển theo từ khóa
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

      // NẾU KHÔNG CÓ TRONG TỪ ĐIỂN MẪU -> TỰ ĐỘNG BÓC TÁCH THÔNG MINH (THỰC PHẨM THỰC TẾ)
      // TUYỆT ĐỐI KHÔNG TẠO CHUỖI "Nguyên liệu chuẩn bị làm: [Tên món]"
      if (!foundInDict) {
        final smartIngredients = _generateSmartFallbackIngredients(title, factor);
        for (final ing in smartIngredients) {
          final id = ing['id'] as String;
          final totalQty = ing['rawQty'] as double;

          if (aggregatedMap.containsKey(id)) {
            aggregatedMap[id]!['rawQty'] = (aggregatedMap[id]!['rawQty'] as double) + totalQty;
          } else {
            aggregatedMap[id] = ing;
          }
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
        'quantity': rawQty,
        'rawQty': rawQty,
        'qty': formattedQty,
        'inPantry': inPantry,
      });
    });

    // Chỉ trả về các nguyên liệu CHƯA CÓ TRONG TỦ LẠNH
    return resultList.where((item) => item['inPantry'] == false).toList();
  }

  /// Phân tích ngôn ngữ thông minh để tạo ra NGUYÊN LIỆU THẬT từ tên món ăn chưa từng gặp
  static List<Map<String, dynamic>> _generateSmartFallbackIngredients(String title, int factor) {
    final t = title.toLowerCase();
    final List<Map<String, dynamic>> items = [];

    // 1. Phân tích loại Đạm chính (Protein)
    if (t.contains('tuần lộc') || t.contains('poron')) {
      items.add({
        'id': 'fb_tuan_loc',
        'name': 'Thịt bò / Thịt tuần lộc tươi (Poronkäristys)',
        'rawQty': 180.0 * factor,
        'unit': 'g',
        'aisle': 'Thịt & Hải sản',
        'storageLocation': 'FREEZER',
      });
    } else if (t.contains('cá hồi') || t.contains('lohi') || t.contains('salmon') || t.contains('uunilohi')) {
      items.add({
        'id': 'fb_ca_hoi',
        'name': 'Lườn cá hồi tươi (Fillet / Lohi)',
        'rawQty': 180.0 * factor,
        'unit': 'g',
        'aisle': 'Thịt & Hải sản',
        'storageLocation': 'FRIDGE',
      });
    } else if (t.contains('cá') || t.contains('fish')) {
      items.add({
        'id': 'fb_ca_tuoi',
        'name': 'Cá tươi fillet',
        'rawQty': 150.0 * factor,
        'unit': 'g',
        'aisle': 'Thịt & Hải sản',
        'storageLocation': 'FRIDGE',
      });
    } else if (t.contains('bò') || t.contains('beef') || t.contains('steak')) {
      items.add({
        'id': 'fb_bo_tuoi',
        'name': 'Thịt bò tươi phi lê / nạc',
        'rawQty': 150.0 * factor,
        'unit': 'g',
        'aisle': 'Thịt & Hải sản',
        'storageLocation': 'FREEZER',
      });
    } else if (t.contains('gà') || t.contains('chicken')) {
      items.add({
        'id': 'fb_ga_tuoi',
        'name': 'Thịt gà tươi đùi / ức',
        'rawQty': 150.0 * factor,
        'unit': 'g',
        'aisle': 'Thịt & Hải sản',
        'storageLocation': 'FREEZER',
      });
    } else if (t.contains('tôm') || t.contains('shrimp')) {
      items.add({
        'id': 'fb_tom_tuoi',
        'name': 'Tôm tươi',
        'rawQty': 150.0 * factor,
        'unit': 'g',
        'aisle': 'Thịt & Hải sản',
        'storageLocation': 'FREEZER',
      });
    } else if (t.contains('mực') || t.contains('squid')) {
      items.add({
        'id': 'fb_muc_tuoi',
        'name': 'Mực tươi',
        'rawQty': 150.0 * factor,
        'unit': 'g',
        'aisle': 'Thịt & Hải sản',
        'storageLocation': 'FREEZER',
      });
    } else if (t.contains('heo') || t.contains('lợn') || t.contains('sườn') || t.contains('pork')) {
      items.add({
        'id': 'fb_heo_tuoi',
        'name': 'Thịt heo / Sườn heo tươi',
        'rawQty': 150.0 * factor,
        'unit': 'g',
        'aisle': 'Thịt & Hải sản',
        'storageLocation': 'FREEZER',
      });
    } else {
      // Đạm tổng hợp tươi ngon
      items.add({
        'id': 'fb_dam_tong_hop',
        'name': 'Thực phẩm tươi chính (Thịt / Cá / Trứng)',
        'rawQty': 150.0 * factor,
        'unit': 'g',
        'aisle': 'Thịt & Hải sản',
        'storageLocation': 'FRIDGE',
      });
    }

    // 2. Phân tích Mứt / Quả mọng / Sốt nêm đặc biệt từ Tên Món
    if (t.contains('mứt') || t.contains('nam việt quất') || t.contains('lingonberry') || t.contains('puolukka') || t.contains('việt quất')) {
      items.add({
        'id': 'fb_mut_nam_viet_quat',
        'name': 'Mứt nam việt quất Phần Lan (Puolukkahillo)',
        'rawQty': 0.5 * factor,
        'unit': 'hũ',
        'aisle': 'Bánh mì & Mứt',
        'storageLocation': 'PANTRY',
      });
    } else if (t.contains('chanh') || t.contains('bơ') || t.contains('thì là')) {
      items.add({
        'id': 'fb_chanh_bo_thi_la',
        'name': 'Chanh vàng, Bơ lạt & Thì là tươi',
        'rawQty': 1.0 * factor,
        'unit': 'bộ',
        'aisle': 'Rau củ quả',
        'storageLocation': 'FRIDGE',
      });
    } else if (t.contains('sốt') || t.contains('sauce') || t.contains('phô mai')) {
      items.add({
        'id': 'fb_sot_gia_vi',
        'name': 'Bơ tỏi, Phô mai & Nước sốt đậm đà',
        'rawQty': 1.0 * factor,
        'unit': 'hũ',
        'aisle': 'Gia vị & Đồ khô',
        'storageLocation': 'PANTRY',
      });
    } else {
      items.add({
        'id': 'fb_rau_gia_vi',
        'name': 'Rau củ tươi & Gia vị nấu ăn',
        'rawQty': 1.0 * factor,
        'unit': 'bộ',
        'aisle': 'Rau củ quả',
        'storageLocation': 'FRIDGE',
      });
    }

    // 3. Phân tích Tinh bột / Rau củ ăn kèm
    if (t.contains('khoai') || t.contains('nướng lò') || t.contains('uunilohi') || t.contains('poron')) {
      items.add({
        'id': 'fb_khoai_tay',
        'name': 'Khoai tây củ / Măng tây tươi',
        'rawQty': 150.0 * factor,
        'unit': 'g',
        'aisle': 'Rau củ quả',
        'storageLocation': 'PANTRY',
      });
    } else if (t.contains('cơm') || t.contains('cháo')) {
      items.add({
        'id': 'fb_gao_thom',
        'name': 'Gạo thơm Jasmine / Gạo nếp',
        'rawQty': 100.0 * factor,
        'unit': 'g',
        'aisle': 'Bún Phở & Ngũ Cốc',
        'storageLocation': 'PANTRY',
      });
    } else if (t.contains('bún') || t.contains('phở') || t.contains('mỳ') || t.contains('pasta')) {
      items.add({
        'id': 'fb_soi_bun_my',
        'name': 'Sợi bún / Phở / Mỳ Ý tươi',
        'rawQty': 120.0 * factor,
        'unit': 'g',
        'aisle': 'Bún Phở & Ngũ Cốc',
        'storageLocation': 'PANTRY',
      });
    }

    return items;
  }
}

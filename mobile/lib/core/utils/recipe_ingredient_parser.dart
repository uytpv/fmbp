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
    // 🥣 Các món Canh / Súp
    {
      'keywords': ['khoai mỡ', 'khoai mo'],
      'ingredients': [
        ParsedIngredient(
          id: 'khoai_mo',
          name: 'Khoai mỡ tím',
          quantityPerPerson: 200.0,
          unit: 'g',
          aisle: 'Rau củ quả',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'tom_kho_tuoi',
          name: 'Tôm tươi / Tôm khô',
          quantityPerPerson: 100.0,
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
      'keywords': ['canh chua', 'cá hồi', 'lohi'],
      'ingredients': [
        ParsedIngredient(
          id: 'ca_hoi',
          name: 'Lườn / Đầu cá hồi tươi',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'ca_chua_thom',
          name: 'Cà chua & Thơm / Dứa',
          quantityPerPerson: 1.0,
          unit: 'quả',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'bac_ha_gia',
          name: 'Bac hà (Dọc mùng) & Giá đậu',
          quantityPerPerson: 100.0,
          unit: 'g',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['rau muống', 'rau muong'],
      'ingredients': [
        ParsedIngredient(
          id: 'rau_muong',
          name: 'Rau muống tươi',
          quantityPerPerson: 1.0,
          unit: 'bó',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'toi_ot',
          name: 'Tỏi & Ớt tươi',
          quantityPerPerson: 20.0,
          unit: 'g',
          aisle: 'Gia vị & Đồ khô',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['canh cải', 'canh cai', 'cải băm'],
      'ingredients': [
        ParsedIngredient(
          id: 'rau_cai',
          name: 'Rau cải xanh / Cải ngọt',
          quantityPerPerson: 1.0,
          unit: 'bó',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'thit_bam',
          name: 'Thịt heo nạc băm',
          quantityPerPerson: 80.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
      ],
    },

    // 🥩 Món Mặn / Món Kho / Món Xào
    {
      'keywords': ['sườn kho', 'suon kho', 'sườn nướng'],
      'ingredients': [
        ParsedIngredient(
          id: 'suon_heo',
          name: 'Sườn non heo',
          quantityPerPerson: 200.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'trung_ga',
          name: 'Trứng gà tươi',
          quantityPerPerson: 1.0,
          unit: 'quả',
          aisle: 'Trứng & Sữa',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'gao_thom',
          name: 'Gạo thơm Jasmine',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['thịt kho', 'thit kho', 'kho tàu'],
      'ingredients': [
        ParsedIngredient(
          id: 'thit_ba_chi',
          name: 'Thịt ba chỉ heo tươi',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'trung_ga_vit',
          name: 'Trứng gà / Trứng vịt',
          quantityPerPerson: 2.0,
          unit: 'quả',
          aisle: 'Trứng & Sữa',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'nuoc_dua',
          name: 'Nước dừa tươi / Dừa hộp',
          quantityPerPerson: 100.0,
          unit: 'ml',
          aisle: 'Gia vị & Đồ khô',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['cá kho', 'ca kho'],
      'ingredients': [
        ParsedIngredient(
          id: 'ca_loc_ro',
          name: 'Cá lóc / Cá rô kho tộ',
          quantityPerPerson: 200.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'thit_ba_chi_ot',
          name: 'Thịt ba chỉ & Ớt tiêu',
          quantityPerPerson: 50.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
      ],
    },
    {
      'keywords': ['tôm', 'tom hấp', 'su su'],
      'ingredients': [
        ParsedIngredient(
          id: 'tom_tuoi',
          name: 'Tôm sú / Tôm thẻ tươi',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'su_su',
          name: 'Su su tươi',
          quantityPerPerson: 1.0,
          unit: 'củ',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'trung_ga',
          name: 'Trứng gà',
          quantityPerPerson: 1.0,
          unit: 'quả',
          aisle: 'Trứng & Sữa',
          storageLocation: 'FRIDGE',
        ),
      ],
    },

    // 🍜 Điểm Tâm / Bún Phở / Cháo / Sandwich
    {
      'keywords': ['sandwich', 'bánh mì', 'mứt dâu', 'mút dâu'],
      'ingredients': [
        ParsedIngredient(
          id: 'banh_mi_sandwich',
          name: 'Bánh mì sandwich',
          quantityPerPerson: 2.0,
          unit: 'lát',
          aisle: 'Bánh mì & Mứt',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'mut_dau',
          name: 'Mứt dâu tây',
          quantityPerPerson: 0.5,
          unit: 'hũ',
          aisle: 'Bánh mì & Mứt',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'bo_lat',
          name: 'Bơ lạt nướng',
          quantityPerPerson: 15.0,
          unit: 'g',
          aisle: 'Trứng & Sữa',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['phở', 'pho bò', 'pho ga'],
      'ingredients': [
        ParsedIngredient(
          id: 'thit_bo',
          name: 'Thịt bò tái / Gà xé',
          quantityPerPerson: 120.0,
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
          id: 'hanh_ngo',
          name: 'Hành tây, Hành lá & Gia vị phở',
          quantityPerPerson: 1.0,
          unit: 'bộ',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['bún', 'bun moc', 'bun bo'],
      'ingredients': [
        ParsedIngredient(
          id: 'bun_tuoi',
          name: 'Bún tươi / Bún khô',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'moc_suon',
          name: 'Sườn heo & Giò sống / Mọc',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
      ],
    },
    {
      'keywords': ['cháo', 'chao ga', 'hat sen'],
      'ingredients': [
        ParsedIngredient(
          id: 'thit_ga',
          name: 'Thịt gà tươi',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'hat_sen_gao',
          name: 'Hạt sen & Gạo nấu cháo',
          quantityPerPerson: 80.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    // 🇫🇮 Món Phần Lan & Bắc Âu (Finnish / Nordic)
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
      'keywords': ['ruisleipä', 'bánh mì đen', 'karjalanpiirakka'],
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
          name: 'Phô mai lát Juusto & Bơ',
          quantityPerPerson: 1.0,
          unit: 'hộp',
          aisle: 'Trứng & Sữa',
          storageLocation: 'FRIDGE',
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

    // 🇪🇺 Món Châu Âu (European / Pasta / Steak)
    {
      'keywords': ['spaghetti', 'bolognese', 'pasta', 'mỳ ý'],
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
      'keywords': ['steak', 'ribeye', 'bít tết', 'cá hồi áp chảo'],
      'ingredients': [
        ParsedIngredient(
          id: 'thit_bo_ribeye',
          name: 'Thịt thăn bò Ribeye / Cá hồi',
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

    // 🥗 Món Healthy / Clean / Salad
    {
      'keywords': ['salad', 'clean', 'healthy', 'quinoa', 'yến mạch'],
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
          name: 'Rau xà lách & Cà chua bi',
          quantityPerPerson: 1.0,
          unit: 'hộp',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['pannukakku', 'kếp', 'bánh kếp'],
      'ingredients': [
        ParsedIngredient(
          id: 'bot_banh_kep',
          name: 'Bột làm bánh kếp & Yến mạch',
          quantityPerPerson: 1.0,
          unit: 'gói',
          aisle: 'Bánh mì & Mứt',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'trung_ga',
          name: 'Trứng gà tươi',
          quantityPerPerson: 1.0,
          unit: 'quả',
          aisle: 'Trứng & Sữa',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'mut_viet_quat',
          name: 'Mứt việt quất / Nam việt quất',
          quantityPerPerson: 0.5,
          unit: 'hũ',
          aisle: 'Bánh mì & Mứt',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['kaurapuuro', 'cháo yến mạch', 'puuro'],
      'ingredients': [
        ParsedIngredient(
          id: 'yen_mach_oats',
          name: 'Yến mạch cán dẹt (Kaurahiutale)',
          quantityPerPerson: 80.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'sua_tuoi_finland',
          name: 'Sữa tươi (Maito)',
          quantityPerPerson: 200.0,
          unit: 'ml',
          aisle: 'Trứng & Sữa',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['pyttipannu', 'xúc xích phần lan'],
      'ingredients': [
        ParsedIngredient(
          id: 'xuc_xich_finland',
          name: 'Xúc xích Phần Lan (Makkara)',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'khoai_tay',
          name: 'Khoai tây củ',
          quantityPerPerson: 2.0,
          unit: 'củ',
          aisle: 'Rau củ quả',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['siskonmakkarakeitto', 'súp xúc xích'],
      'ingredients': [
        ParsedIngredient(
          id: 'xuc_xich_tuoi_siskon',
          name: 'Xúc xích tươi (Siskonmakkara)',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'ca_rot_can_tay',
          name: 'Cà rốt & Cần tây củ',
          quantityPerPerson: 1.0,
          unit: 'bó',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['uunilohi', 'cá hồi nướng lò'],
      'ingredients': [
        ParsedIngredient(
          id: 'ca_hoi_uunilohi',
          name: 'Lườn cá hồi tươi (Lohi)',
          quantityPerPerson: 200.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'sot_chanh_thi_la',
          name: 'Bơ lạt & Thì là tươi',
          quantityPerPerson: 1.0,
          unit: 'bó',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['poronkäristys', 'thịt tuần lộc', 'thịt bò xào mứt'],
      'ingredients': [
        ParsedIngredient(
          id: 'thit_bo_xao_mut',
          name: 'Thịt bò / Tuần lộc nạc',
          quantityPerPerson: 200.0,
          unit: 'g',
          aisle: 'Thịt & Hải sản',
          storageLocation: 'FREEZER',
        ),
        ParsedIngredient(
          id: 'mut_lingonberry_poron',
          name: 'Mứt nam việt quất (Puolukka)',
          quantityPerPerson: 0.5,
          unit: 'hũ',
          aisle: 'Bánh mì & Mứt',
          storageLocation: 'PANTRY',
        ),
      ],
    },
    {
      'keywords': ['croissant', 'omelette', 'french toast'],
      'ingredients': [
        ParsedIngredient(
          id: 'banh_croissant',
          name: 'Bánh mì Croissant / Sandwich',
          quantityPerPerson: 2.0,
          unit: 'chiếc',
          aisle: 'Bánh mì & Mứt',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'trung_ga_y',
          name: 'Trứng gà & Phô mai Mozzarella',
          quantityPerPerson: 2.0,
          unit: 'quả',
          aisle: 'Trứng & Sữa',
          storageLocation: 'FRIDGE',
        ),
      ],
    },
    {
      'keywords': ['tamagoyaki', 'jeonbokjuk', 'udon', 'teriyaki', 'tonkatsu', 'bibimbap', 'sashimi', 'bulgogi', 'ramen'],
      'ingredients': [
        ParsedIngredient(
          id: 'gao_nhat_han',
          name: 'Gạo dẻo Nhật/Hàn hoặc Mì Udon/Ramen',
          quantityPerPerson: 150.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
          storageLocation: 'PANTRY',
        ),
        ParsedIngredient(
          id: 'thit_ga_bo_nhat',
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
    {
      'keywords': ['smoothie', 'overnight oats', 'quinoa'],
      'ingredients': [
        ParsedIngredient(
          id: 'dau_tay_hat_chia',
          name: 'Dâu tây, Quả mọng & Hạt Chia',
          quantityPerPerson: 100.0,
          unit: 'g',
          aisle: 'Rau củ quả',
          storageLocation: 'FRIDGE',
        ),
        ParsedIngredient(
          id: 'yen_mach_quinoa',
          name: 'Yến mạch / Hạt Quinoa Organic',
          quantityPerPerson: 80.0,
          unit: 'g',
          aisle: 'Bún Phở & Ngũ Cốc',
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
            'name': 'Nguyên liệu làm: $cleanTitle',
            'rawQty': 1.0 * factor,
            'unit': 'phần',
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

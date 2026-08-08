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

      // Nếu món ăn không có trong từ điển mẫu, tự động phân tích từ khóa cơ bản
      if (!foundInDict) {
        final words = title.split(RegExp(r'[\s&,/]+'));
        for (final word in words) {
          if (word.length >= 3) {
            final fallbackId = 'fb_${word.toLowerCase()}';
            if (!aggregatedMap.containsKey(fallbackId)) {
              aggregatedMap[fallbackId] = {
                'id': fallbackId,
                'name': 'Nguyên liệu: $word',
                'rawQty': 1.0 * factor,
                'unit': 'phần',
                'aisle': 'Rau củ quả',
                'storageLocation': 'FRIDGE',
              };
            }
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
        'qty': formattedQty,
        'inPantry': inPantry,
      });
    });

    // Chỉ trả về các nguyên liệu CHƯA CÓ TRONG TỦ LẠNH
    return resultList.where((item) => item['inPantry'] == false).toList();
  }
}

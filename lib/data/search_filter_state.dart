import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchFilterState {
  const SearchFilterState({
    this.priceRange = const RangeValues(500000, 1500000),
    this.propertyType = 'Tất cả',
    this.amenities = const {'Wi-Fi miễn phí', 'Điều hòa', 'Bếp nấu ăn'},
    this.isCustomPrice = false,
    this.isCustomPropertyType = false,
    this.isCustomAmenities = false,
  });

  const SearchFilterState.empty()
      : priceRange = const RangeValues(0, 3000000),
        propertyType = 'Tất cả',
        amenities = const {},
        isCustomPrice = false,
        isCustomPropertyType = false,
        isCustomAmenities = false;

  final RangeValues priceRange;
  final String propertyType;
  final Set<String> amenities;
  final bool isCustomPrice;
  final bool isCustomPropertyType;
  final bool isCustomAmenities;

  int? get minPrice {
    if (!isCustomPrice) return null;
    return priceRange.start <= 0 ? null : priceRange.start.round();
  }

  int? get maxPrice {
    if (!isCustomPrice) return null;
    return priceRange.end >= 3000000 ? null : priceRange.end.round();
  }

  String? get normalizedPropertyType {
    if (!isCustomPropertyType || propertyType == 'Tất cả') return null;
    return switch (propertyType) {
      'Khách sạn' => 'HOTEL',
      'Homestay' => 'HOMESTAY',
      _ => propertyType.toUpperCase(),
    };
  }

  int get count =>
      (isCustomPrice ? 1 : 0) +
      (isCustomPropertyType && propertyType != 'Tất cả' ? 1 : 0) +
      (isCustomAmenities && amenities.isNotEmpty ? 1 : 0);

  SearchFilterState copyWith({
    RangeValues? priceRange,
    String? propertyType,
    Set<String>? amenities,
    bool? isCustomPrice,
    bool? isCustomPropertyType,
    bool? isCustomAmenities,
  }) => SearchFilterState(
    priceRange: priceRange ?? this.priceRange,
    propertyType: propertyType ?? this.propertyType,
    amenities: amenities ?? this.amenities,
    isCustomPrice: isCustomPrice ?? this.isCustomPrice,
    isCustomPropertyType: isCustomPropertyType ?? this.isCustomPropertyType,
    isCustomAmenities: isCustomAmenities ?? this.isCustomAmenities,
  );
}

class SearchFilterNotifier extends Notifier<SearchFilterState> {
  @override
  SearchFilterState build() => const SearchFilterState.empty();

  void setFilter(SearchFilterState filter) => state = filter;

  void reset() => state = const SearchFilterState.empty();
}

final searchFilterProvider =
    NotifierProvider<SearchFilterNotifier, SearchFilterState>(
      SearchFilterNotifier.new,
    );


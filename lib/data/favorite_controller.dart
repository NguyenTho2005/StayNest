import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'staynest_api.dart';

/// Trạng thái đồng bộ của danh sách yêu thích trong toàn bộ ứng dụng.
class FavoriteState {
  const FavoriteState({
    this.items = const [],
    this.slugs = const {},
    this.pendingSlugs = const {},
    this.isLoading = false,
    this.error,
  });

  /// Danh sách chi tiết các chỗ ở yêu thích nhận từ API.
  final List<dynamic> items;

  /// Tập hợp các slug đang được yêu thích để tra cứu O(1) tức thì trên card/list/detail.
  final Set<String> slugs;

  /// Tập hợp các slug đang trong tiến trình gọi API (để chặn double-tap).
  final Set<String> pendingSlugs;

  /// Trạng thái đang tải từ API.
  final bool isLoading;

  /// Lỗi gần nhất (nếu có).
  final String? error;

  bool isFavorite(String slug) => slugs.contains(slug);
  bool isPending(String slug) => pendingSlugs.contains(slug);

  FavoriteState copyWith({
    List<dynamic>? items,
    Set<String>? slugs,
    Set<String>? pendingSlugs,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) =>
      FavoriteState(
        items: items ?? this.items,
        slugs: slugs ?? this.slugs,
        pendingSlugs: pendingSlugs ?? this.pendingSlugs,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : (error ?? this.error),
      );
}

/// Controller quản lý một nguồn trạng thái Favorite duy nhất.
/// Hỗ trợ Optimistic Update, chặn double-tap và rollback chính xác khi có lỗi.
class FavoriteController extends Notifier<FavoriteState> {
  @override
  FavoriteState build() {
    ref.listen(currentUserProvider, (previous, next) {
      final prevUser = previous?.value;
      final nextUser = next.value;
      if (prevUser?['id'] != nextUser?['id']) {
        if (nextUser == null) {
          state = const FavoriteState();
        } else {
          load();
        }
      }
    });
    Future.microtask(load);
    return const FavoriteState();
  }

  StayNestApi get _api => ref.read(stayNestApiProvider);

  /// Nạp danh sách yêu thích từ máy chủ.
  Future<void> load() async {
    final token = await _api.token;
    if (token == null) {
      state = const FavoriteState();
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final list = await _api.favorites();
      final slugs = list
          .map((item) => '${item['slug'] ?? ''}')
          .where((s) => s.isNotEmpty)
          .toSet();
      state = state.copyWith(
        items: list,
        slugs: slugs,
        isLoading: false,
        clearError: true,
      );
    } catch (err) {
      state = state.copyWith(isLoading: false, error: '$err');
    }
  }

  bool isFavorite(String slug) => state.isFavorite(slug);

  /// Chuyển đổi trạng thái yêu thích với Optimistic Update và chặn double-tap.
  Future<void> toggle(String slug) async {
    if (slug.isEmpty) return;
    if (state.isPending(slug)) return; // Chặn double-tap

    final token = await _api.token;
    if (token == null) {
      throw const StayNestApiException(
        'AUTH_REQUIRED',
        'Vui lòng đăng nhập để lưu chỗ ở yêu thích.',
        401,
      );
    }

    final currentlySaved = state.isFavorite(slug);
    final targetSaved = !currentlySaved;

    // 1. Optimistic Update ngay lập tức trên UI
    final optimisticSlugs = Set<String>.from(state.slugs);
    if (targetSaved) {
      optimisticSlugs.add(slug);
    } else {
      optimisticSlugs.remove(slug);
    }

    final pending = Set<String>.from(state.pendingSlugs)..add(slug);
    final optimisticItems = targetSaved
        ? state.items
        : state.items.where((i) => '${i['slug']}' != slug).toList();

    state = state.copyWith(
      slugs: optimisticSlugs,
      items: optimisticItems,
      pendingSlugs: pending,
      clearError: true,
    );

    // 2. Gửi request đến backend API
    try {
      await _api.setFavorite(slug, targetSaved);

      // Xóa slug khỏi pending khi thành công
      final finishedPending = Set<String>.from(state.pendingSlugs)..remove(slug);
      state = state.copyWith(pendingSlugs: finishedPending);

      // Nếu thêm mới, tải lại ngầm để có đầy đủ thông tin card trong tab Favorites
      if (targetSaved) {
        final updatedList = await _api.favorites();
        final updatedSlugs = updatedList
            .map((item) => '${item['slug'] ?? ''}')
            .where((s) => s.isNotEmpty)
            .toSet();
        state = state.copyWith(items: updatedList, slugs: updatedSlugs);
      }
    } catch (err) {
      // 3. Rollback chính xác về trạng thái trước đó nếu gọi API thất bại
      final rollbackSlugs = Set<String>.from(state.slugs);
      if (currentlySaved) {
        rollbackSlugs.add(slug);
      } else {
        rollbackSlugs.remove(slug);
      }
      final failedPending = Set<String>.from(state.pendingSlugs)..remove(slug);
      state = state.copyWith(
        slugs: rollbackSlugs,
        pendingSlugs: failedPending,
        error: '$err',
      );
      rethrow;
    }
  }

  /// Xóa khỏi danh sách yêu thích.
  Future<void> remove(String slug) async {
    if (isFavorite(slug)) {
      await toggle(slug);
    }
  }
}

/// Provider duy nhất cung cấp FavoriteState và FavoriteController.
final favoriteControllerProvider =
    NotifierProvider<FavoriteController, FavoriteState>(FavoriteController.new);

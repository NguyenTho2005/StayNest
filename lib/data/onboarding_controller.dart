import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _onboardingKey = 'staynest_onboarding_completed';

class OnboardingController extends Notifier<bool> {
  FlutterSecureStorage get _storage => const FlutterSecureStorage();
  static bool? testInitialValue;

  @override
  bool build() {
    if (testInitialValue != null) {
      return testInitialValue!;
    }
    _init();
    return false;
  }

  Future<void> _init() async {
    if (testInitialValue != null) return;
    try {
      final value = await _storage
          .read(key: _onboardingKey)
          .timeout(const Duration(milliseconds: 100), onTimeout: () => null);
      if (value != null) {
        state = value == 'true';
      }
    } catch (_) {
      // Storage unavailable or fallback
    }
  }

  Future<bool> checkCompleted() async {
    if (testInitialValue != null) {
      state = testInitialValue!;
      return state;
    }
    try {
      final value = await _storage
          .read(key: _onboardingKey)
          .timeout(const Duration(milliseconds: 100), onTimeout: () => null);
      if (value != null) {
        state = value == 'true';
      }
      return state;
    } catch (_) {
      return state;
    }
  }

  Future<void> completeOnboarding() async {
    state = true;
    if (testInitialValue != null) {
      testInitialValue = true;
      return;
    }
    try {
      await _storage.write(key: _onboardingKey, value: 'true');
    } catch (_) {}
  }

  Future<void> resetOnboarding() async {
    state = false;
    if (testInitialValue != null) {
      testInitialValue = false;
      return;
    }
    try {
      await _storage.delete(key: _onboardingKey);
    } catch (_) {}
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, bool>(OnboardingController.new);

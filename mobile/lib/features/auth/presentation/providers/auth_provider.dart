import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/auth_event_bus.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/auth_repository.dart';
import '../../data/invitation_repository.dart';
import '../../data/owner_invitation_repository.dart';

enum AuthStatus {
  /// Initial state, before the splash screen has resolved whether a stored
  /// session exists and is still valid.
  unknown,
  authenticating,
  authenticated,
  unauthenticated,

  /// Logged in successfully server-side, but the account's role has no
  /// mobile home (SUPER_ADMIN / ADMIN_AGENCE) - see task brief.
  unsupportedRole,
}

class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.role,
    this.errorMessage,
  });

  final AuthStatus status;
  final UserModel? user;
  final MobileRole? role;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    MobileRole? role,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      role: clearUser ? null : (role ?? this.role),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState()) {
    _forceLogoutSub = AuthEventBus.instance.onForceLogout.listen((_) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    });
  }

  final AuthRepository _repository;
  StreamSubscription<void>? _forceLogoutSub;

  /// Called once at app start (from the splash screen): checks for a stored
  /// access token and, if present, validates it via `GET /auth/me`.
  Future<void> bootstrap() async {
    final token = await _repository.readStoredAccessToken();
    if (token == null || token.isEmpty) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return;
    }
    try {
      final user = await _repository.me();
      _applyLoggedInUser(user);
    } catch (_) {
      await _repository.logout();
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.authenticating, clearError: true);
    try {
      final user = await _repository.login(email: email, password: password);
      _applyLoggedInUser(user);
    } on ApiException catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, errorMessage: e.message);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Une erreur inattendue est survenue.',
      );
    }
  }

  /// Self-service registration (spec §5.1) - always creates a `GESTIONNAIRE`,
  /// so a successful call always resolves to [AuthStatus.authenticated] with
  /// `role == MobileRole.manager`.
  Future<void> register({
    String? organizationName,
    String? email,
    String? phone,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    state = state.copyWith(status: AuthStatus.authenticating, clearError: true);
    try {
      final user = await _repository.register(
        organizationName: organizationName,
        email: email,
        phone: phone,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      _applyLoggedInUser(user);
    } on ApiException catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, errorMessage: e.message);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Une erreur inattendue est survenue.',
      );
    }
  }

  /// Applies a user that was just authenticated by some flow other than
  /// `login()` (e.g. the invitation-activation flow, whose repository
  /// already persisted the access token / refresh cookie exactly like
  /// [login] does) - lets the router's existing role-based redirect take
  /// over from here.
  void applyLoggedInUser(UserModel user) => _applyLoggedInUser(user);

  void _applyLoggedInUser(UserModel user) {
    final role = mobileRoleFromBackendRole(user.roleName);
    if (role == null) {
      state = AuthState(status: AuthStatus.unsupportedRole, user: user);
      return;
    }
    state = AuthState(status: AuthStatus.authenticated, user: user, role: role);
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  @override
  void dispose() {
    _forceLogoutSub?.cancel();
    super.dispose();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

final invitationRepositoryProvider = Provider<InvitationRepository>((ref) {
  return InvitationRepository(
    dio: ref.watch(dioProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

final ownerInvitationRepositoryProvider = Provider<OwnerInvitationRepository>((ref) {
  return OwnerInvitationRepository(
    dio: ref.watch(dioProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

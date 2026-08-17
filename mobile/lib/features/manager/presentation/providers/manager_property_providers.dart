import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/property_model.dart';
import '../../../agent/presentation/providers/agent_providers.dart'
    show PropertiesListNotifier, propertiesRepositoryProvider;

// Property CRUD for the manager (GESTIONNAIRE) role reuses the agent's
// `PropertiesRepository`/`OwnersRepository` and `PropertiesListNotifier` -
// there is nothing role-specific about listing/creating properties, only
// about which UI surfaces are exposed and which permissions gate them, so
// duplicating those classes here would just be dead weight.
//
// `propertiesRepositoryProvider` and `ownersRepositoryProvider` are reused
// directly from `agent_providers.dart` (re-exported below) rather than
// redeclared, since they are simple `Provider`s keyed off the shared
// `dioProvider`.
export '../../../agent/presentation/providers/agent_providers.dart'
    show ownersRepositoryProvider, propertiesRepositoryProvider;

/// Separate paginated list state from the agent's `propertiesListProvider`,
/// so the manager property tab and the agent property tab each own their
/// own page/filter cursor (they can never be visible at once, since a user
/// only ever has one role, but keeping the state instances distinct avoids
/// any cross-module coupling).
final managerPropertiesListProvider =
    StateNotifierProvider<PropertiesListNotifier, AsyncValue<List<PropertyModel>>>((ref) {
  return PropertiesListNotifier(ref.watch(propertiesRepositoryProvider));
});

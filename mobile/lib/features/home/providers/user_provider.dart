import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../data/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(dioProvider), ref.watch(storageProvider));
});

final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  return ref.watch(userRepositoryProvider).getMe();
});

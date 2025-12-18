import 'package:chat_app/core/services/secure_storage_service.dart';
import 'package:chat_app/features/chats/data/repositories/chat_repository_impl.dart';
import 'package:chat_app/features/chats/domain/repositories/chat_repository.dart';
import 'package:chat_app/features/chats/domain/usecases/mark_as_read_use_case.dart';
import 'package:chat_app/features/chats/presentation/providers/chat_provider.dart';
import 'package:chat_app/features/home/data/repositrories/presence_repository_impl.dart';
import 'package:chat_app/features/home/domain/repositories/presence_repository.dart';
import 'package:chat_app/features/home/data/data_sources/users_remote_data_source.dart';
import 'package:chat_app/features/home/data/repositrories/user_repository_impl.dart';
import 'package:chat_app/features/home/domain/repositories/user_repository.dart';
import 'package:chat_app/features/home/domain/usecases/get_users_use_case.dart';
import 'package:chat_app/features/home/presentation/providers/users_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_me_use_case.dart';
import '../../features/auth/domain/usecases/login_use_case.dart';
import '../../features/auth/domain/usecases/register_use_case.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/providers/login_provider.dart';
import '../../features/auth/presentation/providers/register_provider.dart';
import '../../features/chats/data/data_sources/chat_remote_data_source.dart';
import '../../features/chats/domain/usecases/check_status_for_any_msg_use_case.dart';
import '../../features/chats/domain/usecases/get_message_history_use_case.dart';
import '../../features/chats/domain/usecases/get_message_update_use_case.dart';
import '../../features/chats/domain/usecases/send_message_use_case.dart';
import '../../features/home/data/data_sources/presence_remote_data_source.dart';
import '../../features/home/domain/usecases/get_users_status_use_case.dart';
import '../../features/home/domain/usecases/update_heartbeat_usecase.dart';
import '../../features/home/presentation/providers/presence_provider.dart';
import '../../features/settings/presentation/providers/profile_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 1. External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => SecureStorageService());

  // 2. Data Sources
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));
  sl.registerLazySingleton(() => UsersRemoteDataSource(sl()));
  sl.registerLazySingleton(() => PresenceRemoteDataSource(sl(), sl()));
  sl.registerLazySingleton(() => ChatRemoteDataSource(sl()));

  // 3. Repositories
  sl.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(remoteDataSource: sl(), secureStorageService: sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PresenceRepository>(
    () => PresenceRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );

  // 4. Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetMeUseCase(sl()));
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));
  sl.registerLazySingleton(() => UpdateHeartbeatUseCase(sl()));
  sl.registerLazySingleton(() => GetUsersStatusUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => GetMessageHistoryUseCase(sl()));
  sl.registerLazySingleton(() => GetMessageUpdatesUseCase(sl()));
  sl.registerLazySingleton(() => MarkAsReadUseCase(sl()));
  sl.registerLazySingleton(() => CheckStatusForAnyMsgUseCase(sl()));

  // 5. Providers
  sl.registerLazySingleton(() => ProfileProvider(sl()));

  sl.registerLazySingleton(() => LoginProvider(sl()));
  sl.registerLazySingleton(() => RegisterProvider(sl()));
  sl.registerLazySingleton(() => AuthProvider(sl(), sl(), sl()));
  sl.registerLazySingleton(() => UsersProvider(sl(), sl(), sl()));
  sl.registerLazySingleton(() => PresenceProvider(sl(), sl()));
  sl.registerLazySingleton(
    () => ChatProvider(sl(), sl(), sl(), sl(), sl(), sl()),
  );
}

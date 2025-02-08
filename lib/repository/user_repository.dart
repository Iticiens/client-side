import 'package:iot/generated/pocketbase/users_record.dart';
import 'package:iot/main.dart';

abstract class UserRepository {
  Future<UsersRecord> getCurrentUserDetails();
}

class UserRepositoryImpl implements UserRepository {
  @override
  Future<UsersRecord> getCurrentUserDetails() async {
    return UsersRecord.fromRecordModel(await pb
        .collection('users')
        .getOne(pb.authStore.model!.id, expand: "stations"));
  }
}

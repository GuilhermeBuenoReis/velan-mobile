import 'package:velan_mobile/Models/user.dart';
import 'package:velan_mobile/Services/profile_api.dart';

class ProfileRepository {
  ProfileRepository({ProfileApi? api}) : _api = api ?? ProfileApi();

  final ProfileApi _api;

  Future<User> fetchProfile() {
    return _api.fetchProfile();
  }

  Future<User> updateProfile(ProfilePayload payload) {
    return _api.updateProfile(payload);
  }
}

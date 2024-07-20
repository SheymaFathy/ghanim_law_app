part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final RequestState profileRequestState;
  final ProfileModel? profileModel;
  final String profileErorrMessage;
  final AuthRequestState profileUpdateRequestState;
  final ProfileModel? profileUpdateModel;
  final String profileUpdatErorreMessage;
  final bool checkValuesFormFiled;
  const ProfileState(
      {this.profileRequestState = RequestState.loading,
      this.profileModel,
      this.profileErorrMessage = '',
      this.profileUpdateRequestState = AuthRequestState.normal,
      this.profileUpdateModel,
      this.profileUpdatErorreMessage = '',
      this.checkValuesFormFiled = false});
  ProfileState copyWith(
      {RequestState? profileRequestState,
      ProfileModel? profileModel,
      String? profileErorrMessage,
      AuthRequestState? profileUpdateRequestState,
      ProfileModel? profileUpdateModel,
      String? profileUpdatErorreMessage,
      bool? checkValuesFormFiled}) {
    return ProfileState(
        profileRequestState: profileRequestState ?? this.profileRequestState,
        profileModel: profileModel ?? this.profileModel,
        profileErorrMessage: profileErorrMessage ?? this.profileErorrMessage,
        profileUpdateRequestState:
            profileUpdateRequestState ?? this.profileUpdateRequestState,
        profileUpdateModel: profileUpdateModel ?? this.profileUpdateModel,
        profileUpdatErorreMessage:
            profileUpdatErorreMessage ?? this.profileUpdatErorreMessage,
        checkValuesFormFiled:
            checkValuesFormFiled ?? this.checkValuesFormFiled);
  }

  @override
  List<Object?> get props => [
        profileRequestState,
        profileModel,
        profileErorrMessage,
        profileUpdateRequestState,
        profileUpdateModel,
        profileUpdatErorreMessage,
        checkValuesFormFiled
      ];
}
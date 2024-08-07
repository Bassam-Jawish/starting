import '../../domain/entities/user.dart';

class UserInfoModel extends UserInfoEntity {
  const UserInfoModel({
    String? accessToken,
    String? refreshToken,
    User? user,
  }) : super(
          accessToken: accessToken,
          refreshToken: refreshToken,
          userEntity: user,
        );

  factory UserInfoModel.fromJson(Map<String, dynamic> map) {
    return UserInfoModel(
      accessToken: map['accessToken'] ?? "",
      refreshToken: map['refreshToken'] ?? "",
      user: map['user'] != null ? User.fromJson(map['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': userEntity != null ? (userEntity as User).toJson() : null,
    };
  }
}

class User extends UserEntity {
  const User({
    int? userId,
    String? userName,
    String? name,
    String? email,
  }) : super(
          userId: userId,
          userName: userName,
          name: name,
          email: email,
        );

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      userId: map['id'] ?? "",
      userName: map['userName'] ?? "",
      name: map['name'] ?? "",
      email: map['email'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'userName': userName,
      'name': name,
      'email': email,
    };
  }
}

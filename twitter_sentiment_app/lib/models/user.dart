class UserModel {
  final String id;
  final String bannerImageUrl;
  final String profileImageUrl;
  final String name;
  final String email;

  UserModel(
      {this.id,
      this.name,
      this.profileImageUrl,
      this.bannerImageUrl,
      this.email});
}

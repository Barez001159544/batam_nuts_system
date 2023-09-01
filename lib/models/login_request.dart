class LoginRequest {
  late String username;
  late String password;

  LoginRequest(this.username, this.password);

  Map toJson() => {
    'username': username,
    'password': password,
  };
  // Map<String, dynamic> getJson(){
  //   return {
  //     'username':username,
  //     'password':password,
  //   };
  // }

}
bool checkEmail(String email) {
  final emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.[cC][oO][mM]$');

  if (emailRegex.hasMatch(email)) {
    return true;
  } else {
    return false;
  }
}

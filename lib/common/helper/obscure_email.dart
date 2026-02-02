String maskEmail(String email, {int maskLength = 5}) {
  final atIndex = email.indexOf('@');
  if (atIndex == -1) return email; // bukan email valid

  final localPart = email.substring(0, atIndex);
  final domainPart = email.substring(atIndex);

  if (localPart.length <= maskLength) {
    return '*' * localPart.length + domainPart;
  }

  final visiblePart = localPart.substring(0, localPart.length - maskLength);
  final maskedPart = '*' * maskLength;

  return visiblePart + maskedPart + domainPart;
}

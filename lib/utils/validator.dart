String? phoneValidator(String? value, String msg) {
  var emailReg = RegExp(r"^[1][3,4,5,7,8][0-9]{9}$");
  if (emailReg.hasMatch(value ?? "") != true) {
    return msg;
  } else {
    return null;
  }
}

String? numberValidator(String? value, String msg) {
  var emailReg = RegExp(r"^\d{1,}$");
  if (emailReg.hasMatch(value ?? "") != true) {
    return msg;
  } else {
    return null;
  }
}

String? decimalValidator(String? value, String msg) {
  var emailReg = RegExp(r"^(\-|\+)?\d+(\.\d+)?$");
  if (emailReg.hasMatch(value ?? "") != true) {
    return msg;
  } else {
    return null;
  }
}

String? regValidator(String? value, String reg, String msg) {
  var emailReg = RegExp(reg);
  if (emailReg.hasMatch(value ?? "") != true) {
    return msg;
  } else {
    return null;
  }
}

String? emptyValidator(String? value, String msg) {
  if (value == null) {
    return msg;
  } else if (value.isEmpty == true) {
    return msg;
  } else {
    return null;
  }
}

String? nullValidator(Object? value, String msg) {
  if (value == null) {
    return msg;
  } else {
    return null;
  }
}

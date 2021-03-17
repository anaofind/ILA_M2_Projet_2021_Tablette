enum Role {
  Operator,
  Intervener
}

class RoleConverter {
  static Role get(String role) {
    if (role == 'Role.Operator') {
      return Role.Operator;
    }
    return Role.Intervener;
  }
}


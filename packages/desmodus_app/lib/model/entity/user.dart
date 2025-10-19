class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? dni;
  final String? avatarUrl;
  final String? distritoId;
  final String? documentType;
  final String? address;
  final String? centroPoblado;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.dni,
    this.avatarUrl,
    this.distritoId,
    this.documentType,
    this.address,
    this.centroPoblado,
  });

  factory User.anonymous() {
    return User(
      id: 0,
      name: 'Anónimo',
      email: '',
      phone: '',
      dni: '',
      avatarUrl: null,
      distritoId: null,
      documentType: null,
      address: null,
      centroPoblado: null,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      dni: json['dni'],
      distritoId: json['distritoId'],
      avatarUrl: json['avatarUrl'],
      documentType: json['documentType'],
      address: json['address'],
      centroPoblado: json['centroPoblado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'dni': dni,
      'distritoId': distritoId,
      'avatarUrl': avatarUrl,
      'documentType': documentType,
      'address': address,
      'centroPoblado': centroPoblado,
    };
  }

  bool isComplete() {
    return name.isNotEmpty &&
        email.isNotEmpty &&
        phone != null &&
        phone!.isNotEmpty &&
        dni != null &&
        dni!.isNotEmpty &&
        distritoId != null &&
        distritoId!.isNotEmpty;
  }
}

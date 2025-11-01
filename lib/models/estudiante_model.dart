class EstudianteModel {
  final int? id;
  final String nombre;
  final String? cedula;
  final String? correo;
  final String? telefono;
  final String carrera;
  final int semestre;
  final String estado;
  final String? fechaRegistro;

  EstudianteModel({
    this.id,
    required this.nombre,
    this.cedula,
    this.correo,
    this.telefono,
    required this.carrera,
    required this.semestre,
    this.estado = 'Activo',
    this.fechaRegistro,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'cedula': cedula,
    'correo': correo,
    'telefono': telefono,
    'carrera': carrera,
    'semestre': semestre,
    'estado': estado,
    'fecha_registro': fechaRegistro,
  };

  factory EstudianteModel.fromMap(Map<String, dynamic> map) => EstudianteModel(
    id: map['id'],
    nombre: map['nombre'],
    cedula: map['cedula'],
    correo: map['correo'],
    telefono: map['telefono'],
    carrera: map['carrera'],
    semestre: map['semestre'],
    estado: map['estado'] ?? 'Activo',
    fechaRegistro: map['fecha_registro'],
  );
}

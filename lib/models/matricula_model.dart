class MatriculaModel {
  final int? id;
  final int estudianteId;
  final String periodo;
  final int semestre;
  final String paralelo;
  final int? creditos;
  final String? observaciones;
  final String? fechaMatricula;

  MatriculaModel({
    this.id,
    required this.estudianteId,
    required this.periodo,
    required this.semestre,
    required this.paralelo,
    this.creditos,
    this.observaciones,
    this.fechaMatricula,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'estudiante_id': estudianteId,
    'periodo': periodo,
    'semestre': semestre,
    'paralelo': paralelo,
    'creditos': creditos,
    'observaciones': observaciones,
    'fecha_matricula': fechaMatricula,
  };

  factory MatriculaModel.fromMap(Map<String, dynamic> map) => MatriculaModel(
    id: map['id'],
    estudianteId: map['estudiante_id'],
    periodo: map['periodo'],
    semestre: map['semestre'],
    paralelo: map['paralelo'],
    creditos: map['creditos'],
    observaciones: map['observaciones'],
    fechaMatricula: map['fecha_matricula'],
  );
}

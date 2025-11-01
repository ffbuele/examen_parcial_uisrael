import 'package:buele_francis_7a_app/database/database_helper.dart';
import 'package:buele_francis_7a_app/models/estudiante_model.dart';

class EstudianteDao {
  final database = DatabaseHelper.instance.db;

  Future<List<EstudianteModel>> readAll() async {
    final data = await database.query(
      'estudiantes',
      orderBy: 'nombre COLLATE NOCASE ASC',
    );
    return data.map((e) => EstudianteModel.fromMap(e)).toList();
  }

  Future<int> insert(EstudianteModel estudiante) async {
    return await database.insert('estudiantes', estudiante.toMap());
  }

  Future<void> update(EstudianteModel estudiante) async {
    await database.update(
      'estudiantes',
      estudiante.toMap(),
      where: 'id = ?',
      whereArgs: [estudiante.id],
    );
  }

  Future<void> delete(EstudianteModel estudiante) async {
    await database.delete(
      'estudiantes',
      where: 'id = ?',
      whereArgs: [estudiante.id],
    );
  }

  Future<EstudianteModel?> findByCedula(String cedula) async {
    final data = await database.query(
      'estudiantes',
      where: 'cedula = ?',
      whereArgs: [cedula],
    );
    if (data.isNotEmpty) return EstudianteModel.fromMap(data.first);
    return null;
  }
}

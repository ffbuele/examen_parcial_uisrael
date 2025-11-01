import 'package:buele_francis_7a_app/database/database_helper.dart';
import 'package:buele_francis_7a_app/models/matricula_model.dart';

class MatriculaDao {
  final database = DatabaseHelper.instance.db;

  Future<List<MatriculaModel>> readAll() async {
    final data = await database.query(
      'matriculas',
      orderBy: 'fecha_matricula DESC',
    );
    return data.map((e) => MatriculaModel.fromMap(e)).toList();
  }

  Future<List<MatriculaModel>> readByEstudiante(int estudianteId) async {
    final data = await database.query(
      'matriculas',
      where: 'estudiante_id = ?',
      whereArgs: [estudianteId],
      orderBy: 'periodo DESC',
    );
    return data.map((e) => MatriculaModel.fromMap(e)).toList();
  }

  Future<int> insert(MatriculaModel matricula) async {
    return await database.insert('matriculas', matricula.toMap());
  }

  Future<void> update(MatriculaModel matricula) async {
    await database.update(
      'matriculas',
      matricula.toMap(),
      where: 'id = ?',
      whereArgs: [matricula.id],
    );
  }

  Future<void> delete(MatriculaModel matricula) async {
    await database.delete(
      'matriculas',
      where: 'id = ?',
      whereArgs: [matricula.id],
    );
  }
}

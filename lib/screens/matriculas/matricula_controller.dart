import 'package:flutter/material.dart';
import 'package:buele_francis_7a_app/database/matricula_dao.dart';
import 'package:buele_francis_7a_app/models/matricula_model.dart';

class MatriculaController {
  final int estudianteId;
  final _dao = MatriculaDao();

  final ValueNotifier<List<MatriculaModel>> matriculas = ValueNotifier([]);

  MatriculaController({required this.estudianteId});

  Future<void> loadMatriculas() async {
    final data = await _dao.readByEstudiante(estudianteId);
    matriculas.value = data;
  }

  Future<void> deleteMatricula(MatriculaModel matricula) async {
    await _dao.delete(matricula);
    await loadMatriculas();
  }
}

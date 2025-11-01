import 'package:flutter/material.dart';
import 'package:buele_francis_7a_app/database/estudiante_dao.dart';
import 'package:buele_francis_7a_app/models/estudiante_model.dart';

class EstudianteController {
  final _dao = EstudianteDao();
  final ValueNotifier<List<EstudianteModel>> estudiantes = ValueNotifier([]);

  Future<void> loadEstudiantes() async {
    final data = await _dao.readAll();
    estudiantes.value = data;
  }

  Future<void> addEstudiante(EstudianteModel estudiante) async {
    await _dao.insert(estudiante);
    await loadEstudiantes();
  }

  Future<void> deleteEstudiante(EstudianteModel estudiante) async {
    await _dao.delete(estudiante);
    await loadEstudiantes();
  }
}

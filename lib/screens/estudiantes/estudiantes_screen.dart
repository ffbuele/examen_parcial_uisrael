import 'package:buele_francis_7a_app/screens/matriculas/matriculas_screen.dart';
import 'package:buele_francis_7a_app/widgets/estudiantes/estudiante_form_dialog.dart';
import 'package:buele_francis_7a_app/widgets/estudiantes/estudiante_list.dart';
import 'package:flutter/material.dart';
import 'package:buele_francis_7a_app/models/estudiante_model.dart';
import 'package:buele_francis_7a_app/screens/estudiantes/estudiante_controller.dart';

class EstudiantesScreen extends StatefulWidget {
  const EstudiantesScreen({super.key});

  @override
  State<EstudiantesScreen> createState() => _EstudiantesScreenState();
}

class _EstudiantesScreenState extends State<EstudiantesScreen> {
  final controller = EstudianteController();

  @override
  void initState() {
    super.initState();
    controller.loadEstudiantes();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Estudiantes'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (_) => const EstudianteFormDialog(),
          );
          if (result == true) {
            controller.loadEstudiantes();
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<List<EstudianteModel>>(
          valueListenable: controller.estudiantes,
          builder: (_, estudiantes, __) {
            if (estudiantes.isEmpty) {
              return const Center(
                child: Text(
                  'No hay estudiantes registrados',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }
            return EstudianteList(
              estudiantes: estudiantes,
              onDelete: (e) async {
                await controller.deleteEstudiante(e);
                setState(() {});
              },
              onMatricular: (e) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MatriculasScreen(estudiante: e),
                  ),
                );
              },
              onReload: () {
                controller.loadEstudiantes();
                setState(() {});
              },
            );
          },
        ),
      ),
    );
  }
}

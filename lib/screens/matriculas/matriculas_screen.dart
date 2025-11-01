import 'package:flutter/material.dart';
import 'package:buele_francis_7a_app/models/estudiante_model.dart';
import 'package:buele_francis_7a_app/models/matricula_model.dart';
import 'package:buele_francis_7a_app/screens/matriculas/matricula_controller.dart';
import 'package:buele_francis_7a_app/widgets/matriculas/matricula_form_dialog.dart';
import 'package:buele_francis_7a_app/widgets/matriculas/matricula_list.dart';

class MatriculasScreen extends StatefulWidget {
  final EstudianteModel estudiante;

  const MatriculasScreen({super.key, required this.estudiante});

  @override
  State<MatriculasScreen> createState() => _MatriculasScreenState();
}

class _MatriculasScreenState extends State<MatriculasScreen> {
  late final MatriculaController controller;

  @override
  void initState() {
    super.initState();
    controller = MatriculaController(estudianteId: widget.estudiante.id!);
    controller.loadMatriculas();
  }

  void _openFormDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => MatriculaFormDialog(estudianteId: widget.estudiante.id!),
    );

    if (result == true) {
      controller.loadMatriculas();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Matrículas de ${widget.estudiante.nombre}'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: _openFormDialog,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<List<MatriculaModel>>(
          valueListenable: controller.matriculas,
          builder: (_, matriculas, __) {
            if (matriculas.isEmpty) {
              return const Center(
                child: Text(
                  'No hay matrículas registradas',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            }
            return MatriculaList(
              matriculas: matriculas,
              onDelete: (m) async {
                await controller.deleteMatricula(m);
                setState(() {});
              },
              onReload: () {
                controller.loadMatriculas();
                setState(() {});
              },
            );
          },
        ),
      ),
    );
  }
}

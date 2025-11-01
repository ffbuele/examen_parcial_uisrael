import 'package:flutter/material.dart';
import 'package:buele_francis_7a_app/models/estudiante_model.dart';
import 'package:buele_francis_7a_app/widgets/estudiantes/estudiante_form_dialog.dart';

class EstudianteList extends StatelessWidget {
  final List<EstudianteModel> estudiantes;
  final Function(EstudianteModel) onDelete;
  final Function(EstudianteModel) onMatricular;
  final Function()? onReload;

  const EstudianteList({
    super.key,
    required this.estudiantes,
    required this.onDelete,
    required this.onMatricular,
    this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: estudiantes.length,
      itemBuilder: (context, index) {
        final e = estudiantes[index];

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              radius: 26,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              e.nombre,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${e.carrera}'),
                if (e.correo != null && e.correo!.isNotEmpty)
                  Text(e.correo!, style: const TextStyle(fontSize: 13)),
                Text('Semestre actual: ${e.semestre}'),
                const SizedBox(height: 2),
                Text(
                  'Estado: ${e.estado}',
                  style: TextStyle(
                    color: e.estado == 'Activo'
                        ? Colors.green[700]
                        : Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            onTap: () async {
              // 👁️ Ver detalles
              await showDialog(
                context: context,
                builder: (_) =>
                    EstudianteFormDialog(estudiante: e, readOnly: true),
              );
            },
            trailing: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onSelected: (value) async {
                switch (value) {
                  case 'ver':
                    await showDialog(
                      context: context,
                      builder: (_) =>
                          EstudianteFormDialog(estudiante: e, readOnly: true),
                    );
                    break;
                  case 'editar':
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (_) => EstudianteFormDialog(estudiante: e),
                    );
                    if (result == true && onReload != null) onReload!();
                    break;
                  case 'matricular':
                    onMatricular(e);
                    break;
                  case 'eliminar':
                    onDelete(e);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'ver',
                  child: ListTile(
                    leading: Icon(Icons.visibility_outlined),
                    title: Text('Ver detalles'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'editar',
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text('Editar'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'matricular',
                  child: ListTile(
                    leading: Icon(Icons.school_outlined),
                    title: Text('Matricular'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'eliminar',
                  child: ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    title: Text('Eliminar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

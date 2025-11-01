import 'package:flutter/material.dart';
import 'package:buele_francis_7a_app/models/matricula_model.dart';
import 'package:buele_francis_7a_app/widgets/matriculas/matricula_form_dialog.dart';

class MatriculaList extends StatelessWidget {
  final List<MatriculaModel> matriculas;
  final Function(MatriculaModel) onDelete;
  final Function()? onReload;

  const MatriculaList({
    super.key,
    required this.matriculas,
    required this.onDelete,
    this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (matriculas.isEmpty) {
      return const Center(
        child: Text(
          'No hay matrículas registradas',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      itemCount: matriculas.length,
      itemBuilder: (context, index) {
        final m = matriculas[index];

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
              child: const Icon(Icons.assignment, color: Colors.white),
            ),
            title: Text(
              'Período: ${m.periodo}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Semestre: ${m.semestre}  •  Paralelo: ${m.paralelo}'),
                if (m.creditos != null)
                  Text(
                    'Créditos: ${m.creditos}',
                    style: const TextStyle(fontSize: 13),
                  ),
                if (m.observaciones != null && m.observaciones!.isNotEmpty)
                  Text(
                    'Notas: ${m.observaciones}',
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                Text(
                  'Fecha: ${m.fechaMatricula ?? '-'}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            onTap: () async {
              // 👁️ Ver detalles
              await showDialog(
                context: context,
                builder: (_) =>
                    MatriculaFormDialog(matricula: m, readOnly: true),
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
                          MatriculaFormDialog(matricula: m, readOnly: true),
                    );
                    break;
                  case 'editar':
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (_) => MatriculaFormDialog(matricula: m),
                    );
                    if (result == true && onReload != null) onReload!();
                    break;
                  case 'eliminar':
                    onDelete(m);
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

import 'package:flutter/material.dart';
import 'package:buele_francis_7a_app/database/matricula_dao.dart';
import 'package:buele_francis_7a_app/models/matricula_model.dart';

class MatriculaFormDialog extends StatefulWidget {
  final int? estudianteId; // para nueva matrícula
  final MatriculaModel? matricula; // para editar o ver
  final bool readOnly;

  const MatriculaFormDialog({
    super.key,
    this.estudianteId,
    this.matricula,
    this.readOnly = false,
  });

  @override
  State<MatriculaFormDialog> createState() => _MatriculaFormDialogState();
}

class _MatriculaFormDialogState extends State<MatriculaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dao = MatriculaDao();

  late final TextEditingController _periodoCtrl;
  late final TextEditingController _semestreCtrl;
  late final TextEditingController _paraleloCtrl;
  late final TextEditingController _creditosCtrl;
  late final TextEditingController _observacionesCtrl;

  @override
  void initState() {
    super.initState();
    final m = widget.matricula;
    _periodoCtrl = TextEditingController(text: m?.periodo ?? '');
    _semestreCtrl = TextEditingController(
      text: m?.semestre != null ? m!.semestre.toString() : '',
    );
    _paraleloCtrl = TextEditingController(text: m?.paralelo ?? '');
    _creditosCtrl = TextEditingController(
      text: m?.creditos != null ? m!.creditos.toString() : '',
    );
    _observacionesCtrl = TextEditingController(text: m?.observaciones ?? '');
  }

  @override
  void dispose() {
    _periodoCtrl.dispose();
    _semestreCtrl.dispose();
    _paraleloCtrl.dispose();
    _creditosCtrl.dispose();
    _observacionesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.matricula != null;
    final readOnly = widget.readOnly;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        readOnly
            ? 'Detalles de Matrícula'
            : (isEditing ? 'Editar Matrícula' : 'Nueva Matrícula'),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildField(
                  _periodoCtrl,
                  'Período académico',
                  readOnly,
                  required: true,
                  hint: 'Ejemplo: 2025-A o 2024-B',
                ),
                _buildField(
                  _semestreCtrl,
                  'Semestre (1–10)',
                  readOnly,
                  keyboard: TextInputType.number,
                  required: true,
                  hint: 'Campo obligatorio — Ingrese un número entre 1 y 10',
                ),
                _buildField(
                  _paraleloCtrl,
                  'Paralelo',
                  readOnly,
                  required: true,
                  hint: 'Ejemplo: A, B o C',
                ),
                _buildField(
                  _creditosCtrl,
                  'Créditos totales',
                  readOnly,
                  keyboard: TextInputType.number,
                  hint: 'Campo opcional — Ej: 30 créditos',
                ),
                _buildField(
                  _observacionesCtrl,
                  'Observaciones',
                  readOnly,
                  keyboard: TextInputType.multiline,
                  hint: 'Campo opcional — Notas adicionales o comentarios',
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cerrar'),
          onPressed: () => Navigator.pop(context, false),
        ),
        if (!readOnly)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(isEditing ? 'Actualizar' : 'Guardar'),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              final matricula = MatriculaModel(
                id: widget.matricula?.id,
                estudianteId:
                    widget.estudianteId ?? widget.matricula!.estudianteId,
                periodo: _periodoCtrl.text.trim(),
                semestre: int.tryParse(_semestreCtrl.text.trim()) ?? 1,
                paralelo: _paraleloCtrl.text.trim(),
                creditos: _creditosCtrl.text.trim().isEmpty
                    ? null
                    : int.tryParse(_creditosCtrl.text.trim()),
                observaciones: _observacionesCtrl.text.trim().isEmpty
                    ? null
                    : _observacionesCtrl.text.trim(),
              );

              if (isEditing) {
                await _dao.update(matricula);
              } else {
                await _dao.insert(matricula);
              }

              if (context.mounted) Navigator.pop(context, true);
            },
          ),
      ],
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    bool readOnly, {
    bool required = false,
    TextInputType? keyboard,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: ctrl,
        readOnly: readOnly,
        keyboardType: keyboard,
        validator: (v) {
          if (readOnly) return null;
          if (required && (v == null || v.trim().isEmpty)) {
            return 'Campo obligatorio';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        maxLines: keyboard == TextInputType.multiline ? 3 : 1,
      ),
    );
  }
}

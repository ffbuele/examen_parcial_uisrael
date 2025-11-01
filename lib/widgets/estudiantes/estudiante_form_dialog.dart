import 'package:flutter/material.dart';
import 'package:buele_francis_7a_app/database/estudiante_dao.dart';
import 'package:buele_francis_7a_app/models/estudiante_model.dart';

class EstudianteFormDialog extends StatefulWidget {
  final EstudianteModel? estudiante;
  final bool readOnly;

  const EstudianteFormDialog({
    super.key,
    this.estudiante,
    this.readOnly = false,
  });

  @override
  State<EstudianteFormDialog> createState() => _EstudianteFormDialogState();
}

class _EstudianteFormDialogState extends State<EstudianteFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dao = EstudianteDao();

  late final TextEditingController _nombreCtrl;
  late final TextEditingController _cedulaCtrl;
  late final TextEditingController _correoCtrl;
  late final TextEditingController _telefonoCtrl;
  late final TextEditingController _carreraCtrl;
  late final TextEditingController _semestreCtrl;
  late final TextEditingController _estadoCtrl;

  @override
  void initState() {
    super.initState();
    final e = widget.estudiante;
    _nombreCtrl = TextEditingController(text: e?.nombre ?? '');
    _cedulaCtrl = TextEditingController(text: e?.cedula ?? '');
    _correoCtrl = TextEditingController(text: e?.correo ?? '');
    _telefonoCtrl = TextEditingController(text: e?.telefono ?? '');
    _carreraCtrl = TextEditingController(text: e?.carrera ?? '');
    _semestreCtrl = TextEditingController(
      text: e?.semestre != null ? e!.semestre.toString() : '',
    );
    _estadoCtrl = TextEditingController(text: e?.estado ?? 'Activo');
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _cedulaCtrl.dispose();
    _correoCtrl.dispose();
    _telefonoCtrl.dispose();
    _carreraCtrl.dispose();
    _semestreCtrl.dispose();
    _estadoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.estudiante != null;
    final readOnly = widget.readOnly;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        readOnly
            ? 'Detalles del Estudiante'
            : (isEditing ? 'Editar Estudiante' : 'Nuevo Estudiante'),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildField(
                  _nombreCtrl,
                  'Nombre completo',
                  readOnly,
                  required: true,
                  hint: 'Ej: María López Pérez',
                ),
                _buildField(
                  _cedulaCtrl,
                  'Cédula',
                  readOnly,
                  keyboard: TextInputType.number,
                  hint: 'Campo opcional — 10 dígitos numéricos',
                ),
                _buildField(
                  _correoCtrl,
                  'Correo electrónico',
                  readOnly,
                  keyboard: TextInputType.emailAddress,
                  hint: 'Campo opcional — Ej: usuario@correo.com',
                ),
                _buildField(
                  _telefonoCtrl,
                  'Teléfono',
                  readOnly,
                  keyboard: TextInputType.phone,
                  hint: 'Campo opcional — Ej: 0987654321',
                ),
                _buildField(
                  _carreraCtrl,
                  'Carrera',
                  readOnly,
                  required: true,
                  hint: 'Ej: Ingeniería en Sistemas',
                ),
                _buildField(
                  _semestreCtrl,
                  'Semestre actual (1–10)',
                  readOnly,
                  keyboard: TextInputType.number,
                  required: true,
                  hint: 'Campo obligatorio — Ingrese un número entre 1 y 10',
                ),
                _buildField(
                  _estadoCtrl,
                  'Estado (Activo, Inactivo, Graduado)',
                  readOnly,
                  hint: 'Campo opcional — Valor por defecto: Activo',
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

              final estudiante = EstudianteModel(
                id: widget.estudiante?.id,
                nombre: _nombreCtrl.text.trim(),
                cedula: _cedulaCtrl.text.trim().isEmpty
                    ? null
                    : _cedulaCtrl.text.trim(),
                correo: _correoCtrl.text.trim().isEmpty
                    ? null
                    : _correoCtrl.text.trim(),
                telefono: _telefonoCtrl.text.trim().isEmpty
                    ? null
                    : _telefonoCtrl.text.trim(),
                carrera: _carreraCtrl.text.trim(),
                semestre: int.tryParse(_semestreCtrl.text.trim()) ?? 1,
                estado: _estadoCtrl.text.trim().isEmpty
                    ? 'Activo'
                    : _estadoCtrl.text.trim(),
              );

              if (isEditing) {
                await _dao.update(estudiante);
              } else {
                await _dao.insert(estudiante);
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
          return null; // validaciones ligeras
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
      ),
    );
  }
}

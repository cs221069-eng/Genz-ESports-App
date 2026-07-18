import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utiles/widgets/glass/glass_kit.dart';
import '../../../utiles/widgets/neumorphic/neumorphic_button.dart';
import '../../../utiles/widgets/neumorphic/neumorphic_container.dart';
import '../services/tournament_service.dart';

/// Screen that allows administrators to add a new tournament entry.
/// Utilizes global premium Glassmorphic input fields and buttons.
class AddTournamentScreen extends StatefulWidget {
  const AddTournamentScreen({super.key});

  @override
  State<AddTournamentScreen> createState() => _AddTournamentScreenState();
}

class _AddTournamentScreenState extends State<AddTournamentScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text input fields
  final _titleController = TextEditingController();
  final _scheduleController = TextEditingController();
  final _prizeController = TextEditingController();
  final _attendanceController = TextEditingController();
  final _streamUrlController = TextEditingController();
  final _actionTextController = TextEditingController(text: 'Register');

  String _game = 'FC26';             // Holds selected game value
  String _status = 'Upcoming';       // Holds selected status value
  File? _imageFile;                  // Holds picked background image file
  bool _isSubmitting = false;        // Indicates api submission status
  String? _errorMessage;             // Error display string

  @override
  void dispose() {
    // Release controller resources on pop
    _titleController.dispose();
    _scheduleController.dispose();
    _prizeController.dispose();
    _attendanceController.dispose();
    _streamUrlController.dispose();
    _actionTextController.dispose();
    super.dispose();
  }

  /// Picks background image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (result != null) {
      setState(() {
        _imageFile = File(result.path);
      });
    }
  }

  /// Triggers validation and calls backend service to create the tournament
  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await TournamentService.instance.createTournament(
        title: _titleController.text.trim(),
        game: _game,
        status: _status,
        schedule: _scheduleController.text.trim(),
        prize: _prizeController.text.trim(),
        attendance: _attendanceController.text.trim(),
        streamUrl: _streamUrlController.text.trim(),
        actionText: _actionTextController.text.trim(),
        imageFile: _imageFile,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tournament'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GlassBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildImagePicker(context),
                  const SizedBox(height: 20),
                  
                  // Title Input Field
                  GlassTextField(
                    controller: _titleController,
                    label: 'Tournament Title',
                    hintText: 'Enter event title',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Game Dropdown Selection
                  _buildDropdownField(
                    label: 'Game',
                    value: _game,
                    options: const ['FC26', 'Tekken 8', 'Valorant', 'PUBG', 'Free Fire'],
                    onChanged: (value) {
                      setState(() {
                        _game = value;
                      });
                    },
                  ),
                  const SizedBox(height: 14),

                  // Status Dropdown Selection
                  _buildDropdownField(
                    label: 'Status',
                    value: _status,
                    options: const ['Upcoming', 'Live', 'Completed'],
                    onChanged: (value) {
                      setState(() {
                        _status = value;
                      });
                    },
                  ),
                  const SizedBox(height: 14),

                  // Schedule Input Field
                  GlassTextField(
                    controller: _scheduleController,
                    label: 'Schedule',
                    hintText: '2026-10-15 18:00',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Schedule is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Prize Input Field
                  GlassTextField(
                    controller: _prizeController,
                    label: 'Prize',
                    hintText: 'e.g. \$2,500',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Prize is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Attendance Input Field
                  GlassTextField(
                    controller: _attendanceController,
                    label: 'Attendance',
                    hintText: '48 / 64 Players',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Attendance is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Stream URL Input Field
                  GlassTextField(
                    controller: _streamUrlController,
                    label: 'Stream URL',
                    hintText: 'https://youtube.com/...',
                  ),
                  const SizedBox(height: 14),

                  // Action Button Text Input Field
                  GlassTextField(
                    controller: _actionTextController,
                    label: 'Action Text',
                    hintText: 'Register / Join Now',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Action text is required';
                      }
                      return null;
                    },
                  ),

                  // Submission error feedback
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 18),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                    ),
                  ],
                  const SizedBox(height: 28),

                  // Submit Button
                  NeumorphicButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Save Tournament'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the visual image picker container for background image select
  Widget _buildImagePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Tournament Background',
          style: TextStyle(
            color: Color(0xFFA6C9EA),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        NeumorphicContainer(
          borderRadius: 18,
          padding: EdgeInsets.zero,
          child: InkWell(
            onTap: _pickImage,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                image: _imageFile != null
                    ? DecorationImage(
                        image: FileImage(_imageFile!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _imageFile == null
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.photo_library_outlined, size: 36, color: Color(0xFF6B91B5)),
                          SizedBox(height: 10),
                          Text(
                            'Pick background image',
                            style: TextStyle(color: Color(0xFFA6C9EA)),
                          ),
                        ],
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a customized drop down selection input
  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFA6C9EA),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: DropdownButtonFormField<String>(
              initialValue: value,
              dropdownColor: const Color(0xFF0B2559),
              style: const TextStyle(color: Color(0xFFECF7FF), fontSize: 15),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0x1217B7FF),
              ),
              items: options
                  .map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

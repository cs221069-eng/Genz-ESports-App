import 'dart:ui';
import 'package:flutter/material.dart';
import 'neumorphic/neumorphic_container.dart';
import 'neumorphic/neumorphic_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/* ---------------- ENTRY ---------------- */

Future<void> showParticipationFormBottomSheet(
    BuildContext context, {
      required String eventTitle,
      String? suggestedGameTitle,
    }) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return _ParticipationFormSheet(
        eventTitle: eventTitle,
        suggestedGameTitle: suggestedGameTitle ?? _inferGameTitle(eventTitle),
      );
    },
  );
}

String _inferGameTitle(String eventTitle) {
  final title = eventTitle.toLowerCase();
  if (title.contains('tekken')) return 'Tekken 8';
  return 'FC26';
}

/* ---------------- PAYMENT SHEET ---------------- */

Future<void> _showPaymentSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return const _PaymentSheet();
    },
  );
}

class _PaymentSheet extends StatelessWidget {
  const _PaymentSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        12,
        12,
        MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: NeumorphicContainer(
        borderRadius: 28,
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Details',
                style: TextStyle(
                  color: Color(0xFFECF7FF),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),

              _row("Name", "Muhammad Fardan Mohsin"),
              _row("Account Number", "2678346203949"),
              _row("IBAN Number", "PK93UNIL0109000346203949"),
              _row("Bank", "UBL"),

              const SizedBox(height: 16),

              const Text(
                "Send payment & screenshot on WhatsApp:",
                style: TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 8),

              const Text(
                "0334 2862602",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "After payment, send screenshot to confirm order.",
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 25),


              NeumorphicButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String t, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t,
            style: const TextStyle(
              color: Color(0xFFA6C9EA),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            v,
            style: const TextStyle(
              color: Color(0xFFECF7FF),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------- FORM ---------------- */

class _ParticipationFormSheet extends StatefulWidget {
  const _ParticipationFormSheet({
    required this.eventTitle,
    required this.suggestedGameTitle,
  });

  final String eventTitle;
  final String suggestedGameTitle;

  @override
  State<_ParticipationFormSheet> createState() =>
      _ParticipationFormSheetState();
}

class _ParticipationFormSheetState extends State<_ParticipationFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  final _fullNameController = TextEditingController();
  final _ignController = TextEditingController();
  final _whatsAppController = TextEditingController();

  final _fullNameFocusNode = FocusNode();
  final _ignFocusNode = FocusNode();
  final _whatsAppFocusNode = FocusNode();

  late String _gameTitle = widget.suggestedGameTitle;
  String _participationType = 'Solo';

  bool _isLoading = false;

  final String baseUrl = "https://final-year-backend-pi.vercel.app";

  @override
  void initState() {
    super.initState();
    _fullNameFocusNode.addListener(_handleFocusChange);
    _ignFocusNode.addListener(_handleFocusChange);
    _whatsAppFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fullNameFocusNode.dispose();
    _ignFocusNode.dispose();
    _whatsAppFocusNode.dispose();
    _fullNameController.dispose();
    _ignController.dispose();
    _whatsAppController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!mounted) return;

    FocusNode? activeNode;
    if (_fullNameFocusNode.hasFocus) {
      activeNode = _fullNameFocusNode;
    } else if (_ignFocusNode.hasFocus) {
      activeNode = _ignFocusNode;
    } else if (_whatsAppFocusNode.hasFocus) {
      activeNode = _whatsAppFocusNode;
    }

    if (activeNode == null || activeNode.context == null) return;

    Future.delayed(const Duration(milliseconds: 120), () {
      if (!mounted || !activeNode!.hasFocus) return;

      Scrollable.ensureVisible(
        activeNode.context!,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        alignment: 0.1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: EdgeInsets.fromLTRB(
        12,
        12,
        12,
        MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: NeumorphicContainer(
        borderRadius: 28,
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 18),

                  _field(
                    _fullNameController,
                    "Full Name",
                    focusNode: _fullNameFocusNode,
                  ),
                  _field(
                    _ignController,
                    "IGN",
                    focusNode: _ignFocusNode,
                  ),
                  _field(
                    _whatsAppController,
                    "WhatsApp Number",
                    type: TextInputType.phone,
                    focusNode: _whatsAppFocusNode,
                  ),

                  const SizedBox(height: 22),

                  NeumorphicButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    TextInputType? type,
    FocusNode? focusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        focusNode: focusNode,
        keyboardType: type,
        validator: (v) =>
            v == null || v.trim().isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0x1217B7FF),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      "fullName": _fullNameController.text.trim(),
      "ign": _ignController.text.trim(),
      "whatsapp": _whatsAppController.text.trim(),
      "gameTitle": _gameTitle,
      "participationType": _participationType,
      "eventTitle": widget.eventTitle,
    };

    try {
      final url = "$baseUrl/api/tournamentsForm/submit";

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).pop();
        Future.delayed(const Duration(milliseconds: 200), () {
          _showPaymentSheet(context);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.body}")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
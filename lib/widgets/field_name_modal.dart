import 'package:flutter/material.dart';

Future<String?> showFieldNameModal(BuildContext context, {bool isFirst = false}) {
  final controller = TextEditingController();

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isFirst ? "Nom de votre premier champ" : "Nom du nouveau champ",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: "Nom du champ",
                      hintText: isFirst
                          ? "Ex : Mon premier champ 🌾"
                          : "Ex : Plantations du Nord",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      final name = controller.text.trim();
                      Navigator.of(context).pop(name.isNotEmpty ? name : null);
                    },
                    child: const Text("Valider"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

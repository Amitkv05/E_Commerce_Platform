import 'package:flutter/material.dart';
import 'package:web_admin_for_fullstack/controllers/subcategory_controller.dart';
import 'package:web_admin_for_fullstack/models/subcategory.dart';

class SubcategoryWidget extends StatefulWidget {
  const SubcategoryWidget({super.key});

  @override
  State<SubcategoryWidget> createState() => _SubcategoryWidgetState();
}

class _SubcategoryWidgetState extends State<SubcategoryWidget> {
  final SubcategoryController controller = SubcategoryController();
  late Future<List<Subcategory>> _futureSubcategories;

  @override
  void initState() {
    super.initState();
    _futureSubcategories = controller.loadSubcategories();
  }

  void refreshList() {
    setState(() {
      _futureSubcategories = controller.loadSubcategories();
    });
  }

  void showRenameDialog(Subcategory subcategory) {
    TextEditingController nameController =
        TextEditingController(text: subcategory.subCategoryName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Rename Subcategory'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'New name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
              onPressed: () async {
                await controller.renameSubcategory(
                    subcategory.id, nameController.text, context);
                Navigator.pop(context);
                refreshList();
              },
              child: Text('Save'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Subcategory>>(
      future: _futureSubcategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No Subcategories Found"));
        } else {
          // Group by category
          Map<String, List<Subcategory>> grouped = {};
          for (var sub in snapshot.data!) {
            grouped.putIfAbsent(sub.categoryName, () => []).add(sub);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: grouped.entries.map((entry) {
              return ExpansionTile(
                title: Text(
                  entry.key,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                children: entry.value.map((sub) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(sub.image),
                    ),
                    title: Text(sub.subCategoryName),
                    trailing: Wrap(
                      spacing: 10,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => showRenameDialog(sub),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await controller.deleteSubcategory(sub.id, context);
                            refreshList();
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          );
        }
      },
    );
  }
}

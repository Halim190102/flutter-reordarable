import 'package:bloc_test/data/models/item_models.dart';
import 'package:bloc_test/presentation/bloc/item_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemFormPage extends StatefulWidget {
  final bool isEditing;
  final ItemModel? item;

  const ItemFormPage({
    super.key,
    required this.isEditing,
    this.item,
  });

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.item != null) {
      name.text = widget.item!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemBloc = context.read<ItemBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Item' : 'Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final item = ItemModel(
                      id: widget.isEditing
                          ? widget.item!.id
                          : DateTime.now().millisecondsSinceEpoch,
                      name: name.text,
                    );
                    if (widget.isEditing) {
                      itemBloc.add(UpdateItemEvent(item));
                    } else {
                      itemBloc.add(AddItemEvent(item));
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.isEditing ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

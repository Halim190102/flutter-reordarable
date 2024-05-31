import 'dart:ui';

import 'package:bloc_test/data/models/item_models.dart';
import 'package:bloc_test/presentation/bloc/item_bloc.dart';
import 'package:bloc_test/presentation/pages/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item List'),
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ItemLoaded) {
            final itemmodel = state.items;
            return ReorderableListView.builder(
              itemCount: itemmodel.length,
              itemBuilder: (context, index) {
                final item = itemmodel[index];
                return ListTiles(
                  item: item,
                  key: Key("$index"),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final ItemModel itemdelete = itemmodel.removeAt(oldIndex);
                itemmodel.insert(newIndex, itemdelete);
                context.read<ItemBloc>().reorderableItem(oldIndex, newIndex);
                print(itemmodel);
              },
              proxyDecorator: (child, index, animation) => proxyDecorator(
                child,
                index,
                animation,
                itemmodel,
              ),
            );
          } else if (state is ItemError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No items'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ItemFormPage(
                isEditing: false,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation,
      List<ItemModel> itemModel) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(
          scale: scale,
          child: ListTiles(
            item: itemModel[index],
            key: Key("$index"),
          ),
        );
      },
      child: child,
    );
  }
}

class ListTiles extends StatelessWidget {
  const ListTiles({
    super.key,
    required this.item,
  });

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text(item.id.toString()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemFormPage(
                      isEditing: true,
                      item: item,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                BlocProvider.of<ItemBloc>(context)
                    .add(DeleteItemEvent(item.id));
              },
            ),
          ],
        ),
      ),
    );
  }
}

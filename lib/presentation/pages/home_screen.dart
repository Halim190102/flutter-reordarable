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
  bool _selectedAll = false;
  bool _isSelectionMode = false;
  final List<int> _selectedItems = [];
  _toggleSelectionMode() {
    setState(() {
      _selectedItems.clear();
      _isSelectionMode = false;
      _selectedAll = false;
    });
  }

  void _selectAll() {
    final currentState = context.read<ItemBloc>().state;
    if (currentState is ItemLoaded) {
      setState(() {
        if (_selectedItems.length == currentState.items.length) {
          _selectedItems.clear();
          _isSelectionMode = false;
          _selectedAll = false;
        } else {
          _selectedItems.clear();
          _isSelectionMode = true;
          _selectedAll = true;
          _selectedItems.addAll(currentState.items.map((item) => item.id));
        }
      });
    }
  }

  void _onItemTap(int id) {
    final currentState = context.read<ItemBloc>().state;
    if (currentState is ItemLoaded) {
      setState(() {
        if (_selectedItems.contains(id)) {
          _selectedItems.remove(id);
          if (_selectedItems.isEmpty) {
            _isSelectionMode = false;
          } else {
            _selectedAll = false;
          }
        } else {
          _selectedItems.add(id);
          _isSelectionMode = true;
          if (_selectedItems.length == currentState.items.length) {
            _selectedAll = true;
          }
        }
      });
    }
  }

  void doubleTap(int id) {
    setState(() {
      _selectedItems.add(id);
      _isSelectionMode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item List'),
        actions: [
          Checkbox(
            value: _selectedAll,
            onChanged: (select) => _selectAll(),
          ),
          if (_isSelectionMode == true)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                context
                    .read<ItemBloc>()
                    .add(DeleteMultipleItemsEvent(_selectedItems));
                Future.delayed(Duration.zero, () => _toggleSelectionMode());
              },
            ),
        ],
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ItemLoaded) {
            final itemmodel = state.items;
            return ReorderableListView.builder(
              onReorderStart: (index) {
                _toggleSelectionMode();
              },
              itemCount: itemmodel.length,
              itemBuilder: (context, index) {
                final item = itemmodel[index];
                final isSelected = _selectedItems.contains(item.id);

                return ListTiles(
                  item: item,
                  doubleTap: doubleTap,
                  isSelected: isSelected,
                  isSelectionMode: _isSelectionMode,
                  onTap: _onItemTap,
                  key: Key("$index"),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                context
                    .read<ItemBloc>()
                    .add(ReorderableItemEvent(oldIndex, newIndex));
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
        final double elevation = lerpDouble(1, 6, animValue)!;

        final double scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(
          scale: scale,
          child: ListTiles(
            item: itemModel[index],
            key: Key("$index"),
            elevation: elevation,
          ),
        );
      },
      child: child,
    );
  }
}

class ListTiles extends StatefulWidget {
  const ListTiles({
    super.key,
    required this.item,
    this.elevation,
    this.isSelectionMode,
    this.onTap,
    this.isSelected,
    this.doubleTap,
  });

  final ItemModel item;
  final double? elevation;
  final bool? isSelected;

  final bool? isSelectionMode;
  final Function(int)? onTap;
  final Function(int)? doubleTap;

  @override
  State<ListTiles> createState() => _ListTilesState();
}

class _ListTilesState extends State<ListTiles> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      // child: Dismissible(
      //   key: ValueKey("dismissable-${widget.item.id}"),
      //   direction: DismissDirection.endToStart,
      //   background: Container(
      //     color: Colors.red,
      //     child: const Row(
      //       mainAxisAlignment: MainAxisAlignment.end,
      //       children: [
      //         SizedBox(
      //           width: 100.0,
      //           height: double.infinity,
      //           child: Icon(
      //             Icons.delete,
      //             color: Colors.white,
      //             size: 40.0,
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      //   onDismissed: (_) {
      //     BlocProvider.of<ItemBloc>(context)
      //         .add(DeleteItemEvent(widget.item.id));
      //   },
      child: GestureDetector(
        onDoubleTap: () => widget.onTap!(widget.item.id),
        child: Card(
          color: Colors.lightGreenAccent,
          elevation: widget.elevation,
          child: ListTile(
            title: Text(widget.item.name),
            subtitle: Text(widget.item.id.toString()),
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
                          item: widget.item,
                        ),
                      ),
                    );
                  },
                ),
                if (widget.isSelectionMode == true)
                  Checkbox(
                    value: widget.isSelected,
                    onChanged: (newValue) => widget.onTap!(widget.item.id),
                  ),
              ],
            ),
          ),
        ),
        // ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:ffi';

import 'package:bloc_test/data/models/item_models.dart';

class LocalDataSource {
  List<ItemModel> items = [];
  List<Int> idselected = [];

  Future<List<ItemModel>> getAllItems() async {
    return items
        .map((itemModel) => ItemModel(id: itemModel.id, name: itemModel.name))
        .toList();
  }

  Future<void> addItem(ItemModel item) async {
    items.add(ItemModel(id: item.id, name: item.name));
  }

  Future<void> updateItem(ItemModel item) async {
    int index = items.indexWhere((itemModel) => itemModel.id == item.id);
    if (index != -1) {
      items[index] = ItemModel(id: item.id, name: item.name);
    }
  }

  Future<void> deleteItem(int id) async {
    items.removeWhere((itemModel) => itemModel.id == id);
  }

  Future<void> reorderableItem(int oldIndex, int newIndex) async {
    ItemModel tempOld = items[oldIndex];
    ItemModel tempNew = items[newIndex];

    items[oldIndex] = ItemModel(id: tempOld.id, name: tempNew.name);
    items[newIndex] = ItemModel(id: tempNew.id, name: tempOld.name);
  }
}

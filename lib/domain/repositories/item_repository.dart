import 'package:bloc_test/data/models/item_models.dart';

abstract class ItemRepository {
  Future<List<ItemModel>> getAllItems();
  Future<void> addItem(ItemModel item);
  Future<void> updateItem(ItemModel item);
  Future<void> deleteItem(int id);
  Future<void> reorderableItem(int oldIndex, int newIndex);
}

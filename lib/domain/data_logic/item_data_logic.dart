import 'package:bloc_test/data/models/item_models.dart';
import 'package:bloc_test/domain/repositories/item_repository.dart';

class GetAllItems {
  final ItemRepository repository;

  GetAllItems(this.repository);

  Future<List<ItemModel>> call() async {
    return await repository.getAllItems();
  }
}

class AddItem {
  final ItemRepository repository;

  AddItem(this.repository);

  Future<void> call(ItemModel item) async {
    await repository.addItem(item);
  }
}

class UpdateItem {
  final ItemRepository repository;

  UpdateItem(this.repository);

  Future<void> call(ItemModel item) async {
    await repository.updateItem(item);
  }
}

class DeleteItem {
  final ItemRepository repository;

  DeleteItem(this.repository);

  Future<void> call(int id) async {
    await repository.deleteItem(id);
  }
}

class ReorderableItem {
  final ItemRepository repository;

  ReorderableItem(this.repository);

  Future<void> call(int oldIndex, int newIndex) async {
    await repository.reorderableItem(oldIndex, newIndex);
  }
}

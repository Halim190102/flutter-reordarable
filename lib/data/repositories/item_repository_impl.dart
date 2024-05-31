import 'dart:async';

import 'package:bloc_test/data/datasource/local_data_source.dart';
import 'package:bloc_test/data/models/item_models.dart';
import 'package:bloc_test/domain/repositories/item_repository.dart';

class ItemRepositoryImpl implements ItemRepository {
  final LocalDataSource localDataSource;

  ItemRepositoryImpl(this.localDataSource);

  @override
  Future<List<ItemModel>> getAllItems() async {
    return await localDataSource.getAllItems();
  }

  @override
  Future<void> addItem(ItemModel item) async {
    await localDataSource.addItem(item);
  }

  @override
  Future<void> updateItem(ItemModel item) async {
    await localDataSource.updateItem(item);
  }

  @override
  Future<void> deleteItem(int id) async {
    await localDataSource.deleteItem(id);
  }

  @override
  Future<void> reorderableItem(int oldIndex, int newIndex) async {
    await localDataSource.reorderableItem(oldIndex, newIndex);
  }
}

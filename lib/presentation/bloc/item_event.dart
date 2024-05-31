part of 'item_bloc.dart';

abstract class ItemEvent {}

class GetAllItemsEvent extends ItemEvent {}

class AddItemEvent extends ItemEvent {
  final ItemModel item;

  AddItemEvent(this.item);
}

class UpdateItemEvent extends ItemEvent {
  final ItemModel item;

  UpdateItemEvent(this.item);
}

class DeleteItemEvent extends ItemEvent {
  final int id;

  DeleteItemEvent(this.id);
}

class ReorderableItemEvent extends ItemEvent {
  final int oldIndex, newIndex;

  ReorderableItemEvent(this.oldIndex, this.newIndex);
}

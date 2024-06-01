import 'package:bloc_test/data/models/item_models.dart';
import 'package:bloc_test/domain/data_logic/item_data_logic.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final GetAllItems getAllItems;
  final AddItem addItem;
  final UpdateItem updateItem;
  final DeleteItem deleteItem;
  final ReorderableItem reorderableItem;

  ItemBloc({
    required this.getAllItems,
    required this.addItem,
    required this.updateItem,
    required this.deleteItem,
    required this.reorderableItem,
  }) : super(ItemInitial()) {
    on<GetAllItemsEvent>((event, emit) async {
      emit(ItemLoading());
      try {
        final items = await getAllItems();
        emit(ItemLoaded(items
            .map((item) => ItemModel(id: item.id, name: item.name))
            .toList()));
      } catch (e) {
        emit(ItemError(e.toString()));
      }
    });

    on<AddItemEvent>((event, emit) async {
      try {
        await addItem(ItemModel(id: event.item.id, name: event.item.name));
        add(GetAllItemsEvent());
      } catch (e) {
        emit(ItemError(e.toString()));
      }
    });

    on<UpdateItemEvent>((event, emit) async {
      try {
        await updateItem(ItemModel(id: event.item.id, name: event.item.name));
        add(GetAllItemsEvent());
      } catch (e) {
        emit(ItemError(e.toString()));
      }
    });

    on<DeleteItemEvent>((event, emit) async {
      try {
        await deleteItem(event.id);
        add(GetAllItemsEvent());
      } catch (e) {
        emit(ItemError(e.toString()));
      }
    });

    on<ReorderableItemEvent>((event, emit) async {
      try {
        await reorderableItem(event.oldIndex, event.newIndex);
        add(GetAllItemsEvent());
      } catch (e) {
        emit(ItemError(e.toString()));
      }
    });

    on<DeleteMultipleItemsEvent>((event, emit) async {
      try {
        for (var id in event.ids) {
          await deleteItem(id);
        }
        add(GetAllItemsEvent());
      } catch (e) {
        emit(ItemError(e.toString()));
      }
    });
  }
}

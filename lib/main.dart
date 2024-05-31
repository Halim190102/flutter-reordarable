import 'package:bloc_test/data/datasource/local_data_source.dart';
import 'package:bloc_test/data/repositories/item_repository_impl.dart';
import 'package:bloc_test/domain/data_logic/item_data_logic.dart';
import 'package:bloc_test/presentation/bloc/item_bloc.dart';
import 'package:bloc_test/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final localDataSource = LocalDataSource();
  final itemRepositoryimpl = ItemRepositoryImpl(localDataSource);

  runApp(MyApp(itemRepositoryimpl: itemRepositoryimpl));
}

class MyApp extends StatefulWidget {
  final ItemRepositoryImpl itemRepositoryimpl;

  const MyApp({super.key, required this.itemRepositoryimpl});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemBloc(
        getAllItems: GetAllItems(widget.itemRepositoryimpl),
        addItem: AddItem(widget.itemRepositoryimpl),
        updateItem: UpdateItem(widget.itemRepositoryimpl),
        deleteItem: DeleteItem(widget.itemRepositoryimpl),
        reorderableItem: ReorderableItem(widget.itemRepositoryimpl),
      )..add(GetAllItemsEvent()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ItemPage(),
      ),
    );
  }
}

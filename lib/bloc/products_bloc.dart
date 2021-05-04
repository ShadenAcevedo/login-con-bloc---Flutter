
import 'dart:io';

import 'package:rxdart/rxdart.dart';

import 'package:form_validation/models/product_model.dart';
import 'package:form_validation/providers/products_provider.dart';

class ProductsBloc {
  final _productosController = BehaviorSubject<List<ProductModel>>();
  final _cargandoController = BehaviorSubject<bool>();

  final productsProvider = ProductsProvider();

  Stream<List<ProductModel>> get productsStream => _productosController.stream;
  Stream<bool> get cargandoStream => _cargandoController.stream;

  void cargarProductos() async {
    final productos = await productsProvider.cargarProductos();
    _productosController.sink.add(productos);
  }

  void agregarProducto(ProductModel producto) async {
    _cargandoController.sink.add(true);
    await productsProvider.crearProducto(producto);
    cargarProductos();
    _cargandoController.sink.add(false);
  }

  Future<String> subirFoto(File foto) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await productsProvider.subirImagen(foto);
    _cargandoController.sink.add(false);
    return fotoUrl;
  }

  void editarProducto(ProductModel producto) async {
    _cargandoController.sink.add(true);
    await productsProvider.editarProducto(producto);
    cargarProductos();
    _cargandoController.sink.add(false);
  }

  void borrarProducto(String id) async {
    await productsProvider.borrarProducto(id);
    cargarProductos();
  }

  dispose() {
    _productosController.close();
    _cargandoController.close();
  }


}
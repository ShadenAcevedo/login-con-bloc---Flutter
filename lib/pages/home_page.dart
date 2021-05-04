import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/bloc/provider.dart';
import 'package:form_validation/models/product_model.dart';

class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    
    final productsBloc = Provider.productsBloc(context);
    productsBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        actions: [
          IconButton(
              onPressed: () => Navigator.restorablePushNamed(context, 'login'),
              icon: Icon(Icons.exit_to_app)
          )
        ],
      ),
      body: _crearListado(productsBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProductsBloc productsBloc) {

    return StreamBuilder(
      stream: productsBloc.productsStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
        if(snapshot.hasData){

          final productos = snapshot.data;
          print('productos home' + productos.toString());
          return ListView.builder(
              itemCount: productos?.length,
              itemBuilder: (context, i) => _crearItem(context, productsBloc, productos![i])
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  Widget _crearItem(BuildContext context, ProductsBloc productsBloc, ProductModel producto){
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion){
        // Borrar producto
        productsBloc.borrarProducto(producto.id);
      },
      child: Card(
        child: Column(
          children: [
            (producto.fotoUrl == '')
            ? Image(image: AssetImage('assets/no-image.png'))
            : FadeInImage(
              placeholder: AssetImage('assets/jar-loading.gif'),
              image: NetworkImage(producto.fotoUrl),
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover
            ),
            ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text(producto.id),
                onTap: () => Navigator.pushNamed(context, 'product', arguments: producto)
            ),
          ],
        ),
      )
    );
  }

  _crearBoton(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'product'),
    );
  }
}
